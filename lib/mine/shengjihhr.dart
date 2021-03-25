import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../api/api.dart';
import '../utils/serivice.dart';
import '../service/user_service.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class Shengjihhr extends StatefulWidget {
  @override
  ShengjihhrState createState() => ShengjihhrState();
}

class ShengjihhrState extends State<Shengjihhr> {
  bool isLoading = false;
  bool isPayLoading = false;
  String jwt = '', orderId = '';
  Timer _timer;
  TextEditingController bankidcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    fluwx.weChatResponseEventHandler.listen((res) {
      if (res is fluwx.WeChatPaymentResponse) {
        if (res.errCode == 0) {
          startTimer(orderId);
        } else {
          ToastUtil.showToast('支付失败,请重试');
        }
      }
    });
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

  void startTimer(orderId) {
    setState(() {
      isPayLoading = true;
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
    map.putIfAbsent("type", () => "6");
    UserServer().getPayStatus(map, (success) async {
      setState(() {
        isPayLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');
      Navigator.pop(context);
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  void payhhr() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    Service().sget(Api.SHENGJI_HEHUOREN_URL, map, (success) async {
      setState(() {
        isLoading = false;
      });
      fluwx.payWithWeChat(
        appId: success['res']['appid'],
        partnerId: success['res']['partnerid'],
        prepayId: success['res']['prepayid'],
        packageValue: success['res']['package'],
        nonceStr: success['res']['noncestr'],
        timeStamp: success['res']['timestamp'],
        sign: success['res']['sign'],
      );
      orderId = success['res']['order_id'];
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget ewm = Container(
      padding: EdgeInsets.only(top: 100),
      // child: QrImage(
      //   data: 'https://www.baidu.com/',
      //   version: QrVersions.auto,
      //   size: 200,
      //   gapless: false,
      // ),
      child: Image.asset(
        "assets/mine/ewm.jpg",
        width: ScreenUtil().setWidth(400),
        height: ScreenUtil().setWidth(400),
      ),
    );

    Widget ewmtext = Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Text(
          "购买升级服务商请扫码或搜索添加橙子宝宝客服微信，按客服指导操作升级。客服微信号：mysj1717",
          style: TextStyle(
            color: PublicColor.textColor,
            // fontSize: weigu
          ),
        ));
    // Widget btn = Container(
    //     width: double.infinity,
    //     padding: EdgeInsets.only(
    //       top: ScreenUtil().setWidth(108),
    //       bottom: ScreenUtil().setWidth(108),
    //     ),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //     ),
    //     child: Column(
    //       children: <Widget>[
    //         InkWell(
    //           onTap: () {
    //             payhhr();
    //           },
    //           child: Container(
    //             width: ScreenUtil().setWidth(497),
    //             height: ScreenUtil().setHeight(83),
    //             alignment: Alignment.center,
    //             decoration: BoxDecoration(
    //               gradient: PublicColor.btnlinear,
    //               borderRadius: BorderRadius.circular(5),
    //             ),
    //             child: Text(
    //               "购买播商服务商权限",
    //               style: TextStyle(
    //                 color: PublicColor.btnColor,
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ));

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '升级播商服务商',
              style: new TextStyle(
                color: PublicColor.headerTextColor,
              ),
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
          body: new Container(
            alignment: Alignment.center,
            child: new Column(
              children: [ewm, ewmtext],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
        isPayLoading
            ? LoadingDialog(
                types: "1",
              )
            : Container(),
      ],
    );
  }
}
