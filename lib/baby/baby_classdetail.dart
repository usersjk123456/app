import 'package:client/pay_order/class_wx_pay.dart';
import '../widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/cached_image.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import '../utils/toast_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Navigator_util.dart';
import '../service/goods_service.dart';
import '../service/user_service.dart';
import '../common/color.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class GoodsXiangQingPage extends StatefulWidget {
  final String oid;
  final String shipId;
  final String roomId;
  final String type;
  GoodsXiangQingPage({this.oid, this.shipId, this.roomId, this.type});
  @override
  _GoodsXiangQingPageState createState() => _GoodsXiangQingPageState();
}

class _GoodsXiangQingPageState extends State<GoodsXiangQingPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  bool isLoading = false;
  EasyRefreshController _controller = EasyRefreshController();
  GlobalKey globalKey = GlobalKey();
  bool isplay = false;
  String url = "";
  List guige = [];
  int buynum = 1;
  int checkindex = 0;
  String jwt = '',
      img = '',
      teacher = '',
      name = '',
      text = '',
      detail = "",
      oldprice = '',
      oid = '';
  int checkindex1 = -1;
  Timer _timer;
  List xiangqingimglist = [];
  List bannerList = [];
  List tuijianlist = [];
  int _page = 0, urltype;
  String kfToken = '';
  List commentList = [];
  String count = '0';
  bool isLive = false, isStore = false;

  @override
  void initState() {
    super.initState();

    buynum = 1;
    getLocal();
    _page = 0;

    _controller.finishRefresh();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getLocal();
    }
  }

  void payOrder() async {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("cid", () => oid);
    map.putIfAbsent("amount", () => oldprice);
    map.putIfAbsent("type", () => widget.type);
    GoodsServer().buyClass(map, (success) async {
      setState(() {
        isLoading = false;
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void popContent() {
    NavigatorUtils.toLingQu(context);
  }

  void cancelTimer() {
    _timer?.cancel();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startTimer(orderId) {
    setState(() {
      isLoading = true;
    });
    //设置 1 秒回调一次
    const period = const Duration(seconds: 2);
    _timer = Timer.periodic(period, (timer) {
      getPayStatus(orderId);
      //更新界面
    });
  }

  void getPayStatus(orderId) async {
    print('支付中..');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => orderId);
    map.putIfAbsent("type", () => "1");
    UserServer().getPayStatus(map, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');

      // NavigatorUtils.goMyOrderPage(context, type);
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  @override
  void dispose() {
    _videoPlayerController1?.dispose();
    _chewieController?.dispose();
    super.dispose();
    cancelTimer();
  }

  void playsss() {
    _videoPlayerController1 = VideoPlayerController.network(img);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 2 / 3,
      autoPlay: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {
      isplay = true;
    });
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString('jwt');

    await getGoodsDetails();
  }

  // 商品详情
  Future getGoodsDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    GoodsServer().gethkGoodsDetails(map, (success) async {
      setState(() {
        isLoading = false;
        oid = success['list']['id'].toString();
        img = success['list']['img'];
        urltype = success['list']['urltype'];
        detail = success['list']['detail'];
        name = success['list']['name'];
        text = success['list']['text'];
        teacher = success['list']['teacher']['name'];
        oldprice = success['list']['now_price'];
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: Text(
              '课程详情',
              style: TextStyle(
                color: PublicColor.headerTextColor,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
            centerTitle: true,
            leading: new IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: contentWidget(),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget contentWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
            padding:
                EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(100.0)),
            color: Color(0xffff5f5f5),
            // child: EasyRefresh(
            //   controller: _controller,
            //   header: BezierCircleHeader(
            //     backgroundColor: PublicColor.themeColor,
            //   ),
            //   footer: BezierBounceFooter(
            //     backgroundColor: PublicColor.themeColor,
            //   ),
            //   enableControlFinishRefresh: true,
            //   enableControlFinishLoad: false,
            //   onRefresh: () async {
            //     getLocal();
            //   },
            //   onLoad: () async {},
            // child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Stack(
                children: <Widget>[
                  urltype == 2
                      ? Container(
                          width: ScreenUtil().setWidth(750),
                          height: ScreenUtil().setWidth(420),
                          color: Colors.black,
                          child: isplay
                              ? Chewie(
                                  controller: _chewieController,
                                )
                              : Container(
                                  width: ScreenUtil().setWidth(750),
                                  height: ScreenUtil().setWidth(420),
                                  decoration: img != ""
                                      ? BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              img,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : BoxDecoration(),
                                  child: InkWell(
                                    onTap: () {
                                      playsss();
                                    },
                                    child: Image.asset(
                                      "assets/zhibo/play.png",
                                      width: ScreenUtil().setWidth(90),
                                      height: ScreenUtil().setWidth(90),
                                    ),
                                  ),
                                ),
                        )
                      : Container(
                          child: CachedImageView(
                            ScreenUtil.instance.setWidth(750.0),
                            ScreenUtil.instance.setWidth(420.0),
                            img,
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
              Container(
                height: ScreenUtil.instance.setWidth(191.0),
                width: ScreenUtil.instance.setWidth(750.0),
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(25),
                  right: ScreenUtil().setWidth(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(35),
                    ),
                    Container(
                      // color: Colors.black87,
                      alignment: Alignment.centerLeft,

                      child: Text(
                        // '${goods['name']}',
                        name,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(30.0),
                          color: Color(0xfff000000),
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black87,
                      alignment: Alignment.centerLeft,

                      child: Text(
                        // '${goods['name']}',
                        teacher,

                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(28.0),
                          color: Color(0xffA2BD52),
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black87,
                      alignment: Alignment.centerLeft,

                      child: Text(
                        // '${goods['name']}',
                        text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(28.0),
                          color: Color(0xff4E4E4E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              Container(
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(15),
                ),
                height: ScreenUtil.instance.setWidth(87.0),
                width: ScreenUtil.instance.setWidth(750.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffdddddd)),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setWidth(26),
                      width: ScreenUtil().setWidth(8),
                      decoration: BoxDecoration(
                          color: Color(0xffFD8C34),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(12),
                    ),
                    Text(
                      '课程介绍',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(32.0),
                        color: Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: ScreenUtil().setWidth(750),
              //   height: ScreenUtil().setWidth(700),
              //   color: Color(0xffffffff),
              //   child: Text(
              //     text,
              //     style: TextStyle(
              //       fontSize: ScreenUtil.instance.setWidth(28.0),
              //       color: Color(0xff4E4E4E),
              //     ),
              //   ),
              // ),

              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                child: Html(data: detail),
              ),
            ])),
        // ),
        // ),
        Container(
          height: ScreenUtil.instance.setWidth(100.0),
          decoration: BoxDecoration(color: Color(0xffffffff), boxShadow: [
            BoxShadow(
              color: Color(0xff6C6C6C),
              blurRadius: 5.0,
            ),
          ]),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                ),
                child: Text(
                  oldprice,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    color: Color(0xffFB1F29),
                  ),
                ),
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        right: ScreenUtil().setWidth(36),
                      ),
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setWidth(61),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(
                          color: PublicColor.themeColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '试听',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(34),
                          color: PublicColor.themeColor,
                        ),
                      ),
                    ),
                    onTap: () {
                      NavigatorUtils.todetailInfo(context, widget.oid);
                    },
                  ),
                  InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        right: ScreenUtil().setWidth(36),
                      ),
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setWidth(61),
                      decoration: BoxDecoration(
                        color: Color(0xffFD8C34),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        '购买',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(34),
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    onTap: () {
                      // showDialog(
                      //     context: context,
                      //     barrierDismissible: true,
                      //     builder: (BuildContext context) {
                      //       return MyDialog(
                      //           width: ScreenUtil.instance.setWidth(600.0),
                      //           height: ScreenUtil.instance.setWidth(300.0),
                      //           queding: () {
                      //             payOrder();
                      //             Navigator.of(context).pop();
                      //           },
                      //           quxiao: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //           title: '温馨提示',
                      //           message: '确定购买该商品吗？');
                      //     });

                      if (oldprice == '0') {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return MyDialog(
                                  width: ScreenUtil.instance.setWidth(600.0),
                                  height: ScreenUtil.instance.setWidth(300.0),
                                  queding: () {
                                    payOrder();
                                    Navigator.of(context).pop();
                                  },
                                  quxiao: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: '温馨提示',
                                  message: '确定购买该商品吗？');
                            });
                      } else {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return FukuanWidget(
                                total: oldprice,
                                jwt: jwt,
                                cid: oid,
                                startTimer: startTimer,
                                popContent: popContent,
                                type: '2',
                              );
                            });
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
