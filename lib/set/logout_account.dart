import '../widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../config/Navigator_util.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import '../common/Global.dart';

class LogoutAccountPage extends StatefulWidget {
  @override
  LogoutAccountPageState createState() => LogoutAccountPageState();
}

class LogoutAccountPageState extends State<LogoutAccountPage> {
  String phone;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  // 获取个人资料
  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      setState(() {
        phone = Global.formatPhone(success['user']['phone'].toString());
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
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
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
            child: Text(
              '$phone',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: Color(0xff545454),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.topCenter,
            child: Text(
              '注销以后以下信息将被清空且无法找回',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            width: ScreenUtil().setWidth(543),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffadadad),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            width: ScreenUtil().setWidth(400),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    child: ClipOval(
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xFF454545),
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
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
                  ),
                ),
              ),
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
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    child: ClipOval(
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xFF454545),
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: ScreenUtil().setWidth(400),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    child: ClipOval(
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xFF454545),
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: ScreenUtil().setWidth(400),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    child: ClipOval(
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xFF454545),
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: ScreenUtil().setWidth(400),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    child: ClipOval(
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xFF454545),
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
        ],
      ),
    );

    Widget btnArea = BigButton(
      name: '下一步',
      tapFun: () {
        NavigatorUtils.goLogoutConfirmPage(context);
      },
      top: ScreenUtil().setWidth(80),
    );

    Widget agreenmentArea = new Container(
      child: Container(
        width: ScreenUtil().setWidth(600),
        margin: EdgeInsets.only(top: 10),
        child: new Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text('点击下一步即代表您已同意'),
            ),
            Expanded(
              flex: 2,
              child: new InkWell(
                onTap: () {
                  NavigatorUtils.goAgreement(context, 'zhuxiao');
                },
                child: Text(
                  '《用户注销协议》',
                  style: TextStyle(
                    color: Color(0xfff33232),
                  ),
                ),
              ),
            )
          ],
        ),
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
        body: new Container(
          alignment: Alignment.center,
          child: new Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [picArea, tipsArea, btnArea, agreenmentArea],
          ),
        ),
      ),
    );
  }
}
