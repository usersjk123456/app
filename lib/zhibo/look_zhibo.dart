import 'dart:async';
import 'package:client/api/api.dart';
import 'package:client/bottom_input/input_dialog.dart';
import 'package:client/common/style.dart';
import 'package:client/config/navigator_util.dart';
import 'package:client/config/fluro_convert_util.dart';
import 'package:client/service/service.dart';
import 'package:client/zhibo/live_goods.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../widgets/loading.dart';
import '../widgets/cached_image.dart';
import '../common/utils.dart';
import '../utils/toast_util.dart';
//直播结束页面
import 'package:flutter/services.dart';
import 'package:qntools/view/QNPlayerView.dart';
import 'package:qntools/controller/QNPlayerViewController.dart';
import 'package:qntools/enums/qiniucloud_player_listener_type_enum.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import './TikTokFavoriteAnimationIcon.dart';
import 'live_chat.dart';
import 'live_coupon_get.dart';
import 'live_gift.dart';
import 'live_rank.dart';
import 'live_report.dart';
import 'live_send_gift.dart';
import 'live_share.dart';
import '../service/live_service.dart';
import '../service/user_service.dart';
import 'package:wakelock/wakelock.dart';
import 'package:qntools/controller/QNStreamViewController.dart';

class ZhiboPage extends StatefulWidget {
  final String oid;
  final String objs;
  ZhiboPage({this.oid, this.objs});
  @override
  ZhiboPageState createState() => ZhiboPageState();
}

