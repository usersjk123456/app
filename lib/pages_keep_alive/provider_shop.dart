import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/store_service.dart';

class ShopPage extends StatefulWidget {
  @override
  ShopPageState createState() => ShopPageState();
}

class ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  //保持页面状态
  bool get wantKeepAlive => true;

  bool isLoading = false;
  String jwt = '',
      nickname = '',
      balance = '',
      headimgurl = '',
      todayYg = '',
      cumulativeYg = '',
      cumulativeYj = '',
      id = '';
  int fans = 0;
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    StoreServer().getHome(map, (success) async {
      setState(() {
        headimgurl = success['user']['headimgurl'];
        nickname = success['user']['nickname'];
        balance = success['user']['balance'];
        fans = success['user']['fans'];
        id = success['user']['id'].toString();
        todayYg = success['today'].toString();
        cumulativeYg = success['lei'].toString();
        cumulativeYj = success['yong'].toString();
      });
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
            "assets/shop/bg.png",
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
                Color(0xfffe7342),
                Color(0xfff65232),
                Color(0xffeb281d)
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
                }),
          ),
        ),
        Positioned(
            top: 60,
            left: 20,
            child: new Row(
              children: <Widget>[
                new InkWell(
                  child: Container(
                      child: ClipOval(
                    child: Image.network(
                      headimgurl,
                      height: ScreenUtil().setWidth(127),
                      width: ScreenUtil().setWidth(127),
                      fit: BoxFit.cover,
                    ),
                  )),
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
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                ),
                child: new Column(
                  children: <Widget>[
                    new InkWell(
                      child: new Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(30),
                              10,
                              ScreenUtil().setWidth(20),
                              0),
                          child: Text(
                            '余额(元)',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          )),
                      onTap: () {
                        NavigatorUtils.goCurrentBalancePage(context);
                      },
                    ),
                    new InkWell(
                        child: new Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(30),
                                5,
                                ScreenUtil().setWidth(0),
                                0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$balance',
                              style: TextStyle(
                                  color: Color(0xffe9221b),
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            )))
                  ],
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
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                cumulativeYg,
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
                                cumulativeYj,
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
        Positioned(
          top: 145,
          right: 5,
          child: InkWell(
            child: Container(
              child: Image.asset(
                "assets/shop/zbqy.png",
                height: ScreenUtil().setWidth(60),
                width: ScreenUtil().setWidth(188),
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              NavigatorUtils.toAnchorQyPage(context);
            },
          ),
        ),
      ]),
    );

    Widget btnArea = new Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: new Column(
        children: <Widget>[
          InkWell(
              child: new Container(
            // alignment: Alignment.centerRight,
            height: ScreenUtil().setWidth(80),
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd)))),
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
                    String type = "0";
                    NavigatorUtils.goMyOrderPage(context, type);
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
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(12),
                          left: ScreenUtil.instance.setWidth(8.0)),
                      height: ScreenUtil.instance.setWidth(155.0),
                      width: ScreenUtil.instance.setWidth(130.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(30.0),
                          ),
                          Expanded(
                            flex: 0,
                            child: Image.asset(
                              "assets/mine/dfk.png",
                              height: ScreenUtil().setWidth(50),
                              width: ScreenUtil().setWidth(50),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Expanded(
                            child: Text(
                              '待付款',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
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
                      height: ScreenUtil.instance.setWidth(155.0),
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
                              "assets/mine/dfh.png",
                              height: ScreenUtil().setWidth(50),
                              width: ScreenUtil().setWidth(50),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Expanded(
                            child: Text(
                              '待发货',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
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
                      height: ScreenUtil.instance.setWidth(155.0),
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
                              "assets/mine/dsh.png",
                              height: ScreenUtil().setWidth(50),
                              width: ScreenUtil().setWidth(50),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Expanded(
                            child: Text(
                              '待收货',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
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
                      height: ScreenUtil.instance.setWidth(155.0),
                      width: ScreenUtil.instance.setWidth(140.0),
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
                              width: ScreenUtil().setWidth(50),
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
                                fontSize: ScreenUtil().setSp(28),
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
    //我的工具
    Widget myGongJu = new Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Container(
        width: ScreenUtil().setWidth(700),
        padding: EdgeInsets.only(bottom: 20),
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
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
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
            spacing: 30.0, // 主轴(水平)方向间距
            runSpacing: 2.0, // 纵轴（垂直）方向间距
            alignment: WrapAlignment.start, //沿主轴方向居中
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(120),
                child: InkWell(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Image.asset(
                          "assets/shop/cjzb.png",
                          height: ScreenUtil().setWidth(92),
                          width: ScreenUtil().setWidth(92),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '商品管理',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    NavigatorUtils.toCreateZhiboPage(context);
                  },
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(120),
                child: InkWell(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Image.asset(
                          "assets/shop/wdyg.png",
                          height: ScreenUtil().setWidth(92),
                          width: ScreenUtil().setWidth(92),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '资金管理',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    NavigatorUtils.toMyYgPage(context);
                  },
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(120),
                child: InkWell(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Image.asset(
                          "assets/shop/wdzb.png",
                          height: ScreenUtil().setWidth(92),
                          width: ScreenUtil().setWidth(92),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '发货仓',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    print('fahuo');
                    // NavigatorUtils.toFahuoPage(context);
                  },
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(120),
                child: InkWell(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Image.asset(
                          "assets/shop/dsp.png",
                          height: ScreenUtil().setWidth(92),
                          width: ScreenUtil().setWidth(92),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '运费模板',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    NavigatorUtils.toShortVideoPage(context);
                  },
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(120),
                child: InkWell(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Image.asset(
                          "assets/shop/cjzb.png",
                          height: ScreenUtil().setWidth(92),
                          width: ScreenUtil().setWidth(92),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '优惠券  ',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    NavigatorUtils.toCreateZhiboPage(context);
                  },
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(120),
                child: InkWell(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Image.asset(
                          "assets/shop/wdyg.png",
                          height: ScreenUtil().setWidth(92),
                          width: ScreenUtil().setWidth(92),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '信息卡  ',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    NavigatorUtils.toMyYgPage(context);
                  },
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(120),
                child: InkWell(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Image.asset(
                          "assets/shop/wdzb.png",
                          height: ScreenUtil().setWidth(92),
                          width: ScreenUtil().setWidth(92),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '满包邮',
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    NavigatorUtils.toMyZbPage(context);
                  },
                ),
              ),
            ],
          ))
        ]),
      ),
    );

    //我的直播
    Widget myZhiBo = new Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Container(
        width: ScreenUtil().setWidth(700),
        padding: EdgeInsets.only(bottom: 20),
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
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
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
              // width: ScreenUtil().setWidth(500),
              child: Container(
                  width: ScreenUtil().setWidth(520),
                  child: Wrap(
                    spacing: 30.0, // 主轴(水平)方向间距
                    runSpacing: 2.0, // 纵轴（垂直）方向间距
                    alignment: WrapAlignment.start, //沿主轴方向居中
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(120),
                        child: InkWell(
                          child: new Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Image.asset(
                                  "assets/shop/cjzb.png",
                                  height: ScreenUtil().setWidth(92),
                                  width: ScreenUtil().setWidth(92),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '创建直播',
                                    style: TextStyle(
                                      color: Color(0xff888888),
                                      fontSize: ScreenUtil().setSp(28),
                                    ),
                                  ))
                            ],
                          ),
                          onTap: () {
                            NavigatorUtils.toCreateZhiboPage(context);
                          },
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(120),
                        child: InkWell(
                          child: new Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Image.asset(
                                  "assets/shop/wdyg.png",
                                  height: ScreenUtil().setWidth(92),
                                  width: ScreenUtil().setWidth(92),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '我的预告',
                                    style: TextStyle(
                                      color: Color(0xff888888),
                                      fontSize: ScreenUtil().setSp(28),
                                    ),
                                  ))
                            ],
                          ),
                          onTap: () {
                            NavigatorUtils.toMyYgPage(context);
                          },
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(120),
                        child: InkWell(
                          child: new Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Image.asset(
                                  "assets/shop/wdzb.png",
                                  height: ScreenUtil().setWidth(92),
                                  width: ScreenUtil().setWidth(92),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '我的直播',
                                    style: TextStyle(
                                      color: Color(0xff888888),
                                      fontSize: ScreenUtil().setSp(28),
                                    ),
                                  ))
                            ],
                          ),
                          onTap: () {
                            NavigatorUtils.toMyZbPage(context);
                          },
                        ),
                      ),
                    ],
                  )))
        ]),
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Container(
          child:
              new ListView(padding: EdgeInsets.only(top: 0), children: <Widget>[
        bgArea,
        btnArea,
        myGongJu,
        myZhiBo,
        new SizedBox(height: ScreenUtil().setWidth(30))
      ])),
    );
  }
}
