import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/toTime.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';

class FishCurrencyPage extends StatefulWidget {
  final String coinStr;
  FishCurrencyPage({this.coinStr});
  @override
  FishCurrencyPageState createState() => FishCurrencyPageState();
}

class FishCurrencyPageState extends State<FishCurrencyPage> {
  bool isLoading = true;
  String jwt = '';
  int type = 0;
  List notUsedList = [], notTackEffectList = [], invalidList = [];
  @override
  void initState() {
    super.initState();
    getList(1);
  }

//未使用
  void getList(type) async {
    print('coin------${widget.coinStr}');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);

    UserServer().coinList(map, (success) async {
      getNotTack(2);
      if (widget.coinStr != "null") {
        List arr = widget.coinStr.split(',');
        List data = [];
        for (var i = 0; i < arr.length; i++) {
          for (var item in success['list']) {
            if (arr[i].toString() == item['id']) {
              data.insert(i, item);
            }
          }
        }
        setState(() {
          isLoading = false;
          notUsedList = data;
        });
      } else {
        setState(() {
          isLoading = false;
          notUsedList = success['list'];
        });
      }
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

//未生效
  void getNotTack(type) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    UserServer().coinList(map, (success) async {
      getInvalid(3);

      setState(() {
        notTackEffectList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  //已失效
  void getInvalid(type) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    UserServer().coinList(map, (success) async {
      setState(() {
        invalidList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    //未使用
    Widget notList() {
      List<Widget> arr = <Widget>[];
      Widget content;

      if (notUsedList.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ));
      } else {
        for (var item in notUsedList) {
          item['startTime'] =
              ToTime.time(item['detail']['start_time'].toString(), 'YY');
          item['endTime'] =
              ToTime.time(item['detail']['end_time'].toString(), 'YY');

          arr.add(Container(
            alignment: Alignment.topCenter,
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(215),
            child: Stack(
              children: <Widget>[
                InkWell(
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: ScreenUtil().setWidth(694),
                    height: ScreenUtil().setWidth(272),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/mine/ljsy.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(40),
                      right: ScreenUtil().setWidth(40),
                    ),
                    child: Row(children: [
                      Row(children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '￥',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xfff03329),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['detail']['price'].toString(),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(50),
                                color: Color(0xfff03329),
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ]),
                      Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                item['detail']['name'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(35),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "有效期至${item['endTime']}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(24),
                                    color: Color(0xff999999)),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                  onTap: () {
                    if (widget.coinStr != "null") {
                      Navigator.pop(context, item);
                    } else {
                      NavigatorUtils.goHomePage(context);
                    }
                  },
                ),
              ],
            ),
          ));
        }
      }
      content = new ListView(
        children: arr,
      );
      return content;
    }

    //未生效
    Widget notTackList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (notTackEffectList.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ));
      } else {
        for (var item in notTackEffectList) {
          item['startTime'] =
              ToTime.time(item['detail']['start_time'].toString(), 'YY');
          item['endTime'] =
              ToTime.time(item['detail']['end_time'].toString(), 'YY');
          arr.add(Container(
            alignment: Alignment.topCenter,
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(215),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  width: ScreenUtil().setWidth(694),
                  height: ScreenUtil().setWidth(272),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/mine/wsx.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(40),
                  ),
                  child: Row(children: [
                    Row(children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '￥',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Color(0xfff03329),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['detail']['price'].toString(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xfff03329),
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ]),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              item['detail']['name'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "有效期至${item['endTime']}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(24),
                                  color: Color(0xff999999)),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ));
        }
      }
      content = new ListView(
        children: arr,
      );
      return content;
    }

    //已失效
    Widget invalidsList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (invalidList.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ));
      } else {
        for (var item in invalidList) {
          item['startTime'] =
              ToTime.time(item['detail']['start_time'].toString(), 'YY');
          item['endTime'] =
              ToTime.time(item['detail']['end_time'].toString(), 'YY');
          arr.add(Container(
            alignment: Alignment.topCenter,
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(215),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  width: ScreenUtil().setWidth(694),
                  height: ScreenUtil().setWidth(272),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/mine/ygq.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(40),
                  ),
                  child: Row(children: [
                    Row(children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '￥',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Color(0xfff03329),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['detail']['price'].toString(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xfff03329),
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ]),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              item['detail']['name'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "有效期至${item['endTime']}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(24),
                                  color: Color(0xff999999)),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ));
        }
      }
      content = new ListView(
        children: arr,
      );
      return content;
    }

    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '我的葫芦',
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
            actions: <Widget>[
              InkWell(
                child: Container(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Text(
                      '规则',
                      style: new TextStyle(
                        color: PublicColor.headerTextColor,
                        fontSize: ScreenUtil().setSp(30),
                        height: 2.7,
                      ),
                    )),
                onTap: () {
                  print('规则');
                  NavigatorUtils.goCouponRulePage(context);
                },
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Material(
                color: Colors.white,
                child: TabBar(
                    indicatorWeight: 4.0,
                    // indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: PublicColor.themeColor,
                    unselectedLabelColor: Color(0xff5e5e5e),
                    labelColor: PublicColor.themeColor,
                    tabs: <Widget>[
                      new Tab(
                        child: Text(
                          '未使用(${notUsedList.length})',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      new Tab(
                        child: Text(
                          '未生效(${notTackEffectList.length})',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      new Tab(
                        child: Text(
                          '已失效(${invalidList.length})',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),
              ),
            )),
        body: isLoading
            ? LoadingDialog()
            : new TabBarView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: notList(),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: notTackList(),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: invalidsList(),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
