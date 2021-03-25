import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../api/api.dart';
import '../utils/serivice.dart';

class Integral extends StatefulWidget {
  @override
  IntegralState createState() => IntegralState();
}

class IntegralState extends State<Integral> {
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
    Service().sget(Api.INTERGRAL_LIST_URL, map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          consumptionList = success['data'];
        } else {
          if (success['data'].length == 0) {
          } else {
            for (var i = 0; i < success['data'].length; i++) {
              consumptionList.insert(
                  consumptionList.length, success['data'][i]);
            }
          }
        }
        balance = success['jifen'].toString();
      });
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  // 列表项
  Container listItem(String time, String jifen, String desc) {
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
                    time,
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
                    jifen,
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
                    desc,
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
      alignment: Alignment.center,
      child: new Column(
        children: <Widget>[
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
                Container(
                  child: Text(
                    '当前积分数量 ',
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$balance',
                    style: TextStyle(
                      color: Color(0xffe92f2f),
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: new Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: ScreenUtil().setWidth(91),
                  width: ScreenUtil().setWidth(750),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
                  ),
                  child: new Row(
                    children: <Widget>[
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
                            '积分数量',
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
                          alignment: Alignment.centerRight,
                          child: Text(
                            '类型',
                            style: TextStyle(
                              color: Color(0xff5e5e5e),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
            item['create_at'].toString(),
            item['jifen'].toString(),
            item['desc'].toString(),
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
              '积分',
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
