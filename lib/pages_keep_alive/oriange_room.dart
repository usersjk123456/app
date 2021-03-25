import 'dart:async';
import 'package:client/common/style.dart';
import 'package:client/widgets/swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/home_service.dart';
import '../home/homeList.dart';
import '../widgets/cached_image.dart';
import '../common/style.dart';
import '../home/agreement.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/common/Global.dart';
class OriangeRoomPage extends StatefulWidget {
  @override
  OriangeRoomPageState createState() => OriangeRoomPageState();
}

class OriangeRoomPageState extends State<OriangeRoomPage>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool isOpen = false;
  EasyRefreshController _controller = EasyRefreshController();
  TabController tabController;
  GlobalKey anchorKey = GlobalKey();
  List categoryList = [], jingxuanList = [], flList = [];
  List tabTitles = [];
  String tmendtime = '', jwt = '';
  int _page = 0;
  bool isbegin = false, isLive = false, isStore = false;
  int seconds = 0,index=0;
  int clickIndex = 0;
  String sateId = '';
  String betweenimgurl = '';
  List tabView = [];
  bool open = true;
  List bannerImages = [];
  // bool isclose = false;
  @override
  void initState() {
    super.initState();
    getBannerImages();
    getList();
    getTYK();
    getHK();
  }

  /// 查询轮播图接口
  Future<void> getBannerImages() async {
   HomeServer().getBannerImages((success) {
     setState(() {
        isLoading = false;
      });
     bannerImages = success['banner'];
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

// 课程
  void getTYK() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("is_tiyan", () => 1);
       map.putIfAbsent("limit", () => 2);
    map.putIfAbsent("page", () => _page);
    HomeServer().getclass(map, (success) async {
      setState(() {
        isLoading = false;
      });

      jingxuanList = success['list'];


      // fenleiApi();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

// 好课
  void getHK() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();

    map.putIfAbsent("is_tuijian", () => 1);
       map.putIfAbsent("limit", () => 2);
    map.putIfAbsent("page", () => _page);
    HomeServer().getclass(map, (success) async {
      setState(() {
        isLoading = false;
      });

      flList = success['list'];
      // fenleiApi();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void showAgreement() async {
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

  void getList() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 4);
    HomeServer().getOrangeList(map, (success) async {
      setState(() {
        isLoading = false;
      });
      categoryList = success['list'];
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }



  void goShopList(oid, name,index) {
    print(name);

    NavigatorUtils.goBabyFenleiPage(context,oid,name,index.toString());

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



    Widget _getflListItem(BuildContext context, productEntity) {
      return Card(
        elevation: 1,
        child: Container(
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(24),
              left: ScreenUtil().setWidth(26),
              bottom: ScreenUtil().setWidth(24)),
          child: InkWell(
            onTap: () {
              NavigatorUtils.togoodClassList(context);
            },
            //设置圆角
            child: Row(children: [
              Container(
                child: CachedImageView(
                  ScreenUtil.instance.setWidth(219.0),
                  ScreenUtil.instance.setWidth(219.0),
                  productEntity['img'],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    productEntity['name'],
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: ScreenUtil().setSp(32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                      width: ScreenUtil().setWidth(373),
                      child: Text(
                        productEntity['text'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      )),
                  Container(
                      width: ScreenUtil().setWidth(373),
                      child: Text(
                        productEntity['teacher']['name'],
                        style: TextStyle(
                          color: Color(0xffA3C265),
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      )),
                  Container(
                    width: ScreenUtil().setWidth(373),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(155),
                          height: ScreenUtil().setWidth(39),
                          decoration: BoxDecoration(
                            color: Color(0xffFDEAE2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border:
                                Border.all(color: Color(0xffEE9249), width: 1),
                          ),
                          child: Text(
                            productEntity['age'],
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xffF48051),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '￥',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  color: Color(0xffFA242F),
                                ),
                              ),
                              Text(
                                productEntity['now_price'],
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(44),
                                  color: Color(0xffFA242F),
                                ),
                              ),
                              Text(
                                '起',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(26),
                                  color: Color(0xffFA242F),
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
            ]),
          ),
        ),
      );
    }

    Widget _getGridViewItem(BuildContext context, productEntity) {
      return Card(
        elevation: 1,
        child: Container(
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(24),
              left: ScreenUtil().setWidth(26),
              bottom: ScreenUtil().setWidth(24)),
          child: InkWell(
            onTap: () {
              print(productEntity);
              // String oid = (productEntity['id']).toString();
              NavigatorUtils.toBabyList(context);
            },
            //设置圆角
            child: Row(children: [
              Container(
                child: CachedImageView(
                  ScreenUtil.instance.setWidth(219.0),
                  ScreenUtil.instance.setWidth(219.0),
                  productEntity['img'],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    productEntity['name'],
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: ScreenUtil().setSp(32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                      width: ScreenUtil().setWidth(373),
                      child: Text(
                        productEntity['text'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      )),
                  Container(
                    width: ScreenUtil().setWidth(373),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(155),
                          height: ScreenUtil().setWidth(39),
                          decoration: BoxDecoration(
                            color: Color(0xffFDEAE2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border:
                                Border.all(color: Color(0xffEE9249), width: 1),
                          ),
                          child: Text(
                            productEntity['age'],
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xffF48051),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(136),
                          height: ScreenUtil().setWidth(53),
                          decoration: BoxDecoration(
                            color: Color(0xffF57C4C),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border:
                                Border.all(color: Color(0xffF57C4C), width: 1),
                          ),
                          child: InkWell(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '0元领',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(34),
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(11),
                                ),
                                Image.asset(
                                  'assets/index/ic_jiantou.png',
                                  width: ScreenUtil().setWidth(13),
                                ),
                              ],
                            ),
                            onTap: () {
                              NavigatorUtils.toBabyList(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      );
    }

    //分类
    Widget category() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (categoryList.length != 0) {
        for (var i=0;i<categoryList.length;i++) {
          arr.add(HomeListBuilder.categoryBuild(categoryList[i], goShopList,i));
        }
      }

      content = new Row(
        children: arr,
      );

      return content;
    }

    Widget rili = new Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.only(left: 12, right: 12),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10.0),
          itemCount: jingxuanList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _getGridViewItem(context, jingxuanList[index]);
          }),
    );

    Widget fenl = new Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.only(left: 12, right: 12),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10.0),
          itemCount: flList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _getflListItem(context, flList[index]);
          }),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: PublicColor.bodyColor,
              child: Column(
                children: <Widget>[
                  SwiperView(
                    bannerImages,
                    0,
                    ScreenUtil.instance.setWidth(550.0),
                    'xq',
                  ),
  /*Global.isShow
                  ?  
                    Container(
                    color: Color(0xffffffff),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '·',
                          style: TextStyle(
                              fontSize: ScreenUtil().setWidth(60),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Text(
                          '体验课栏',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(36),
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Text(
                          '·',
                          style: TextStyle(
                              fontSize: ScreenUtil().setWidth(60),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    height: ScreenUtil().setWidth(99),
                    width: ScreenUtil().setWidth(750),
                  ):Container(),
                  Global.isShow
                  ?  rili:Container(),*/
                  // 分类
                  /* Global.isShow
                  ?Container(
                    color: Color(0xffffffff),
                    height: ScreenUtil().setWidth(200),
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(20),
                    ),
                    alignment: Alignment.center,
                    child: category(),
                  ):Container(),*/
                  Container(
                    color: Color(0xffffffff),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '·',
                          style: TextStyle(
                              fontSize: ScreenUtil().setWidth(60),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Text(
                          '好课推荐',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(36),
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Text(
                          '·',
                          style: TextStyle(
                              fontSize: ScreenUtil().setWidth(60),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    height: ScreenUtil().setWidth(99),
                    width: ScreenUtil().setWidth(750),
                  ),
                  fenl,
                ],
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }
}
