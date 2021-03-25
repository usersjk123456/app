import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/loading.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';

class DiamondsJxPage extends StatefulWidget {
  final String type;
  DiamondsJxPage({this.type});
  @override
  DiamondsJxPageState createState() => DiamondsJxPageState();
}

class DiamondsJxPageState extends State<DiamondsJxPage> {
  bool isLoading = false;
  EasyRefreshController _controller = EasyRefreshController();
  List shopList = [];
  String title = '';

  @override
  void initState() {
    super.initState();
    getList();
    getTitle(widget.type);
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => widget.type);
    StoreServer().getDiomondList(map, (success) {
      setState(() {
        shopList = success['list'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  void getTitle(type) {
    if (type == '3') {
      title = '钻石精选';
    } else if (type == '4') {
      title = '每周必BUY';
    } else if (type == '5') {
      title = '低价专区';
    }
  }

  Widget listArea() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (shopList.length != 0) {
      for (var item in shopList) {
        arr.add(
          Container(
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(15)),
            child: new Column(children: <Widget>[
              new InkWell(
                child: new Container(
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setWidth(256),
                  padding: EdgeInsets.only(left: 10),
                  // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Color(0xffdddddd))),
                    color: Colors.white,
                  ),
                  child: new Row(children: <Widget>[
                    Expanded(
                        flex: 0,
                        child: Container(
                          child: Image.network(
                            item['thumb'],
                            height: ScreenUtil().setWidth(204),
                            width: ScreenUtil().setWidth(204),
                            fit: BoxFit.cover,
                          ),
                        )),
                    Expanded(
                      flex: 2,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(20),
                                ScreenUtil().setWidth(20),
                                ScreenUtil().setWidth(10),
                                0),
                            alignment: Alignment.topLeft,
                            child: Text(
                              item['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(20),
                              0,
                              ScreenUtil().setWidth(10),
                              ScreenUtil().setWidth(15),
                            ),
                            child: new Row(children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: RichText(
                                  text: TextSpan(
                                    text: '￥',
                                    style: TextStyle(
                                      color: Color(0xffe61414),
                                      fontSize:
                                          ScreenUtil.instance.setWidth(26),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: item['now_price'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffe61414),
                                          fontSize:
                                              ScreenUtil.instance.setWidth(30),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: InkWell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: ScreenUtil().setWidth(56),
                                      width: ScreenUtil().setWidth(142),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: PublicColor.btnlinear,
                                      ),
                                      child: Text(
                                        '购买',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(28),
                                          color: PublicColor.whiteColor,
                                        ),
                                      )),
                                  onTap: () {
                                    print('购买');
                                    NavigatorUtils.toXiangQing(
                                        context, item['id'], '0', '0');
                                  },
                                ),
                              )
                            ]),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
                onTap: () {
                  print('商品');
                },
              ),
            ]),
          ),
        );
      }
    } else {
      arr.add(Container(
        margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(300),
        ),
        child: Image.asset(
          'assets/mine/zwsj.png',
          width: ScreenUtil().setWidth(400),
        ),
      ));
    }

    content = Column(
      children: arr,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    // Widget btnArea = new Container(
    //   alignment: Alignment.center,
    //   child: Container(
    //     height: ScreenUtil().setWidth(86),
    //     width: ScreenUtil().setWidth(640),
    //     decoration: BoxDecoration(
    //         color: PublicColor.themeColor,
    //         borderRadius: new BorderRadius.circular((8.0))),
    //     child: new FlatButton(
    //       disabledColor: PublicColor.themeColor,
    //       onPressed: () {
    //         Navigator.push(context,
    //               MaterialPageRoute(builder: (context) => AuthenticationTwoPage()));
    //       },
    //       child: new Text(
    //         '结算 ￥0.00元',
    //         style: TextStyle(
    //             color: PublicColor.textColor,
    //             fontSize: ScreenUtil().setSp(28),
    //             fontWeight: FontWeight.w600),
    //       ),
    //     ),
    //   ),
    // );

    Widget contentWidget() {
      return Stack(
        children: <Widget>[
          Container(
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
                _controller.finishRefresh();
              },
            ),
          ),
          // Positioned(
          //     bottom: 0,
          //     child: Container(
          //       color: Colors.white,
          //       height: ScreenUtil().setWidth(100),
          //       width: ScreenUtil().setWidth(750),
          //       child: Column(children: <Widget>[btnArea]),
          //     )),
          isLoading ? LoadingDialog() : Container(),
        ],
      );
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: new Text(
                title,
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
            body: contentWidget()));
  }
}
