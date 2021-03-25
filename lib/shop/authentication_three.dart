import 'package:client/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import '../config/fluro_convert_util.dart';
import '../utils/toast_util.dart';

class AuthenticationThreePage extends StatefulWidget {
  final String objs;
  AuthenticationThreePage({this.objs});
  @override
  AuthenticationThreePageState createState() => AuthenticationThreePageState();
}

class AuthenticationThreePageState extends State<AuthenticationThreePage> {
  Map obj = {};
  TextEditingController bankcontroller = TextEditingController();
  TextEditingController bankidcontroller = TextEditingController();
  TextEditingController bankzhicontroller = TextEditingController();
  @override
  void initState() {
    obj = FluroConvertUtils.string2map(widget.objs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
 
  Widget topArea = new Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(453),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          "assets/shop/rzt.png",
        ),
      )),
      child: Stack(
        children: <Widget>[
          //bg图片

          Positioned(
            top: 10,
            left: 10,
            child: Container(
              width: ScreenUtil().setWidth(750),
              height: ScreenUtil().setWidth(112),
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Icon(
                      Icons.navigate_before,
                      color: Color(0xffffffff),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    '供应商认证',
                    style: new TextStyle(
                        color: Color(0xffffffff),
                        fontSize: ScreenUtil().setSp(32)),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(96),
                    height: ScreenUtil().setWidth(46),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 10,
            child: Container(
              child: Image.asset(
                "assets/shop/yhzm3.png",
                height: ScreenUtil().setWidth(190),
                width: ScreenUtil().setWidth(715),
              ),
            ),
          ),
        ],
      ),
    );

    Widget inforArea = new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(312),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular((8.0)),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '银行开户行',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ))),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: new TextField(
                      controller: bankcontroller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      decoration: new InputDecoration(
                        hintText: '请输入',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xffa1a1a1)),
                      ),
                    ),
                  ))
            ]),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '个人银行账户',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ))),
              Expanded(
                flex: 3,
                child: InkWell(
                  child: Container(
                    child: new TextField(
                      controller: bankidcontroller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      decoration: new InputDecoration(
                        hintText: '请输入',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xffa1a1a1)),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '开户行支行名称',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ))),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: new TextField(
                      controller: bankzhicontroller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      decoration: new InputDecoration(
                        hintText: '请输入',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xffa1a1a1)),
                      ),
                    ),
                  ))
            ]),
          )
        ]),
      ),
    );

    Widget btnArea = BigButton(
      name: '下一步',
      tapFun: () {
        if (bankcontroller.text == '') {
          ToastUtil.showToast('请输入开户行');
          return;
        }
        if (bankidcontroller.text == '') {
          ToastUtil.showToast('请输入银行卡号');
          return;
        }
        if (bankzhicontroller.text == '') {
          ToastUtil.showToast('请输入开户支行');
          return;
        }
        obj['open_bank'] = bankcontroller.text;
        obj['bank_account'] = bankidcontroller.text;
        obj['bank_branch'] = bankzhicontroller.text;
        NavigatorUtils.toAuthenticationFourPage(context, obj);
      },
      top: ScreenUtil().setWidth(40),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
     
          body: new Container(
            alignment: Alignment.center,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                topArea,
                inforArea,
                btnArea,
                new SizedBox(height: ScreenUtil().setWidth(30)),
              ],
            ),
          ),
        ));
  }
}
