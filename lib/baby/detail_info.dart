
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/cached_image.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import '../utils/toast_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Navigator_util.dart';
import '../service/goods_service.dart';
import '../service/user_service.dart';
import '../common/color.dart';
import 'package:client/pay_order/class_wx_pay.dart';
import '../widgets/dialog.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';

class DetailInfoPage extends StatefulWidget {
  final String oid;
  final String shipId;
  final String roomId;
  DetailInfoPage({this.oid, this.shipId, this.roomId});
  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

String musicId = '';

List guige = [];
int buynum = 1;
int checkindex = 0;

class _DetailInfoPageState extends State<DetailInfoPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
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
  bool isplay = false;

  bool isLoading = false;
  EasyRefreshController _controller = EasyRefreshController();
  GlobalKey globalKey = GlobalKey();
  List coinList = [], dogList = [], rmbList = [];
  int checkindex1 = -1, urltype;
  Timer _timer;
  String jwt = '',
      img = '',
      teacher = '',
      name = '',
      text = '',
      age = '',
      oldprice = '',
      oid = '';

  List xiangqingimglist = [];
  List bannerList = [];
  List tuijianlist = [];
  String kfToken = '';
  List commentList = [];
  String count = '0';
  bool isLive = false, isStore = false;

  @override
  void initState() {
    super.initState();
    print('roomId===${widget.roomId}');
    buynum = 1;
    getLocal();
    _initAudioPlayer();
    _controller.finishRefresh();
  }

