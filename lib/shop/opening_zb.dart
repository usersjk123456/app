import '../widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './share_django.dart';

class OpeningZbPage extends StatefulWidget {
  @override
  OpeningZbPageState createState() => OpeningZbPageState();
}

class OpeningZbPageState extends State<OpeningZbPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget bg = new Container(
      alignment: Alignment.center,
      child: Container(
        child: new Column(
          children: <Widget>[
            new InkWell(
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/shop/bj1.png",
                  // height: ScreenUtil().setWidth(700),
                  width: ScreenUtil().setWidth(750),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new InkWell(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/shop/bj2.png",
                  height: ScreenUtil().setWidth(237),
                  width: ScreenUtil().setWidth(700),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: BigButton(
                name: '分享链接',
                tapFun: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareDjango(type: "open");
                      });
                },
              ),
            )
          ],
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
              '创业礼包',
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/shop/bj.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: new ListView(
              children: [
                bg
                // new SizedBox(height: ScreenUtil().setHeight(30)),
              ],
            ),
          ),
        ));
  }
}
