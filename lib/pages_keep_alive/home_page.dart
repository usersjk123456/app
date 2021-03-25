import 'dart:async';

import 'package:client/common/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/home_topbar.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/swiper.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/home_service.dart';
import '../home/homeList.dart';
import '../widgets/zhibo_product.dart';
import '../service/live_service.dart';
import '../common/color.dart';
import '../api/api.dart';
import '../utils/serivice.dart';
import '../home/agreement.dart';
import '../widgets/cached_image.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isLoading = false;
  bool isOpen = false;
  EasyRefreshController _controller = EasyRefreshController();
  TabController tabController;
  GlobalKey anchorKey = GlobalKey();
  List categoryList = [], bannerList = [], jingxuanList = [];
  List tabTitles = [];
  String tmendtime = '', jwt = '', id = '';
  int _page = 0;
  bool isbegin = false, isLive = false, isStore = false;
  int seconds = 0;
  int clickIndex = 0;
  String sateId = '';
  String betweenimgurl = '', newCount = '0';
  List tabView = [];
  bool open = true;
  Timer _timer;
  // bool isclose = false;
  @override
  void initState() {
    print('首页');
    getLocal();

    super.initState();
    getHome();
    startTimer();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
  }

  void getLunXun() async {
    Map<String, dynamic> map = Map();
    Service().lxget(Api.LUNXUN_URL, map, (success) async {
      print('success[res]--------------------------->$success["res"]');
      if (success['res'].toString() != "false") {
        cancelTimer();
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return _zjWidget(context, success['res']);
            });
      }
    }, (onFail) async {
      print("~~~~~~~~~~~~~~~~~~");
      print(onFail);
      print("~~~~~~~~~~~~~~~~~~");
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

  void cancelTimer() {
    print('++++++++++++++cancelTimer+++++++++++++++++++++++');
    _timer?.cancel();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 5);
    _timer = Timer.periodic(period, (timer) {
      print("轮训？？？？？？？？");
      getLunXun();
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
      bannerList = success['banner'];
      jingxuanList = success['goods'];
      newCount = success['car'].toString();
      
      fenleiApi();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
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

  void goShopList(oid, name, index) {
    print(name);
    NavigatorUtils.toShopListPage(context, oid, name, "1")
        .then((res) => getHome());
  }

  @override
  void dispose() {
    print("走了没？？？？？？？？");
    if (tabController != null) {
      tabController.dispose();
    }
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
              elevation: 0,
              title: TopBar(
                newcount: newCount,
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: PublicColor.linearBtn,
                ),
              ),
              automaticallyImplyLeading: false),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }

  Widget _zjWidget(BuildContext context, type) {
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: new Container(
          width: ScreenUtil.instance.setWidth(504.0),
          height: ScreenUtil.instance.setWidth(575.0),
          padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(20),
              left: ScreenUtil().setWidth(20)),
          decoration: ShapeDecoration(
            image: DecorationImage(image: AssetImage("assets/index/djbg.png")),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          child: type != "success"
              ? Column(
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setWidth(60)),
                    Image.asset(
                      "assets/index/wzj.png",
                      width: ScreenUtil().setWidth(422),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "补贴已经返回我的余额",
                        style: TextStyle(
                          color: PublicColor.themeColor,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(30)),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        startTimer();
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(400),
                        height: ScreenUtil().setWidth(80),
                        decoration: BoxDecoration(
                          gradient: PublicColor.linearHeader,
                          borderRadius: BorderRadius.circular(80),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "确认",
                          style: TextStyle(
                            color: PublicColor.btnColor,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setWidth(60)),
                    Image.asset(
                      "assets/index/zj.png",
                      width: ScreenUtil().setWidth(422),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "恭喜拼团成功",
                        style: TextStyle(
                          color: PublicColor.themeColor,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(30)),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        startTimer();
                        String type = "0";
                        NavigatorUtils.goMyOrderPage(context, type)
                            .then((res) => getHome());
                        ;
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(400),
                        height: ScreenUtil().setWidth(80),
                        decoration: BoxDecoration(
                          gradient: PublicColor.linearHeader,
                          borderRadius: BorderRadius.circular(80),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "立即前往查看",
                          style: TextStyle(
                            color: PublicColor.btnColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  //分类
  Widget category() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (categoryList.length != 0) {
      for (var i = 0; i < categoryList.length; i++) {
        arr.add(HomeListBuilder.categoryBuild(categoryList[i], goShopList, i));
      }
    }

    content = new Row(
      children: arr,
    );
    return content;
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

  Widget _getGridViewItem(BuildContext context, productEntity) {
    return Container(
      color: Color(0xffffffff),
      child: InkWell(
        onTap: () {
          print(productEntity);
          String oid = (productEntity['id']).toString();

          NavigatorUtils.toXiangQing(context, oid, '0', '0')
              .then((res) => getHome());
        },
        //设置圆角
        child: Column(children: [
          Container(
            child: CachedImageView(
              ScreenUtil.instance.setWidth(338.0),
              ScreenUtil.instance.setWidth(338.0),
              productEntity['thumb'],
              null,
              BorderRadius.all(
                Radius.circular(0),
              ),
            ),
          ),
          Container(
            height: 18,
            child: Text(productEntity['name'] ?? "",
              overflow: TextOverflow.clip,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(29),
                right: ScreenUtil().setWidth(29)),
            child: Text(
              '￥' + productEntity['now_price'].toString(),
              style: TextStyle(
                  color: Colors.red,
                  fontSize: ScreenUtil.instance.setWidth(30)),
            ),
          )
        ]),
      ),
    );
  }

  Widget contentWidget() {
    return Container(
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
          child: Column(
            children: <Widget>[
              SwiperView(bannerList, bannerList.length,
                  ScreenUtil.instance.setWidth(360.0), 'home'),
              SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
              Container(
                color: Color(0xffffffff),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(28),
                    bottom: ScreenUtil().setWidth(28)),
                child: category(),
              ),
              SizedBox(height: ScreenUtil.instance.setWidth(30.0)),
          /*    InkWell(
                onTap: () {
                  showAgreement();
                },
                child: Image.asset(
                  "assets/index/ic_sc_pt.png",
                  width: ScreenUtil.instance.setWidth(693.0),
                ),
              ),*/
             /* Global.isShow
                  ? Container(
                      height: ScreenUtil().setWidth(98),
                      color: Color(0xffffffff),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: ScreenUtil().setWidth(30),
                          ),
                          Image.asset(
                            'assets/index/ic_tuijian.png',
                            width: ScreenUtil().setWidth(37),
                            height: ScreenUtil().setWidth(49),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(19),
                          ),
                          Text(
                            '直播列表',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color(0xff333333),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),*/
            /*  Global.isShow
                  ? Container(
                      // height: ScreenUtil.instance.setWidth(600) * length,
                      width: ScreenUtil.instance.setWidth(750.0),
                      key: anchorKey,
                      child: listBox(),
                    )
                  : Container(),*/
              Global.isShow
                  ? Container(
                      height: ScreenUtil().setWidth(98),
                      color: Color(0xffffffff),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: ScreenUtil().setWidth(30),
                          ),
                          Image.asset(
                            'assets/index/rx.png',
                            width: ScreenUtil().setWidth(37),
                            height: ScreenUtil().setWidth(49),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(19),
                          ),
                          Text(
                            '优选商品',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color(0xff333333),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              jingxuanList.length <= 0 && Global.isShow
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(50),
                          bottom: ScreenUtil().setHeight(50)),
                      child: Image.asset(
                        'assets/mine/zwsj.png',
                        width: ScreenUtil().setWidth(400),
                      ),
                    )
                  : Global.isShow
                      ? Container(
                          color: Color(0xffffffff),
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10.0),
                              itemCount: jingxuanList.length,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      //横轴元素个数
                                      crossAxisCount: 2,
                                      //纵轴间距
                                      mainAxisSpacing: 5.0,

                                      //横轴间距
                                      crossAxisSpacing: 5.0,
                                      //子组件宽高长度比例
                                      childAspectRatio: 0.8),
                              itemBuilder: (BuildContext context, int index) {
                                return _getGridViewItem(
                                    context, jingxuanList[index]);
                              }),
                        )
                      : Container(),
            ],
          ),
        ),
        onRefresh: () async {
          _page = 0;
          getHome();
        },
        onLoad: () async {
          if (this.tabController != null) {
            listApi(this.tabController.index);
          }
        },
      ),
    );
  }
}
