import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/home_topbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/video_product.dart';
import '../utils/toast_util.dart';
import 'package:flutter/services.dart';
import '../common/color.dart';
import '../service/video_service.dart';

class ShortVideoPage extends StatefulWidget {
  @override
  ShortVideoPageState createState() => ShortVideoPageState();
}

class ShortVideoPageState extends State<ShortVideoPage>
    with TickerProviderStateMixin {
  bool isloading = false;
  DateTime lastPopTime;
  EasyRefreshController _controller = EasyRefreshController();
  TabController tabController;
  String jwt = '';
  List tabTitles = [];
  String typeId = "";
  int _page = 0;
  bool isOpen = false;
  List tabView = [];
  String uid = '';
  int typeIndex = 0;
  @override
  void initState() {
    super.initState();
    _queryZhiboData();
    getInfo();
    fenleiApi();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          uid = success['id'].toString();
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  //分类
  void fenleiApi() async {
    Map<String, dynamic> map = Map();
    VideoServer().getViodeType(map, (success) async {
      setState(() {
        isOpen = true;
        tabTitles = success['list'];
      });
      this.tabController = new TabController(
        length: tabTitles.length,
        vsync: this,
      );
      _page = 0;
      listApi(0);
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  void listApi(index) async {
    typeId = tabTitles[index]['id'].toString();
    _page++;
    if (_page == 1) {
      tabView = [];
    }
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => typeId);
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 6);
    VideoServer().getViodeList(map, (success) async {
      if (success['list'].length == 0) {
        setState(() {
          isloading = false;
        });
        // ToastUtil.showToast('已加载全部数据');
      } else {
        for (var i = 0; i < success['list'].length; i++) {
          setState(() {
            isloading = false;
            tabView.insert(tabView.length, success['list'][i]);
          });
        }
      }
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  _queryZhiboData() {
    _controller.finishRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return WillPopScope(
      child: Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: TopBar(),
            flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: PublicColor.linearHeader,
                  ),
                ),

            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Material(
                color: Colors.white,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: isOpen ? tabBar() : Container(),
                ),
              ),
            ),
          ),
          body: contentWidget()),
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

  Widget tabBar() {
    return TabBar(
      controller: tabController,
      indicatorColor: null,
      indicator: const BoxDecoration(),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.red,
      unselectedLabelColor: Colors.black,
      isScrollable: true,
      tabs: tabTitles
          .map(
            (i) => Tab(
              text: i['name'],
            ),
          )
          .toList(),
      unselectedLabelStyle:
          TextStyle(fontSize: ScreenUtil.instance.setWidth(30)),
      labelStyle: TextStyle(
        fontSize: ScreenUtil.instance.setWidth(30),
        fontWeight: FontWeight.bold,
      ),
      onTap: ((index) {
        _page = 0;
        typeIndex = index;
        listApi(index);
      }),
    );
  }

  Widget contentWidget() {
    return Container(
      color: Color(0xffff5f5f5),
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
          child: tabView.length == 0
              ? Container(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(300),
                    left: ScreenUtil().setWidth(150),
                    right: ScreenUtil().setWidth(150),
                  ),
                  child: Image.asset(
                    'assets/mine/zwsj.png',
                  ),
                )
              : ProductView(tabView, typeId, uid),
        ),
        onRefresh: () async {
          _page = 0;
          listApi(typeIndex);
          _controller.finishRefresh();
        },
        onLoad: () async {
          listApi(typeIndex);
          _controller.finishRefresh();
        },
      ),
    );
  }
}