class ZhiboPageState extends State<ZhiboPage>
    with SingleTickerProviderStateMixin {
  bool isloading = true;
  bool showPullDisconnected = false;
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _commentFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  Animation<double> animation;
  AnimationController animatecontroller;
  var _statusListener;
  bool isAnimating = false;
  bool isGift = false; // 控制动效出现
  Map giftData = {};
  String ewm = '';
  // socket
  IOWebSocketChannel channel;
  List listview = [];
  String jwt = '';
  List sendList = [];
  Map objs = {};
  bool showshare = false;
  Map room = {
    "id": 1,
    "is_close": 0,
    "live_stream": "muyuzb1585133648_409597",
    "live_type": 1,
    "uid": 409597,
    "sort": 0,
    "is_top": 0,
    "location": "",
    "goods_id": 5,
    "goods_list": "6",
    "img": "imgimgmig",
    "desc": "名称",
    "type": 1,
    "is_notice": 1,
    "def": 0,
    "is_open": 0,
    "is_try": 0,
    "online": 17,
    "max_online": 0,
    "like": 0,
    "order_num": 0,
    "c_order_num": 0,
    "c_total": 0,
    "total": 0,
    "share": 0,
    "click": 0,
    "interact": 0,
    "views": 0,
    "start_time": 1585122791,
    "end_time": 0,
    "create_at": 1585121561
  };
  Map anchor = {
    "id": 0,
    "shangji": 0,
    "phone": 0,
    "openid": "",
    "unionid": "",
    "accountstatus": 0,
    "nickname": "",
    "headimgurl": "",
    "sex": 0,
    "province": "",
    "city": "",
    "country": "",
    "wxqrcode": "",
    "coin": 0,
    "balance": "",
    "achievement": 0,
    "is_live": 0,
    "is_store": 0,
    "store_name": "",
    "store_desc": "",
    "store_headimg": "",
    "store_img": "",
    "is_open": 1,
    "fans": 0,
    "location": "",
    "createtime": 1585028164,
    "updatetime": 1585028164
  };

  ///***************** socket *******************/
  Map userinfo = {
    "id": 0,
    "nickname": "",
    "headimgurl": "",
  };
  bool isFirst = true;

  String joinroom = '';

  List<Offset> icons = [];
  GlobalKey _key = GlobalKey();
  Offset _p(Offset p) {
    RenderBox getBox = _key.currentContext.findRenderObject();
    return getBox.globalToLocal(p);
  }

  bool canAddFavorite = false;
  bool justAddFavorite = false, isCoupon = false;
  Map couponMap = {};
  String couponId = '0';
  Timer timer;
  Timer _hearttimer;
  Timer _restartSocket;
  Timer _couponTimer;
  bool isClose = false;

  ///***************** socket *******************/
  int isFollow = 0;
  int count = 0;
  int like = 0;
  String online = "0";
  bool followOpen = true;
  String token = '';
  /*  直播相关 */
  /// 播放控制器
  QNPlayerViewController controller;
  QNStreamViewController controllers;

  /// 描述信息
  String hint;

  /// 状态
  int status;

  /// 错误信息
  String error;

  /// 视频宽度
  int width = 0;

  /// 视频高度
  int height = 0;
  String url = '';
  /*  直播相关 */
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    objs = FluroConvertUtils.string2map(widget.objs);

    setState(() {
      url = objs['res']['rtmp_url'];
      room = objs['room'];
      anchor = objs['anchor'];
      isFollow = objs['is_follow'];
      count = int.parse(objs['follow'].toString());
    });

    animatecontroller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    getLocal();
  }

  shareLive() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    LiveServer().shareGoods(map, (success) async {
      ewm = success['data'];
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  clickshare() async {
    //统计分享次数
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("jwt", () => jwt);
    map.putIfAbsent("token", () => token);
    map.putIfAbsent("room_id", () => widget.oid);
    LiveServer().shareNum(map, (success) async {
      setState(() {
        isloading = false;
      });
      // showDialog(
      //     context: context,
      //     barrierDismissible: true,
      //     builder: (BuildContext context) {
      //       return _shareWidget(context, success['data']);
      //     });
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  sharetoken() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    LiveServer().getToken(map, (success) async {
      setState(() {
        token = success['token'];
        isloading = false;
      });
      clickshare();
      // showDialog(
      //     context: context,
      //     barrierDismissible: true,
      //     builder: (BuildContext context) {
      //       return _shareWidget(context, success['data']);
      //     });
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void shareOver() async {
    print('分享成功');
    await sharetoken();

    controllers.resume();
  }

  // 进入直播间动画
  void _gestureTap() {
    _statusListener = (AnimationStatus status) {
      print('$status');
      if (status == AnimationStatus.completed) {
        isAnimating = false;
        animatecontroller.reset();
        animation.removeStatusListener(_statusListener);
      }
    };

    animation = Tween<double>(
      begin: -ScreenUtil.instance.setWidth(410),
      end: ScreenUtil.instance.setWidth(25),
    ).animate(
      CurvedAnimation(
        parent: animatecontroller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(_statusListener);
    animatecontroller.reset();
    animatecontroller.forward();
    isAnimating = true;
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString('jwt');
    });

    await initwebsocket();
    await getList();
    await couponLunxun();
  }

  void unFouce() {
    _commentFocus.unfocus(); // input失去焦点
  }

  initwebsocket() async {
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      userinfo = success['user'];
      channel = IOWebSocketChannel.connect(Utils.getsocket());

      var data = {
        "type": 'login',
        "data": {
          "jwt": jwt,
          "uid": userinfo['id'],
          "nickname": userinfo['nickname'],
          "headimgurl": userinfo['headimgurl'],
          "room_id": widget.oid,
          "count": count,
          "follow": objs['follow'],
          "online": objs['online'],
          "like": objs['like'],
        }
      };
      channel.sink.add(jsonEncode(data));
      channel.stream.listen(this.onData, onError: onError, onDone: onDone);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void loadheart() {
    //设置 1 秒回调一次
    _hearttimer?.cancel();
    const period = const Duration(seconds: 10);
    _hearttimer = Timer.periodic(period, (timer) {
      var data = {"type": "heart", "data": {}};
      print('心跳');
      channel.sink.add(jsonEncode(data));
    });
  }

  Future couponLunxun() async {
    _couponTimer?.cancel();
    const period = const Duration(seconds: 3);
    _couponTimer = Timer.periodic(period, (timer) {
      lunxun();
    });
  }

  void lunxun() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    Service().getData(map, Api.LUNXUN, (success) async {
      print('lunxun-----success');
      setState(() {
        isCoupon = success['coupon_id'].toString() != '0';
        couponId = success['coupon_id'].toString();
        couponMap['price'] = success['price'];
        couponMap['mini'] = success['mini'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 送礼人列表
  getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    LiveServer().theList(map, (success) async {
      setState(() {
        sendList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 离开直播间
  void offline() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    LiveServer().offline(map, (success) async {
      // ToastUtil.showToast('离开');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  onData(response) {
    var data = jsonDecode(response);
    print('datalook--->>>>$data');
    if (data['errcode'].toString() != '0') {
      ToastUtil.showToast(data['errmsg']);
      return;
    }

    if (data['type'] == 'login') {
      print('login====$data');
      loadheart();
      _restartSocket?.cancel();
      if (mounted) {
        setState(() {
          joinroom = data['msg'];
          count = int.parse(data['follow'].toString());
          like = int.parse(data['like'].toString());
          online = data['people'].toString();
          sendList = data['userlist'];
        });
      }
      _gestureTap();
      // 历史消息
      if (data['history'].length != 0) {
        setState(() {
          listview = data['history'];
          if (scrollController.position.maxScrollExtent -
                  scrollController.offset <
              100) {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent + 100,
                curve: Curves.ease,
                duration: Duration(milliseconds: 500));
          }
        });
      }
    } else if (data['type'] == 'msg') {
      if (mounted) {
        setState(() {
          listview.insert(listview.length, data);
          if (scrollController.position.maxScrollExtent -
                  scrollController.offset <
              100) {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent + 100,
                curve: Curves.ease,
                duration: Duration(milliseconds: 500));
          }
        });
      }
    } else if (data['type'] == 'follow') {
      setState(() {
        count = int.parse(data['follow'].toString());
      });
    } else if (data['type'] == 'like') {
      setState(() {
        like = int.parse(data['like'].toString());
      });
    } else if (data['type'] == 'gift') {
      setState(() {
        isGift = true;
        giftData = data;
        sendList = data['userlist'];
      });
    } else if (data['type'] == 'close') {
      setState(() {
        online = data['people'].toString();
      });
    } else if (data['type'] == 'offline') {
      initwebsocket();
    }
  }

  onError(err) {
    print('socket连接发生错误');
    // debugPrint('this is error');
    // WebSocketChannelException ex = err;
    // debugPrint(ex.message);
  }

  onDone() {
    _hearttimer?.cancel();
    if (!isClose) {
      const period = const Duration(seconds: 10);
      _restartSocket = Timer.periodic(period, (timer) {
        initwebsocket();
      });
    }
  }

  @override
  void dispose() {
    isClose = true;
    onStopPlayback();
    if (controller != null) {
      controller.removeListener(onListener);
    }
    if (channel != null) {
      channel.sink.close();
      print('close============>');
      offline();
    }
    timer?.cancel();
    _hearttimer?.cancel();
    _couponTimer?.cancel();
    animatecontroller?.dispose();
    print('页面已销毁!!!!!!!!!!!');
    super.dispose();
  }

  closeShare() {
    setState(() {
      showshare = false;
    });
  }

  /// 控制器初始化
  onViewCreated(QNPlayerViewController controller) {
    print('控制器IQIQIQIQiiqiqiqiq ');
    print('ur11l=====${this.url}');
    Future.delayed(Duration(milliseconds: 2000), () {
      onStart();
    });
    this.controller = controller;
    controller.addListener(onListener);
    if (Platform.isAndroid) {
      // 设置视频路径
      controller.setVideoPath(url: this.url);
    }
    // else {
    //   onStart();
    // }
  }

  /// 监听器
  onListener(type, params) {
    // 错误
    print("================ onListener ======================");
    print(params);
    print(type);
    print("================ onListener ======================");
    if (type == QiniucloudPlayerListenerTypeEnum.Error) {
      // ToastUtil.showToast('视频流拉取异常,errcode:${params.toString()}');
      if (!showPullDisconnected) {
        ToastUtil.showToast('主播已下播');
        showPullDisconnected = true;
        isloading = true;
        // Navigator.pop(context);
        this.setState(() => error = params.toString());
      }
    }

    // 状态改变
    if (type == QiniucloudPlayerListenerTypeEnum.Info) {
      Map<String, dynamic> paramsObj = jsonDecode(params);
      this.setState(() => status = paramsObj["what"]);
      int what = paramsObj["what"];
      if (what == 10004 || what == 10005 && isloading == true) {
        isloading = false;
        showPullDisconnected = false;
      }
    }

    // 大小改变
    if (type == QiniucloudPlayerListenerTypeEnum.VideoSizeChanged) {
      Map<String, dynamic> paramsObj = jsonDecode(params);
      this.setState(() {
        width = paramsObj["width"];
        height = paramsObj["height"];
      });
    }
  }

  /// 获得状态文本
  getStatusText() {
    print('123=====');
    if (status == null) {
      return "等待中";
    }

    switch (status) {
      case 1:
        return "未知消息";
      case 3:
        return "第一帧视频已成功渲染";
      case 200:
        onStart();
        return "连接成功";
      case 340:
        return "读取到 metadata 信息";
      case 701:
        return "开始缓冲";
      case 702:
        return "停止缓冲";
      case 802:
        return "硬解失败，自动切换软解";
      case 901:
        return "预加载完成";
      case 8088:
        return "loop 中的一次播放完成";
      case 10001:
        return "获取到视频的播放角度";
      case 10002:
        return "第一帧音频已成功播放";
      case 10003:
        return "获取视频的I帧间隔";
      case 20001:
        return "视频的码率统计结果";
      case 20002:
        return "视频的帧率统计结果";
      case 20003:
        return "音频的帧率统计结果";
      case 20003:
        return "音频的帧率统计结果";
      case 10004:
        return "视频帧的时间戳";
      case 10005:
        return "音频帧的时间戳";
      case 1345:
        return "离线缓存的部分播放完成";
      case 565:
        return "上一次 seekTo 操作尚未完成";
      default:
        return "未知状态";
    }
  }

  /// 获得状态文本
  getErrorText() {
    switch (error) {
      case "-1":
        return "未知错误";
      case "-2":
        return "播放器打开失败";
      case "-3":
        return "网络异常";
      case "-4":
        return "拖动失败";
      case "-5":
        return "预加载失败";
      case "-2003":
        return "硬解失败";
      case "-2008":
        return "播放器已被销毁，需要再次 setVideoURL 或 prepareAsync";
      case "-9527":
        return "so 库版本不匹配，需要升级";
      case "-4410":
        return "AudioTrack 初始化失败，可能无法播放音频";
      default:
        return "未知错误";
    }
  }

  /// 开始播放
  onStart() async {
    print('开始直播');
    await controller.start();
  }

  /// 暂停播放
  onPause() async {
    await controller.pause();
  }

  /// 停止播放
  onStopPlayback() async {
    await controller.stopPlayback();
  }

  /// 获得视频时���戳
  onGetRtmpVideoTimestamp() async {
    int time = await controller.getRtmpVideoTimestamp();
    this.setState(() => hint = "视频时间戳为:$time");
  }

  /// 获得音频时��戳
  onGetRtmpAudioTimestamp() async {
    int time = await controller.getRtmpAudioTimestamp();
    this.setState(() => hint = "音频时间戳为:$time");
  }

  /// 获取���经缓�����的长度
  onGetHttpBufferSize() async {
    String size = await controller.getHttpBufferSize();
    this.setState(() => hint = "已经缓冲的长度:$size");
  }

  // 礼物
  void showGift(userInfo, giftItem) {
    var data = {
      "type": 'gift',
      "data": {
        "img": giftItem['img'],
        "num": 1,
        "nickname": userInfo['nickname'],
        "headimgurl": userInfo['headimgurl'],
        "gid": giftItem['id'],
        "uid": userInfo['id'],
        "roomId": widget.oid,
        "name": giftItem['name']
      }
    };
    channel.sink.add(jsonEncode(data));
  }

  //礼物结束
  void giftEnd() {
    setState(() {
      isGift = false;
    });
  }

  //关注
  follow(type) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    map.putIfAbsent("anchor_id", () => anchor['id']);
    LiveServer().follow(map, (success) async {
      if (success['type'].toString() == "1") {
        ToastUtil.showToast('关注成功');
        isFollow = 1;
      } else {
        isFollow = 0;
        ToastUtil.showToast('已取消成功');
      }
      setState(() {
        followOpen = true;
      });
      var data = {
        "type": 'follow',
        "data": {
          "jwt": jwt,
          "uid": userinfo['id'],
          "nickname": userinfo['nickname'],
          "headimgurl": userinfo['headimgurl'],
          "type": type,
          "fans": success['fans'],
          "room_id": widget.oid
        }
      };
      print('-------------->' + jsonEncode(data));
      channel.sink.add(jsonEncode(data));
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget listbuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (sendList.length > 0) {
        for (var i = 0; i < sendList.length; i++) {
          if (i < 3) {
            arr.add(
              InkWell(
                child: Container(
                  width: ScreenUtil.instance.setWidth(58.0),
                  height: ScreenUtil.instance.setWidth(58.0),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                  child: CachedImageView(
                      ScreenUtil.instance.setWidth(58.0),
                      ScreenUtil.instance.setWidth(58.0),
                      sendList[i]['headimgurl'],
                      null,
                      BorderRadius.all(Radius.circular(50))),
                ),
                onTap: () {
                  print('榜单');
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return RankWidget(sendList: sendList);
                    },
                  );
                },
              ),
            );
          }
        }
      } else {
        arr.add(Container());
      }

      content = Row(
        children: arr,
      );
      return content;
    }

    var iconStack = Stack(
      children: icons
          .map<Widget>(
            (p) => TikTokFavoriteAnimationIcon(
              key: Key(p.toString()),
              position: p,
              onAnimationComplete: () {
                icons.remove(p);
              },
            ),
          )
          .toList(),
    );

    return Scaffold(
        resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
        body: Stack(
          children: <Widget>[
            Container(
              height: ScreenUtil.instance.setHeight(1334.0),
              child: Swiper(
                loop: false,
                autoplay: false,
                onIndexChanged: (index) {
                  debugPrint("index:$index");
                },
                itemCount: 1,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil.instance.setHeight(1334.0),
                        width: ScreenUtil.instance.setWidth(750.0),
                        color: Colors.black.withOpacity(0.3),
                        child: this.url != ''
                            ? QNPlayerView(
                                url: this.url,
                                onViewCreated: onViewCreated,
                              )
                            : Text(''),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: ScreenUtil.instance.setWidth(750.0),
                          height: ScreenUtil.instance.setWidth(500.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new SizedBox(
                                  height: ScreenUtil.instance.setWidth(70.0),
                                ),
                                Container(
                                  width: ScreenUtil.instance.setWidth(750.0),
                                  height: ScreenUtil.instance.setWidth(120.0),
                                  padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(15),
                                    left: ScreenUtil().setWidth(15),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        child: Row(children: [
                                          Container(
                                            width: ScreenUtil.instance
                                                .setWidth(380.0),
                                            height: ScreenUtil.instance
                                                .setWidth(80.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(50.0),
                                              ),
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            child: Row(children: [
                                              SizedBox(
                                                width: ScreenUtil.instance
                                                    .setWidth(90.0),
                                              ),
                                              Container(
                                                width: ScreenUtil.instance
                                                    .setWidth(195.0),
                                                height: ScreenUtil.instance
                                                    .setWidth(80.0),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        anchor['nickname'], //昵称
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil
                                                              .instance
                                                              .setWidth(28.0),
                                                        ),
                                                      ),
                                                      Text(
                                                        (count > 10000
                                                                ? ((count ~/
                                                                                1000) /
                                                                            10)
                                                                        .toString() +
                                                                    'w'
                                                                : count
                                                                    .toString()) +
                                                            '关注 ' +
                                                            (like > 10000
                                                                ? ((like ~/ 1000) /
                                                                            10)
                                                                        .toString() +
                                                                    'w'
                                                                : like
                                                                    .toString()) +
                                                            '点赞',
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil
                                                              .instance
                                                              .setWidth(22.0),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              InkWell(
                                                child: Container(
                                                  width: ScreenUtil.instance
                                                      .setWidth(80.0),
                                                  height: ScreenUtil.instance
                                                      .setWidth(50.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    color:
                                                        PublicColor.themeColor,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    isFollow == 1 ? '取关' : '关注',
                                                    style: TextStyle(
                                                      color: PublicColor
                                                          .btnTextColor,
                                                      fontSize: ScreenUtil
                                                          .instance
                                                          .setWidth(28.0),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  unFouce();

                                                  if (followOpen) {
                                                    followOpen = false;
                                                    if (isFollow == 1) {
                                                      //取关
                                                      follow(2);
                                                    } else {
                                                      // 关注
                                                      follow(1);
                                                    }
                                                  }
                                                },
                                              )
                                            ]),
                                          ),
                                          new SizedBox(
                                              width: ScreenUtil.instance
                                                  .setWidth(10.0)),
                                          listbuild(),
                                          InkWell(
                                            child: Container(
                                              width: ScreenUtil.instance
                                                  .setWidth(58.0),
                                              height: ScreenUtil.instance
                                                  .setWidth(58.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                online,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil.instance
                                                      .setWidth(24.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        left:
                                            ScreenUtil.instance.setWidth(10.0),
                                        top: ScreenUtil.instance.setWidth(5.0),
                                      ),
                                      Positioned(
                                        child: InkWell(
                                          onTap: () {
                                            NavigatorUtils
                                                .goInformationLivePage(
                                                    context, anchor['id'], '1');
                                          },
                                          child: anchor['headimgurl'] == ""
                                              ? Container()
                                              : CachedImageView(
                                                  ScreenUtil.instance
                                                      .setWidth(90.0),
                                                  ScreenUtil.instance
                                                      .setWidth(90.0),
                                                  anchor['headimgurl'],
                                                  null,
                                                  BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                ),
                                        ),
                                        left: 0,
                                        top: 0,
                                      ),
                                      Positioned(
                                        child: Image.asset(
                                          'assets/zhibo/sj.png',
                                          width: ScreenUtil.instance
                                              .setWidth(70.0),
                                        ),
                                        left:
                                            ScreenUtil.instance.setWidth(13.0),
                                        top: ScreenUtil.instance.setWidth(75.0),
                                      ),
                                    ],
                                  ),
                                ),
                                new SizedBox(
                                  height: ScreenUtil.instance.setWidth(20.0),
                                ),
                                Container(
                                  width: ScreenUtil.instance.setWidth(290.0),
                                  height: ScreenUtil.instance.setWidth(50.0),
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(15),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '直播间ID:' + widget.oid.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(28.0),
                                    ),
                                  ),
                                ),
                                isCoupon
                                    ? GestureDetector(
                                        onTap: () {
                                          print(couponMap);
                                          if (couponMap.toString() == 'null') {
                                            return;
                                          }
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) {
                                              return GetCoupon(
                                                roomId: widget.oid.toString(),
                                                couponMap: couponMap,
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(20),
                                            top: ScreenUtil().setWidth(30),
                                          ),
                                          child: Image.asset(
                                            'assets/zhibo/coupon.png',
                                            width: ScreenUtil().setWidth(111),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ]),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          width: ScreenUtil.instance.setWidth(750.0),
                          height: ScreenUtil.instance.setWidth(800.0),
                          child: Stack(
                            children: <Widget>[
                              isGift
                                  ? SendGift(
                                      giftData: giftData, giftEnd: giftEnd)
                                  : Container(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(30.0)),
                                  // 进入直播间
                                  Container(
                                    width: ScreenUtil.instance.setWidth(380.0),
                                    height: ScreenUtil.instance.setWidth(50.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: animation != null
                                              ? animation.value
                                              : -ScreenUtil.instance
                                                  .setWidth(400.0),
                                          child: Container(
                                            width: ScreenUtil.instance
                                                .setWidth(320.0),
                                            height: ScreenUtil.instance
                                                .setWidth(50.0),
                                            color: Colors.red.withOpacity(0.6),
                                            margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(25),
                                            ),
                                            child: Row(
                                              children: [
                                                new SizedBox(
                                                    width: ScreenUtil.instance
                                                        .setWidth(10.0)),
                                                joinroom != ""
                                                    ? Icon(
                                                        Icons.videocam,
                                                        size: ScreenUtil
                                                            .instance
                                                            .setWidth(40.0),
                                                        color: Colors.white,
                                                      )
                                                    : Text(''),
                                                new SizedBox(
                                                  width: ScreenUtil.instance
                                                      .setWidth(10.0),
                                                ),
                                                Container(
                                                  width: ScreenUtil.instance
                                                      .setWidth(240.0),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    joinroom,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil
                                                            .instance
                                                            .setWidth(26.0)),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(30.0)),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: ScreenUtil.instance
                                              .setWidth(350.0),
                                          height: ScreenUtil.instance
                                              .setWidth(400.0),
                                          alignment: Alignment.topCenter,
                                          padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(25),
                                            right: ScreenUtil().setWidth(25),
                                          ),
                                          child: ListView.builder(
                                            itemCount: listview.length,
                                            controller: scrollController,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ChatWidget(
                                                ctx: context,
                                                list: listview[index],
                                                index: index,
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(26)),
                                          width: ScreenUtil.instance
                                              .setWidth(200.0),
                                          height: ScreenUtil.instance
                                              .setWidth(400.0),
                                          alignment: Alignment.bottomRight,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: ScreenUtil.instance
                                                    .setWidth(200.0),
                                                height: ScreenUtil.instance
                                                    .setWidth(300.0),
                                                child: Container(
                                                  width: ScreenUtil.instance
                                                      .setWidth(100.0),
                                                  height: ScreenUtil.instance
                                                      .setWidth(200.0),
                                                  child: iconStack,
                                                ),
                                              ),
                                              GestureDetector(
                                                key: _key,
                                                onTapDown: (detail) {
                                                  setState(
                                                    () {
                                                      if (canAddFavorite) {
                                                        // print(
                                                        //     '添加爱心，当前爱���数量:${icons.length}');
                                                        var data = {
                                                          "type": 'like',
                                                          "data": {
                                                            "jwt": jwt,
                                                            "uid":
                                                                userinfo['id'],
                                                            "nickname":
                                                                userinfo[
                                                                    'nickname'],
                                                            "headimgurl":
                                                                userinfo[
                                                                    'headimgurl'],
                                                            "room_id":
                                                                widget.oid
                                                          }
                                                        };
                                                        // print('-------------->' +
                                                        //     jsonEncode(data));
                                                        channel.sink.add(
                                                            jsonEncode(data));
                                                        icons.add(_p(detail
                                                            .globalPosition));
                                                        justAddFavorite = true;
                                                      } else {
                                                        justAddFavorite = false;
                                                      }
                                                    },
                                                  );
                                                },
                                                onTapUp: (detail) {
                                                  timer?.cancel();
                                                  var delay = canAddFavorite
                                                      ? 1200
                                                      : 600;
                                                  timer = Timer(
                                                      Duration(
                                                          milliseconds: delay),
                                                      () {
                                                    canAddFavorite = false;
                                                    timer = null;
                                                    if (!justAddFavorite) {
                                                      // widget.onSingleTap?.call();
                                                    }
                                                  });
                                                  canAddFavorite = true;
                                                },
                                                onTapCancel: () {
                                                  print('onTapCancel');
                                                },
                                                child: Image.asset(
                                                  'assets/zhibo/dz.png',
                                                  width: ScreenUtil.instance
                                                      .setWidth(80.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(30.0)),
                                  Row(
                                    children: <Widget>[
                                      new SizedBox(
                                          width: ScreenUtil.instance
                                              .setWidth(25.0)),
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            width: ScreenUtil.instance
                                                .setWidth(300.0),
                                            height: ScreenUtil.instance
                                                .setWidth(65.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(
                                                right:
                                                    ScreenUtil().setWidth(15),
                                                left:
                                                    ScreenUtil().setWidth(15)),
                                            child: Container(
                                              width: ScreenUtil.instance
                                                  .setWidth(240.0),
                                              child: TextField(
                                                controller:
                                                    _textEditingController,
                                                keyboardType:
                                                    TextInputType.text,
                                                focusNode: _commentFocus,
                                                style: TextStyle(
                                                    fontSize: ScreenUtil
                                                        .instance
                                                        .setWidth(28.0),
                                                    color: Colors.white),
                                                decoration: new InputDecoration(
                                                    hintText: '说点什么~',
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                    )),
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  InputDialog.show(context)
                                                      .then((value) {
                                                    if (value.toString() !=
                                                        "null") {
                                                      var data = {
                                                        "type": 'msg',
                                                        "data": {
                                                          "jwt": jwt,
                                                          "uid": userinfo['id'],
                                                          "nickname": userinfo[
                                                              'nickname'],
                                                          "headimgurl":
                                                              userinfo[
                                                                  'headimgurl'],
                                                          "msg": value,
                                                          "room_id": widget.oid
                                                        }
                                                      };

                                                      channel.sink.add(
                                                          jsonEncode(data));
                                                      _textEditingController
                                                          .text = "";
                                                      scrollController
                                                          .animateTo(
                                                        scrollController
                                                                .position
                                                                .maxScrollExtent +
                                                            100,
                                                        curve: Curves.ease,
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                      );
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      new SizedBox(
                                        width:
                                            ScreenUtil.instance.setWidth(20.0),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print('商品');
                                          unFouce();
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return LiveGoods(
                                                roomId: widget.oid,
                                                jwt: jwt,
                                                userinfo: userinfo,
                                                userId: anchor['id'],
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          'assets/zhibo/gwd.png',
                                          width: ScreenUtil.instance
                                              .setWidth(80.0),
                                        ),
                                      ),
                                      new SizedBox(
                                          width: ScreenUtil.instance
                                              .setWidth(20.0)),
                                      InkWell(
                                        onTap: () {
                                          print('其他');
                                          unFouce();
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ReportWidget(
                                                    roomId: widget.oid);
                                              });
                                        },
                                        child: Image.asset(
                                          'assets/zhibo/qt.png',
                                          width: ScreenUtil.instance
                                              .setWidth(80.0),
                                        ),
                                      ),
                                      new SizedBox(
                                          width: ScreenUtil.instance
                                              .setWidth(20.0)),
                                      InkWell(
                                        onTap: () {
                                          unFouce();
                                          setState(() {
                                            showshare = true;
                                          });
                                          // showModalBottomSheet(
                                          //     context: context,
                                          //     builder: (BuildContext context) {
                                          //       return LiveShare(
                                          //         objs: objs,
                                          //         userinfo: userinfo,
                                          //         ewm: ewm,
                                          //         roomId: widget.oid.toString(),
                                          //         shareOver: shareOver,
                                          //       );
                                          //       // return LiveShare();
                                          //     });
                                        },
                                        child: Image.asset(
                                          'assets/zhibo/fx.png',
                                          width: ScreenUtil.instance
                                              .setWidth(80.0),
                                        ),
                                      ),
                                      new SizedBox(
                                        width:
                                            ScreenUtil.instance.setWidth(20.0),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print('礼物');
                                          unFouce();
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return GiftsWidget(
                                                  showGift: showGift,
                                                  roomId:
                                                      widget.oid.toString());
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          'assets/zhibo/lwzx.png',
                                          width: ScreenUtil.instance
                                              .setWidth(80.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new SizedBox(
                                    height: ScreenUtil.instance.setWidth(50.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      showshare
                          ? LiveShare(
                              objs: objs,
                              userinfo: userinfo,
                              ewm: ewm,
                              roomId: widget.oid.toString(),
                              shareOver: shareOver,
                              closeShare: closeShare)
                          : Container(),
                    ],
                  );
                },
              ),
            ),
            isloading ? LoadingDialog() : Container(),
            Positioned(
              right: ScreenUtil.instance.setWidth(13.0),
              top: ScreenUtil.instance.setWidth(80.0),
              child: InkWell(
                child: Container(
                  width: ScreenUtil.instance.setWidth(58.0),
                  height: ScreenUtil.instance.setWidth(58.0),
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/zhibo/guanbi.png",
                    width: ScreenUtil().setWidth(50),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ));
  }
}