  void deactivate() async {
    print('结束');
    int result = await _audioPlayer.release();
    if (result == 1) {
      print('release success');
    } else {
      print('release failed');
    }
    super.deactivate();
    getLocal();
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

  void payOrder() async {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("cid", () => oid);
    map.putIfAbsent("amount", () => oldprice);
    GoodsServer().buyClass(map, (success) async {
      setState(() {
        isLoading = false;
      });
      NavigatorUtils.toLingQu(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void popContent() {
    NavigatorUtils.toLingQu(context);
  }

  void cancelTimer() {
    _timer?.cancel();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startTimer(orderId) {
    setState(() {
      isLoading = true;
    });
    //设置 1 秒回调一次
    const period = const Duration(seconds: 2);
    _timer = Timer.periodic(period, (timer) {
      getPayStatus(orderId);
      //更新界面
    });
  }

  void getPayStatus(orderId) async {
    print('支付中..');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => orderId);
    map.putIfAbsent("type", () => "1");
    UserServer().getPayStatus(map, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');

      // NavigatorUtils.goMyOrderPage(context, type);
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  @override
  void dispose() {
    _videoPlayerController1?.dispose();
    _chewieController?.dispose();
    super.dispose();
    cancelTimer();
  }

  void playsss() {
    _videoPlayerController1 = VideoPlayerController.network(img);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 2 / 3,
      autoPlay: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {
      isplay = true;
    });
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString('jwt');
    if (jwt != null) {
      // await loaduser(); // 分享加载头像
    }
    await getGoodsDetails();
  }

  // Future loaduser() async {
  //   Map<String, dynamic> map = Map();
  //   map.putIfAbsent("id", () => widget.oid);

  //   UserServer().getUserInfo(map, (success) async {
  //     setState(() {
  //       user = success;
  //       isLive = success['is_live'].toString() == "0" ? false : true;
  //       isStore = success['is_store'].toString() == "0" ? false : true;
  //     });
  //   }, (onFail) async {
  //     ToastUtil.showToast(onFail);
  //   });
  // }

  // 商品详情
  // 商品详情
  Future getGoodsDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    GoodsServer().gethkGoodsDetails(map, (success) async {
      setState(() {
        isLoading = false;
        //  goods = success['list'];
        oid = success['list']['id'].toString();
        img = success['list']['img'];
        name = success['list']['name'];
        urltype = success['list']['urltype'];
        text = success['list']['text'];
        age = success['list']['age'];
        teacher = success['list']['teacher']['name'];
        oldprice = success['list']['now_price'];
        xiangqingimglist = success['list']['child'];
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: Text(
              '课程详情',
              style: TextStyle(
                color: PublicColor.headerTextColor,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),

            centerTitle: true,
            leading: new IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // actions: <Widget>[
            //   MaterialButton(
            //       child: Icon(
            //         Icons.share,
            //         size: 25.0,
            //         color: Colors.black,
            //       ),
            //       onPressed: () {
            //         print('分享');
            //         if (jwt == null) {
            //           ToastUtil.showToast(Global.NO_LOGIN);
            //           return;
            //         }
            //         shareGoods();
            //         // showDialog(
            //         //     context: context,
            //         //     barrierDismissible: true,
            //         //     builder: (BuildContext context) {
            //         //       return _shareWidget(context);
            //         //     });
            //       }),
            // ],
          ),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget buildDogList() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (xiangqingimglist.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in xiangqingimglist) {
        if (item['type'] == '1') {
          arr.add(Container(
                    height: ScreenUtil().setHeight(135),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      border: Border.all(
                        color: Color(0xffF5F5F5),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(24),
                        left: ScreenUtil().setWidth(26),
                        right: ScreenUtil().setWidth(26),
                        bottom: ScreenUtil().setWidth(24)),
                    child: InkWell(
                      onTap: () {
                        // print(item);
                        // String oid = (item['id']).toString();
                        // // NavigatorUtils.toXiangQing(context, oid, '0', '0');
                        // NavigatorUtils.todetailInfo(context);
                      },
                      //设置圆角
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: ScreenUtil().setWidth(500),
                                  child: Text(
                                    item['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: ScreenUtil().setSp(30)),
                                  ),
                                ),
                                // Text(
                                //   '时长 05：11',
                                //   style: TextStyle(
                                //       color: Color(0xff666666),
                                //       fontSize: ScreenUtil().setSp(26)),
                                // )
                              ],
                            ),
                            musicId != item['id']
                                ? InkWell(
                                    //播放
                                    child: Image.asset(
                                      'assets/foods/ic_bofang.png',
                                      width: ScreenUtil.instance.setWidth(38.0),
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        musicId = item['id'];
                                        url = item['url'];
                                        item['isplay'] = true;
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
                                        item['isplay'] = false;
                                        musicId = '';
                                      });
                                      _pause();
                                    },
                                  ),
                          ]),
                    ),
                  )
              
          );
        }else{
          content= Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
                    child: Text(
                      '暂无音频',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(35),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                   return content;
        }
      }
    }
    content = new ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
      children: arr,
    );
    return content;
  }

  Widget contentWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(100.0)),
          color: Color(0xffff5f5f5),
          child: EasyRefresh(
            controller: _controller,
            header: BezierCircleHeader(
              backgroundColor: PublicColor.themeColor,
            ),
            footer: BezierBounceFooter(
              backgroundColor: PublicColor.themeColor,
            ),
            enableControlFinishRefresh: true,
            enableControlFinishLoad: false,
            onRefresh: () async {
              getLocal();
            },
            onLoad: () async {
              // loadtuijian();
            },
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Stack(
                children: <Widget>[
                  urltype == 2
                      ? Container(
                          width: ScreenUtil().setWidth(750),
                          height: ScreenUtil().setWidth(420),
                          color: Colors.black,
                          child: isplay
                              ? Chewie(
                                  controller: _chewieController,
                                )
                              : Container(
                                  width: ScreenUtil().setWidth(750),
                                  height: ScreenUtil().setWidth(420),
                                  decoration: img != ""
                                      ? BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              img,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : BoxDecoration(),
                                  child: InkWell(
                                    onTap: () {
                                      playsss();
                                    },
                                    child: Image.asset(
                                      "assets/zhibo/play.png",
                                      width: ScreenUtil().setWidth(90),
                                      height: ScreenUtil().setWidth(90),
                                    ),
                                  ),
                                ),
                        )
                      : Container(
                          child: CachedImageView(
                            ScreenUtil.instance.setWidth(750.0),
                            ScreenUtil.instance.setWidth(420.0),
                            img,
                            null,
                            BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                        ),
                ],
              ),
              Container(
                height: ScreenUtil.instance.setWidth(133.0),
                width: ScreenUtil.instance.setWidth(750.0),
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(25),
                  right: ScreenUtil().setWidth(25),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // color: Colors.black87,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setHeight(20),
                      ),
                      width: ScreenUtil().setWidth(500),
                      child: Text(
                        // '${goods['name']}',
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(30.0),
                          color: Color(0xff333333),
                        ),
                      ),
                    ),
                    // Container(
                    //     // color: Colors.black87,

                    //     margin: EdgeInsets.only(
                    //       right: ScreenUtil().setHeight(20),
                    //     ),
                    //     child: Image.asset(
                    //       'assets/index/ic_zanting.png',
                    //       width: ScreenUtil().setWidth(37),
                    //     )),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              Container(
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(15),
                ),
                height: ScreenUtil.instance.setWidth(87.0),
                width: ScreenUtil.instance.setWidth(750.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffdddddd)),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setWidth(26),
                      width: ScreenUtil().setWidth(8),
                      decoration: BoxDecoration(
                          color: Color(0xffFD8C34),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(12),
                    ),
                    Text(
                      '章节目录',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(32.0),
                        color: Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
              buildDogList(),
              // new Column(
              //   mainAxisSize: MainAxisSize.max,
              //   children: xiangqingimglist
              //       .map(
              //         (i) => Container(
              //           height: ScreenUtil().setHeight(135),
              //           decoration: BoxDecoration(
              //             color: Color(0xffffffff),
              //             border: Border.all(
              //               color: Color(0xffF5F5F5),
              //               width: 1,
              //             ),
              //           ),
              //           padding: EdgeInsets.only(
              //               top: ScreenUtil().setWidth(24),
              //               left: ScreenUtil().setWidth(26),
              //               right: ScreenUtil().setWidth(26),
              //               bottom: ScreenUtil().setWidth(24)),
              //           child: InkWell(
              //             onTap: () {
              //               // print(i);
              //               // String oid = (i['id']).toString();
              //               // // NavigatorUtils.toXiangQing(context, oid, '0', '0');
              //               // NavigatorUtils.todetailInfo(context);
              //             },
              //             //设置圆角
              //             child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: <Widget>[
              //                       Container(
              //                         width: ScreenUtil().setWidth(500),
              //                         child: Text(
              //                           i['name'],
              //                           maxLines: 1,
              //                           overflow: TextOverflow.ellipsis,
              //                           style: TextStyle(
              //                               color: Color(0xff333333),
              //                               fontSize: ScreenUtil().setSp(30)),
              //                         ),
              //                       ),
              //                       // Text(
              //                       //   '时长 05：11',
              //                       //   style: TextStyle(
              //                       //       color: Color(0xff666666),
              //                       //       fontSize: ScreenUtil().setSp(26)),
              //                       // )
              //                     ],
              //                   ),
              //                   // Container(
              //                   //     margin: EdgeInsets.only(
              //                   //         right: ScreenUtil().setWidth(20)),
              //                   //     child: Image.asset(
              //                   //       'assets/index/ic_bofang1.png',
              //                   //       width: ScreenUtil().setWidth(45),
              //                   //     )),

              //                   musicId != i['id']
              //                       ? InkWell(
              //                           //播放
              //                           child: Image.asset(
              //                             'assets/foods/ic_bofang.png',
              //                             width: ScreenUtil.instance
              //                                 .setWidth(38.0),
              //                           ),
              //                           onTap: () async {
              //                             setState(() {
              //                               musicId = i['id'];
              //                               url = i['url'];
              //                               i['isplay'] = true;
              //                               // musiclist[i]['isplay'] = true;
              //                             });
              //                             await _play();
              //                           },
              //                         )
              //                       : InkWell(
              //                           //暂停
              //                           child: Image.asset(
              //                             'assets/foods/ic_zanting.png',
              //                             width: ScreenUtil.instance
              //                                 .setWidth(38.0),
              //                           ),
              //                           onTap: () async {
              //                             setState(() {
              //                               i['isplay'] = false;
              //                               musicId = '';
              //                             });
              //                             _pause();
              //                           },
              //                         ),
              //                 ]),
              //           ),
              //         ),
              //       )
              //       .toList(),
              // ),
            ])),
          ),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(100.0),
          width: ScreenUtil().setWidth(750),
          color: Color(0xffffffff),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: ScreenUtil().setWidth(40)),
                  Text(
                    '0',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(50),
                      color: Color(0xffFB1F29),
                    ),
                  ),
                  Text(
                    '元',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: Color(0xffFB1F29),
                    ),
                  ),
                ],
              ),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(36),
                  ),
                  width: ScreenUtil().setWidth(136),
                  height: ScreenUtil().setWidth(53),
                  decoration: BoxDecoration(
                    color: Color(0xffFD8C34),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    '购买',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(34),
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                onTap: () {
                  if (oldprice == '0') {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return MyDialog(
                              width: ScreenUtil.instance.setWidth(600.0),
                              height: ScreenUtil.instance.setWidth(300.0),
                              queding: () {
                                payOrder();
                                Navigator.of(context).pop();
                              },
                              quxiao: () {
                                Navigator.of(context).pop();
                              },
                              title: '温馨提示',
                              message: '确定购买该商品吗？');
                        });
                  } else {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return FukuanWidget(
                            total: oldprice,
                            jwt: jwt,
                            cid: oid,
                            startTimer: startTimer,
                            popContent: popContent,
                          );
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
