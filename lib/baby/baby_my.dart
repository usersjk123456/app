import 'package:client/api/api.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:client/widgets/my_question.dart';
import 'package:client/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';

class BabyMy extends StatefulWidget {
  @override
  BabyMyState createState() => BabyMyState();
}

class BabyMyState extends State<BabyMy> {
  String aboutContent;
  bool isLoading = false;
  List tabTitles = [
    {
      'name': '话题',
      'id': 1,
    },
    {
      'name': '问答',
      'id': 2,
    },
  ];
  List htlist = [];
  Map userlist = {};
  List datalist = [];
  Map babyInf = {'headimgurl': ''};
  TabController tabController;
  int _page = 0;
  String tabIdx = '0';
  String newcount = '';
  String fans = '';
  @override
  void initState() {
    super.initState();
    getgz();
    getBabyInf();
    getQuestion();
  }

  void getBabyInf() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    //获取宝宝信息
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    Service().getData(map, Api.GET_BABY_URL, (success) async {
      setState(() {
        babyInf = success['data'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getgz() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    //获取宝宝信息
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    Service().getData(map, Api.USER_RUL, (success) async {
      setState(() {
        newcount = success['user']['new_count'].toString();
        fans = success['user']['fans'].toString();
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getQuestion() {
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("limit", () => 10);
    // map.putIfAbsent("page", () => 1);
    Service().getData(map, Api.GET_MY_QUESTION_URL, (success) async {
      print('~~~~~~~~~~~~~~~');
      setState(() {
        htlist = success['list'];
        userlist = success['user'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getWenda() {
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("limit", () => 10);
    // map.putIfAbsent("page", () => 1);
    Service().getData(map, Api.GET_MY_ANSWER_URL, (success) async {
      print('~~~~~~~~~~~~~~~');
      setState(() {
        datalist = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget topArea = Container(
      alignment: Alignment.topCenter,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(516),
      color: PublicColor.whiteColor,
      child: Stack(
        children: <Widget>[
          //图片
          Positioned(
            top: 0,
            child: Image.asset(
              "assets/index/bg_shouye_wode.png",
              height: ScreenUtil().setWidth(244),
              width: ScreenUtil().setWidth(750),
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 20,
            child: Container(
              height: ScreenUtil().setWidth(90),
              width: ScreenUtil().setWidth(750),
              alignment: Alignment.center,
              child: Text(
                '',
                style: TextStyle(
                  fontSize: 18,
                  color: PublicColor.headerTextColor,
                ),
              ),
            ),
          ),

          Positioned(
              top: 35,
              left: 15,
              child: Container(
                height: ScreenUtil().setWidth(60),
                width: ScreenUtil().setWidth(40),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                        padding: new EdgeInsets.fromLTRB(2, 2, 2, 12.0),
                        child: Image.asset(
                          "assets/mine/backIcon.png",
                          width: 7,
                        )),
                  ),
                ),
              )),

          Positioned(
            top: ScreenUtil().setWidth(205),
            left: ScreenUtil().setWidth(40),
            child: Container(
                width: ScreenUtil().setWidth(180),
                height: ScreenUtil().setWidth(180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: PublicColor.whiteColor,
                      width: ScreenUtil().setWidth(5),
                      style: BorderStyle.solid),
                ),
                child: Container(
                  child: CachedImageView(
                    ScreenUtil.instance.setWidth(175.0),
                    ScreenUtil.instance.setWidth(175.0),
                    babyInf['headimgurl'],
                    null,
                    BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                )),
          ),
          Positioned(
            top: ScreenUtil().setWidth(266),
            left: ScreenUtil().setWidth(240),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${babyInf['nickname']}',
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(36.0),
                      color: PublicColor.textColor,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
                  Text(
                    '${babyInf['is_birth'] == 2 ? '出生' : '怀孕'}${babyInf['week']}周${babyInf['day']}天',
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(28.0),
                      color: PublicColor.grewNoticeColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil().setWidth(440),
            left: ScreenUtil().setWidth(45),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${newcount}',
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(34.0),
                      color: PublicColor.textColor,
                    ),
                  ),
                  Text(
                    '关注',
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(28.0),
                      color: PublicColor.grewNoticeColor,
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(43),
                  ),
                  Text(
                    '${fans}',
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(34.0),
                      color: PublicColor.textColor,
                    ),
                  ),
                  Text(
                    '粉丝',
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(28.0),
                      color: PublicColor.grewNoticeColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
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
              child: new Text('话题',
                  style: TextStyle(fontSize: ScreenUtil().setWidth(30)))),
          Tab(
              child: new Text('问答',
                  style: TextStyle(fontSize: ScreenUtil().setWidth(30)))),
          // Tab(
          //     child: new Text('收益排行',
          //         style: TextStyle(fontSize: ScreenUtil().setSp(22)))),
        ],
        onTap: ((index) {
          print(index);
          if (index == 0) {
            getQuestion();
          } else {
            getWenda();
          }
          setState(() {
            tabIdx = index.toString();
          });

          _page = 0;
        }),
      ),
    );

    Widget nodataView = Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setWidth(111),
          ),
          Image.asset(
            'assets/index/ic_wushuju.png',
            width: ScreenUtil.instance.setWidth(240.0),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(111),
          ),
          Text(
            '你还没有发表过内容',
            style: TextStyle(
              fontSize: 28,
              color: PublicColor.grewNoticeColor,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(54),
          ),
          Container(
            child: InkWell(
              child: Text(
                '发表话题',
                style: TextStyle(
                  fontSize: ScreenUtil().setWidth(30),
                  color: PublicColor.foodColor,
                ),
              ),
              onTap: () {
                NavigatorUtils.goBabyMyFb(context).then((res) {
                  getQuestion();
                });
              },
            ),
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(195),
            height: ScreenUtil().setWidth(60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: PublicColor.foodColor,
                  width: ScreenUtil().setWidth(1),
                  style: BorderStyle.solid),
            ),
          )
        ],
      ),
    );

    Widget dataView = Container(
        child: tabIdx == '0'
            ? htlist.length > 0
                ? Questionlist(
                    item: htlist,
                    userlist: userlist,
                    type: tabIdx.toString(),
                    getQuestion: getQuestion)
                : nodataView
            : datalist.length > 0
                ? Questionlist(
                    item: datalist,
                    userlist: userlist,
                    type: tabIdx.toString(),
                    getQuestion: getWenda,
                  )
                : NoData(deHeight: 450));

    return MaterialApp(
        title: "话题",
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: isLoading
                ? LoadingDialog()
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          topArea,
                          SizedBox(
                            height: ScreenUtil().setWidth(20),
                          ),
                          tabBar,
                          SizedBox(
                            height: ScreenUtil().setWidth(2),
                          ),
                          dataView
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }
}
