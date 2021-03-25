import 'package:client/pages_keep_alive/my_store.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages_keep_alive/home_page.dart';
import 'pages_keep_alive/baby_home.dart';
import 'pages_keep_alive/oriange_room.dart';
import 'pages_keep_alive/shop.dart';
import 'pages_keep_alive/mine.dart';
import 'pages_keep_alive/shop_goods_list.dart';
import './service/user_service.dart';

class Tabbar extends StatefulWidget {
  final String index;
  Tabbar({this.index});
  @override
  TabbarState createState() => TabbarState();
}

class TabbarState extends State<Tabbar> {
  //当前选择索引页面
  var _currentIndex = 0;
  DateTime lastPopTime;

  HomePage homePage;

  BabyHomePage babyHomePage;

  OriangeRoomPage oriangeRoomPage;

  ShopPage shopPage;

  MyStorePage myStorePage;

  ShopGoodsList shopGoodsList;

  MinePage minePage;
  int isUser = 0;
  String jwt = '';
  String errcode = '';
  bool isLive = true;
  @override
  void initState() {
    super.initState();

    if (widget.index != "null") {
      _currentIndex = int.parse(widget.index);
    }
    getLocal();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString('jwt');
    });
    if (jwt != null) {
      getInfo();
    }
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      setState(() {
        isLive = success['is_live'].toString() == "0" ? false : true;
      });
    }, (onFail) async {
      print('11111111111111111111');
      print(onFail);
      errcode = onFail;
      print('11111111111111111111');
    });
  }

  //根据当前索引返回不同页面
  currentPage() {
    switch (_currentIndex) {
      case 0:
        if (babyHomePage == null) {
          babyHomePage = BabyHomePage();
        }
        return babyHomePage;

      case 1:
        if (oriangeRoomPage == null) {
          oriangeRoomPage = OriangeRoomPage();
        }
        return oriangeRoomPage;
      case 2:
        if (homePage == null) {
          homePage = HomePage();
        }
        return homePage;

      /*case 3:
        Widget content;
        if (!isLive) {
          content = ShopGoodsList();
        } else if (errcode == '请前往登录') {
          content = ShopGoodsList();
        } else {
          if (isUser == 0) {
            shopPage = ShopPage(stateUser: stateUser);
            content = shopPage;
          } else {
            myStorePage = MyStorePage(stateUser: stateUser);
            content = myStorePage;
          }
        }

        return content;*/

     
      case 3:
          if (minePage == null) {
            minePage = MinePage(getInfo: getInfo);
            if (isUser != 0) {
              return Container();
            }
          }
          return minePage;
    }
  }

  void stateUser(type) {
    setState(() {
      isUser = type;
    });
    print("type---->>>$_currentIndex");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: currentPage(),
        //底部导航栏
        bottomNavigationBar: BottomNavigationBar(
            //通过fixedColor设置选中item颜色
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: ((index) {
              setState(() {
                _currentIndex = index;
              });
            }),
            //底部导航栏
            items: [
              BottomNavigationBarItem(
                title: Text('首页'),
                icon: Image.asset(
                  _currentIndex == 0
                      ? "assets/tabbar/icon_one1.png"
                      : "assets/tabbar/icon_one.png",
                  width: ScreenUtil().setWidth(50),
                ),
              ),
              BottomNavigationBarItem(
                title: Text('橙子教室'),
                icon: Image.asset(
                  _currentIndex == 1
                      ? "assets/tabbar/icon_two1.png"
                      : "assets/tabbar/icon_two.png",
                  width: ScreenUtil().setWidth(50),
                ),
              ),
              BottomNavigationBarItem(
                title: Text('商城'),
                icon: Image.asset(
                  _currentIndex == 2
                      ? "assets/tabbar/icon_three1.png"
                      : "assets/tabbar/icon_three.png",
                  width: ScreenUtil().setWidth(50),
                ),
              ),
            /*  BottomNavigationBarItem(
                title: Text('店铺'),
                icon: Image.asset(
                  _currentIndex == 3
                      ? "assets/tabbar/icon_four1.png"
                      : "assets/tabbar/icon_four.png",
                  width: ScreenUtil().setWidth(50),
                ),
              ),*/
           BottomNavigationBarItem(
                      title: Text('我的'),
                      icon: Image.asset(
                        _currentIndex == 3
                            ? "assets/tabbar/icon_five1.png"
                            : "assets/tabbar/icon_five.png",
                        width: ScreenUtil().setWidth(50),
                      ),
                    ),
            ]),
      ),
      onWillPop: () async {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          ToastUtil.showToast('再按一次退出');
          return false;
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    );
  }
}
