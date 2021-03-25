import 'dart:async';
import '../utils/toast_util.dart';
import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/live_service.dart';
import '../common/toTime.dart';
import '../common/Global.dart';
import 'package:client/widgets/dialog.dart';
import '../config/Navigator_util.dart';

class LiveOverPage extends StatefulWidget {
  final oid;
  final type;
  LiveOverPage({this.oid, this.type});
  @override
  LiveOverPageState createState() => LiveOverPageState();
}

class LiveOverPageState extends State<LiveOverPage> {
  Map objs = {
    "room": {},
    "anchor": {},
  };
  String ewm = '';
  Map room = {
    "img": "",
    "desc": "",
    "live_stream": "",
    "start_time": 0,
  };
  Map anchor = {};
  int lastTime = 0;
  Timer _timer;
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    LiveServer().inRoomDetails(map, (success) async {
      setState(() {
        room = success['room'];
        anchor = success['anchor'];
      });
      startTimer();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void createLive() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    map.putIfAbsent("live_stream", () => room['live_stream']);
    LiveServer().beginLive(map, (success) async {
      print('live====${success['room']}');
      await Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
        NavigatorUtils.goOpenZhibo(context, success['room']).then((res) {
          // getInfo();
        });
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void resConfig() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    LiveServer().noticeLive(map, (success) async {
      ToastUtil.showToast('预约成功');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      if (mounted) {
        setState(() {
          lastTime = room['start_time'] - Global.currentTimeMillis();
        });
        print('lastTime=====$lastTime');
      }
      if (lastTime <= 0) {
        setState(() {
          lastTime = 0;
        });
        //倒计时秒数为0，取消定时器
        cancelTimer();
      }
    });
  }

  int today(int time) {
    int day = time ~/ (3600 * 24);
    return day;
  }

  int tohour(int time) {
    int hour = time % (3600 * 24) ~/ 3600;
    return hour;
  }

  int tominute(int time) {
    int minute = time % 3600 ~/ 60;
    return minute;
  }

  int tosecond(int time) {
    int second = time % 60;
    return second;
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    //头部
    Widget topArea = Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(80),
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.navigate_before,
                    color: Colors.white,
                    size: ScreenUtil().setSp(44),
                  ),
                ),
                Text(
                  '返回',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          // InkWell(
          //   onTap: () {},
          //   child: Icon(
          //     Icons.share,
          //     color: Colors.white,
          //     size: ScreenUtil().setSp(40),
          //   ),
          // )
        ],
      ),
    );

    //body
    Widget centerBody = Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setWidth(180),
            ),
            Container(
              child: room['img'] == ""
                  ? Container()
                  : Image.network(
                      room["img"],
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setWidth(300),
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(32),
            ),
            Container(
              child: Center(
                child: Text(
                  room["desc"],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(32),
            ),
            //结束时间
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Image.asset(
                  //   "assets/zhibo/times.png",
                  //   width: ScreenUtil().setWidth(33),
                  // ),
                  Text('   ${ToTime.time(room["start_time"].toString())}',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(32),
            ),
            //距离时间
            Container(
              // color:Colors.yellowAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: PublicColor.themeColor,
                    ),
                    height: ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        '${today(lastTime)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        '天',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: PublicColor.themeColor,
                    ),
                    height: ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        '${tohour(lastTime)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        '时',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: PublicColor.themeColor,
                    ),
                    height: ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        '${tominute(lastTime)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        '分',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: PublicColor.themeColor,
                    ),
                    height: ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        '${tosecond(lastTime)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        '秒',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.type != "1"
                ? SingleChildScrollView(
              child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setWidth(70),
                      ),
                      //敬请期待
                      Container(
                        child: Center(
                          child: Text(
                            '—— 敬请期待 ——',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(40),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(140),
                      ),
                      //预约直播间
                      Container(
                        width: ScreenUtil().setWidth(545),
                        height: ScreenUtil().setWidth(80),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return MyDialog(
                                    width: ScreenUtil.instance.setWidth(600.0),
                                    height: ScreenUtil.instance.setWidth(300.0),
                                    queding: () {
                                      resConfig();
                                      Navigator.of(context).pop();
                                    },
                                    quxiao: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: '温馨提示',
                                    message: '确定预约该直播？');
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: PublicColor.themeColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                '预约直播间',
                                style: TextStyle(
                                  color: PublicColor.themeColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(46),
                      ),
                      //去逛其他直播间
                      Container(
                        width: ScreenUtil().setWidth(545),
                        height: ScreenUtil().setWidth(80),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                '去逛其他直播间',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            ): Column(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setWidth(140),
                      ),
                      //预约直播间
                      Container(
                        width: ScreenUtil().setWidth(545),
                        height: ScreenUtil().setWidth(80),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return MyDialog(
                                    width: ScreenUtil.instance.setWidth(600.0),
                                    height: ScreenUtil.instance.setWidth(300.0),
                                    queding: () {
                                      createLive();
                                      Navigator.of(context).pop();
                                    },
                                    quxiao: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: '温馨提示',
                                    message: '确定开始直播？');
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: PublicColor.themeColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                '开始直播',
                                style: TextStyle(
                                  color: PublicColor.themeColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(40),
                      ),
                      //分享直播间
                      // Container(
                      //   width: ScreenUtil().setWidth(545),
                      //   height: ScreenUtil().setWidth(80),
                      //   child: InkWell(
                      //     onTap: () {
                      //       print('分享！！·····');
                      //       ToastUtil.showToast('暂未开放');
                      //       // showModalBottomSheet(
                      //       //     context: context,
                      //       //     builder: (BuildContext context) {
                      //       //       return ShareDjango(type: "startLive");
                      //       //     });

                      //       // showModalBottomSheet(
                      //       //     context: context,
                      //       //     builder: (BuildContext context) {
                      //       //       return LiveShare(objs: objs, ewm: ewm);
                      //       //     });
                      //     },
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         border: Border.all(color: PublicColor.themeColor),
                      //         borderRadius: BorderRadius.circular(10.0),
                      //       ),
                      //       child: Center(
                      //         child: Text(
                      //           '分享给好友',
                      //           style: TextStyle(
                      //             color: PublicColor.themeColor,
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
          ]),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.black54,
          // decoration:  BoxDecoration(
          //   image:  DecorationImage(
          //     image:  AssetImage('assets/zhibo/bj1.png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                topArea,
                centerBody,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
