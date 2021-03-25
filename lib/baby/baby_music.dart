import 'dart:async';

import 'package:client/api/api.dart';
import 'package:client/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicClass extends StatefulWidget {
  MusicClass({Key key}) : super(key: key);
  @override
  MusicClassState createState() => MusicClassState();
}

class MusicClassState extends State<MusicClass>
    with SingleTickerProviderStateMixin {
  String url;
  PlayerMode mode;
  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  String aboutContent;
  bool isLoading = false;
  bool isPlay = false;
  int _page = 0;

  String musicId = '';
  TabController tabController;
  List tabTitles = [];
  List musiclist = [];
  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    getData();
  }

  // @override
  // void dispose() {
  //   //释放
  //   print('@@@@@@');
  //   _audioPlayer.dispose();
  //   _durationSubscription?.cancel();
  //   _positionSubscription?.cancel();
  //   _playerCompleteSubscription?.cancel();
  //   _playerErrorSubscription?.cancel();
  //   _playerStateSubscription?.cancel();
  //   super.dispose();
  //   print('@@@@@@');
  // }

  @override
  void deactivate() async {
    print('结束');
    int result = await _audioPlayer.release();
    if (result == 1) {
      print('release success');
    } else {
      print('release failed');
    }
    super.deactivate();
  }

  _initAudioPlayer() {
    //  /// Ideal for long media files or streams.
    mode = PlayerMode.MEDIA_PLAYER;
    //初始化
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on iOS.
        _audioPlayer.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    //监听进度
    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    //播放完成
    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
//          _onComplete();
      setState(() {
        _position = Duration();
      });
    });

    //监听报错
    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
//        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    //播放状态改变
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {});
    });

    ///// iOS中来自通知区域的玩家状态变化流。
    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
    });

//    _playingRouteState = PlayingRouteState.speakers;
  }

  //开始播放
  void _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      print('succes');
    }
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);
  }

  //暂停
  void _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      print('succes');
    }
  }

  //停止播放
  _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _position = Duration();
      });
    }
  }

  //释放
  _release() async {
    final result = await _audioPlayer.release();
    if (result == 1) {
      setState(() {
        _position = Duration();
      });
    }
  }

  void getData() {
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("limit", () => 1);
    // map.putIfAbsent("page", () => 1);
    Service().getData(map, Api.GET_MUSIC_URL, (success) async {
      print('~~~~~~~~~~~~~~~');
      print(success['list']);
      setState(() {
        tabTitles = success['list'];
        musiclist = tabTitles[0]['children'];
        // readlist = success['list'];
      });
      print(tabTitles);
      print('~~~~~~~~~~~~~~~');
      tabController = new TabController(length: tabTitles.length, vsync: this);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget tabBar() {
      return SafeArea(
        child: TabBar(
          controller: tabController,
          indicatorColor: null,
          indicator: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xffEE9249), width: 3)),
          ),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.black,
          unselectedLabelColor: Color(0xff666666),
          indicatorPadding: EdgeInsets.zero,
          isScrollable: true,
          tabs: tabTitles.map((i) => Tab(text: i['title'])).toList(),
          unselectedLabelStyle:
              TextStyle(fontSize: ScreenUtil.instance.setWidth(34)),
          labelStyle: TextStyle(
              fontSize: ScreenUtil.instance.setWidth(36),
              fontWeight: FontWeight.bold),
          onTap: ((index) {
            // _page = 0;
            setState(() {
              musiclist = tabTitles[index]['children'];
            });
            //歌曲添加播放状态
            for (int i = 0; i < musiclist.length; i++) {
              setState(() {
                musiclist[i]['isplay'] = false;
              });
            }
            ;
          }),
        ),
      );
    }

    tabShowView() {
      List<Widget> list = [];
      for (var i = 0; i < musiclist.length; i++) {
        list.add(
          Container(
            height: ScreenUtil().setWidth(90),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Container(
                    child: Text('${musiclist[i]['title']}'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          child: Image.asset(
                            'assets/foods/ic_xia.png',
                            width: ScreenUtil.instance.setWidth(25.0),
                          ),
                          onTap: () async {
                            if (musicId != musiclist[i]['id']) {
                              return false;
                            }
                            if (i == 0) {
                              setState(() {
                                url = musiclist[i]['url'];
                                musicId = musiclist[i]['id'];
                              });
                            } else {
                              setState(() {
                                url = musiclist[i - 1]['url'];
                                musicId = musiclist[i - 1]['id'];
                              });
                            }

                            await _stop();
                            await _play();
                            // Navigator.of(context).pop();
                          },
                        ),
                        musicId != musiclist[i]['id']
                            ? InkWell(
                                //播放
                                child: Image.asset(
                                  'assets/foods/ic_bofang.png',
                                  width: ScreenUtil.instance.setWidth(38.0),
                                ),
                                onTap: () async {
                                  setState(() {
                                    musicId = musiclist[i]['id'];
                                    url = musiclist[i]['url'];
                                    musiclist[i]['isplay'] = true;
                                    // musiclist[i]['isplay'] = true;
                                  });
                                  await _play();
                                },
                              )
                            : InkWell(
                                //暂停
                                child: Image.asset(
                                  'assets/foods/ic_zanting.png',
                                  width: ScreenUtil.instance.setWidth(38.0),
                                ),
                                onTap: () async {
                                  setState(() {
                                    musiclist[i]['isplay'] = false;
                                    musicId = '';
                                  });
                                  _pause();
                                },
                              ),
                        InkWell(
                          child: Image.asset(
                            'assets/foods/ic_shang.png',
                            width: ScreenUtil.instance.setWidth(25.0),
                          ),
                          onTap: () async {
                            if (musicId != musiclist[i]['id']) {
                              return false;
                            }
                            // Navigator.of(context).pop();
                            if (i == musiclist.length - 1) {
                              setState(() {
                                url = musiclist[i]['url'];
                                musicId = musiclist[i]['id'];
                              });
                            } else {
                              setState(() {
                                url = musiclist[i + 1]['url'];
                                musicId = musiclist[i + 1]['id'];
                              });
                            }
                            await _stop();
                            await _play();
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
      return list;
    }

    Widget tabShowContainer = Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(28), right: ScreenUtil().setWidth(28)),
      child: Column(
        children: tabShowView(),
      ),
    );

    Widget contentContainer = Container(
        margin: EdgeInsets.only(top: ScreenUtil().setWidth(18)),
        width: ScreenUtil().setWidth(750),
        color: PublicColor.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[tabBar(), tabShowContainer],
        ));
    return MaterialApp(
      title: "儿童音乐",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '儿童音乐',
            style: new TextStyle(color: PublicColor.headerTextColor),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: PublicColor.linearHeader,
            ),
          ),
          leading: new IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: PublicColor.headerTextColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? LoadingDialog()
            : Container(
                color: PublicColor.whiteColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      tabTitles.length > 0 ? contentContainer : Container()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
