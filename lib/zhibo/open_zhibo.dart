import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:client/common/utils.dart';
import 'package:client/config/fluro_convert_util.dart';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:client/widgets/dialog.dart';
import 'package:client/zhibo/live_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:web_socket_channel/io.dart';
import 'package:qntools/view/QNStreamView.dart';
import 'package:qntools/controller/QNStreamViewController.dart';
import 'package:qntools/entity/camera_streaming_setting_entity.dart';
import 'package:qntools/entity/streaming_profile_entity.dart';
import 'package:qntools/entity/face_beauty_setting_entity.dart';
import 'package:qntools/entity/video_capture_configration.dart';
import 'package:qntools/enums/qiniucloud_encoding_size_level_enum.dart';
import 'package:qntools/enums/qiniucloud_push_listener_type_enum.dart';
import 'package:flutter/cupertino.dart';
import '../utils/toast_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/navigator_util.dart';
import 'live_chat.dart';
import 'live_preview.dart';
import 'live_rank.dart';
import 'live_send_gift.dart';
import './zb_goods.dart';
import '../bottom_input/input_dialog.dart';
import '../widgets/loading.dart';
import './feature.dart';
import 'package:wakelock/wakelock.dart';
import 'package:connectivity/connectivity.dart';

class OpenZhibo extends StatefulWidget {
  final String live;
  final String liveUrl;

  OpenZhibo({this.live, this.liveUrl});
  @override
  ZhiboPageState createState() => ZhiboPageState();
}

