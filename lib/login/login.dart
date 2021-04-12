import 'dart:io';

import 'package:client/common/string.dart';
import 'package:client/utils/shared_preferences_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluwx/fluwx.dart' as fluwxlogin;
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../widgets/verification.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';
import 'agreement.dart';
import '../common/Global.dart';

class LoginPage extends StatefulWidget {
  final String type;
  LoginPage({this.type});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  DateTime lastPopTime;
  String jwt = '', uid = '';
  String phone = '';
  String code = '';
  String type = 'login';
  String type1 = 'login';
  bool agree = false;
  List list = [];
  bool codeActive = false; //获取验证码按钮状态
  bool isLoading = false; //获取验证码按钮状态
  bool _flag = false;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  FocusNode codeFocus = FocusNode();

  bool showVXLogin = true;

  @override
  void initState() {
    super.initState();
    wxLoginListen();
    getSwitch();
    showAgreement();
    WidgetsBinding.instance.addObserver(this);
    type = 'login';
    getEnableVxLogin();
  }

  void updateGroupValue(v) {
    setState(() {
      _flag = v;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("-didChangeAppLifecycleState-" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        phoneFocus.unfocus(); // 失去焦点
        codeFocus.unfocus();
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  void getList() async {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    UserServer().getbabyList(map, (success) async {
      if (success['list'].length > 0) {
        NavigatorUtils.addBaby(context);
      } else {
        await Future.delayed(Duration(seconds: 1), () {
          // NavigatorUtils.goHomePage(context);
          NavigatorUtils.goStatePage(context);
        });
      }

      setState(() {
        // isLoading = false;
        list = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getSwitch() async {
    Map<String, dynamic> map = Map();
    UserServer().getswitch(map, (success) async {
      setState(() {
        Global.isShow = success['display'] == 1 ? false : true;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void wxLoginListen() {
    fluwxlogin.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((data) async {
      //do something.
      if (data is fluwxlogin.WeChatAuthResponse) {
        if (data.errCode == 0) {
          if (type == 'login' && type1 == 'login') {
            Map<String, dynamic> map = Map();
            map.putIfAbsent("code", () => data.code);
            // map.putIfAbsent("code", () => "b2");
            map.putIfAbsent("edition", () => "1");
            UserServer().wxLogin(map, (success) async {
              Global.logined = true;
              // if (success['user']['shangji'] == 0) {
              //   showDialog<Null>(
              //     context: context,
              //     barrierDismissible: false,
              //     builder: (BuildContext context) {
              //       return BindDialog(uid: success['user']['id'].toString());
              //     },
              //   );
              // } else {
              ToastUtil.showToast('登录成功');
              final prefs = await SharedPreferences.getInstance();
              // 存值
              await prefs.setString('jwt', success['jwt']);
              await prefs.setInt('uid', success['user']['id']);
              await prefs.setString("contactPhone", success['contactPhone']);
              await Future.delayed(Duration(seconds: 1), () {
                // NavigatorUtils.goHomePage(context);
                getList();
              });
            }, (onFail) async {
              ToastUtil.showToast(onFail);
            });
          }
        } else {
          ToastUtil.showToast('授权失败');
        }
      }
    });
  }

  Future<void> showAgreement() async {
    final prefs = await SharedPreferences.getInstance();
    bool agreeResult = prefs.getBool(Strings.AGREE_AGREEMENT);
    agree = agreeResult ?? false;
    if (agree) {
      return;
    }
    await Future.delayed(Duration(seconds: 1), () {
      showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AgreementDialog(uid: '123');
        },
      );
    });
  }

  @override
  void dispose() {
    type = 'bind';
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 微信登录接口
  void login() async {
    fluwxlogin
        .sendWeChatAuth(scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
        .then((data) {});
  }

  void phoneLogin() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("phone", () => _phoneController.text);
    map.putIfAbsent("code", () => _codeController.text); //_codeController.text
    map.putIfAbsent("edition", () => "1");
    UserServer().login(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('登录成功');
      // getList();
      final prefs = await SharedPreferences.getInstance();
      // 存值
      await prefs.setString('jwt', success['jwt']);
      await prefs.setInt('uid', success['user']['id']);
      await prefs.setString("contactPhone", success['contactPhone']);
      await Future.delayed(Duration(seconds: 1), () {
        // NavigatorUtils.goHomePage(context);
        getList();
        // if(list.length<=0){

        // }else{
        //    NavigatorUtils.goHomePage(context);
        // }
      });
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

    //跳过
    Widget topArea = new Container(
      margin: EdgeInsets.only(top: 40),
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 20,
            child: new Text(
              '',
            ),
          ),
          /*Expanded(
              flex: 2,
              child: InkWell(
                child: Text(
                  '跳过',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: PublicColor.textColor),
                ),
                onTap: () async {
                  // NavigatorUtils.goHomePage(context);
                  if (_flag) {
                         final prefs = await SharedPreferences.getInstance();
                     await prefs.setString('jwt',"");
                    NavigatorUtils.goStatePage(context);
                  } else {
                    ToastUtil.showToast('请先同意用户协议');
                  }
                },
              )),
          Expanded(
            flex: 2,
            child: new Icon(Icons.arrow_forward),
          )*/
        ],
      ),
    );
    //logo
    Widget logoImageArea = new Container(
      margin: EdgeInsets.only(top: 30),
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/login/logo.png",
        height: ScreenUtil().setWidth(198),
        width: ScreenUtil().setWidth(150),
        fit: BoxFit.cover,
      ),
    );

    //输入框
    Widget inputArea = new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: new Column(
        children: <Widget>[
          //手机号
          new InkWell(
            child: new Container(
              height: ScreenUtil().setWidth(130),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd)))),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new Container(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/login/tel.png",
                        height: ScreenUtil().setWidth(38),
                        width: ScreenUtil().setWidth(26),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: new TextField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: new InputDecoration(
                        hintText: '请输入手机号',
                        hintStyle: TextStyle(
                            // color: Color.fromRGBO(255, 255, 255, 0.6)
                            ),
                        border: InputBorder.none,
                      ),
                      focusNode: phoneFocus,
                      onChanged: (value) {
                        setState(() {
                          codeActive = value.length == 0 ? false : true;
                          phone = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          //验证码
          Container(
              child: new Container(
            height: ScreenUtil().setWidth(130),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd)))),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/login/yanzheng.png",
                      height: ScreenUtil().setWidth(34),
                      width: ScreenUtil().setWidth(30),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: new TextField(
                    keyboardType: TextInputType.phone,
                    controller: _codeController,
                    focusNode: codeFocus,
                    decoration: new InputDecoration(
                      hintText: '请输入验证码',
                      // hintStyle:
                      // TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)
                      // ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FormCode(
                    countdown: 60,
                    getPhone: () => phone,
                    type: "login",
                    available: codeActive,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );

    Widget xieyi = new Container(
      alignment: Alignment.center,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: new Container(
              alignment: Alignment.centerRight,
              child: Image.asset(
                _flag ? "assets/login/check1.png" : "assets/login/check2.png",
                // height: ScreenUtil().setHeight(33),
                width: ScreenUtil().setWidth(40),
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              if (_flag) {
                _flag = false;
              } else {
                _flag = true;
              }
              updateGroupValue(_flag);
            },
          ),
          Text.rich(
            TextSpan(
              text: '  同意橙子宝宝',
              style: TextStyle(fontSize: 15),
              children: [
                TextSpan(
                  text: '《用户协议》',
                  style: TextStyle(fontSize: 15, color: PublicColor.themeColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      String type = "0";
                      NavigatorUtils.goXieYiPage(context, type);
                    },
                ),
                TextSpan(
                  text: ' 《隐私政策》',
                  style: TextStyle(fontSize: 15, color: PublicColor.themeColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      String type = "1";
                      NavigatorUtils.goXieYiPage(context, type);
                    },
                )
              ],
            ),
          )
        ],
      ),
    );

    //登录按钮
    Widget btnArea = new Container(
      height: ScreenUtil().setWidth(94),
      width: ScreenUtil().setWidth(575),
      margin: EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
          gradient: PublicColor.linearBtn,
          borderRadius: new BorderRadius.circular((30.0))),
      child: new FlatButton(
        disabledColor: PublicColor.themeColor,
        onPressed: () {
         if (_phoneController.text == '') {
            ToastUtil.showToast('请输入手机号');
            return;
          }
          if (_codeController.text == '') {
            ToastUtil.showToast('请输入验证码');
            return;
          }
          if (_flag) {
            phoneLogin();
          } else {
            ToastUtil.showToast('请先同意用户协议');
          }
        },
        child: new Text(
          '登录',
          style: TextStyle(
            color: PublicColor.btnTextColor,
            fontSize: ScreenUtil().setSp(28),
          ),
        ),
      ),
    );

    //第三方登录区域
    Widget thirdLoginArea = new Container(
      margin: EdgeInsets.only(
        left: 45,
        right: 45,
        top: 60,
      ),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
              Text(
                '其他登录方式',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  // color: Colors.white,
                ),
              ),
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );

    //微信登录
    Widget weChatArea = new Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 20),
      child: new Column(
        children: <Widget>[
          new InkWell(
            child: Container(
              // 圆形图片
              child: ClipOval(
                child: Image.asset(
                  'assets/login/weixin.png',
                  height: ScreenUtil().setWidth(86),
                  width: ScreenUtil().setWidth(86),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () async {
              if (!_flag) {
                ToastUtil.showToast('请先同意用户协议');
                // showAgreement();
                return;
              }
              // final prefs = await SharedPreferences.getInstance();
              // agree = prefs.getString('agree');
              // if (agree != '1') {
              //   ToastUtil.showToast('请先同意用户协议');
              //   showAgreement();
              //   return;
              // }
              login();
              // print('微信登录');
              // ToastUtil.showToast('暂未开放');
            },
          ),
          new InkWell(
              child: new Container(
            child: new Text(
              '微信登录',
              style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: ScreenUtil().setSp(30),
                  height: 2),
            ),
          ))
        ],
      ),
    );

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("assets/login/bg.png"),
                //   fit: BoxFit.cover,
                // ),
                color: Color(0xffffffff),
              ),
              child: new ListView(
                children: <Widget>[
                  // new SizedBox(
                  //   height: ScreenUtil().setHeight(100),
                  // ),
                  topArea,
                  logoImageArea,
                  inputArea,
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(87.5),
                      right: ScreenUtil().setWidth(87.5),
                    ),
                    child: btnArea,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(30)),
                  xieyi,
                  Global.isShow && showVXLogin ? Column(
                    children: [
                      thirdLoginArea,
                      weChatArea
                    ],
                  ): Container(),
                  // weChatArea
                ],
              ),
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ),
        resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
      ),
      onWillPop: () async {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          ToastUtil.showToast('再按一次退出');
          return false;
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    );
  }

  Future<void> getEnableVxLogin() async {
    Map<String, dynamic> map = Map();
    UserServer().getEnableVxLogin(map, (success) async {
     if (Platform.isAndroid) {
       return;
     }
     setState(() {
       showVXLogin = success["isShowWxLogin"] == 1;
     });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }
}
