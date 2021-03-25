import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shop/share_django.dart';

class InvitationFsPage extends StatefulWidget {
  @override
  InvitationFsPageState createState() => InvitationFsPageState();
}

class InvitationFsPageState extends State<InvitationFsPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget btnArea = new Container(
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setWidth(86),
        width: ScreenUtil().setWidth(640),
        // margin: EdgeInsets.only(top: 580),

        decoration: BoxDecoration(
       
          gradient: PublicColor.btnlinear,
          borderRadius: new BorderRadius.circular(
            (10.0),
          ),
        ),
        child: new FlatButton(
          disabledColor: PublicColor.themeColor,
          onPressed: () {
            print('vip');
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ShareDjango(type: "invite");
                });
          },
          child: new Text(
            '发送邀请',
            style: TextStyle(
              color: PublicColor.btnColor,
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '邀请专属粉丝',
            style: TextStyle(
              color: PublicColor.headerTextColor,
            ),
          ),
          backgroundColor: PublicColor.headerColor,
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
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setWidth(1334),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/shop/yqhy.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: ScreenUtil().setWidth(55),
                bottom: ScreenUtil().setWidth(40),
                child: btnArea,
              )
            ],
          ),
        ),
      ),
    );
  }
}