class ZhiboPageState extends State<OpenZhibo>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animatecontroller;
  var _statusListener;
  bool isAnimating = false;
  bool isloading = false;
  ScrollController scrollController = ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _commentFocus = FocusNode();
  Map objs = {
    "room": {},
    "anchor": {},
  };
  String ewm = '';
  String jwt = '';
  bool iskaiqi = false;
  String voiceStatue = '1';
  Map lives = {}, liveUrls = {};
  int count = 0;
  int like = 0;
  int online = 0;
  int isFollow = 0;
  String joinroom = '';
  DateTime lastPopTime;
  //socket
  IOWebSocketChannel channel;
  List listview = [];
  List sendList = [];
  bool isLive = false;
  Timer _hearttimer;
  Timer _restartSocket;
  String url = '';
  Map userinfo = {
    "id": 0,
    "nickname": "",
    "headimgurl": "",
  };
  bool isGift = false; // 控制动效出现
  Map giftData = {};
  bool isyulan = true;
  bool isClose = false;
  bool isShutDown = false;
  bool isStreaming = false;
  bool isTryResume = false;
  QNStreamViewController controller;
  String publishUrl = "";
  bool showshare = false;
  String token = '';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // 美颜对象
  FaceBeautySettingEntity faceBeautySettingEntity =
      FaceBeautySettingEntity(beautyLevel: 0.5, redden: 0.5, whiten: 0.5);

  /// 控制器初始化
  onViewCreated(QNStreamViewController controller) async {
    this.controller = controller;
    this.controller.addListener(onListener);
    await Future.delayed(Duration(milliseconds: 10), () async {
      bool result = await controller.resume();
      print("result=" + result.toString());
    });
  }

  closeShare() {
    setState(() {
      showshare = false;
    });
  }

  /// 监听器
  onListener(type, params) {
    // print("================ onListener ======================");
    // print(params);
    // print(type);
    // print("================ onListener ======================");
    // debugPrint("----------------------->" +
    //     "type=" +
    //     type.toString() +
    //     ",params=" +
    //     params.toString());
    Map<String, dynamic> map = json.decode(params);
    if (type == QiniucloudPushListenerTypeEnum.StateChanged) {
      var status = map["status"];
      if (status == "STREAMING") {
        isStreaming = true;
        isTryResume = false;
        isShutDown = false;
      } else if (status == "SHUTDOWN") {
        isShutDown = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    lives = FluroConvertUtils.string2map(widget.live);
    objs['room'] = lives;

    liveUrls = FluroConvertUtils.string2map(widget.liveUrl);
    animatecontroller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    getLocal();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      print("网络断线");
    } else {
      print("网络可用");
      print("当前状态111");
      print("isShutDown=" + isShutDown.toString());
      print("isStreaming=" + isStreaming.toString());
      print("isTryResume=" + isTryResume.toString());
      print('11publishUrl=====$publishUrl');
      if (isShutDown && isStreaming && !isTryResume) {
        // this.controller.resume();
        // this.controller.startStreaming({pub})

        controller.startStreaming(publishUrl: publishUrl);

        print("重新推流");
        isTryResume = true;
      }
    }
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

  void changeYulan() {
    setState(() {
      isyulan = false;
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
    map.putIfAbsent("room_id", () => lives['id']);
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
    controller.resume();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString('jwt');
    if (jwt == '') {
      ToastUtil.showToast('请先登录');
      // 跳转登录页
      return;
    }
    await initwebsocket();
    await getList();
  }

  // 送礼人列表
  getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().theList(map, (success) async {
      setState(() {
        sendList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  //礼物结束
  void giftEnd() {
    setState(() {
      isGift = false;
    });
  }

  //---------------webscoket----------------
  initwebsocket() async {
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      userinfo = success['user'];
      setState(() {
        userinfo = success['user'];
        objs['anchor'] = success['user'];
      });
      channel = IOWebSocketChannel.connect(Utils.getsocket());
      var data = {
        "type": 'login',
        "data": {
          "jwt": jwt,
          "uid": userinfo['id'],
          "nickname": userinfo['nickname'],
          "headimgurl": userinfo['headimgurl'],
          "room_id": lives['id']
        }
      };
      print('web初始化========');
      print('-------------->' + jsonEncode(data));
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

  shareLive() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().shareGoods(map, (success) async {
      ewm = success['data'];
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getVoice() async {
    final prefs = await SharedPreferences.getInstance();
    voiceStatue = prefs.getString('voiceStatue');
  }

  void changeVoice() async {
    setState(() {
      if (voiceStatue == '1') {
        voiceStatue = '0';
      } else {
        voiceStatue = '1';
      }
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('voiceStatue', voiceStatue);
  }

  onData(response) {
    var data = jsonDecode(response);
    print('dataopen11--->>>>$data');
    if (data['errcode'].toString() != '0') {
      // ToastUtil.showToast(data['errmsg']);
      return;
    }

    if (data['type'] == 'login') {
      print('dataopen--->>>>$data');
      loadheart();
      _restartSocket?.cancel();

      if (mounted) {
        setState(() {
          sendList = data['userlist'];
          if (userinfo['id'].toString() != data['uid'].toString()) {
            joinroom = data['msg'];
            like = int.parse(data['like'].toString());
            online = int.parse(data['people'].toString());

            _gestureTap();
          }
        });
      }
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
              duration: Duration(milliseconds: 500),
            );
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
        if (data['msg'] != "取关了") {
          joinroom = data['msg'];
          _gestureTap();
        }
        count = int.parse(data['follow'].toString());
      });
    } else if (data['type'] == 'like') {
      setState(() {
        like = int.parse(data['like'].toString());
      });
    } else if (data['type'] == 'gift') {
      print('data=====$data');

      setState(() {
        isGift = true;
        giftData = data;
        sendList = data['userlist'];
      });
    } else if (data['type'] == 'close') {
      setState(() {
        online = data['people'];
      });
    }
  }

  onError(err) {
    print('socket连接发生错误');
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
  //----------------scoket------------------

  // 开始直播
  // void startLive() {
  //   if (liveUrls == null) {
  //     Map<String, dynamic> map = Map();
  //     map.putIfAbsent("live_stream", () => lives['live_stream']);
  //     map.putIfAbsent("room_id", () => lives['id']);
  //     LiveServer().startLive(map, (success) async {
  //       print('推流url======${success['url']}');
  //       publishUrl = success['url'];
  //       controller.startStreaming(publishUrl: publishUrl);
  //       setState(() {
  //         count = int.parse(success['follow'].toString());
  //       });
  //       ToastUtil.showToast('直播开始');
  //     }, (onFail) async {
  //       ToastUtil.showToast(onFail);
  //     });
  //   } else {
  //     controller.startStreaming(publishUrl: liveUrls['url']);
  //   }
  // }

  void startLive() {
    if (liveUrls.toString() == null ||
        liveUrls.toString() == '' ||
        liveUrls.toString() == '{}') {
      Map<String, dynamic> map = Map();
      map.putIfAbsent("live_stream", () => lives['live_stream']);
      map.putIfAbsent("room_id", () => lives['id']);
      LiveServer().startLive(map, (success) async {
        publishUrl = success['url'];
        controller.startStreaming(publishUrl: publishUrl);
        setState(() {
          isLive = true;
          count = int.parse(success['follow'].toString());
        });
        ToastUtil.showToast('直播开始');
      }, (onFail) async {
        ToastUtil.showToast(onFail);
      });
    } else {
      controller.startStreaming(publishUrl: liveUrls['url']);
    }
  }

  // 关闭直播
  void closeLive() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().closeLive(map, (success) async {
      ToastUtil.showToast('关闭成功');
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('voiceStatue', '1');
      Navigator.pop(context);
      Navigator.pop(context);
      // NavigatorUtils.goReplayDetails(context, success['room_id']);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void startmeiyan() async {
    print('开启美颜');
    if (iskaiqi) {
      setState(() {
        iskaiqi = false;
      });
      controller.updateFaceBeautySetting(
        FaceBeautySettingEntity(
          beautyLevel: 0,
          redden: 0,
          whiten: 0,
        ),
      );
    } else {
      setState(() {
        iskaiqi = true;
      });
      controller.updateFaceBeautySetting(
          FaceBeautySettingEntity(beautyLevel: 0.5, redden: 0.5, whiten: 0.5));
    }
  }

  void setfenbianlv(int index) async {
    print('设置分辨率');
  }

  void switchCamera() async {
    controller.switchCamera(target: null);
  }

  void unFouce() {
    _commentFocus.unfocus(); // input失去焦点
  }

  @override
  void dispose() {
    isClose = true;
    controller?.stopStreaming();
    controller?.pause();
    controller?.destroy();
    animatecontroller?.dispose();
    if (channel != null) {
      channel.sink.close();
    }
    if (isLive) {
      closeLive();
    }

    _hearttimer?.cancel();
    super.dispose();
  }

  void closeRoom() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MyDialog(
            width: ScreenUtil.instance.setWidth(600.0),
            height: ScreenUtil.instance.setWidth(300.0),
            queding: () {
              closeLive();
            },
            quxiao: () {
              Navigator.of(context).pop();
            },
            title: '温馨提示',
            message: '确定要退出直播间吗？');
      },
    );
  }

  void sendmessage() {
    FocusScope.of(context).requestFocus(FocusNode());
    InputDialog.show(context).then((value) {
      if (value.toString() != "null") {
        var data = {
          "type": 'msg',
          "data": {
            "jwt": jwt,
            "uid": userinfo['id'],
            "nickname": userinfo['nickname'],
            "headimgurl": userinfo['headimgurl'],
            "msg": value,
            "room_id": lives['id']
          }
        };

        channel.sink.add(jsonEncode(data));
        _textEditingController.text = "";
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget dianzan = Text(
      (count > 10000
              ? ((count ~/ 1000) / 10).toString() + 'w'
              : count.toString()) +
          '关注 ' +
          (like > 10000
              ? ((like ~/ 1000) / 10).toString() + 'w'
              : like.toString()) +
          '点赞',
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: Colors.white,
        fontSize: ScreenUtil.instance.setWidth(22.0),
      ),
    );
    Widget dianzanbox() {
      return Container(
        width: ScreenUtil.instance.setWidth(380.0),
        height: ScreenUtil.instance.setWidth(80.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Row(children: [
          SizedBox(
            width: ScreenUtil.instance.setWidth(90.0),
          ),
          Container(
            width: ScreenUtil.instance.setWidth(195.0),
            height: ScreenUtil.instance.setWidth(80.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userinfo['nickname'], //昵称
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.instance.setWidth(28.0))),
                  dianzan
                ]),
          ),
        ]),
      );
    }

    Widget onlinewidget() {
      return InkWell(
        child: Container(
          width: ScreenUtil.instance.setWidth(58.0),
          height: ScreenUtil.instance.setWidth(58.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            color: Colors.black.withOpacity(0.5),
          ),
          alignment: Alignment.center,
          child: Text(
            '$online',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.instance.setWidth(24.0),
            ),
          ),
        ),
        onTap: () {},
      );
    }

    Widget closebox() {
      return Container(
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
                dianzanbox(),
                new SizedBox(
                  width: ScreenUtil.instance.setWidth(10.0),
                ),
                listbuild(),
                onlinewidget()
              ]),
              left: ScreenUtil.instance.setWidth(10.0),
              top: ScreenUtil.instance.setWidth(5.0),
            ),
            Positioned(
              child: InkWell(
                onTap: () {
                  NavigatorUtils.goInformationLivePage(
                      context, userinfo['id'], '1');
                },
                child: userinfo['headimgurl'] == ""
                    ? Container()
                    : CachedImageView(
                        ScreenUtil.instance.setWidth(90.0),
                        ScreenUtil.instance.setWidth(90.0),
                        userinfo['headimgurl'],
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
                width: ScreenUtil.instance.setWidth(70.0),
              ),
              left: ScreenUtil.instance.setWidth(13.0),
              top: ScreenUtil.instance.setWidth(75.0),
            ),
            Positioned(
              right: ScreenUtil.instance.setWidth(13.0),
              top: ScreenUtil.instance.setWidth(20.0),
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
                  closeRoom();
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget topwidget() {
      return Container(
        width: ScreenUtil.instance.setWidth(750.0),
        height: ScreenUtil.instance.setWidth(300.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          new SizedBox(
            height: ScreenUtil.instance.setWidth(70.0),
          ),
          closebox(),
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
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              color: Colors.black.withOpacity(0.5),
            ),
            alignment: Alignment.center,
            child: Text(
              '直播间ID:' + lives['id'].toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.instance.setWidth(28.0),
              ),
            ),
          ),
        ]),
      );
    }

    Widget animatemessage() {
      return Row(children: [
        new SizedBox(width: ScreenUtil.instance.setWidth(10.0)),
        joinroom != ""
            ? Icon(
                Icons.videocam,
                size: ScreenUtil.instance.setWidth(40.0),
                color: Colors.white,
              )
            : Text(''),
        new SizedBox(
          width: ScreenUtil.instance.setWidth(10.0),
        ),
        Container(
          width: ScreenUtil.instance.setWidth(240.0),
          alignment: Alignment.centerLeft,
          child: Text(
            joinroom,
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.instance.setWidth(26.0)),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ]);
    }

    Widget joinzhibo() {
      return Container(
        width: ScreenUtil.instance.setWidth(380.0),
        height: ScreenUtil.instance.setWidth(50.0),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: animation != null
                  ? animation.value
                  : -ScreenUtil.instance.setWidth(400.0),
              child: Container(
                  width: ScreenUtil.instance.setWidth(320.0),
                  height: ScreenUtil.instance.setWidth(50.0),
                  color: Colors.red.withOpacity(0.6),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(25),
                  ),
                  child: animatemessage()),
            ),
          ],
        ),
      );
    }

    Widget liaotian() {
      return Stack(
        children: <Widget>[
          Container(
            width: ScreenUtil.instance.setWidth(400.0),
            height: ScreenUtil.instance.setWidth(65.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              color: Colors.black26,
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(15),
                left: ScreenUtil().setWidth(15)),
            child: Container(
              width: ScreenUtil.instance.setWidth(240.0),
              child: TextField(
                controller: _textEditingController,
                focusNode: _commentFocus,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: ScreenUtil.instance.setWidth(28.0),
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                  hintText: '说点什么~',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                onTap: () {
                  sendmessage();
                },
              ),
            ),
          ),
        ],
      );
    }

    Widget zhibobox() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new SizedBox(height: ScreenUtil.instance.setWidth(30.0)),
          // 进入直播间
          joinzhibo(),
          new SizedBox(height: ScreenUtil.instance.setWidth(30.0)),
          Row(children: [
            Container(
              width: ScreenUtil.instance.setWidth(350.0),
              height: ScreenUtil.instance.setWidth(400.0),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(25),
                right: ScreenUtil().setWidth(25),
              ),
              child: ListView.builder(
                itemCount: listview.length,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return ChatWidget(
                      ctx: context, list: listview[index], index: index);
                },
              ),
            ),
          ]),
          new SizedBox(height: ScreenUtil.instance.setWidth(30.0)),
          Container(
            child: Row(
              children: <Widget>[
                new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
                liaotian(),
                new SizedBox(
                  width: ScreenUtil.instance.setWidth(20.0),
                ),
                InkWell(
                  onTap: () {
                    print('商品');
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ZbGoods(roomId: lives['id']);
                      },
                    );
                    unFouce();
                  },
                  child: Image.asset(
                    'assets/zhibo/lwzx.png',
                    width: ScreenUtil.instance.setWidth(80.0),
                  ),
                ),
                new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                InkWell(
                  onTap: () {
                    unFouce();
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return FeatureWidget(
                          switchCamera: switchCamera,
                          startmeiyan: startmeiyan,
                          controller: controller,
                          roomId: lives['id'].toString(),
                          changeVoice: changeVoice,
                        );
                      },
                    );
                  },
                  child: Image.asset(
                    'assets/zhibo/qt.png',
                    width: ScreenUtil.instance.setWidth(80.0),
                  ),
                ),
                new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                InkWell(
                  onTap: () {
                    print('分享');
                    unFouce();
                    setState(() {
                      showshare = true;
                    });
                    // showModalBottomSheet(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return LiveShare(
                    //       objs: objs,
                    //       userinfo: userinfo,
                    //       ewm: ewm,
                    //       roomId: lives['id'].toString(),
                    //       shareOver: shareOver,
                    //     );
                    //     // return LiveShare();
                    //   },
                    // );
                  },
                  child: Image.asset(
                    'assets/zhibo/fx.png',
                    width: ScreenUtil.instance.setWidth(80.0),
                  ),
                ),
                new SizedBox(
                  width: ScreenUtil.instance.setWidth(20.0),
                ),
              ],
            ),
          ),
          new SizedBox(
            height: ScreenUtil.instance.setWidth(50.0),
          ),
        ],
      );
    }

    Widget onLive = Stack(
      children: <Widget>[
        Positioned(left: 0, top: 0, child: topwidget()),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            width: ScreenUtil.instance.setWidth(750.0),
            height: ScreenUtil.instance.setWidth(800.0),
            child: Stack(
              children: <Widget>[
                isGift
                    ? SendGift(giftData: giftData, giftEnd: giftEnd)
                    : Container(),
                zhibobox()
              ],
            ),
          ),
        )
      ],
    );

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
        body: isloading
            ? LoadingDialog()
            : Container(
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
                    return Stack(children: <Widget>[
                      Container(
                        height: ScreenUtil.instance.setHeight(1334.0),
                        width: ScreenUtil.instance.setWidth(750.0),
                        child: buildStreamView(),
                      ),
                      isyulan
                          ? Preview(
                              switchCamera: switchCamera,
                              changeYulan: changeYulan,
                              startLive: startLive,
                              startmeiyan: startmeiyan)
                          : onLive,
                      showshare
                          ? LiveShare(
                              objs: objs,
                              userinfo: userinfo,
                              ewm: ewm,
                              roomId: lives['id'].toString(),
                              shareOver: shareOver,
                              closeShare: closeShare)
                          : Container(),
                    ]);
                  },
                ),
              ),
      ),
      // ignore: missing_return
      onWillPop: () async {
        // 点击返回键的操作
        if (isLive) {
          closeRoom();
        }
      },
    );
  }

  Widget buildStreamView() {
    if (Platform.isAndroid) {
      return QNStreamView(
        cameraStreamingSetting:
            CameraStreamingSettingEntity(faceBeauty: faceBeautySettingEntity),
        streamingProfile: StreamingProfileEntity(),
        onViewCreated: onViewCreated,
      );
    } else if (Platform.isIOS) {
      return QNStreamView(
          videoCaptureConfiguration: VideoCaptureConfiguration(
            videoFrameRate: 20,
          ),
          onViewCreated: onViewCreated,
          streamingProfile: StreamingProfileEntity(
              encodingSizeLevel:
                  QiniucloudEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_1088));
    } else {
      return Text("不支持的平台");
    }
  }

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
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(6)),
                child: CachedImageView(
                  ScreenUtil.instance.setWidth(58.0),
                  ScreenUtil.instance.setWidth(58.0),
                  sendList[i]['headimgurl'],
                  null,
                  BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
              ),
              onTap: () {
                print('���单');
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
}
