import 'dart:ui';

import 'package:client/api/api.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class FoodAll extends StatefulWidget {
  @override
  FoodAllState createState() => FoodAllState();
}

class FoodAllState extends State<FoodAll> {
  String aboutContent;
  bool isLoading = false;
  List foodAllList = [];
  List foodAllList1 = [];
  List foodAllList2 = [];
  List foodAllList3 = [];
  List foodAllList4 = [];
  @override
  void initState() {
    super.initState();
    getFoodList();
  }

  void getFoodList() {
    //获取辅食菜单列表
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("type", () => 3);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => 1);
    Service().getData(map, Api.FOODSP_URL, (success) async {
      print('~~~~~~~~~~~');
      print(success);
      setState(() {
        foodAllList = success['list']['data1'];
        foodAllList1 = success['list']['data2'];
        foodAllList2 = success['list']['data3'];
        foodAllList3 = success['list']['data4'];
        foodAllList4 = success['list']['data5'];
      });
      // print(foodAllList);

      print('~~~~~~~~!!!!!!!!!~~~~~~~~~~~');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget title(text) {
      return Container(
        child: Row(
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(35),
              width: ScreenUtil().setWidth(8),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(28)),
              decoration: BoxDecoration(
                color: PublicColor.foodColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(23)),
              child: Text(
                '${text}',
                style: TextStyle(
                  fontSize: ScreenUtil.instance.setWidth(32.0),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      );
    }

    ;
    mobanView(item) {
      List<Widget> list = <Widget>[];
      for (var i = 0; i < item.length; i++) {
        list.add(
          Container(
              child: InkWell(
            child: Column(
              children: <Widget>[
                CachedImageView(
                  ScreenUtil.instance.setWidth(100.0),
                  ScreenUtil.instance.setWidth(100.0),
                  '${item[i]['img']}',
                  null,
                  BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(22)),
                  child: Text('${item[i]['name']}'),
                )
              ],
            ),
            onTap: () {
              NavigatorUtils.goFoodList(context, item[i]['id'].toString());
            },
          )),
        );
      }
      return list;
    }

    ylmobanView(item) {
      print(item);
      print('卧槽');
      List<Widget> list = <Widget>[];
      for (var i = 0; i < item.length; i++) {
        list.add(
          Container(
              child: InkWell(
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(181),
              height: ScreenUtil().setWidth(76),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      const Color(0xffCAE283),
                      const Color(0xffEFFEC5)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 5.0), //阴影xy轴偏移量
                        blurRadius: 10.0, //阴影模糊程度
                        spreadRadius: 3.0 //阴影扩散程度
                        )
                  ],
                  borderRadius: BorderRadiusDirectional.circular(10)),
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(22)),
              child: Text(
                '${item[i]['name']}',
                style: TextStyle(
                  color: Color(0xff7C9D19),
                  fontSize: ScreenUtil.instance.setWidth(30.0),
                ),
              ),
            ),
            onTap: () {
              NavigatorUtils.goFoodList(context, item[i]['id'].toString());
              // NavigatorUtils.goFoodList(context);
            },
          )),
        );
      }
      return list;
    }

    Widget ylContainer = Container(
      color: PublicColor.whiteColor,
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(17),
      ),
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(45),
            ),
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(45),
            ),
            child: title("月龄"),
          ),
          Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(64)),
              child: Wrap(
                runSpacing: ScreenUtil.instance.setWidth(32.0),
                spacing: ScreenUtil.instance.setWidth(38),
                children: ylmobanView(foodAllList),
              ))
        ],
      ),
    );

    Widget yygnContainer = Container(
      color: PublicColor.whiteColor,
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(17),
      ),
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(45),
            ),
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(45),
            ),
            child: title("营养功能"),
          ),
          Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(64)),
              child: Wrap(
                runSpacing: ScreenUtil.instance.setWidth(40.0),
                spacing: ScreenUtil.instance.setWidth(70),
                children: mobanView(foodAllList1),
              ))
        ],
      ),
    );

    Widget cjfsContainer = Container(
      color: PublicColor.whiteColor,
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(17),
      ),
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(45),
            ),
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(45),
            ),
            child: title("常见辅食"),
          ),
          Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(64)),
              child: Wrap(
                runSpacing: ScreenUtil.instance.setWidth(40.0),
                spacing: ScreenUtil.instance.setWidth(70),
                children: mobanView(foodAllList2),
              ))
        ],
      ),
    );

    Widget cjsbfsContainer = Container(
      color: PublicColor.whiteColor,
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(17),
        bottom: ScreenUtil().setWidth(30),
      ),
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(45),
            ),
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(45),
            ),
            child: title("常见生病辅食"),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(64)),
            child: Wrap(
              runSpacing: ScreenUtil.instance.setWidth(40.0),
              spacing: ScreenUtil.instance.setWidth(70),
              children: mobanView(foodAllList3),
            ),
          )
        ],
      ),
    );

    Widget cjscContainer = Container(
      color: PublicColor.whiteColor,
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(17),
      ),
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(45),
            ),
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(45),
            ),
            child: title("常见食材"),
          ),
          Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(64)),
              child: Wrap(
                runSpacing: ScreenUtil.instance.setWidth(40.0),
                spacing: ScreenUtil.instance.setWidth(70),
                children: mobanView(foodAllList4),
              ))
        ],
      ),
    );

    return MaterialApp(
      title: "全部食谱",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '全部食谱',
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
        body: isLoading
            ? LoadingDialog()
            : Container(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ylContainer,
                    yygnContainer,
                    cjfsContainer,
                    cjsbfsContainer,
                    cjscContainer
                  ],
                )),
              ),
      ),
    );
  }
}
