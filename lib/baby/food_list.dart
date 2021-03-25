import 'dart:async';

import 'package:client/api/api.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class FoodList extends StatefulWidget {
  final String foodId;
  FoodList({this.foodId});
  @override
  FoodListState createState() => FoodListState();
}

class FoodListState extends State<FoodList> {
  EasyRefreshController _controller = EasyRefreshController();
  String aboutContent;
  bool isLoading = false;
  List foodCdlist = [];
  int _page = 0;
  int _limit = 10;
  @override
  void initState() {
    super.initState();
    getFoodList();
  }

  void getFoodList() {
    _page++;
    if (_page == 1) {
      setState(() {
        foodCdlist = [];
      });
    }
    //获取辅食菜单列表
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => widget.foodId);
    map.putIfAbsent("limit", () => _limit);
    map.putIfAbsent("page", () => _page);
    Service().getData(map, Api.FOODCD_List_URL, (success) async {
      print(success['list']['data'].length);
      print('!!!!!!!!');
      if (success['list']['data'].length <= 0) {
        // setState(() {
        //   isloading = false;
        // });
        // ToastUtil.showToast('已加载全部数据');
      } else {
        setState(() {
          for (var i = 0; i < success['list']['data'].length; i++) {
            foodCdlist.add(success['list']['data'][i]);
          }
        });
      }

      _controller.finishRefresh();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
      _controller.finishRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    //标签
    bqView() {
      List<Widget> list = [];
      for (var i = 0; i < 18; i++) {
        list.add(
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfffFCE1CD)),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(6),
                bottom: ScreenUtil().setWidth(6),
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16)),
            child: Text(
              '补铁${widget.foodId}',
              style: TextStyle(
                fontSize: ScreenUtil.instance.setWidth(24.0),
                color: PublicColor.foodColor,
              ),
            ),
          ),
        );
      }
      return list;
    }

    Widget bqContainer = Container(
      child: Wrap(
        runSpacing: ScreenUtil.instance.setWidth(10.0),
        spacing: ScreenUtil.instance.setWidth(26),
        children: bqView(),
      ),
    );

    _createGridViewItem() {
      List<Widget> list = [];
      for (var i = 0; i < foodCdlist.length; i++) {
        // 你想分几列，就除以几， 高度可以进行自定义
        list.add(Container(
            decoration: BoxDecoration(
                color: PublicColor.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                      blurRadius: 15.0, //阴影模糊程度
                      spreadRadius: 1.0 //阴影扩散程度
                      )
                ]),
            width: ScreenUtil.instance.setWidth(334.0),
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(20),
            ),
            // height: ScreenUtil.instance.setWidth(443.0),
            child: InkWell(
              onTap: () {
                NavigatorUtils.goFoodDetails(context, foodCdlist[i]['id'])
                    .then((res) {
                  setState(() {
                    _page = 0;
                  });
                  getFoodList();
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: ScreenUtil.instance.setWidth(257.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil.instance.setWidth(334.0),
                          height: ScreenUtil.instance.setWidth(220.0),
                          decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage("${foodCdlist[i]['img']}"),
                                  fit: BoxFit.fitWidth),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ))),
                        ),
                        Positioned(
                            top: ScreenUtil.instance.setWidth(203.0),
                            left: ScreenUtil.instance.setWidth(24.0),
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(6),
                                  bottom: ScreenUtil().setWidth(6),
                                  left: ScreenUtil().setWidth(16),
                                  right: ScreenUtil().setWidth(16)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: PublicColor.foodColor),
                              child: Text(
                                '${foodCdlist[i]['age']}',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(24.0),
                                  color: PublicColor.whiteColor,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(24),
                    ),
                    child: Text(
                      '${foodCdlist[i]['name']}',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(28.0),
                        color: PublicColor.textColor,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(10),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(10),
                          left: ScreenUtil().setWidth(24)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(16)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xfffFCE1CD)),
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(6),
                                bottom: ScreenUtil().setWidth(6),
                                left: ScreenUtil().setWidth(16),
                                right: ScreenUtil().setWidth(16)),
                            child: Text(
                              '${foodCdlist[i]['nutrients']}',
                              style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(24.0),
                                color: PublicColor.foodColor,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xfffFCE1CD)),
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(6),
                                bottom: ScreenUtil().setWidth(6),
                                left: ScreenUtil().setWidth(16),
                                right: ScreenUtil().setWidth(16)),
                            child: Text(
                              '${foodCdlist[i]['food']}',
                              style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(24.0),
                                color: PublicColor.foodColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(29),
                        left: ScreenUtil().setWidth(24)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(6)),
                                child: Image.asset(
                                  'assets/foods/xin.png',
                                  width: ScreenUtil.instance.setWidth(28.0),
                                ),
                              ),
                              Container(
                                child: Text('${foodCdlist[i]['like']}'),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(6)),
                                child: Image.asset(
                                  'assets/foods/yanjing.png',
                                  width: ScreenUtil.instance.setWidth(28.0),
                                ),
                              ),
                              Container(
                                child: Text('${foodCdlist[i]['visits']}'),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
      }
      return list;
    }

    Widget foodView() {
      return Container(
          color: PublicColor.whiteColor,
          // height: ScreenUtil.instance.setWidth(520.0),
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(22),
          ),
          // width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: Wrap(
                  runSpacing: ScreenUtil.instance.setWidth(40.0),
                  spacing: ScreenUtil.instance.setWidth(20),
                  children: _createGridViewItem(),
                ),
              )
            ],
          ));
    }

    return MaterialApp(
      title: "为宝宝下厨吧",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '为宝宝下厨吧',
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
                color: PublicColor.whiteColor,
                width: ScreenUtil().setWidth(750),
                child: EasyRefresh(
                  controller: _controller,
                  header: BezierCircleHeader(
                    backgroundColor: PublicColor.themeColor,
                  ),
                  footer: BezierBounceFooter(
                    backgroundColor: PublicColor.themeColor,
                  ),
                  enableControlFinishRefresh: true,
                  enableControlFinishLoad: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        foodCdlist.length > 0 ? foodView() : NoData()
                      ],
                    ),
                  ),
                  onRefresh: () async {
                    // _controller.finishRefresh();
                    _page = 0;
                    getFoodList();
                  },
                  onLoad: () async {
                    getFoodList();
                    _controller.finishRefresh();
                  },
                )),
      ),
    );
  }
}
