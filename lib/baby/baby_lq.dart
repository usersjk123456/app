import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/Global.dart';
import '../service/goods_service.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../common/color.dart';
import '../widgets/dashed_rect.dart';
import '../widgets/cached_image.dart';
import 'package:flutter_html/flutter_html.dart';
import '../service/user_service.dart';

class LingquWidget extends StatefulWidget {
  final Function(int) onChanged;
  final String jwt;
  final Map goods;
  final String type;
  final bool isLive;
  final String roomId;
  final String shipId;
  final List guige;
  LingquWidget({
    Key key,
    this.onChanged,
    @required this.jwt,
    @required this.goods,
    this.type,
    this.isLive,
    this.roomId,
    this.shipId,
    this.guige,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<LingquWidget> {
  int buynum = 1;
  int checkindex = 0;
  String buyType = '0', ewm = '';
  int chaTime = 0;
  Timer _timer;
  int currentTime = 0;
  int cancelTime = 0;
  String aboutContent = '';
  String status = '0';
  @override
  void initState() {
    super.initState();
    cancelTime = ((new DateTime.now().millisecondsSinceEpoch) ~/ 1000).toInt() +
        (24 * 60);
    startTimer();
    teacher();
    getAbout();
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  // 获取个人资料
  void getAbout() async {
    Map<String, dynamic> map = Map();
    UserServer().getAbout(map, (success) async {
      setState(() {
        aboutContent = success['res']['zhengce'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      currentTime =
          ((new DateTime.now().millisecondsSinceEpoch) ~/ 1000).toInt();
      if (mounted) {
        setState(() {
          chaTime = cancelTime - currentTime;
        });
      }
      if (chaTime <= 0) {
        //倒计时秒数为0，取消定时器
        cancelTimer();
        // cancelOrder();
      }
    });
  }

  void teacher() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.goods['teacher']['id']);
    // map.putIfAbsent("type", () => widget.type);
    GoodsServer().buyTeacher(map, (success) async {
      ewm = success['list']['img'];

      // widget.onChanged(-1);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void buy(id) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("cid", () => id);
    map.putIfAbsent("amount", () => 0);
    map.putIfAbsent("type", () => widget.type);
    GoodsServer().buyClass(map, (success) async {
      setState(() {});
      Navigator.of(context).pop();
      // Navigator.pop(context);
      myDialog();
    }, (onFail) async {
      setState(() {});
      ToastUtil.showToast(onFail);
    });
  }

  myDialog() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
            // 手势处理事件
            onTap: () {
              Navigator.of(context).pop(); //退出弹出框
            },
            child: Container(
              //弹出框的具体事件
              child: Material(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                child: Center(
                  child: Container(
                    width: ScreenUtil().setWidth(350),
                    height: ScreenUtil().setWidth(400.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(350),
                          height: ScreenUtil().setWidth(50.0),
                          alignment: Alignment.center,
                          color: Color(0xffffffff),
                          child: Text(
                            '请扫码领取课程',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(36),
                              color: Color(0xff222222),
                            ),
                          ),
                        ),
                        Container(
                          color: Color(0xffffffff),
                          width: ScreenUtil().setWidth(350),
                          height: ScreenUtil().setWidth(350),
                          child: CachedImageView(
                            ScreenUtil.instance.setWidth(350.0),
                            ScreenUtil.instance.setWidth(350.0),
                            ewm,
                            null,
                            BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: ScreenUtil.instance.setWidth(780.0),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(20), top: ScreenUtil().setWidth(15)),
          child: InkWell(
            child: Image.asset(
              'assets/index/gb.png',
              width: ScreenUtil.instance.setWidth(40.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(20),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(350.0),
          width: ScreenUtil().setWidth(700),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
            Radius.circular(30),
          )),
          child: ListView(children: [
            Container(
              alignment: Alignment.centerLeft,
              height: ScreenUtil.instance.setWidth(300.0),
              width: ScreenUtil().setWidth(500),
              decoration: BoxDecoration(color: Color(0xffffffff), boxShadow: [
                BoxShadow(
                  color: Color(0xffEDECF2),
                  blurRadius: 5.0,
                ),
              ]),
              padding: EdgeInsets.all(
                ScreenUtil().setWidth(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '订单详情',
                    style: TextStyle(
                      color: Color(0xff515462),
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.goods['name'],
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                      Text(
                        '￥0',
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(40),
                  ),
                  Container(
                    width: 700.0,
                    child: DashedRect(
                        color: Color(0xff979797), strokeWidth: 0.5, gap: 3.0),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(40),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            // 手势处理事件
                            onTap: () {
                              Navigator.of(context).pop(); //退出弹出框
                            },
                            child: Container(
                              //弹出框的具体事件
                              child: Material(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                child: Center(
                                  child: Container(
                                    color: Color(0xffffffff),
                                    constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().setWidth(500),
                                      minHeight: ScreenUtil().setWidth(300),
                                    ),
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setWidth(20)),
                                    child: Html(data: aboutContent),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      '退课政策',
                      style: TextStyle(
                        color: const Color(0xff666666),
                        decoration: TextDecoration.underline,
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        Container(
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setWidth(100),
          color: Color(0xffFFF5C7),
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)),
          child: status == '0'
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '剩余领取时间',
                      style: TextStyle(
                          color: Color(0xff57390B),
                          fontSize: ScreenUtil().setSp(36)),
                    ),
                    Text(
                      '${Global.constructTime(chaTime).substring(2, 4)}:${Global.constructTime(chaTime).substring(2, 4)}:${Global.constructTime(chaTime).substring(4)}',
                      style: TextStyle(
                        color: Color(0xffF46664),
                        fontSize: ScreenUtil.instance.setWidth(45.0),
                      ),
                    )
                  ],
                )
              : Container(),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(25),
        ),
        Container(
          child: Row(children: [
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
                  child: InkWell(
                    child: Container(
                      height: ScreenUtil.instance.setWidth(90.0),
                      width: ScreenUtil.instance.setWidth(667.0),
                      decoration: BoxDecoration(
                        gradient: PublicColor.linearBtn,
                        borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '立即领取',
                        style: TextStyle(
                          color: PublicColor.whiteColor,
                          fontSize: ScreenUtil.instance.setWidth(32.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (widget.jwt == null) {
                        ToastUtil.showToast(Global.NO_LOGIN);
                        return;
                      }
                      buy(widget.goods['id']);
                      // myDialog();
                    },
                  ),
                ))
          ]),
        ),
      ]),
    );
  }
}
