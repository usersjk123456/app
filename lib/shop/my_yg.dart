import 'package:client/service/live_service.dart';
import 'package:client/widgets/dialog.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import '../utils/toast_util.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';

class MyYgPage extends StatefulWidget {
  @override
  MyYgPageState createState() => MyYgPageState();
}

class MyYgPageState extends State<MyYgPage> {
  bool isLoading = false;
  String jwt = '';
  List goodsList = [];
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();
    getMyNotice();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getMyNotice();
    }
  }

  void getMyNotice() async {
    Map<String, dynamic> map = Map();
    LiveServer().getMyNotice(map, (success) async {
      setState(() {
        isLoading = false;
        goodsList = success['list'];
      });
      _controller.finishRefresh();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 删除预告
  void deleNotice(item) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => item['id']);

    LiveServer().deleNotice(map, (success) async {
      ToastUtil.showToast('删除成功');
      getMyNotice();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  Widget listArea() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (goodsList.length == 0) {
      arr.add(Container(
        height: ScreenUtil().setWidth(700),
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Image.asset(
          'assets/mine/zwsj.png',
          width: ScreenUtil().setWidth(400),
        ),
      ));
    } else {
      for (var item in goodsList) {
        arr.add(Container(
          child: new Column(
            children: <Widget>[
              new InkWell(
                child: Container(
                  height: ScreenUtil().setWidth(246),
                  width: ScreenUtil().setWidth(750),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
                  ),
                  child: new Row(children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: Stack(children: <Widget>[
                        Positioned(
                          child: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Image.network(
                              item['img'].toString(),
                              height: ScreenUtil().setWidth(197),
                              width: ScreenUtil().setWidth(202),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          child: Container(
                              child: Image.asset(
                            "assets/shop/yg.png",
                            width: ScreenUtil().setWidth(60),
                            height: ScreenUtil().setWidth(40),
                            fit: BoxFit.cover,
                          )),
                        )
                      ]),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          item['desc'].toString(),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Container(
                            padding: EdgeInsets.only(bottom: 15),
                            alignment: Alignment.bottomRight,
                            child: new Row(children: <Widget>[
                              Expanded(
                                flex: 0,
                                child: Image.asset(
                                  "assets/shop/scan.png",
                                  width: ScreenUtil().setWidth(30),
                                  height: ScreenUtil().setSp(32),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                    child: Text(
                                  '删除',
                                  style: TextStyle(
                                      color: Color(0xffb6b6b6),
                                      fontSize: ScreenUtil().setSp(28),
                                      height: 1.7),
                                )),
                              )
                            ])),
                        onTap: () {
                          print('删除');
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return MyDialog(
                                  width: ScreenUtil.instance.setWidth(600.0),
                                  height: ScreenUtil.instance.setWidth(300.0),
                                  queding: () {
                                    deleNotice(item);
                                    Navigator.of(context).pop();
                                  },
                                  quxiao: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: '温馨提示',
                                  message: '确定删除该预告？');
                            },
                          );
                        },
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  NavigatorUtils.goLiveOverPage(context, item['room_id'], "1")
                      .then((res) {
                    getMyNotice();
                  });
                  // showDialog(
                  //   context: context,
                  //   barrierDismissible: true,
                  //   builder: (BuildContext context) {
                  //     return MyDialog(
                  //         width: ScreenUtil.instance.setWidth(600.0),
                  //         height: ScreenUtil.instance.setWidth(300.0),
                  //         queding: () {
                  //           createLive(item);
                  //           Navigator.of(context).pop();
                  //         },
                  //         quxiao: () {
                  //           Navigator.of(context).pop();
                  //         },
                  //         title: '温馨提示',
                  //         message: '确定开始直播？');
                  //   },
                  // );
                },
              ),
            ],
          ),
        ));
      }
    }
    content = Column(
      children: arr,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // Widget shopList = listArea();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text(
          '我的预告',
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
      body: contentWidget(),
    );
  }

  Widget contentWidget() {
    return Container(
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
            children: <Widget>[
              listArea(),
            ],
          ),
        ),
        onRefresh: () async {
          getMyNotice();
          _controller.finishRefresh();
        },
      ),
    );
  }
}
