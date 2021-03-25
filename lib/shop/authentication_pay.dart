import 'dart:async';
import 'package:client/config/Navigator_util.dart';
import 'package:flutter_html/flutter_html.dart';

import '../widgets/btn_widget.dart';
import 'package:client/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../service/store_service.dart';
import '../widgets/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../service/user_service.dart';

class AuthenticationPayPage extends StatefulWidget {
  @override
  _AuthenticationPayPageState createState() => _AuthenticationPayPageState();
}

class _AuthenticationPayPageState extends State<AuthenticationPayPage> {
  bool isLoading = false;
  String money = "";
  String orderId = '';
  Timer _timer;
  bool _flag = true;
  String xieyi = "";
  String zbxieyi = "";
  String aboutContent = '';
  void updateGroupValue(v) {
    setState(() {
      _flag = v;
    });
  }

  @override
  void initState() {
    super.initState();
    getMoney();
    // getInfo();
    getAbout();
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

  // 获取个人资料
  void getAbout() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    UserServer().getAbout(map, (success) async {
      setState(() {
        aboutContent = success['res']['xieyi'];
        isLoading = false;
      });
    }, (onFail) async {
      isLoading = false;
      ToastUtil.showToast(onFail);
    });
  }

  void getInfo() {
    Map<String, dynamic> map = Map();
    StoreServer().getXieYi(map, (success) {
      setState(() {
        xieyi = success['res']['apply'];
        zbxieyi = success['res']['live'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  void getMoney() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("pay_state", () => 1);
    StoreServer().getStoreMoney(map, (success) async {
      setState(() {
        money = success['amount'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void payMoney() {
    Map<String, dynamic> map = Map();
    StoreServer().storePay(map, (success) async {
      fluwx.payWithWeChat(
        appId: success['res']['appid'],
        partnerId: success['res']['partnerid'],
        prepayId: success['res']['prepayid'],
        packageValue: success['res']['package'],
        nonceStr: success['res']['noncestr'],
        timeStamp: success['res']['timestamp'],
        sign: success['res']['sign'],
      );
      orderId = success['res']['order_id'].toString();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
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
    map.putIfAbsent("type", () => "3");
    UserServer().getPayStatus(map, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');
      createKf();
      // 创建客服
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  void pop() {
    Navigator.pop(context);
  }

  // 创建客服
  void createKf() async {
    Map<String, dynamic> map = Map();
    UserServer().createKf(map, (success) async {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return MyDialog(
                width: ScreenUtil.instance.setWidth(600.0),
                height: ScreenUtil.instance.setWidth(300.0),
                queding: () {
                  Clipboard.setData(ClipboardData(
                      text:
                          "http://kefu.fir.show/admin,${success['username']},${success['password']}"));
                  ToastUtil.showToast('信息已复制');
                  Navigator.of(context);
                  pop();
                },
                quxiao: () {
                  Navigator.of(context).pop();
                  pop();
                },
                title: '温馨提示',
                message:
                    '你的客服系统创建成功,请访问：http://kefu.fir.show/admin查看，客服账号为：${success['username']},密码为：${success['password']},请妥善保存');
          });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget btnArea = BigButton(
      name: '去缴纳',
      tapFun: () {
        if (_flag) {
          payMoney();
          // NavigatorUtils.toAuthenticationOnePage(context);
        } else {
          FlutterToast.showToast(
            msg: "请先阅读橙子宝宝保证金条款",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
          );
        }
      },
      top: ScreenUtil().setWidth(40),
    );

    Widget playBox = Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      child: Html(data: aboutContent),
    );
    Widget agreement = new Container(
      height: ScreenUtil().setHeight(275),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            offset: new Offset(0.0, 0.1),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(top: 25),
        child: new Column(
          children: <Widget>[btnArea],
        ),
      ),
    );

    Widget topArea = new Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '审核通过',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(20),
          ),
          RichText(
            text: TextSpan(
              text: '缴纳金额:',
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(28)),
              children: [
                TextSpan(
                  text: '$money 元',
                  style: TextStyle(
                      color: Colors.red, fontSize: ScreenUtil().setSp(28)),
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(50),
          ),
        ],
      ),
    );

    Widget content = Expanded(
        flex: 1,
        child: Column(
          children: <Widget>[
            // Container(
            //   padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            //   child: Text(
            //     '入驻申请协议',
            //     style: TextStyle(
            //       fontSize: ScreenUtil().setSp(30),
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                child: ListView(
                  children: <Widget>[
                    aboutContent != '' ? playBox : Container(),
                  ],
                ),
              ),
            ),
          ],
        ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: new Text(
                '供销商认证',
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
            body: new Container(
              alignment: Alignment.topLeft,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [topArea, content, agreement],
              ),
            ),
          ),
          isLoading
              ? LoadingDialog(
                  types: "1",
                )
              : Container()
        ],
      ),
    );
  }
}
