import 'package:client/service/store_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'dart:convert';
import '../widgets/loading.dart';

class CumulativeFwPage extends StatefulWidget {
  @override
  CumulativeFwPageState createState() => CumulativeFwPageState();
}

class CumulativeFwPageState extends State<CumulativeFwPage> {
  bool isLoading = false;
  List dateList = [], fangke = [], fangwen = [], hotList = [], saleList = [];
  var option = {};
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    StoreServer().guestManage(map, (success) async {
      setState(() {
        isLoading = false;
        hotList = success['hot'].take(3).toList();
        saleList = success['sale'].take(3).toList();
        dateList = success['time'];
        fangke = success['data']['fangke'];
        fangwen = success['data']['fangwen'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    option = {
      "xAxis": {"type": "category", "data": dateList},
      "yAxis": {"type": "value"},
      "series": [
        {"data": fangke, "type": "line"},
        {"data": fangwen, "type": "line"},
      ]
    };

    Widget echartArea = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: ScreenUtil().setWidth(700),
        // height: ScreenUtil().setWidth(550),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(right: 50),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '访问数据',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Text(
                        '七日数据统计',
                        style: TextStyle(
                          color: Color(0xffc8c8c8),
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 150),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Container(child: Text('访客量')),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(10),
                      decoration: BoxDecoration(
                          color: Color(0xfff58d52),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(child: Text('访问量')),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(10),
                      decoration: BoxDecoration(
                          color: Color(0xffff2e90),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(400),
              child: isLoading
                  ? LoadingDialog()
                  : Echarts(option: '''${jsonEncode(option)}'''),
            )
          ],
        ),
      ),
    );

    // 单个商品组件
    Widget goodsItem(item) {
      return Expanded(
        flex: 1,
        child: InkWell(
          child: Container(
            height: ScreenUtil().setWidth(260),
            width: ScreenUtil().setWidth(213),
            decoration: BoxDecoration(
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.circular(10),
            ),
            child: new Column(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['img'],
                      height: ScreenUtil().setWidth(200),
                      width: ScreenUtil().setWidth(213),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    item['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(28),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            print('商品');
          },
        ),
      );
    }

    Widget goodsItem1(item) {
      return Expanded(
        flex: 1,
        child: InkWell(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            // height: ScreenUtil().setWidth(260),
            width: ScreenUtil().setWidth(213),
            decoration: BoxDecoration(
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.circular(10),
            ),
            child: new Column(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['thumb'],
                      height: ScreenUtil().setWidth(200),
                      width: ScreenUtil().setWidth(213),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '${item['name']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(28),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            print('商品');
          },
        ),
      );
    }

    Widget buildHot() {
      List<Widget> arr = <Widget>[];
      Widget content;
      for (var item in hotList) {
        arr.add(goodsItem(item));
      }
      content = Row(children: arr);
      return content;
    }

    Widget buildSale() {
      List<Widget> arr = <Widget>[];
      Widget content;
      for (var item in saleList) {
        arr.add(goodsItem1(item));
      }
      content = Row(children: arr);
      return content;
    }

    Widget shops = new Container(
      alignment: Alignment.center,
      child: new Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().setWidth(700),
          height: ScreenUtil().setWidth(400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
          ),
          child: new Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setWidth(85),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffdddddd),
                    ),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    text: '七日最热类目',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil.instance.setWidth(28)),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'TOP',
                        style: TextStyle(
                          color: Color(0xffef7272),
                          fontSize: ScreenUtil.instance.setWidth(28),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: buildHot(),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: ScreenUtil().setWidth(700),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
          ),
          child: new Column(children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(85),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
              ),
              child: RichText(
                text: TextSpan(
                  text: '七日热销商品',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(28)),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'TOP',
                      style: TextStyle(
                        color: Color(0xffef7272),
                        fontSize: ScreenUtil.instance.setWidth(28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // padding: EdgeInsets.only(top: 15),
              child: buildSale(),
            )
          ]),
        )
      ]),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '访客管理',
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
        body: Container(
          alignment: Alignment.center,
          child: new ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              echartArea,
              shops,
              new SizedBox(height: ScreenUtil().setHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
