import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/zhibo_topbar.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/swiper.dart';
import '../widgets/cached_image.dart';
import '../widgets/zhibo_product.dart';
import '../utils/toast_util.dart';
import 'package:flutter/services.dart';
import '../common/color.dart';
import '../service/live_service.dart';

class ZhiboListPage extends StatefulWidget {
  @override
  ZhiboPageListState createState() => ZhiboPageListState();
}

class ZhiboPageListState extends State<ZhiboListPage>
    with TickerProviderStateMixin {
  bool isloading = false;
  DateTime lastPopTime;
  EasyRefreshController _controller = EasyRefreshController();
  GlobalKey anchorKey = GlobalKey();
  TabController tabController;
  double length = 0;
  String jwt = '';
  List tabTitles = [];
  int _page = 0;
  List bannerList = [];
  bool isOpen = false;
  List tabView = [];
  bool open = true;

  @override
  void initState() {
    super.initState();
    bannerApi();
    rexiaoApi();
  }

//轮播
  void bannerApi() async {
    Map<String, dynamic> map = Map();
    LiveServer().getLiveBanner(map, (success) async {
      setState(() {
        bannerList = success['banner'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

//直播热销
  void rexiaoApi() async {
    Map<String, dynamic> map = Map();
    LiveServer().getHotList(map, (success) async {
      setState(() {
        rexiaolist = success['goods'];
      });
      fenleiApi();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

//分类
  void fenleiApi() async {
    Map<String, dynamic> map = Map();
    LiveServer().getLiveCate(map, (success) async {
      isOpen = true;
      setState(() {
        tabTitles = success['list'];
      });
      this.tabController = new TabController(
        length: tabTitles.length,
        vsync: this,
      );
      _page = 0;
      if (tabTitles.length != 0) {
        listApi(0);
      }
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

//直播列表
  void listApi(index) async {
    var id = tabTitles[index]['id'];
    _page++;
    if (_page == 1) {
      setState(() {
        tabView = [];
      });
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => id);
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 100);
    LiveServer().getLiveList(map, (success) async {
      open = true;
      if (success['list'].length == 0) {
        // setState(() {
        //   isloading = false;
        // });
        // ToastUtil.showToast('已加载全部数据');
      } else {
        print('222222222');
        for (var i = 0; i < success['list'].length; i++) {
          setState(() {
            tabView.insert(tabView.length, success['list'][i]);
          });
        }
        print('222222222=======$tabView');
      }
      _controller.finishRefresh();
    }, (onFail) async {
      // setState(() {
      //   isloading = false;
      // });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  getliveurl(productEntity) async {
    if (productEntity['is_open'].toString() == "1") {
      Map<String, dynamic> map = Map();
      map.putIfAbsent("room_id", () => productEntity['id']);
      LiveServer().inRoom(map, (success) async {
        NavigatorUtils.goLookZhibo(
            context, productEntity['id'].toString(), success);
      }, (onFail) async {
        ToastUtil.showToast(onFail);
      });
    } else {
      NavigatorUtils.goLiveOverPage(context, productEntity['id']);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // tabController.dispose();
  }

  List rexiaolist = [];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        WillPopScope(
          child: Scaffold(
              appBar: new AppBar(
                  elevation: 0,
                  title: TopBar(),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: PublicColor.linearHeader,
                    ),
                  ),
                  automaticallyImplyLeading: false),
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
        ),
        isloading ? LoadingDialog() : Container(),
      ],
    );
  }

  Widget buildListData(context, item, index) {
    return Container(
      height: ScreenUtil.instance.setWidth(260.0),
      width: ScreenUtil.instance.setWidth(210.0),
      padding: EdgeInsets.only(right: ScreenUtil.instance.setWidth(20.0)),
      child: InkWell(
        child: new Column(
          children: <Widget>[
            CachedImageView(
                ScreenUtil.instance.setWidth(190.0),
                ScreenUtil.instance.setWidth(195.0),
                item['thumb'],
                new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Color(0xfffcccccc), width: 0.5),
                ),
                BorderRadius.circular(10)),
            new Container(
              width: ScreenUtil.instance.setWidth(190.0),
              height: ScreenUtil.instance.setWidth(65.0),
              padding: EdgeInsets.only(top: ScreenUtil.instance.setWidth(10.0)),
              alignment: Alignment.topCenter,
              child: Text(
                '￥' + item['now_price'].toString(),
                style: TextStyle(
                    fontSize: ScreenUtil.instance.setWidth(30.0),
                    color: Colors.red,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        onTap: () {
          NavigatorUtils.toXiangQing(context, item['id']);
        },
      ),
    );
  }

  Widget tabBar() {
    return SafeArea(
      child: TabBar(
        controller: tabController,
        indicatorColor: null,
        indicator: const BoxDecoration(),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.red,
        unselectedLabelColor: Colors.black,
        isScrollable: true,
        tabs: tabTitles.map((i) => Tab(text: i['name'])).toList(),
        unselectedLabelStyle:
            TextStyle(fontSize: ScreenUtil.instance.setWidth(30)),
        labelStyle: TextStyle(
            fontSize: ScreenUtil.instance.setWidth(30),
            fontWeight: FontWeight.bold),
        onTap: ((index) {
          _page = 0;
          if (open) {
            open = false;
            listApi(index);
          }
        }),
      ),
    );
  }

  // 列表部分
  Widget listBox() {
    return tabView.length == 0
        ? Container(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(50),
              bottom: ScreenUtil().setWidth(50),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/zhibo/zanwuzhibo_bg.png',
              width: ScreenUtil().setWidth(258),
            ),
          )
        : ProductView(tabView, getliveurl);
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
          child: new Listener(
            onPointerMove: (event) {
              RenderBox renderBox = anchorKey.currentContext.findRenderObject();
              var offset = renderBox.localToGlobal(Offset.zero);
              print(offset.dy);
            },
            child: Column(
              children: <Widget>[
                SwiperView(bannerList, bannerList.length,
                    ScreenUtil.instance.setWidth(360.0), 'home'),
                new Container(
                  color: Color(0xffffffff),
                  height: ScreenUtil.instance.setWidth(75.0),
                  width: ScreenUtil.instance.setWidth(750.0),
                  padding:
                      EdgeInsets.only(left: ScreenUtil.instance.setWidth(27.0)),
                  child: new Row(children: [
                    Image.asset(
                      'assets/zhibo/hot.png',
                      width: ScreenUtil.instance.setWidth(44.0),
                    ),
                    Text(
                      '  直播热销',
                      style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(36.0),
                          color: PublicColor.themeColor,
                          fontWeight: FontWeight.w700),
                    )
                  ]),
                ),
                rexiaolist.length == 0
                    ? Container(
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(30),
                          bottom: ScreenUtil().setWidth(60),
                        ),
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(750),
                        color: Colors.white,
                        child: Image.asset(
                          'assets/mine/zwsj.png',
                          width: ScreenUtil().setWidth(300),
                        ),
                      )
                    : Container(
                        height: ScreenUtil.instance.setWidth(260.0),
                        width: ScreenUtil.instance.setWidth(750.0),
                        padding: EdgeInsets.only(
                            left: ScreenUtil.instance.setWidth(25.0)),
                        color: Color(0xffffffff),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: rexiaolist.length,
                          itemBuilder: (context, index) {
                            return buildListData(
                                context, rexiaolist[index], index);
                          },
                        ),
                      ),
                Container(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: isOpen ? tabBar() : Container(),
                  ),
                ),
                Container(
                  // height: ScreenUtil.instance.setWidth(600) * length,
                  width: ScreenUtil.instance.setWidth(750.0),
                  key: anchorKey,
                  child: listBox(),
                )
              ],
            ),
          ),
        ),
        onRefresh: () async {
          _page = 0;
          fenleiApi();
        },
        onLoad: () async {
          if (this.tabController != null) {
            listApi(this.tabController.index);
          }
          _controller.finishRefresh();
        },
      ),
    );
  }
}
