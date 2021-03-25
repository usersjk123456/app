import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/dialog.dart';
import '../service/user_service.dart';
import '../widgets/cached_image.dart';
import '../widgets/search_card.dart';
import 'package:client/service/store_service.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/toTime.dart';

class ShengZhangPage extends StatefulWidget {
  final String id;
  ShengZhangPage({this.id});
  @override
  ShengZhangPageState createState() => ShengZhangPageState();
}

class ShengZhangPageState extends State<ShengZhangPage> {
  bool isLoading = false;
  String jwt = '', addressId = "";
  String id = '';
  int _page = 0;

  var option = {};
  var option1 = {};
  var option2 = {};
  List dateList = [], fangke = [], fangwen = [], hotList = [], saleList = [];
  int clickIndex = 0;
  List coinList = [];
  EasyRefreshController _controller = EasyRefreshController();

  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  final FocusNode _focus = new FocusNode();

  void initState() {
    getLocal();
    print(widget.id);
    super.initState();
    _controller.dispose();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    print(
        '1111111111111111111111111111111111111111111----------------------------------');
    print(id);
    _page = 0;
    getList();
  }

  void _onFocusChange() {}

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
    }
  }

  void getList() async {
    _page++;
    if (_page == 1) {
      coinList = [];
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);

    UserServer().getShengzhangList(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          coinList = success['list'];
          dateList = success['xaxis'];
          fangke = success['height'];
          fangwen = success['weight'];
          hotList = success['circumference'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              coinList.insert(coinList.length, success['list'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  void deleteAddrss(bid) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id);
    map.putIfAbsent("id", () => bid);
    UserServer().delGrowthRecord(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('删除成功');
      getList();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  InkWell buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        color: color,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _focus.addListener(_onFocusChange);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget getSlides = new InkWell(
      child: Container(
        width: ScreenUtil.instance.setWidth(195.0),
        height: ScreenUtil.instance.setWidth(66.0),
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(150),
        ),
        decoration: BoxDecoration(
            color: PublicColor.themeColor,
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            )),
        alignment: Alignment.center,
        child: Text('开始记录',
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.instance.setWidth(28.0))),
      ),
      onTap: () {
        print('开始导入');
        // apply();

        NavigatorUtils.goAddSZPage(context).then((res) => getLocal());
      },
    );

    Container rankItem(int rank, String bid, String title, String old,
        String weight, String height, String head, String desc) {
      return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.only(top: 15, bottom: 15),
        height: ScreenUtil().setWidth(300),
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
        ),
        child: RaisedButton(
            color: Color(0xffffffff),
            elevation: 0,
            child: new Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setWidth(70),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: ScreenUtil().setSp(26),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(310),
                            height: ScreenUtil().setWidth(50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '宝宝年龄: ',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                                Text(
                                  old,
                                  style: TextStyle(
                                    color: Color(0xffA2BD52),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                                Text(
                                  '岁',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(310),
                            height: ScreenUtil().setWidth(50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '身高 : ',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                                Text(
                                  height,
                                  style: TextStyle(
                                    color: Color(0xffA2BD52),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                                Text(
                                  'cm',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(310),
                            height: ScreenUtil().setWidth(50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '体重 : ',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                                Text(
                                  weight,
                                  style: TextStyle(
                                    color: Color(0xffA2BD52),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                                Text(
                                  'kg',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(310),
                            height: ScreenUtil().setWidth(50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '头围 : ',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                                Text(
                                  head,
                                  style: TextStyle(
                                    color: Color(0xffA2BD52),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                                Text(
                                  'cm',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(310),
                            height: ScreenUtil().setWidth(50),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '体型描述 : ',
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(20),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(140),
                                  child: Text(
                                    desc,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xffA2BD52),
                                      fontSize: ScreenUtil().setSp(28),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(310),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      height: ScreenUtil().setWidth(321),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(50),
                                  right: ScreenUtil().setWidth(50)),
                              height: ScreenUtil().setWidth(106),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: PublicColor.lineColor)),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '修改',
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                              ),
                            ),
                            onTap: () {
                              print('生长编辑');
                                Navigator.pop(context);
                              NavigatorUtils.goAddSZPage(context, title, old,
                                      weight, height, head, desc).then((res) => getLocal());
                                  
                            },
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(50),
                                  right: ScreenUtil().setWidth(50)),
                              height: ScreenUtil().setWidth(106),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: PublicColor.lineColor)),
                              ),
                              child: Text(
                                '删除',
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              deleteAddrss(bid);
                            },
                          ),
                          InkWell(
                            child: Container(
                              height: ScreenUtil().setWidth(106),
                              alignment: Alignment.center,
                              child: Text(
                                '取消',
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  });
            }),
      );
    }

    Widget buildCoinList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (coinList.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Text(
            '暂无数据',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold),
          ),
        ));
      } else {
        int index = 1;
        for (var item in coinList) {
          // item['create'] = ToTime.time(*1000, 'YY');
          var time = int.parse(item['create_at']) * 1000;
          item['create'] = DateTime.fromMillisecondsSinceEpoch(time).toString();

          arr.add(rankItem(
            index++,
            item['id'],
            item['create'].split(' ')[0],
            item['age'],
            item['weight'],
            item['height'],
            item['circumference'],
            item['desc'],
          ));
        }
      }
      content = ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: arr,
      );
      return content;
    }

    option = {
      'xAxis': {'type': 'category', 'data': dateList},
      'yAxis': {'type': 'value'},
      'series': [
        {'data': fangke, 'type': 'line', 'smooth': true}
      ]
    };

    Widget buildDogList = new Container(
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
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(600),
              child: isLoading
                  ? LoadingDialog()
                  : Echarts(option: '''${jsonEncode(option)}'''),
            )
          ],
        ),
      ),
    );
    option1 = {
      'xAxis': {'type': 'category', 'data': dateList},
      'yAxis': {'type': 'value'},
      'series': [
        {'data': fangwen, 'type': 'line', 'smooth': true}
      ]
    };
    Widget weight = new Container(
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
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(600),
              child: isLoading
                  ? LoadingDialog()
                  : Echarts(option: '''${jsonEncode(option1)}'''),
            )
          ],
        ),
      ),
    );
    option2 = {
      'xAxis': {'type': 'category', 'data': dateList},
      'yAxis': {'type': 'value'},
      'series': [
        {'data': hotList, 'type': 'line', 'smooth': true}
      ]
    };
    Widget head = new Container(
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
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(600),
              child: isLoading
                  ? LoadingDialog()
                  : Echarts(option: '''${jsonEncode(option2)}'''),
            )
          ],
        ),
      ),
    );

    Widget tabBar = Material(
      //这里设置tab的背景色
      color: Colors.white,
      child: TabBar(
        indicatorColor: PublicColor.themeColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: PublicColor.themeColor,
        unselectedLabelColor: PublicColor.textColor,
        tabs: [
          Tab(
              child: new Text('记录列表',
                  style: TextStyle(fontSize: ScreenUtil().setSp(22)))),
          Tab(
              child: new Text('身高曲线',
                  style: TextStyle(fontSize: ScreenUtil().setSp(22)))),
          Tab(
              child: new Text('体重曲线',
                  style: TextStyle(fontSize: ScreenUtil().setSp(22)))),
          Tab(
              child: new Text('头围曲线',
                  style: TextStyle(fontSize: ScreenUtil().setSp(22)))),
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 4,
          // initialIndex: int.parse(widget.type),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: new Text(
                '生长记录',
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
              actions: <Widget>[
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 14.0,
                    ),
                    child: Image.asset(
                      'assets/index/ic_tianjia.png',
                      width: ScreenUtil().setWidth(39),
                      height: ScreenUtil().setWidth(39),
                    ),
                  ),
                  onTap: () {
                    // sendPlant();
                    NavigatorUtils.goAddSZPage(context)
                        .then((res) => getLocal());
                  },
                )
              ],
            ),
            body: coinList.length < 0
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/index/shangc.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: getSlides)
                : Column(
                    children: <Widget>[
                      tabBar,
                      Expanded(
                        flex: 1,
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(

                            child:Container(
             
                              child: buildCoinList(),
                            ),
                            ),
                            buildDogList,
                            weight,
                            head,
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
