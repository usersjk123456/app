import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../service/home_service.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter/rendering.dart';
import 'package:client/api/api.dart';
import '../widgets/cached_image.dart';
import 'dart:async';
import '../utils/toast_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Navigator_util.dart';
import '../service/goods_service.dart';
import '../service/user_service.dart';
import 'package:client/pay_order/class_wx_pay.dart';
import '../widgets/dialog.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:audioplayers/audioplayers.dart';

class MoreDetailList extends StatefulWidget {
  final String oid;
  final String shipId;
  final String roomId;
  MoreDetailList({this.oid, this.shipId, this.roomId});
  @override
  _MoreDetailListState createState() => _MoreDetailListState();
}

List guige = [];
int buynum = 1;
int checkindex = 0;

class _MoreDetailListState extends State<MoreDetailList>
    with SingleTickerProviderStateMixin {
  String musicId = '';
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
  HomeServer homeService = HomeServer();
  bool isLoading = true;
  Timer _timer;
  String jwt = '',
      img = '',
      teacher = '',
      detail = '',
      name = '',
      text = '',
      age = '',
      oldprice = '',
      oid = '';
  List coinList = [], dogList = [], rmbList = [];
  List bannerList = [];
  EasyRefreshController _controller = EasyRefreshController();

  // @override
  // void initState() {
  //   super.initState();

  // }

  GlobalKey globalKey = GlobalKey();
  int checkindex1 = -1;
  List goods = [];
  Map user = {
    'phone': 0,
    "headimgurl":
        "https://pic1.zhimg.com/v2-fda399250493e674f2152c581490d6eb_1200x500.jpg",
    "nickname": "1",
  };
  List xiangqingimglist = [];
  List tuijianlist = [];
  int _page = 0;
  String kfToken = '';
  List commentList = [];
  String count = '0';
  bool isLive = false, isStore = false;
  List afterList = [];
  int types = 1;
  int type = 1;
  int _pages = 0;

  @override
  void initState() {
    super.initState();
    print('roomId===${widget.roomId}');
    buynum = 1;
    getLocal();
    _page = 0;
    _initAudioPlayer();
    _controller.finishRefresh();
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

  void getList() async {
    _page++;
    if (_page == 1) {
      afterList = [];
    }
    // setState(() {
    //   isLoading = true;
    // });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    UserServer().getAfterList(map, (success) async {
      setState(() {
        isLoading = false;
        if (_page == 1) {
          //赋值
          afterList = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              afterList.insert(afterList.length, success['list'][i]);
            }
          }
        }
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
  Future<void> deactivate() async {
    //刷新页面
    print('结束');
    int result = await _audioPlayer.release();
    if (result == 1) {
      print('release success');
    } else {
      print('release failed');
    }
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getLocal();
    }
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString('jwt');
    if (jwt != null) {
      await loaduser(); // 分享加载头像
    }
    await getGoodsDetails();
    // await loadtuijian(); // 加载推荐商品
    await getComment();
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
    super.dispose();
    cancelTimer();
  }

  Future loaduser() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    UserServer().getUserInfo(map, (success) async {
      setState(() {
        user = success;
        isLive = success['is_live'].toString() == "0" ? false : true;
        isStore = success['is_store'].toString() == "0" ? false : true;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

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
        detail = success['list']['detail'];
        print(detail);
        text = success['list']['text'];
        age = success['list']['age'];
        teacher = success['list']['teacher']['name'];
        oldprice = success['list']['now_price'];
        dogList = success['list']['child'];
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

  // 评论
  Future getComment() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);
    map.putIfAbsent("page", () => 1);
    map.putIfAbsent("limit", () => 2);
    GoodsServer().getServer(map, Api.GET_COMMENT, (success) async {
      if (mounted) {
        setState(() {
          commentList = success['list'];
          count = success['count'].toString();
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topBox = Column(
      children: <Widget>[
        // height: ScreenUtil().setHeight(272),
        Stack(
          children: <Widget>[
            CachedImageView(
              ScreenUtil.instance.setWidth(750.0),
              ScreenUtil.instance.setWidth(500.0),
              img,
              null,
              BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(5),
              ),
            ),
            Positioned(
              bottom: 0,
              child: new Container(
                width: ScreenUtil().setWidth(750),
                height: ScreenUtil().setHeight(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius:
                  //     new BorderRadius.vertical(top: Radius.elliptical(60, 60)),
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(130),
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ),
        Container(
          height: ScreenUtil.instance.setWidth(191.0),
          width: ScreenUtil.instance.setWidth(750.0),
          color: Colors.white,
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(25),
            right: ScreenUtil().setWidth(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // color: Colors.black87,
                alignment: Alignment.centerLeft,

                child: Text(
                  // '${goods['name']}',
                  name,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: ScreenUtil.instance.setWidth(30.0),
                    color: Color(0xfff000000),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(26),
              ),
              Container(
                // color: Colors.black87,
                alignment: Alignment.centerLeft,

                child: Text(
                  // '${goods['name']}',
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: ScreenUtil.instance.setWidth(28.0),
                    color: Color(0xff4E4E4E),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );

    Widget tabBar = Material(
      //这里设置tab的背景色
      color: Colors.white,
      child: TabBar(
        indicatorColor: PublicColor.themeColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: PublicColor.themeColor,
        unselectedLabelColor: PublicColor.textColor,
        tabs: [
          Tab(
              child: new Text('介绍',
                  style: TextStyle(fontSize: ScreenUtil().setSp(22)))),
          Tab(
              child: new Text('目录',
                  style: TextStyle(fontSize: ScreenUtil().setSp(22)))),
          // Tab(
          //     child: new Text('收益排行',
          //         style: TextStyle(fontSize: ScreenUtil().setSp(22)))),
        ],
      ),
    );

    Container rankItem(int rank, String detail) {
      return new Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        child: Html(data: detail),
      );
    }

    Widget buildCoinList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (detail == '') {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Text(
            '暂无数据',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold),
          ),
        ));
      } else {
        int index = 1;
        // for (var item in goods) {
        arr.add(rankItem(index++, detail)); // item['detail'].toString()
        // }
      }
      content = ListView(
        children: arr,
      );
      return content;
    }

    Widget buildDogList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (dogList.length == 0) {
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
        for (var item in dogList) {
          arr.add(
          item['type']=='1'?  
           Container(
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
            :Container(
          // alignment: Alignment.center,
          // margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          // child: Text(
          //   '暂无音频',
          //   style: TextStyle(
          //     fontSize: ScreenUtil().setSp(35),
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
          );
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

    Widget bottomBtn = Container(
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
                oldprice,
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
          ),
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Container(
            // height: 400,
            decoration: BoxDecoration(color: PublicColor.bodyColor),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                topBox,
                SizedBox(
                  height: ScreenUtil().setWidth(15),
                ),
                tabBar,
                Expanded(
                  flex: 1,
                  child: TabBarView(
                    children: [
                      Container(
                        height: ScreenUtil().setWidth(600),
                        child: buildCoinList(),
                      ),
                      buildDogList(),
                    ],
                  ),
                ),
                bottomBtn
              ],
            ),
          ),
        ),
      ),
    );
  }
}
