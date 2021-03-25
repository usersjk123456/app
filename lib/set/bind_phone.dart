import 'package:client/common/regExp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import '../widgets/verification.dart';

class BindPhonePage extends StatefulWidget {
  @override
  BindPhonePageState createState() => BindPhonePageState();
}

class BindPhonePageState extends State<BindPhonePage>
    with WidgetsBindingObserver {
  String phone = "", code = "", newPhone = "";
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  FocusNode phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getInfo();
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
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 获取个人资料
  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      setState(() {
        phone = success['user']['phone'].toString();
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 更换手机
  void changePhone() {
    if (phoneController.text == '' || phoneController.text == null) {
      ToastUtil.showToast('请输入手机号');
      return;
    }
    if (!RegExpTest.checkPhone.hasMatch(phoneController.text)) {
      ToastUtil.showToast('电话号码格式错误');
      return;
    }
    if (codeController.text == '' || codeController.text == null) {
      ToastUtil.showToast('请输入验证码');
      return;
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("phone", () => phoneController.text);
    map.putIfAbsent("code", () => codeController.text);
    UserServer().changePhone(map, (success) async {
      ToastUtil.showToast('绑定成功');
      await Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget phoneArea = new Container(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
        child: Text(
          '手机号: $phone',
          style: TextStyle(
            color: Color(0xff454545),
            fontSize: ScreenUtil().setSp(28),
          ),
        ),
      ),
    );

    Widget phoneInput = new Container(
      child: Container(
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
              flex: 11,
              child: new TextField(
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      newPhone = value;
                    });
                  }
                },
                focusNode: phoneFocus,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                  hintText: '请输入新手机号',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget inputArea = new Container(
      child: Container(
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
                controller: codeController,
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                    hintText: '请输入验证码', border: InputBorder.none),
              ),
            ),
            Expanded(
              flex: 3,
              child: FormCode(
                countdown: 60,
                getPhone: () => newPhone,
                type: "login",
                available: true,
              ),
            ),
          ],
        ),
      ),
    );

    Widget btnArea = new Container(
      height: ScreenUtil().setWidth(86),
      width: ScreenUtil().setWidth(645),
      margin: EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
          gradient: PublicColor.btnlinear,
          borderRadius: new BorderRadius.circular((8.0))),
      child: new FlatButton(
        disabledColor: PublicColor.themeColor,
        onPressed: () {
          changePhone();
        },
        child: new Text(
          '确认',
          style: TextStyle(
            color: PublicColor.btnTextColor,
            fontSize: ScreenUtil().setSp(28),
          ),
        ),
      ),
    );
    return MaterialApp(
        title: phone == '未绑定' ? '绑定手机' : '更换手机',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              phone == '未绑定' ? '绑定手机' : '更换手机',
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
            alignment: Alignment.center,
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: ScreenUtil().setWidth(30),
                ),
                phoneArea,
                SizedBox(
                  height: ScreenUtil().setWidth(30),
                ),
                phoneInput,
                SizedBox(
                  height: ScreenUtil().setWidth(30),
                ),
                inputArea,
                btnArea
              ],
            ),
          ),
        ));
  }
}
