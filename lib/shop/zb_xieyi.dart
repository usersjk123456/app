import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/fluro_convert_util.dart';

class ZbXieyiPage extends StatefulWidget {
  final String objs;
  ZbXieyiPage({this.objs});
  @override
  _ZbXieyiPageState createState() => _ZbXieyiPageState();
}

class _ZbXieyiPageState extends State<ZbXieyiPage> {
  Map obj = {"xieyi": ""};
  @override
  void initState() {
    super.initState();
    obj = FluroConvertUtils.string2map(widget.objs);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '直播协议',
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
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: ListView(children: [
              Text(
                obj['xieyi'],
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ]),
          ),
        ));
  }
}
