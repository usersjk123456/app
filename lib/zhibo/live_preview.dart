import 'dart:async';
import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//直播预览
class Preview extends StatefulWidget {
  final Function switchCamera;
  final Function changeYulan;
  final Function startLive;
  final Function startmeiyan;

  Preview(
      {this.switchCamera, this.changeYulan, this.startLive, this.startmeiyan});

  @override
  PreviewState createState() => PreviewState();
}

class PreviewState extends State<Preview> {
  bool isLoading = false;
  String jwt = '';
  String giftCoin = '0', myCoin = '0';
  List giftsList = [];
  Map userInfo = {};
  Map giftItem = {};
  Timer _timer;
  int djsNum = 3;
  bool isBegin = false;
  bool isOpen = true;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        //秒数减一，因为一秒回调一次
        djsNum--;
      });
      if (djsNum < 0) {
        //倒计时秒数为0，取消定时器
        cancelTimer();
        setState(() {
          isOpen = true;
          isBegin = false;
          widget.changeYulan();
          widget.startLive();
        });
        // NavigatorUtils.goOpenZhibo(context, lives);
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 600)..init(context);

    return Stack(children: <Widget>[
      Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: ScreenUtil().setWidth(750),
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(100),
            bottom: ScreenUtil().setWidth(30),
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
          ),
          color: Color.fromRGBO(0, 0, 0, 0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        print('切换摄像头');
                        widget.switchCamera();
                      },
                      child: Image.asset(
                        'assets/zhibo/icon_paizhao.png',
                        width: ScreenUtil.instance.setWidth(44.0),
                      ),
                    ),
                    new SizedBox(
                      width: ScreenUtil.instance.setWidth(42.0),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(10),
                        bottom: ScreenUtil().setWidth(10),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(10)),
                      ),
                      child: Text(
                        '直播预览',
                        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      isBegin
          ? Positioned(
              left: ScreenUtil().setWidth(250),
              top: ScreenUtil().setWidth(467),
              child: Container(
                child: Text(
                  "$djsNum",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(400),
                    fontWeight: FontWeight.w500,
                    color: PublicColor.themeColor,
                  ),
                ),
              ),
            )
          : Container(),
      Positioned(
        left: 0,
        bottom: 0,
        child: Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(30),
              bottom: ScreenUtil().setWidth(30),
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30),
            ),
            color: Color.fromRGBO(0, 0, 0, 0.5),
            child: Stack(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(750),
                  child: InkWell(
                    onTap: () {
                      if (isOpen) {
                        isOpen = false;
                        setState(() {
                          isBegin = true;
                        });
                        startTimer();
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setWidth(120),
                          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                          decoration: BoxDecoration(
                            color: PublicColor.themeColor,
                            borderRadius: BorderRadius.circular(120),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(120),
                            ),
                          ),
                        ),
                        Text(
                          '开始直播',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setWidth(100),
                  top: ScreenUtil().setWidth(25),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          widget.startmeiyan();
                        },
                        child: Image.asset(
                          'assets/zhibo/icon_meiyan.png',
                          width: ScreenUtil.instance.setWidth(80.0),
                        ),
                      ),
                      Text(
                        '美颜',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    ]);
  }
}
