import 'dart:async';
import 'package:client/common/color.dart';
import 'package:client/model/user.dart';
import 'package:client/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../widgets/cached_image.dart';
import '../service/user_service.dart';
import '../mine/live_permission.dart';
import '../common/Global.dart';

class MinePage extends StatefulWidget {
  final Function getInfo;
  MinePage({this.getInfo});
  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> with TickerProviderStateMixin {
  //保持页面状态
  bool get wantKeepAlive => true;
  bool isLoading = false;
  bool isLogin = false;
  String jwt = '',
      orderOne = '',
      orderTwo = '',
      orderThree = '';
  User _user;
  Timer _timer;
  int isLive = 0;

  @override
  void initState() {
    super.initState();
    getInfo();

  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  void cancelTimer() {
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
    map.putIfAbsent("type", () => "2");
    UserServer().getPayStatus(map, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功,若没有权限,请重新登录');
      widget.getInfo();
      getInfo();
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {

        setState(() {
          isLogin = true;
          orderOne = success['order']['one'].toString();
          orderTwo = success['order']['two'].toString();
          orderThree = success['order']['three'].toString();
          _user = User.fromJson(success['user']);
          _user.vip = _user.vip + 1;
        });

    }, (onFail) async {
      //ToastUtil.showToast(onFail);
      NavigatorUtils.logout(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "加载中"
          ),
        ),
        body: CupertinoActivityIndicator(),
      );
    }

    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = Container(
      alignment: Alignment.topCenter,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(439),
      child: Stack(children: <Widget>[
        //图片
        Positioned(
          top: 0,
          child: Image.asset(
            "assets/mine/rzt.png",
            height: ScreenUtil().setWidth(439),
            width: ScreenUtil().setWidth(750),
            fit: BoxFit.cover,
          ),
        ),
        //消息
        Positioned(
          top: ScreenUtil().setWidth(70),
          right: 60,
          child: Container(
              child: Row(children: <Widget>[
            InkWell(
              child: Image.asset(
                "assets/mine/lt.png",
                width: ScreenUtil().setWidth(49),
                fit: BoxFit.cover,
              ),
              onTap: () {
                NavigatorUtils.goNewsPage(context);
              },
            ),
          ])),
        ),
        //设置
        Positioned(
          top: ScreenUtil().setWidth(70),
          right: 20,
          child: Container(
              child: Row(children: <Widget>[
            InkWell(
              child: Image.asset(
                "assets/mine/sz.png",
                width: ScreenUtil().setWidth(49),
                fit: BoxFit.cover,
              ),
              onTap: () {
                NavigatorUtils.goSetPage(context).then((res) => getInfo());
              },
            )
          ])),
        ),
        //头像
        Positioned(
          top: ScreenUtil().setWidth(100),
          child: Container(
              child: Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0,
                      ScreenUtil().setWidth(45), 0),
                  child: _user.headimgurl == ""
                      ? Container()
                      : CachedImageView(
                          ScreenUtil.instance.setWidth(124.0),
                          ScreenUtil.instance.setWidth(124.0),
                          _user.headimgurl,
                          null,
                          BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Row(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(250),
                        ),
                        child: Text(
                          "${_user.nickname}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: PublicColor.btnColor,
                            fontSize: ScreenUtil().setSp(32),
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      /*Container(
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(16),
                            ScreenUtil().setWidth(3),
                            ScreenUtil().setWidth(16),
                            ScreenUtil().setWidth(3)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          border: Border.all(
                            width: ScreenUtil().setWidth(1),
                            color: Color(0xffffffff),
                          ),
                        ),
                        child: Text(
                          '等级${_user.vip}',
                          style: TextStyle(
                            color: PublicColor.btnColor,
                            fontSize: ScreenUtil().setSp(22),
                          ),
                        ),
                      ),*/
                    ],
                  )),
                  Container(
                    child: Text(
                      // shangjilive != '0'
                      // (邀请人ID：${shangjilive})
                      "ID: ${_user.id}",
                      // : 'ID: ${id}',
                      style: TextStyle(
                        color: PublicColor.btnColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                    ),
                  ),
                  _user.phone != "未绑定"
                      ? Container(
                          child: Text(
                            "${Global.formatPhone(_user.phone?.toString())}",
                            style: TextStyle(
                              color: PublicColor.btnColor,
                              fontSize: ScreenUtil().setSp(26),
                            ),
                          ),
                        )
                      : Container()
                ],
              )
            ],
          )),
        ),
        /*Positioned(
          top: ScreenUtil().setWidth(240),
          left: ScreenUtil().setWidth(212),
          child: Row(
            children: <Widget>[
              InkWell(
                child: Column(
                  children: <Widget>[
                    Text(
                      '关注',
                      style: TextStyle(
                        color: PublicColor.btnColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                    ),
                    Text(
                      '${_user.follow}',
                      style: TextStyle(
                        color: PublicColor.btnColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  NavigatorUtils.look(context);
                },
              ),
              SizedBox(
                width: ScreenUtil().setWidth(121),
              ),
              InkWell(
                child: Column(
                  children: <Widget>[
                    Text(
                      '粉丝',
                      style: TextStyle(
                        color: PublicColor.btnColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                    ),
                    Text(
                      '${_user.fans}',
                      style: TextStyle(
                        color: PublicColor.btnColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  NavigatorUtils.fensi(context);
                },
              ),
            ],
          ),
        ),*/
        /*Positioned(
          top: ScreenUtil().setWidth(200),
          right: ScreenUtil().setWidth(0),
          child: Container(
            height: ScreenUtil().setWidth(70),
            width: ScreenUtil().setWidth(200),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color(0xffA9CD60),
                Color(0xff0FC798),
              ]),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'VIP充值',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  NavigatorUtils.goVip(context);
                  // widget.stateUser(0);
                }),
          ),
        ),*/
        Global.isShow
            ? Positioned(
                // top: ScreenUtil().setWidth(260),
                bottom: 0,
                left: 15,
                child: Container(
                  width: ScreenUtil().setWidth(695),
                  height: ScreenUtil().setWidth(86),
                  padding: EdgeInsets.only(
                    // top: ScreenUtil().setWidth(30),
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30),
                    // bottom: ScreenUtil().setWidth(50),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        const Color(0xff5D686E),
                        const Color(0xff565861)
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    /*  Text(
                        "邀请粉丝赚佣金/精明省分享赚",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          // color: PublicColor.themeColor,
                          color: Color(0xffA3C265),
                        ),
                      ),*/
                      InkWell(
                        onTap: () {
                          NavigatorUtils.goRecommendFansPage(context);
                        },
                        child: Text(
                          "成为推手 >",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Color(0xffA3C265),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ]),
    );
    Widget mine = Container(
      width: ScreenUtil().setWidth(695),
      height: ScreenUtil().setWidth(250),
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          InkWell(
              child: Container(
            // alignment: Alignment.centerRight,

            height: ScreenUtil().setWidth(80),
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: PublicColor.lineColor),
              ),
            ),
            child: Row(children: <Widget>[
              Expanded(
                flex: 8,
                child: Text(
                  '我的订单',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(34),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  child: Text(
                    '查看全部',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xff999999),
                    ),
                  ),
                  onTap: () {
                    String type = "0";
                    NavigatorUtils.goMyOrderPage(context, type);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.navigate_next,
                  color: Color(0xff999999),
                ),
              )
            ]),
          )),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(12),
                          left: ScreenUtil.instance.setWidth(8.0)),
                      height: ScreenUtil.instance.setWidth(135.0),
                      width: ScreenUtil.instance.setWidth(100.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(30.0),
                          ),
                          Expanded(
                            flex: 0,
                            child: Stack(
                              children: <Widget>[
                                Image.asset(
                                  "assets/mine/dfk.png",
                                  height: ScreenUtil().setWidth(50),
                                  fit: BoxFit.cover,
                                ),
                                orderOne == '0'
                                    ? Positioned(
                                        top: ScreenUtil().setWidth(0),
                                        right: ScreenUtil().setWidth(0),
                                        child: Container(),
                                      )
                                    : Positioned(
                                        top: ScreenUtil().setWidth(0),
                                        right: ScreenUtil().setWidth(0),
                                        child: Container(
                                          width: ScreenUtil().setWidth(20),
                                          height: ScreenUtil().setWidth(20),
                                               alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Text(
                                            orderOne,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Expanded(
                            child: Text(
                              '待付款',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: Color(0xff7b7b7b),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      print('待付款');
                      String type = "1";
                      NavigatorUtils.goMyOrderPage(context, type);
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(12),
                          left: ScreenUtil.instance.setWidth(8.0)),
                      height: ScreenUtil.instance.setWidth(135.0),
                      width: ScreenUtil.instance.setWidth(90),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(30.0),
                          ),
                          Expanded(
                            flex: 0,
                            child: Stack(
                              children: <Widget>[
                                Image.asset(
                                  "assets/mine/dfh.png",
                                  height: ScreenUtil().setWidth(50),
                                  fit: BoxFit.cover,
                                ),
                                orderTwo == '0'
                                    ? Positioned(
                                        top: ScreenUtil().setWidth(0),
                                        right: ScreenUtil().setWidth(0),
                                        child: Container(),
                                      )
                                    : Positioned(
                                        top: ScreenUtil().setWidth(0),
                                        right: ScreenUtil().setWidth(0),
                                        child: Container(
                                          width: ScreenUtil().setWidth(20),
                                          height: ScreenUtil().setWidth(20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Text(
                                            orderTwo,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Expanded(
                            child: Text(
                              '待发货',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: Color(0xff7b7b7b),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      print('待发货');
                      String type = "2";
                      NavigatorUtils.goMyOrderPage(context, type);
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(12),
                          left: ScreenUtil.instance.setWidth(8.0)),
                      height: ScreenUtil.instance.setWidth(135.0),
                      width: ScreenUtil.instance.setWidth(90),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(30.0),
                          ),
                          Expanded(
                            flex: 0,
                            child:Stack(children: <Widget>[

                            Image.asset(
                              "assets/mine/dsh.png",
                              height: ScreenUtil().setWidth(50),
                              fit: BoxFit.cover,
                            ),
                            orderThree=='0'?Positioned(
                                        top: ScreenUtil().setWidth(0),
                                        right: ScreenUtil().setWidth(0),
                                        child: Container(),
                                      ):
                            Positioned(
                                        top: ScreenUtil().setWidth(0),
                                        right: ScreenUtil().setWidth(0),
                                        child: Container(
                                          width: ScreenUtil().setWidth(20),
                                          height: ScreenUtil().setWidth(20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Text(
                                            orderThree,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                            ],), 
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Expanded(
                            child: Text(
                              '待收货',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: Color(0xff7b7b7b),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      print('待收货');
                      String type = "3";
                      NavigatorUtils.goMyOrderPage(context, type);
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(12),
                          left: ScreenUtil.instance.setWidth(8.0)),
                      height: ScreenUtil.instance.setWidth(135.0),
                      width: ScreenUtil.instance.setWidth(90),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(30.0),
                          ),
                          Expanded(
                            flex: 0,
                            child: Image.asset(
                              "assets/mine/ywc.png",
                              height: ScreenUtil().setWidth(50),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Expanded(
                            child: Text(
                              '已完成',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: Color(0xff7b7b7b),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      print('已完成');
                      String type = "4";
                      NavigatorUtils.goMyOrderPage(context, type);
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(12),
                          left: ScreenUtil.instance.setWidth(8.0)),
                      height: ScreenUtil.instance.setWidth(135.0),
                      width: ScreenUtil.instance.setWidth(100.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(30.0),
                          ),
                          Expanded(
                            flex: 0,
                            child: Image.asset(
                              "assets/mine/sh.png",
                              height: ScreenUtil().setWidth(50),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Expanded(
                            child: Text(
                              '退款 / 售后',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: Color(0xff7b7b7b),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      NavigatorUtils.goCustomerServicePage(context);
                    },
                  )
                ]),
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
      child: Column(children: <Widget>[
        InkWell(
          child: Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
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
                    "assets/mine/yb.png",
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
                      '已购课程',
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
            NavigatorUtils.goBuyClassPage(context);
          },
        ),
      Global.isShow?   InkWell(
          child: Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
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
                    "assets/mine/ic_wode_tyk.png",
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
                      '我的体验课',
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
            NavigatorUtils.goTyClassPage(context);
          },
        ):Container(),
        // InkWell(
        //   child: Container(
        //     //  alignment: Alignment.centerLeft,
        //     height: ScreenUtil().setWidth(100),
        //     width: ScreenUtil().setWidth(700),
        //     padding: EdgeInsets.fromLTRB(
        //         ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
        //     decoration: BoxDecoration(
        //       border: Border(
        //         bottom: BorderSide(
        //           color: PublicColor.lineColor,
        //         ),
        //       ),
        //     ),
        //     child: Row(children: <Widget>[
        //       Expanded(
        //           flex: 1,
        //           child: Container(
        //             alignment: Alignment.centerLeft,
        //             child: Image.asset(
        //               "assets/mine/ic_wode_yhq.png",
        //               width: ScreenUtil().setWidth(42),
        //               fit: BoxFit.cover,
        //             ),
        //           )),
        //       Expanded(
        //           flex: 7,
        //           child: Container(
        //             alignment: Alignment.centerLeft,
        //             child: Text(
        //               '优惠券',
        //               style: TextStyle(
        //                 color: Colors.black,
        //                 fontSize: ScreenUtil().setSp(28),
        //               ),
        //             ),
        //           )),
        //       Expanded(
        //           flex: 1,
        //           child: Container(
        //             alignment: Alignment.centerRight,
        //             child: Icon(
        //               Icons.navigate_next,
        //               color: Color(0xff999999),
        //             ),
        //           )),
        //     ]),
        //   ),
        //   onTap: () {
        //     NavigatorUtils.goCouponPage(context);
        //   },
        // ),
        InkWell(
          child: Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/ic_wode_shdz.png",
                      width: ScreenUtil().setWidth(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '收货地址',
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
            NavigatorUtils.goHarvestAddressPage(context);
          },
        ),
        InkWell(
          child: Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/ic_wode_smrz.png",
                      width: ScreenUtil().setWidth(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '实名认证',
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
            NavigatorUtils.goRealAuthenticationPage(context);
          },
        ),
        /*InkWell(
          child: Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(30),
              0,
              ScreenUtil().setWidth(20),
              0,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),

            child: Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    "assets/mine/ic_wode_gfkf.png",
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
                    '官方客服',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.navigate_next,
                    color: Color(0xff999999),
                  ),
                ),
              ),
            ]),
          ),
          onTap: () {
            print('官方客服');
            NavigatorUtils.goService(context, _user.kfToken);
          },
        ),*/
        // InkWell(
        //   child: Container(
        //     //  alignment: Alignment.centerLeft,
        //     height: ScreenUtil().setWidth(100),
        //     width: ScreenUtil().setWidth(700),
        //     padding: EdgeInsets.fromLTRB(
        //         ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
        //     decoration: BoxDecoration(
        //       border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
        //     ),
        //     child: Row(children: <Widget>[
        //       Expanded(
        //           flex: 1,
        //           child: Container(
        //             alignment: Alignment.centerLeft,
        //             child: Image.asset(
        //               "assets/mine/ic_wode_yqkc.png",
        //               width: ScreenUtil().setWidth(42),
        //               fit: BoxFit.cover,
        //             ),
        //           )),
        //       Expanded(
        //           flex: 7,
        //           child: Container(
        //             alignment: Alignment.centerLeft,
        //             child: Text(
        //               '邀请店铺',
        //               style: TextStyle(
        //                 color: Colors.black,
        //                 fontSize: ScreenUtil().setSp(28),
        //               ),
        //             ),
        //           )),
        //       Expanded(
        //           flex: 1,
        //           child: Container(
        //             alignment: Alignment.centerRight,
        //             child: Icon(
        //               Icons.navigate_next,
        //               color: Color(0xff999999),
        //             ),
        //           )),
        //     ]),
        //   ),
        //   onTap: () {
        //     NavigatorUtils.gobmlist(context);
        //   },
        // ),
        InkWell(
          child: Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
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
                      "assets/mine/ic_wode_wdye.png",
                      width: ScreenUtil().setWidth(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '我的余额',
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
            NavigatorUtils.goCurrentBalancePage(context);
          },
        ),
        /*InkWell(
          child: Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/ic_wode_wdsc.png",
                      width: ScreenUtil().setWidth(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('成为供应商',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                  *//*    !_user.isStore ?
                      (_user.state == -1 ? '成为供应商' : _user.state == 0 ? '审核中' : _user.state == 1 ? '缴纳保证金' : '审核失败')
                          : '切换到供货商',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: PublicColor.whiteColor,
                      )*//*
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
            if (!_user.isStore) {
              if (_user.state == 0) {
                NavigatorUtils.goAuthenticationWaitingPage(context)
                    .then((data) {
                  getInfo();
                });
              } else if (_user.state == 1) {
                NavigatorUtils.toAuthenticationPayPage(context)
                    .then((data) {
                  getInfo();
                });
              } else {
                NavigatorUtils.goApplicationPage(context).then((data) {
                  getInfo();
                });
              }
            }
          },
        )*/
        /*InkWell(
          child: Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/ic_wode_wdsc.png",
                      width: ScreenUtil().setWidth(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '我的收藏',
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
            // NavigatorUtils.goIntegral(context);
            NavigatorUtils.goCollectMine(context);
          },
        ),*/
       /* isLive == 0
            ? InkWell(
                child: Container(
                  //  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setWidth(100),
                  width: ScreenUtil().setWidth(700),
                  padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30),
                    0,
                    ScreenUtil().setWidth(20),
                    0,
                  ),
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/mine/kt.png",
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
                          '升级播商',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.navigate_next,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return OpenLiveDialog(startTimer: startTimer);
                    },
                  );
                },
              )
            : Container()*/
      ]),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: PublicColor.bodyColor,
          body: Container(
            alignment: Alignment.center,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                topArea,
                SizedBox(
                  height: ScreenUtil().setWidth(30),
                ),
                mine,
                SizedBox(
                  height: ScreenUtil().setWidth(30),
                ),
                listArea
              ],
            ),
          ),
        ),
        isLoading ? LoadingDialog(types: "1") : Container()
      ],
    );
  }
}

Map<String, String> codeMapperText = {
  "-1": "成为供应商",
  "0": "",
  "1": ""
};