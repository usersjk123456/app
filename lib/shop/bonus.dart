import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../service/user_service.dart';

class BonusPage extends StatefulWidget {
  @override
  BonusPageState createState() => BonusPageState();
}

class BonusPageState extends State<BonusPage> {
  bool isLoading = false;
  String jwt = '', balance = '';
  List consumptionList = [];
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getList() async {
    _page++;
    if (_page == 1) {
      consumptionList = [];
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    UserServer().getBonusBalance(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          consumptionList = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              consumptionList.insert(
                  consumptionList.length, success['list'][i]);
            }
          }
        }
        balance = success['user']['balance'];
      });
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  balanceType(type) {
    switch (type) {
      case "1":
        return "购买商品";
      case "2":
        return "获得佣金";
      case "7":
        return "礼物分成";
      case "8":
        return "提现拒绝";
      case "9":
        return "主播返利";
      case "10":
        return "售后退款";
    }
  }

  // 列表项
  Container listItem(String date, String time, String amount, String type) {
    return new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20, right: 20),
        height: ScreenUtil().setWidth(91),
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: new Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    date,
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    time,
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ))),
          // Expanded(
          //     flex: 1,
          //     child: Container(
          //         alignment: Alignment.centerRight,
          //         child: Text(
          //           balanceType(type),
          //           style: TextStyle(
          //             color: Color(0xff5e5e5e),
          //             fontSize: ScreenUtil().setSp(28),
          //           ),
          //         )))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
      alignment: Alignment.center,
      child: new Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          height: ScreenUtil().setWidth(111),
          width: ScreenUtil().setWidth(750),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
          ),
          child: new Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    child: Text(
                  '当前奖金',
                  style: TextStyle(
                    color: Color(0xff5e5e5e),
                    fontSize: ScreenUtil().setSp(28),
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '￥$balance',
                      style: TextStyle(
                          color: Color(0xffe92f2f),
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w600),
                    )),
              )
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(111),
          width: ScreenUtil().setWidth(750),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
          ),
          child: new Row(children: <Widget>[
            Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                    alignment: Alignment.center,
                    height: ScreenUtil().setWidth(90),
                    width: ScreenUtil().setWidth(375),
                    decoration: BoxDecoration(
                      border:
                          Border(right: BorderSide(color: Color(0xffd6d6d6))),
                    ),
                    child: Text(
                      '去消费',
                      style: TextStyle(
                        color: PublicColor.themeColor,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    )),
                onTap: () {
                  NavigatorUtils.goHomePage(context);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '去提现',
                      style: TextStyle(
                        color: PublicColor.themeColor,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    )),
                onTap: () {
                  NavigatorUtils.toTixianPagePage(context);
                },
              ),
            )
          ]),
        ),
        Container(
          alignment: Alignment.center,
          height: ScreenUtil().setWidth(86),
          width: ScreenUtil().setWidth(750),
          decoration: BoxDecoration(
            color: Color(0xfff5f5f5),
            border: Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
          ),
          child: Text(
            '消费记录',
            style: TextStyle(
              color: Color(0xff5e5e5e),
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          child: new Column(children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                height: ScreenUtil().setWidth(91),
                width: ScreenUtil().setWidth(750),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '日期',
                        style: TextStyle(
                          color: Color(0xff5e5e5e),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '时间',
                            style: TextStyle(
                              color: Color(0xff5e5e5e),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))),
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '数量',
                            style: TextStyle(
                              color: Color(0xff5e5e5e),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))),
                  // Expanded(
                  //     flex: 1,
                  //     child: Container(
                  //         alignment: Alignment.centerRight,
                  //         child: Text(
                  //           '类型',
                  //           style: TextStyle(
                  //             color: Color(0xff5e5e5e),
                  //             fontSize: ScreenUtil().setSp(28),
                  //           ),
                  //         )))
                ]))
          ]),
        ),
      ]),
    );

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (consumptionList.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Text(
            '没有更多了',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold),
          ),
        ));
      } else {
        for (var item in consumptionList) {
          arr.add(listItem(
            item['date'].toString(),
            item['time'].toString(),
            item['balance'].toString(),
            item['type'].toString(),
          ));
        }
      }
      content = ListView(
        children: arr,
      );
      return content;
    }

    Widget withdrawList = Container(
      child: EasyRefresh(
        controller: _controller,
        header: BezierCircleHeader(
          backgroundColor: Color(0xfffffd302),
        ),
        footer: BezierBounceFooter(
          backgroundColor: Color(0xfffffd302),
        ),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: false,
        onRefresh: () async {
          print('onRefresh============');
          _page = 0;
          getList();
        },
        onLoad: () async {
          print('onLoad============');
          if (_page * 10 > consumptionList.length) {
            return;
          }
          getList();
        },
        child: listArea(),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '当前奖金',
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
          body: isLoading
              ? LoadingDialog()
              : new Container(
                  alignment: Alignment.center,
                  child: new Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [topArea, Expanded(flex: 1, child: withdrawList)],
                  ),
                ),
        ));
  }
}
