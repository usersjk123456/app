import '../widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import '../common/Global.dart';
import 'package:fluwx/fluwx.dart' as fluwxbind;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../config/routes.dart';
import '../widgets/verification.dart';

class RelationWechatPage extends StatefulWidget {
  final String type;
  RelationWechatPage({this.type});

  @override
  RelationWechatPageState createState() => RelationWechatPageState();
}

class RelationWechatPageState extends State<RelationWechatPage> {
  String nickname, phone = "", phonecode, allphone;
  TextEditingController phoneController = TextEditingController();
  String type = 'bind';
  bool codeActive = false;
  @override
  void initState() {
    super.initState();
    wxLoginListen();
    getInfo();
  }

  @override
  void dispose() {
    type = 'bindssssss';
    super.dispose();
  }

  void wxLoginListen() {
    fluwxbind.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((data) async {
      //do something.
      if (data is fluwxbind.WeChatAuthResponse) {
        if (type == 'bind') {
          changeWx(data.code);
        }
      }
    });
  }

  // 获取个人资料
  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      setState(() {
        nickname = success['user']['nickname'];
        phone = success['user']['phone'].toString();
        allphone = success['user']['phone'].toString();
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 绑定微信
  // 绑定微信
  void bindWx() {
    fluwxbind
        .sendWeChatAuth(scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
        .then((data) {});
  }

  //更换微信
  void changeWx(code) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("phonecode", () => phonecode);
    map.putIfAbsent("phone", () => allphone);
    map.putIfAbsent("code", () => code);
    UserServer().changeWx(map, (success) async {
      ToastUtil.showToast('绑定成功');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await Future.delayed(Duration(seconds: 1), () {
        Routes.navigatorKey.currentState
            .pushNamedAndRemoveUntil("/", ModalRoute.withName(Routes.root));
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget topArea = new Container(
      child: new Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
              child: new Row(children: <Widget>[
                Container(
                  child: Text('亲爱的：'),
                ),
                Container(
                  child: Text('$nickname'),
                )
              ])),
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            alignment: Alignment.centerLeft,
            child: Text('请输入绑定你的手机号 ${Global.formatPhone(phone)} 收到的验证码'),
          )
        ],
      ),
    );

    Widget inputArea = new Container(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
        height: ScreenUtil().setWidth(106),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: new TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                  hintText: '请输入验证码',
                  border: InputBorder.none,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FormCode(
                countdown: 60,
                getPhone: () => allphone,
                type: "login",
                available: true,
              ),
            ),
          ],
        ),
      ),
    );

    Widget btnArea = BigButton(
      name: '更换绑定微信',
      tapFun: () {
        if (phoneController.text == '') {
          ToastUtil.showToast('请输入验证码');
          return;
        }
        setState(() {
          phonecode = phoneController.text;
        });
        bindWx();
      },
      top: ScreenUtil().setWidth(120),
    );

    return MaterialApp(
      title: "绑定微信",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '绑定微信',
            style: TextStyle(
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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new SizedBox(
                height: ScreenUtil().setWidth(30),
              ),
              topArea,
              inputArea,
              btnArea
            ],
          ),
        ),
      ),
    );
  }
}
