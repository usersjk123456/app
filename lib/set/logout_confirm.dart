import 'package:client/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/verification.dart';

class LogoutConfirmPage extends StatefulWidget {
  @override
  LogoutConfirmPageState createState() => LogoutConfirmPageState();
}

class LogoutConfirmPageState extends State<LogoutConfirmPage> {
  TextEditingController _phoneController = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  FocusNode codeFocus = FocusNode();

  String phone = '';
  bool codeActive = false; //获取验证码按钮状态
  bool isLoading = false; //获取验证码按钮状态
  TextEditingController _codeController = TextEditingController();
  void logOff() async {
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("phone", () => _phoneController.text);
    map.putIfAbsent("code", () => _codeController.text);
    UserServer().logOff(map, (success) async {
      signOut();
      NavigatorUtils.logout(context);
      ToastUtil.showToast('注销成功');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget picArea = new Container(
      margin: EdgeInsets.only(top: 30),
      alignment: Alignment.topCenter,
      child: ClipOval(
        child: Image.asset(
          'assets/set/zx.png',
          height: ScreenUtil().setWidth(132),
          width: ScreenUtil().setWidth(132),
          fit: BoxFit.cover,
        ),
      ),
    );
    //提示信息部分
    Widget tipsArea = new Container(
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30),
          alignment: Alignment.topCenter,
          child: Text(
            '请核实是否符合以下情况',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
              color: Color(0xff545454),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.topCenter,
          child: Text(
            '否则账号无法注销',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
              color: Color(0xff545454),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 40),
            width: ScreenUtil().setWidth(543),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffadadad))))),
        Container(
          margin: EdgeInsets.only(top: 30),
          width: ScreenUtil().setWidth(400),
          child: new Row(children: <Widget>[
            Expanded(
                flex: 0,
                child: Container(
                    child: ClipOval(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    color: Color(0xFF454545),
                  ),
                ))),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '账号绑定的小程序',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
              ),
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().setWidth(400),
          child: new Row(children: <Widget>[
            Expanded(
                flex: 0,
                child: Container(
                    child: ClipOval(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    color: Color(0xFF454545),
                  ),
                ))),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '实名认证信息',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
              ),
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().setWidth(400),
          child: new Row(children: <Widget>[
            Expanded(
                flex: 0,
                child: Container(
                    child: ClipOval(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    color: Color(0xFF454545),
                  ),
                ))),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '银行卡信息',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
              ),
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().setWidth(400),
          child: new Row(children: <Widget>[
            Expanded(
                flex: 0,
                child: Container(
                    child: ClipOval(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    color: Color(0xFF454545),
                  ),
                ))),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '账号信息',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
              ),
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().setWidth(400),
          child: new Row(children: <Widget>[
            Expanded(
                flex: 0,
                child: Container(
                    child: ClipOval(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    color: Color(0xFF454545),
                  ),
                ))),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '会员权益信息',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
              ),
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().setWidth(400),
          child: new Row(children: <Widget>[
            Expanded(
                flex: 0,
                child: Container(
                    child: ClipOval(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    color: Color(0xFF454545),
                  ),
                ))),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '交易记录',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
              ),
            )
          ]),
        ),
      ]),
    );

    Widget btnArea = BigButton(
      name: '确认符合',
      tapFun: () {
        if (_phoneController.text == '') {
          ToastUtil.showToast('请输入手机号');
          return;
        }
        if (_codeController.text == '') {
          ToastUtil.showToast('请输入验证码');
          return;
        }
        print('确认');
        logOff();
      },
      top: ScreenUtil().setWidth(80),
    );
    // Widget phoneBtn = Row(
    //   children: <Widget>[Text('1111'), Text('2222')],
    // );

    //输入框
    Widget phoneBtn = new Container(
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
                        width: ScreenUtil().setWidth(30),
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
                        hintText: '请输入验证码', border: InputBorder.none),
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

    return MaterialApp(
        title: "注销账号",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '注销账号',
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
          body: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Container(
                  child: new ListView(
                    children: [picArea, tipsArea, phoneBtn, btnArea],
                  ),
                ),
              ],
            ),
            resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
          ),
          // body: new Container(
          //   alignment: Alignment.center,
          //   child: new Column(
          //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [picArea, tipsArea, phoneBtn, btnArea],
          //   ),
          // ),
        ));
  }
}
