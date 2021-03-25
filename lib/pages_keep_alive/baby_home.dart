import 'dart:async';
import 'package:client/common/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/home_service.dart';
import '../widgets/cached_image.dart';
import '../common/color.dart';
import '../home/agreement.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';
import '../service/user_service.dart';

class BabyHomePage extends StatefulWidget {
  @override
  BabyHomePageState createState() => BabyHomePageState();
}

class BabyHomePageState extends State<BabyHomePage>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool isOpen = false;
  EasyRefreshController _controller = EasyRefreshController();
  TabController tabController;
  GlobalKey anchorKey = GlobalKey();
  List categoryList = [], bannerList = [], wdList = [], wdlist = [], list = [];

  String tmendtime = '',
      newcount = '',
      newCount = '',
      jwt = '',
      text = '',
      id = '',
      birth = '',
      week = '',
      day = '',
      weight = '',
      points = '',
      long = '',
      times = '',
      datete = '',
      mcontent = '',
      bcontent = '',
      days = '';
  int is_birth = 0;
  int _page = 0;
  bool isbegin = false, isLive = false, isStore = false;
  int seconds = 0;
  int clickIndex = 0;
  String sateId = '',babyImage="";
  String betweenimgurl = '';
  List tabView = [];
  bool open = true;
  Timer _timer;
  bool isCollect = false;
  List datedata = [], lists = [];
  int actionIdx = 0;
  // bool isclose = false;
  @override
  void initState() {
    super.initState();
    DateTime now = new DateTime.now();
    datete = (now.millisecondsSinceEpoch ~/ 1000).toString();
    times = datete;
    getbabyList();

    getHome();
    getQuestion();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');

    if (id != null) {
      DateTime now = new DateTime.now();
      datete = (now.millisecondsSinceEpoch ~/ 1000).toString();
      times = datete;
      getBabyChange();
      getBaby();
    }
  }

  void getbabyList() async {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    UserServer().getbabyList(map, (success) async {
      setState(() {
        // isLoading = false;
        lists = success['list'];
      });
      if (success['list'].length > 0) {
        getweek();
        getLocal();
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void collect(id, isLike) async {

    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent('qid', () => id);
    map.putIfAbsent('is_like', () => isLike);
    HomeServer().getanswer(map, (success) async {
      getQuestion();
      isLoading = false;
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void showAgreement() async {
    // final prefs = await SharedPreferences.getInstance();
    // agree = prefs.getString('agree');
    // if (agree == '1') {
    //   return;
    // }
    await Future.delayed(Duration(seconds: 1), () {
      showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AgreementDialog(uid: '123');
        },
      );
    });
  }

  void getHome() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    HomeServer().getHome(map, (success) async {
      setState(() {
        isLoading = false;
      });
      Global.isShow = success['display'] == 1 ? false : true;
      categoryList = success['category'];
      newCount = success['car'].toString();
      bannerList = success['banner'];
      // fenleiApi();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void getweek() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("time", () => times);
    HomeServer().getWeek(map, (success) async {
      setState(() {
        isLoading = false;
        datedata = success['week'];
      });
      print(datedata);
      // fenleiApi();
      getBabyChange();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void getBaby() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    HomeServer().getbaby(map, (success) async {
      setState(() {
        isLoading = false;
        var bir = success['data']['birth_at'] * 1000;
        birth =
            DateTime.fromMillisecondsSinceEpoch(bir).toString().split(' ')[0];
        week = success['data']['week'].toString();
        day = success['data']['day'].toString();
        days = success['data']['disparity'].toString();
        text = success['text'];
        is_birth = success['data']['is_birth'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void getBabyChange() async {
    setState(() {
      isLoading = true;
      mcontent = '';
      bcontent = '';
    });
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');

    Map<String, dynamic> map = Map();

    map.putIfAbsent("bid", () => id);
    map.putIfAbsent("time", () => times);
    HomeServer().getbabychange(map, (success) async {
      setState(() {
        isLoading = false;
        weight = success['list']['weight'].toString();
        long = success['list']['long'].toString();
        points = success['list']['points'].toString();
        babyImage = success['list']['img'].toString();
        mcontent = success['list']['mchange'].toString();
        bcontent = success['list']['bchange'].toString();
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      // ToastUtil.showToast(onFail);
    });
  }

  void getQuestion() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id);
    HomeServer().getpro(map, (success) async {
      setState(() {
        isLoading = false;
        wdlist = success['list'];
      });
      print('~~~~~~~~~~~~~~');
      print(wdlist);
      print('~~~~~~~~~~~~~~');
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      // ToastUtil.showToast(onFail);
    });
  }

  void goShopList(oid, name) {
    print(name);
    NavigatorUtils.toShopListPage(context, oid, name, "1");
  }

  @override
  void dispose() {
    if (tabController != null) {
      tabController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget appBar = new Container(
      height: ScreenUtil().setWidth(503),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/index/bg_shouye.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setWidth(70),
          ),
          InkWell(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    color: Color(0xffffffff),
                  ),
                  onPressed: () {
                    NavigatorUtils.addBaby(context);
                  },
                ),
                Text(
                  '宝宝',
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
              ],
            ),
            onTap: () {
              NavigatorUtils.addBaby(context);
            },
          ),
          SizedBox(
            height: ScreenUtil().setWidth(20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/index/ic_rebk.png',
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setWidth(60),
                      fit: BoxFit.cover,
                    ),
                    Text(
                      '辅食日记',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  NavigatorUtils.goFoodclass(context);
                },
              )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/index/ic_fsri.png',
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                          fit: BoxFit.cover,
                        ),
                        Text(
                          '育儿百科',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      NavigatorUtils.goWiki(context);
                    },
                  )),
              Global.isShow
                  ? Expanded(
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/index/ic_etyy.png',
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setWidth(60),
                              fit: BoxFit.cover,
                            ),
                            Text(
                              '儿童音乐',
                              style: TextStyle(
                                color: Color(0xffffffff),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          NavigatorUtils.goBabymusic(context);
                        },
                      ),
                      flex: 1,
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );

    Widget bottom = new Card(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(30),
        ),
        width: ScreenUtil().setWidth(670),
        height: ScreenUtil().setWidth(328),
        decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
                  is_birth == 2
                      ? Text(
                          '已出生' + week.toString() + '周' + day.toString() + '天',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(36),
                            color: Color(0xff333333),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          week.toString() +
                              '周' +
                              day.toString() +
                              '天' +
                              '(' +
                              birth +
                              ')',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(36),
                            color: Color(0xff333333),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  is_birth == 2
                      ? Container()
                      : Text(
                          text,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Color(0xff333333),
                          ),
                        ),
                  SizedBox(
                    height: ScreenUtil().setWidth(30),
                  ),
                  Text(
                    '顶臀长' + long + 'cm 体重' + weight + 'g',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      color: Color(0xff999999),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(29),
                  ),
                  InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        width: ScreenUtil.instance.setWidth(221.0),
                        height: ScreenUtil.instance.setWidth(64.0),
                        decoration: BoxDecoration(
                          border: new Border.all(
                            color: PublicColor.themeColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '查看本周要点',
                              style: TextStyle(
                                color: PublicColor.themeColor,
                                fontSize: ScreenUtil.instance.setWidth(26),
                              ),
                            ),
                            Icon(
                              Icons.navigate_next,
                              color: PublicColor.themeColor,
                              size: ScreenUtil().setWidth(30),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return GestureDetector(
                              // 手势处理事件
                              onTap: () {
                                // Navigator.of(context).pop(); //退出弹出框
                              },
                              child: Container(
                                //弹出框的具体事件
                                child: Material(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  child: Center(
                                    child: Container(
                                        width: ScreenUtil().setWidth(400),
                                        height: ScreenUtil().setWidth(480),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/index/ceng.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(
                                            ScreenUtil().setWidth(20)),
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                    top: ScreenUtil()
                                                        .setWidth(80),
                                                    bottom: ScreenUtil()
                                                        .setWidth(50),
                                                  ),
                                                  // child: Text(points),
                                                  child: ListView(
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                            ScreenUtil()
                                                                .setWidth(30)),
                                                        child: Text(points),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(100),
                                                height:
                                                    ScreenUtil().setWidth(50),
                                                decoration: BoxDecoration(
                                                  color: PublicColor.themeColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '确定',
                                                  style: TextStyle(
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ],
              ),
              // Image.asset(
              //   'assets/index/ic_taixing.png',
              //   width: ScreenUtil().setWidth(243),
              //   height: ScreenUtil().setWidth(297),
              //   fit: BoxFit.cover,
              // ),
              Image.network(
                 babyImage,
                  width: ScreenUtil.instance.setWidth(243.0),
                  height: ScreenUtil.instance.setWidth(297.0),
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ),
      ),
      elevation: 1,
    );
    weeklist() {
      List<Widget> list = [];
      for (var i = 0; i < datedata.length; i++) {
        list.add(
          Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: datedata[i]['check']
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/index/ic_date_bg.png"),
                          fit: BoxFit.contain,
                        ),
                      )
                    : BoxDecoration(),
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setWidth(100),
                child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('${datedata[i]['week']}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setWidth(26),
                                fontWeight: FontWeight.bold,
                                color: datedata[i]['check']
                                    ? PublicColor.whiteColor
                                    : PublicColor.foodColor)),
                        Text(
                            '${datedata[i]['is_day'] ? '今天' : datedata[i]['data']}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setWidth(20),
                                fontWeight: FontWeight.bold,
                                color: datedata[i]['check']
                                    ? PublicColor.whiteColor
                                    : PublicColor.foodColor))
                      ],
                    ),
                    onTap: () {
                      print(i);
                      times = datedata[i]['time'].toString();

                      for (var j = 0; j < datedata.length; j++) {
                        setState(() {
                          datedata[j]['check'] = false;
                          datedata[i]['check'] = true;
                          actionIdx = i;
                        });
                      }
                      getBabyChange();
                    }),
              )),
        );
      }
      return list;
    }

    // 日历 磊少
    Widget rili = new Container(
      alignment: Alignment.center,
      height: ScreenUtil().setWidth(137),
      width: ScreenUtil().setWidth(750),
      color: Color(0xffffffff),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: weeklist(),
      ),
    );

    // //日历下面

    var list = [
      {
        'content': '我准备在子宫着床，感谢妈妈给我这么安全的地方，让我汲取营养健康成长。妈妈可能轻微出血，别慌张哦。',
        'bianhua': '1',
      },
      {
        'content': '我准备在子宫着床，感谢妈妈给我这么安全的地方，让我汲取营养健康成长。妈妈可能轻微出血，别慌张哦。',
        'bianhua': '2',
      },
      {
        'content': '我准备在子宫着床，感谢妈妈给我这么安全的地方，让我汲取营养健康成长。妈妈可能轻微出血，别慌张哦。',
        'bianhua': '2',
      }
    ];

    Widget center = new Container(
      color: Color(0xffffffff),
      height: ScreenUtil().setWidth(230),
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () {
              NavigatorUtils.toYunPage(context, id);
            },
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/index/ic_shouye_yxc.png',
                  width: ScreenUtil().setWidth(133),
                  height: ScreenUtil().setWidth(133),
                ),
                Text(
                  '云相册',
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: ScreenUtil().setSp(33),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              NavigatorUtils.toShengZhangPage(context, id);
            },
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/index/ic_shouye_czjl.png',
                  width: ScreenUtil().setWidth(133),
                  height: ScreenUtil().setWidth(133),
                ),
                Text(
                  '生长记录',
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: ScreenUtil().setSp(33),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              NavigatorUtils.toYimiaoPage(context, id);
            },
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/index/ic_shouye_ymjz.png',
                  width: ScreenUtil().setWidth(133),
                  height: ScreenUtil().setWidth(133),
                ),
                Text(
                  '疫苗接种',
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: ScreenUtil().setSp(33),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              NavigatorUtils.toBig(context, id);
            },
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/index/ic_shouye_dsj.png',
                  width: ScreenUtil().setWidth(133),
                  height: ScreenUtil().setWidth(133),
                ),
                Text(
                  '大事记',
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: ScreenUtil().setSp(33),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    // Widget tabBar() {
    //   return SafeArea(
    //     child: TabBar(
    //       controller: tabController,
    //       indicatorColor: null,
    //       indicator: const BoxDecoration(
    //         border:
    //             Border(bottom: BorderSide(color: Color(0xffEE9249), width: 3)),
    //       ),
    //       indicatorSize: TabBarIndicatorSize.label,
    //       labelColor: Colors.black,
    //       unselectedLabelColor: Color(0xff666666),
    //       indicatorPadding: EdgeInsets.zero,
    //       isScrollable: true,
    //       tabs: tabTitles.map((i) => Tab(text: i['name'])).toList(),
    //       unselectedLabelStyle:
    //           TextStyle(fontSize: ScreenUtil.instance.setWidth(34)),
    //       labelStyle: TextStyle(
    //           fontSize: ScreenUtil.instance.setWidth(36),
    //           fontWeight: FontWeight.bold),
    //       onTap: ((index) {
    //         _page = 0;
    //         if (open) {
    //           open = false;
    //           // listApi(index);
    //         }
    //       }),
    //     ),
    //   );
    // }

    Widget slider() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (wdlist.length == 0) {
        arr.add(Container(
          color: Color(0xfff9f9f9),
          // color: PublicColor.bodyColor,
          alignment: Alignment.center,
          // margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Text(
            '暂无数据',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      } else {
        for (var item in wdlist) {
          arr.add(
            Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
              ),
              margin: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(20),
              ),
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(24),
                left: ScreenUtil().setWidth(50),
              ),

              //设置圆角
              child: Column(
                children: <Widget>[
                  Row(children: [
                    Container(
                      child: CachedImageView(
                        ScreenUtil.instance.setWidth(55.0),
                        ScreenUtil.instance.setWidth(55.0),
                        item['user']['headimgurl'],
                        null,
                        BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(29),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(400),
                      child: Text(
                        item['user']['nickname'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ),
                    ),
                  ]),
                  InkWell(
                    onTap: () {
                      print(item);
                      String oid = (item['id']).toString();
                   
                      NavigatorUtils.goBabyMyQuestion(context,oid)
                                                  .then((res) {
                                                  getQuestion();
                                                });
                      // NavigatorUtils.gobabyXiangqing(context);
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil().setWidth(80),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['desc'],
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: ScreenUtil().setSp(32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Image.asset(
                            //   'assets/index/ic_shouye_da.png',
                            //   width: ScreenUtil().setWidth(33),
                            //   height: ScreenUtil().setWidth(33),
                            // ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: ScreenUtil().setWidth(600),
                              child: Text(
                                // item['now_price'],
                                '${item['text']}',
                                //maxLines: 3,
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(25),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: CachedImageView(
                            ScreenUtil.instance.setWidth(240.0),
                            ScreenUtil.instance.setWidth(240.0),
                            item['img'],
                            null,
                            BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(24),
                  ),
                  Container(
                    // width: ScreenUtil().setWidth(651),
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                    height: ScreenUtil().setWidth(1),
                    color: Color(0xffE5E5E5),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(83),
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(37)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  String oid = (item['id']).toString();
                                  NavigatorUtils.goBabyMyQuestion(context, oid);
                                },
                                child: Image.asset(
                                  'assets/index/ly.png',
                                  width: ScreenUtil().setWidth(32),
                                  height: ScreenUtil().setWidth(32),
                                )),
                            Text(
                              item['comment'],
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(77),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  print('点赞');
                                  if (item['is_like'] == 0) {
                                    return collect(item['id'], 1);
                                  } else if (item['is_like'] == 1) {
                                    return collect(item['id'], 2);
                                  }
                                },
                                child: Image.asset(
                                  item['is_like'] == 0
                                      ? 'assets/index/ic_dianzan.png'
                                      : 'assets/index/dz.png',
                                  width: ScreenUtil().setWidth(32),
                                  height: ScreenUtil().setWidth(32),
                                )),
                            Text(
                              item['like'],
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(77),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  NavigatorUtils.toBabytipoffPage(context, '1');
                                },
                                child: Image.asset(
                                  'assets/index/jb.png',
                                  width: ScreenUtil().setWidth(32),
                                  height: ScreenUtil().setWidth(32),
                                )),
                            Text(
                              '举报',
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
      content = new ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 0),
        children: arr,
      );
      return content;
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: PublicColor.bodyColor,
              child: Column(
                children: <Widget>[
                  Container(
                      height: ScreenUtil().setWidth(650),
                      color: Color(0xffffffff),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            child: appBar,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 8,
                            child: id == null || lists.length <= 0
                                ? Container()
                                : bottom,
                          )
                        ],
                      )),
                  id == null || lists.length <= 0 ? Container() : rili,
                  id == null || lists.length <= 0
                      ? Container()
                      : Container(
                          width: ScreenUtil().setWidth(750),
                          color: Color(0xffffffff),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(15),
                              right: ScreenUtil().setWidth(15)),
                          child: Card(
                            elevation: 1,
                            child: bcontent == ''
                                ? Container(
                                    alignment: Alignment.center,
                                    // margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                                    child: Text(
                                      '暂无数据',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(35),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(20)),
                                    child: new Column(children: <Widget>[
                                      new InkWell(
                                        child: new Container(
                                            width: ScreenUtil().setWidth(700),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffEE9249),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      padding: EdgeInsets.all(
                                                          ScreenUtil()
                                                              .setWidth(5)),
                                                      child: Text(
                                                        '宝宝变化',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: ScreenUtil()
                                                          .setWidth(5),
                                                    ),
                                                    Container(
                                                      width: ScreenUtil()
                                                          .setWidth(530),
                                                      child: Text(
                                                        bcontent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height:
                                                      ScreenUtil().setWidth(15),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffEE9249),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      padding: EdgeInsets.all(
                                                          ScreenUtil()
                                                              .setWidth(5)),
                                                      child: Text(
                                                        '妈妈变化',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: ScreenUtil()
                                                          .setWidth(5),
                                                    ),
                                                    Container(
                                                      width: ScreenUtil()
                                                          .setWidth(530),
                                                      child: Text(
                                                        mcontent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        onTap: () {
                                          // NavigatorUtils.toRealDetailPage(context, item)
                                          //     .then((res) => getList();
                                        },
                                      )
                                    ]),
                                  ),
                          )),
                  id == null || lists.length <= 0 ? Container() : center,
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  Container(
                      height: ScreenUtil().setHeight(95),
                      width: ScreenUtil().setWidth(750),
                      color: Color(0xffffffff),
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.bottomCenter,
                              height: ScreenUtil().setHeight(95),
                              width: ScreenUtil().setWidth(120),
                              padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setWidth(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '问答',
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: ScreenUtil().setSp(36),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(29),
                                    height: ScreenUtil().setWidth(9),
                                    decoration: BoxDecoration(
                                        color: PublicColor.themeColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                  )
                                ],
                              )),
                          InkWell(
                            child: Container(
                                alignment: Alignment.bottomCenter,
                                height: ScreenUtil().setHeight(95),
                                width: ScreenUtil().setWidth(120),
                                padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setWidth(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      child: InkWell(
                                        child: Text(
                                          '我的',
                                          style: TextStyle(
                                            color: Color(0xff666666),
                                            fontSize: ScreenUtil().setSp(34),
                                          ),
                                        ),
                                        onTap: () {
                                          id == null || lists.length <= 0
                                              ? ToastUtil.showToast(
                                                  '请填写宝宝信息或怀孕信息')
                                              : NavigatorUtils.goBabyMy(context)
                                                  .then((res) {
                                                  getQuestion();
                                                });
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(29),
                                      height: ScreenUtil().setWidth(9),
                                      decoration: BoxDecoration(
                                          color: PublicColor.whiteColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    )
                                  ],
                                )),
                            onTap: () {
                              // NavigatorUtils.goMineTitle(context);
                            },
                          )
                        ],
                      )),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  wdlist.length > 0 ? slider() : Container(),
                ],
              ),
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
    
               NavigatorUtils.goBabyMyFb(context)
                                                  .then((res) {
                                                  getQuestion();
                                                });
             
            },
            child: Image.asset(
              'assets/index/huati.png',
              width: ScreenUtil().setWidth(60),
            ),
            elevation: 3.0,
            highlightElevation: 2.0,
            backgroundColor: PublicColor.themeColor, // 红色
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }
}
