import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';

class TixianPagePage extends StatefulWidget {
  @override
  TixianPagePageState createState() => TixianPagePageState();
}

class TixianPagePageState extends State<TixianPagePage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget kinds = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: ScreenUtil().setWidth(222),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          new InkWell(
            child: new Container(
              height: ScreenUtil().setWidth(108),
              width: ScreenUtil().setWidth(700),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 10),
                      child: Image.asset(
                        "assets/shop/zfb.png",
                        height: ScreenUtil().setWidth(60),
                        width: ScreenUtil().setWidth(60),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        '提现到支付宝',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ))
                ],
              ),
            ),
            onTap: () {
              NavigatorUtils.toTixianAlipayPage(context);
            },
          ),
          new InkWell(
            child: new Container(
              height: ScreenUtil().setWidth(108),
              width: ScreenUtil().setWidth(700),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 10),
                      child: Image.asset(
                        "assets/shop/yhk.png",
                        height: ScreenUtil().setWidth(60),
                        width: ScreenUtil().setWidth(60),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        '提现到银行卡',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ))
                ],
              ),
            ),
            onTap: () {
              NavigatorUtils.toTixianBankPage(context);
            },
          )
        ]),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '提现',
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
            actions: <Widget>[
              InkWell(
                child: Container(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Text(
                      '提现记录',
                      style: new TextStyle(
                        color: PublicColor.whiteColor,
                        fontSize: ScreenUtil().setSp(28),
                        height: 2.7,
                      ),
                    )),
                onTap: () {
                  NavigatorUtils.toTixianRecordPage(context);
                },
              )
            ],
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [kinds],
            ),
          ),
        ));
  }
}
