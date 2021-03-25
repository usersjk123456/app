import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';

class BabyPage extends StatefulWidget {
    final String oid;
  BabyPage({this.oid});
  @override
  BabyPageState createState() => BabyPageState();
}

class BabyPageState extends State<BabyPage> {
String type;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget top = new Container(
  
          alignment: Alignment.center,
          child: Text(
            '请选择宝宝性别',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
              color: Color(0xff333333),
        
            ),
          ),
        );

    Widget bottom = new Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
  
          child: InkWell(
            child: Image.asset(
              'assets/login/ic_tj_nanhai.png',
              width: ScreenUtil().setWidth(300),
              fit: BoxFit.cover,
            ),
            onTap: () {
             
              NavigatorUtils.goBabyInfoPage(context,'1',widget.oid);
            },
          ),
        ),
       
        InkWell(
          child: Image.asset(
            'assets/login/ic_tj_nvhai.png',
            width: ScreenUtil().setWidth(300),
            fit: BoxFit.cover,
          ),
          onTap: () {

             NavigatorUtils.goBabyInfoPage(context,'2',widget.oid);
          },
        ),
     
      ],
    );


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
             appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '添加宝宝',
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
        ),
          body: new Container(
            color: Color(0xffffffff),
            alignment: Alignment.center,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // content
                SizedBox(
                  height: ScreenUtil().setHeight(126),
                ),
                top,
                    SizedBox(
                  height: ScreenUtil().setHeight(72),
                ),
                bottom,
         
              ],
            ),
          ),
        ));
  }
}
