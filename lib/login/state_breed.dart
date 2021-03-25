import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';

class StatePage extends StatefulWidget {
  @override
  StatePageState createState() => StatePageState();
}

class StatePageState extends State<StatePage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget top = new Column(
      children: <Widget>[
        Container(
          height: ScreenUtil().setWidth(120),
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(76)),
          alignment: Alignment.bottomLeft,
          child: Image.asset(
            'assets/login/ic_huanying_1.png',
            width: ScreenUtil().setWidth(79),
            height: ScreenUtil().setWidth(8),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(76), top: ScreenUtil().setWidth(24)),
          alignment: Alignment.bottomLeft,
          child: Text(
            '选择孕育状态',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(40),
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(76), top: ScreenUtil().setWidth(24)),
          alignment: Alignment.bottomLeft,
          child: Text(
            '橙子宝宝为您推荐专属内容',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(26),
              color: Color(0xff999999),
            ),
          ),
        ),
      ],
    );

    Widget bottom = new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(119)),
          child: InkWell(
            child: Image.asset(
              'assets/login/ic_jinru_yichusheng.png',
              width: ScreenUtil().setWidth(608),
              fit: BoxFit.cover,
            ),
            onTap: () {
              NavigatorUtils.goBabyPage(context);
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(43),
        ),
        InkWell(
          child: Image.asset(
            'assets/login/ic_jinru_huaiyunzhong.png',
            width: ScreenUtil().setWidth(608),
            fit: BoxFit.cover,
          ),
          onTap: () {
            NavigatorUtils.goHuaiyunPage(context);
          },
        ),
        SizedBox(
          height: ScreenUtil().setWidth(43),
        ),
        InkWell(
          child: Image.asset(
            'assets/login/ic_jinru_beiyunzhong.png',
            width: ScreenUtil().setWidth(608),
            fit: BoxFit.cover,
          ),
          onTap: () {
            NavigatorUtils.goHomePage(context);
          },
        ),
      ],
    );

    //跳过
    Widget topArea = new Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(102)),
      width: ScreenUtil().setWidth(750),
      alignment: Alignment.center,
      child: InkWell(
       child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '跳过',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: PublicColor.textColor),
            ),
            Icon(Icons.navigate_next),
          ],
        ),
        onTap: () {
          NavigatorUtils.goHomePage(context);
        },
      ),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: new Container(
            // color: Color(0xffffbc3d),
            alignment: Alignment.center,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // content
                top,
                bottom,
                topArea,
              ],
            ),
          ),
        ));
  }
}
