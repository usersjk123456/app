import 'package:client/common/color.dart';
import 'package:client/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../api/api.dart';
import '../utils/serivice.dart';
import '../service/user_service.dart';

class TeamPage extends StatefulWidget {
  @override
  TeamPageState createState() => TeamPageState();
}

class TeamPageState extends State<TeamPage> with TickerProviderStateMixin {
  bool isLoading = false;
  String lvl1 = '0', lvl2 = '0', lvl3 = '0', lvl0 = '0';
  int isLive = 0;
  int isStore = 0;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      setState(() {
        isLive = success['is_live'];
        isStore = success['is_store'];
      });
      getList();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    Service().sget(Api.TEAM_URL, map, (success) async {
      setState(() {
        isLoading = false;
        lvl0 = success['lvl0'].toString();
        lvl1 = success['lvl1'].toString();
        lvl2 = success['lvl2'].toString();
        lvl3 = success['lvl3'].toString();
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

    Widget topArea = Container(
      alignment: Alignment.topCenter,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(410),
      child: Stack(
        children: <Widget>[
          //图片
          Positioned(
            top: 0,
            child: Image.asset(
              "assets/mine/rzt.png",
              height: ScreenUtil().setWidth(277),
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
                '我的团队',
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
            top: ScreenUtil().setWidth(170),
            left: 15,
            child: Container(
              width: ScreenUtil().setWidth(695),
              height: ScreenUtil().setWidth(200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        NavigatorUtils.goBoshang(context, "1", lvl1);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$lvl1",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(40),
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(10)),
                          Text(
                            "播商成员",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        NavigatorUtils.goBoshang(context, "2", lvl2);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$lvl2",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(40),
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(10)),
                          Text(
                            "播商服务商",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        NavigatorUtils.goBoshang(context, "3", lvl0);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$lvl0",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(40),
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(10)),
                          Text(
                            "粉丝成员",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        NavigatorUtils.goBoshang(context, "4", lvl3);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$lvl3",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(40),
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(10)),
                          Text(
                            "VIP成员",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    Widget listArea = Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(26),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          isLive == 2
              ? InkWell(
                  child: Container(
                    //  alignment: Alignment.centerLeft,
                    height: ScreenUtil().setWidth(100),
                    width: ScreenUtil().setWidth(700),
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0,
                        ScreenUtil().setWidth(20), 0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: PublicColor.lineColor,
                        ),
                      ),
                    ),
                    child: Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            "assets/mine/quanxianzengsong.png",
                            width: ScreenUtil().setWidth(42),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 7,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '权限赠送',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.navigate_next,
                              color: Color(0xff999999),
                            ),
                          )),
                    ]),
                  ),
                  onTap: () {
                    NavigatorUtils.goQuanxian(context);
                  },
                )
              : Container(),
          // isLive != 0
          isLive != 2
              ? InkWell(
                  child: Container(
                    //  alignment: Alignment.centerLeft,
                    height: ScreenUtil().setWidth(100),
                    width: ScreenUtil().setWidth(700),
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0,
                        ScreenUtil().setWidth(20), 0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: PublicColor.lineColor,
                        ),
                      ),
                    ),
                    child: Row(children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              "assets/mine/shenqinggaojihehuoren.png",
                              width: ScreenUtil().setWidth(42),
                              fit: BoxFit.cover,
                            ),
                          )),
                      Expanded(
                          flex: 7,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '申请播商服务商',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.navigate_next,
                              color: Color(0xff999999),
                            ),
                          )),
                    ]),
                  ),
                  onTap: () {
                    NavigatorUtils.goPayhhr(context);
                  },
                )
              : Container(),
          // isLive == 1
          isLive != 2
              ? InkWell(
                  child: Container(
                    //  alignment: Alignment.centerLeft,
                    height: ScreenUtil().setWidth(100),
                    width: ScreenUtil().setWidth(700),
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0,
                        ScreenUtil().setWidth(20), 0),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: PublicColor.lineColor)),
                    ),
                    child: Row(children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              "assets/mine/shengjigaojihehuoren.png",
                              width: ScreenUtil().setWidth(42),
                              fit: BoxFit.cover,
                            ),
                          )),
                      Expanded(
                          flex: 7,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '升级播商服务商',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.navigate_next,
                              color: Color(0xff999999),
                            ),
                          )),
                    ]),
                  ),
                  onTap: () {
                    NavigatorUtils.goShengjihhr(context).then((res) {
                      getInfo();
                    });
                  },
                )
              : Container(),
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: PublicColor.bodyColor,
          body: Container(
            alignment: Alignment.center,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[topArea, listArea],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
