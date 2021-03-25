import 'package:client/common/color.dart';
import '../widgets/order_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/store_service.dart';
import '../widgets/tool_menu.dart';

class MyStorePage extends StatefulWidget {
  final Function stateUser;
  MyStorePage({this.stateUser});
  @override
  _MyStorePageState createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage>
    with TickerProviderStateMixin {
  //保持页面状态
  bool get wantKeepAlive => true;

  bool isLoading = false;
  String jwt = '',
      nickname = '',
      balance = '',
      headimgurl = '',
      todayYg = '',
      daijiesuan = '',
      jinridingdancount = '',
      id = '';
  int fans = 0;
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();

    StoreServer().getHome(map, (success) {
      if (mounted) {
        setState(() {
          headimgurl = success['user']['headimgurl'];
          nickname = success['user']['nickname'];
          balance = success['user']['balance'];
          fans = success['user']['fans'];
          id = success['user']['id'].toString();
          todayYg = success['today'].toString();
          daijiesuan = success['daijiesuan'].toString();
          jinridingdancount = success['jinridingdancount'].toString();
        });
      }
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget bgArea = new Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(520),
      child: Stack(children: <Widget>[
        //bg图片
        Positioned(
          top: 0,
          child: Image.asset(
            "assets/shop/bg_wode.png",
            height: ScreenUtil().setWidth(395),
            width: ScreenUtil().setWidth(750),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 40,
          right: 0,
          child: Container(
            height: ScreenUtil().setWidth(70),
            width: ScreenUtil().setWidth(200),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color(0xffA7CD60),
                Color(0xff10C798),
              ]),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '到用户',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  NavigatorUtils.goApplicationPage(context);
                  widget.stateUser(0);
                }),
          ),
        ),
        Positioned(
            top: 60,
            left: 20,
            child: new Row(
              children: <Widget>[
                new InkWell(
                  child: headimgurl != ""
                      ? Container(
                          child: ClipOval(
                          child: Image.network(
                            headimgurl,
                            height: ScreenUtil().setWidth(127),
                            width: ScreenUtil().setWidth(127),
                            fit: BoxFit.cover,
                          ),
                        ))
                      : Container(),
                  onTap: () {
                    NavigatorUtils.goShopInforPage(context);
                  },
                ),
                new Container(
                  padding: EdgeInsets.only(left: 20),
                  child: new Column(children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(560),
                      child: Text(
                        nickname,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(560),
                      child: Text(
                        'ID: ' + id,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                )
              ],
            )),
        Positioned(
          bottom: 0,
          left: 15,
          child: Container(
            height: ScreenUtil().setWidth(260),
            width: ScreenUtil().setWidth(700),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: new Column(children: <Widget>[
              Container(
                height: ScreenUtil().setWidth(120),
                width: ScreenUtil().setWidth(700),
                     decoration: BoxDecoration(
                              border:Border(
                                bottom: BorderSide(
                                  width: ScreenUtil().setWidth(1),
                                  color:  PublicColor.lineColor,
                                )
                              ),
                            ),
                child: new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30),
                            10, ScreenUtil().setWidth(20), 0),
                       
                        child: Text(
                          '余额(元)',
                          style: TextStyle(
                            color: Color(0xff888888),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30),
                            5, ScreenUtil().setWidth(30), 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$balance',
                          style: TextStyle(
                              color: Color(0xffA2BD52),
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    NavigatorUtils.goCurrentBalancePage(context);
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: new Row(children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: new Column(children: <Widget>[
                          Container(
                              child: Text(
                            '今日预估',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          )),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                todayYg,
                                style: TextStyle(
                                    color: Color(0xff4f4f4f),
                                    fontSize: ScreenUtil().setSp(28),
                                    fontWeight: FontWeight.w600),
                              ))
                        ])),
                    Expanded(
                        flex: 1,
                        child: new Column(children: <Widget>[
                          Container(
                              child: Text(
                            '待结算金额',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          )),
                          Container(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(10)),
                              child: Text(
                                daijiesuan,
                                style: TextStyle(
                                    color: Color(0xff4f4f4f),
                                    fontSize: ScreenUtil().setSp(28),
                                    fontWeight: FontWeight.w600),
                              ))
                        ])),
                    Expanded(
                        flex: 1,
                        child: new Column(children: <Widget>[
                          Container(
                              child: Text(
                            '今日订单数',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          )),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                jinridingdancount,
                                style: TextStyle(
                                    color: Color(0xff4f4f4f),
                                    fontSize: ScreenUtil().setSp(28),
                                    fontWeight: FontWeight.w600),
                              ))
                        ]))
                  ]))
            ]),
          ),
        ),
      ]),
    );

    Widget btnArea = Container(
      alignment: Alignment.center,
      child: new Container(
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: new Column(
          children: <Widget>[
            InkWell(
                child: new Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setWidth(20),
                left: ScreenUtil().setWidth(20),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: PublicColor.lineColor),
                ),
              ),
              child: new Row(children: <Widget>[
                Expanded(
                  flex: 8,
                  child: new Text(
                    '我的订单',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
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
                      print('查看全部');
                      String type = "0";
                      NavigatorUtils.goMyStoreOrderPage(context, type);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: new Icon(
                    Icons.navigate_next,
                    color: Color(0xff999999),
                  ),
                )
              ]),
            )),
            new Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // 订单按钮
                    OrderMenu(
                      icon: "assets/mine/dfk.png",
                      name: "待付款",
                      navigator: () {
                        NavigatorUtils.goMyStoreOrderPage(context, '1');
                      },
                    ),
                    OrderMenu(
                      icon: "assets/mine/dfh.png",
                      name: "待发货",
                      navigator: () {
                        NavigatorUtils.goMyStoreOrderPage(context, '2');
                      },
                    ),
                    OrderMenu(
                      icon: "assets/mine/dsh.png",
                      name: "待收货",
                      navigator: () {
                        NavigatorUtils.goMyStoreOrderPage(context, '3');
                      },
                    ),
                    OrderMenu(
                      icon: "assets/mine/sh.png",
                      name: "退款/售后",
                      navigator: () {
                        NavigatorUtils.goStoreCustomerServicePage(context);
                      },
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
    //我的工具
    Widget myGongJu = new Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
      alignment: Alignment.center,
      child: Container(
        width: ScreenUtil().setWidth(700),
        padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: new Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 8, left: 15),
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(80),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: Text(
              '我的工具',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: Colors.black,
              ),
            ),
          ),
          Container(
            child: Wrap(
              spacing: ScreenUtil().setWidth(30), // 主轴(水平)方向间距
              runSpacing: ScreenUtil().setWidth(4), // 纵轴（垂直）方向间距
              children: <Widget>[
                ToolMenu(
                  img: 'assets/gongyingshang/icon_spgl.png',
                  name: '商品管理',
                  tapFun: () {
                    NavigatorUtils.goShangpinguanliPage(context);
                  },
                ),
                ToolMenu(
                  img: 'assets/gongyingshang/icon_zjgl.png',
                  name: '资金管理',
                  tapFun: () {
                    NavigatorUtils.toMyZjPage(context);
                  },
                ),
                ToolMenu(
                  img: 'assets/gongyingshang/icon_fhc.png',
                  name: '发货仓',
                  tapFun: () {
                    NavigatorUtils.goShippingHoursePage(context);
                  },
                ),
                ToolMenu(
                  img: 'assets/gongyingshang/icon_yfmb.png',
                  name: '运费模板',
                  tapFun: () {
                    NavigatorUtils.goYunfeimobanPage(context);
                  },
                ),
                ToolMenu(
                  img: 'assets/gongyingshang/icon_yhq.png',
                  name: '优惠券',
                  tapFun: () {
                    NavigatorUtils.goStoreCouponPage(context);
                  },
                ),
                ToolMenu(
                  img: 'assets/gongyingshang/icon_mby.png',
                  name: '满包邮',
                  tapFun: () {
                    NavigatorUtils.goFreeShippingPage(context);
                  },
                ),
              ],
            ),
          )
        ]),
      ),
    );

    // 我的直播
    Widget myZhiBo = new Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
      alignment: Alignment.center,
      child: Container(
        width: ScreenUtil().setWidth(700),
        padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8, left: 15),
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(80),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: PublicColor.lineColor),
                ),
              ),
              child: Text(
                '我的直播',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Wrap(
                spacing: ScreenUtil().setWidth(30), // 主轴(水平)方向间距
                runSpacing: ScreenUtil().setWidth(4), // 纵轴（垂直）方向间距
                children: <Widget>[
                  ToolMenu(
                    img: 'assets/gongyingshang/icon_cjzb.png',
                    name: '创建直播',
                    tapFun: () {
                      NavigatorUtils.toCreateZhiboPage(context);
                    },
                  ),
                  ToolMenu(
                    img: 'assets/gongyingshang/icon_wdyg.png',
                    name: '我的预告',
                    tapFun: () {
                      NavigatorUtils.toMyYgPage(context);
                    },
                  ),
                  ToolMenu(
                    img: 'assets/gongyingshang/icon_wdzb.png',
                    name: '我的直播',
                    tapFun: () {
                      NavigatorUtils.toMyZbPage(context);
                    },
                  ),
                  Container(
                    width: ScreenUtil().setWidth(140),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: PublicColor.bodyColor,
      body: Container(
          child:
              new ListView(padding: EdgeInsets.only(top: 0), children: <Widget>[
        bgArea,
        SizedBox(height: ScreenUtil().setWidth(30)),
        btnArea,
        myGongJu,
        myZhiBo,
        new SizedBox(height: ScreenUtil().setWidth(30))
      ])),
    );
  }
}
