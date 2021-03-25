import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../config/Navigator_util.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import '../common/Global.dart';

class AccountSafePage extends StatefulWidget {
  @override
  AccountSafePageState createState() => AccountSafePageState();
}

class AccountSafePageState extends State<AccountSafePage> {
  String nickname = '', phone = '';

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  // 获取个人资料
  void getInfo() async {
    print('info================');
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      if (mounted) {
        setState(() {
          nickname = success['user']['nickname'];
          phone = Global.formatPhone(success['user']['phone'].toString());
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget accountArea = new Container(
      height: ScreenUtil().setWidth(306),
      width: ScreenUtil().setWidth(700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xffe5e5e5), width: 1),
      ),
      child: new Column(children: <Widget>[
        new InkWell(
          child: Container(
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  '关联微信',
                  style: TextStyle(
                    color: Color(0xff454545),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: new Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$nickname',
                    style: TextStyle(
                      color: Color(0xffbababa),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            if (phone == '未绑定') {
              ToastUtil.showToast('请先绑定手机');
              return;
            }
            NavigatorUtils.goRelationWechatPage(context)
                .then((res) => getInfo());
          },
        ),
        new InkWell(
          child: Container(
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  phone == '未绑定' ? '绑定手机' : '更换手机',
                  style: TextStyle(
                    color: Color(0xff454545),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: new Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$phone',
                    style: TextStyle(
                      color: Color(0xffbababa),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            if (phone == '未绑定') {
              NavigatorUtils.goBindPhonePage(context).then((res) => getInfo());
            } else {
              NavigatorUtils.goReplacePhonePage(context)
                  .then((res) => getInfo());
            }
          },
        ),
        new InkWell(
          child: Container(
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            child: new Row(children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  '注销账号',
                  style: TextStyle(
                    color: Color(0xff454545),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            NavigatorUtils.goLogoutAccountPage(context)
                .then((res) => getInfo());
          },
        ),
      ]),
    );
    return MaterialApp(
        title: "账户安全",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '账户安全',
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
                  height: ScreenUtil().setWidth(20),
                ),
                accountArea
              ],
            ),
          ),
        ));
  }
}
