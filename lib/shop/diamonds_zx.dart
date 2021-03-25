import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';

class DiamondsZxPage extends StatefulWidget {
  @override
  DiamondsZxPageState createState() => DiamondsZxPageState();
}

class DiamondsZxPageState extends State<DiamondsZxPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    //活动专题
    Widget activityTopic = new Container(
      alignment: Alignment.center,
      child: Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().setWidth(700),
          height: ScreenUtil().setWidth(470),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: new Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Image.asset(
                "assets/shop/hdzt.png",
                height: ScreenUtil().setWidth(40),
                width: ScreenUtil().setWidth(320),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Wrap(
                spacing: 10.0, // 主轴(水平)方向间距
                runSpacing: 2.0,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {
                        NavigatorUtils.toDiamondsJxPage(context, "3");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          "assets/shop/zx1.png",
                          height: ScreenUtil().setWidth(323),
                          width: ScreenUtil().setWidth(210),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: InkWell(
                      onTap: () {
                        NavigatorUtils.toDiamondsJxPage(context, "4");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          "assets/shop/zx2.png",
                          height: ScreenUtil().setWidth(323),
                          width: ScreenUtil().setWidth(210),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: InkWell(
                      onTap: () {
                        ToastUtil.showToast('暂未开放');
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          "assets/shop/zx3.png",
                          height: ScreenUtil().setWidth(323),
                          width: ScreenUtil().setWidth(210),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '钻石专享111',
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
          child: new ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              activityTopic
              // new SizedBox(height: ScreenUtil().setWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}
