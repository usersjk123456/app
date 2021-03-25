import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InforCardPage extends StatefulWidget {
  @override
  InforCardPageState createState() => InforCardPageState();
}

class InforCardPageState extends State<InforCardPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget content = new Container(
      alignment: Alignment.center,
      child: new Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 100),
          child: Image.asset(
            "assets/shop/zwkf.png",
            height: ScreenUtil().setWidth(400),
            width: ScreenUtil().setWidth(350),
            fit: BoxFit.cover,
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '程序员正在开发中...',
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: ScreenUtil().setSp(28),
              ),
            ))
      ]),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: new Text(
              '信息卡',
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
            actions: <Widget>[
              InkWell(
                child: Container(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Text(
                      '新建',
                      style: new TextStyle(
                        color: PublicColor.textColor,
                        fontSize: ScreenUtil().setSp(28),
                        height: 2.7,
                      ),
                    )),
                onTap: () {
                  ToastUtil.showToast('敬请期待');
                  return;
                  // NavigatorUtils.toNewBulidPage(context);
                },
              )
            ],
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [content],
            ),
          ),
        ));
  }
}
