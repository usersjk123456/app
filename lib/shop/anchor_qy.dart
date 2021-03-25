import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class AnchorQyPage extends StatefulWidget {
  @override
  AnchorQyPageState createState() => AnchorQyPageState();
}

class AnchorQyPageState extends  State<AnchorQyPage> {

  @override
  Widget build(BuildContext context) {
  ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget content = new Container(
      child: Container(
        color: Color(0xffffbc3d),
        alignment: Alignment.center,
        child: Image.asset('assets/shop/zhuboquanyi.png',),
      ),
    );
   return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '主播权益',
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
            color: Color(0xffffbc3d),
            alignment: Alignment.center,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                content
              ],
            ),
          ),
        ));
  }
}