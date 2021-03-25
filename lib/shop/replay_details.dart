import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../service/live_service.dart';
import '../config/Navigator_util.dart';

class ReplayDetails extends StatefulWidget {
  final oid;
  ReplayDetails({this.oid});
  @override
  ReplayDetailsState createState() => ReplayDetailsState();
}

class ReplayDetailsState extends State<ReplayDetails> {
  bool isLoading = false;
  bool isLive = false;
  int tabIndex = 0;
  Map obj = {
    "id": 0,
    "is_huifang": "1",
    "timestr": "",
    "max_online": 0,
    "interact": 0,
    "share": 0,
    "click": 0,
    "order_num": 0,
    "c_order_num": 0,
    "total": 0,
    "c_total": 0,
  };
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    LiveServer().replayDetails(map, (success) async {
      setState(() {
        obj = success['room'];
        print('-----------');
        print(obj['timestr']);
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget topArea = new Container(
      height: ScreenUtil().setWidth(505),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/shop/bg.png"), fit: BoxFit.fitWidth),
      ),
      child: new Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(
                    Icons.chevron_left,
                    color: PublicColor.whiteColor,
                    size: ScreenUtil.instance.setWidth(55.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                Text(
                  "直播详情",
                  style: TextStyle(
                    color: PublicColor.whiteColor,
                    fontSize: ScreenUtil().setSp(35),
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(95.0),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(80),
          ),
          new Container(
            width: ScreenUtil().setWidth(750),
            child: Column(
              children: <Widget>[
                Text(
                  obj["is_huifang"].toString() == "2" ? "回放已生成" : "回放生成中",
                  style: TextStyle(
                    color: PublicColor.whiteColor,
                    fontSize: ScreenUtil().setSp(35),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(10),
                ),
                Text(
                  "直播时长:${obj['timestr']}",
                  style: TextStyle(
                    color: PublicColor.whiteColor,
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(20),
                ),
                InkWell(
                  onTap: () {
                    if (obj["is_huifang"].toString() == "2") {
                      NavigatorUtils.goLiveDetails(
                          context, obj['id'].toString());
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: ScreenUtil().setWidth(310),
                    height: ScreenUtil().setWidth(68),
                    decoration: BoxDecoration(
                      color: Color(0xffF4A76A),
                      borderRadius: BorderRadius.circular(68),
                    ),
                    child: Text(
                      obj["is_huifang"].toString() == "2" ? "查看回放" : "回放生成中",
                      style: TextStyle(
                        color: PublicColor.whiteColor,
                        fontSize: ScreenUtil().setSp(30),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          body: Stack(
            children: <Widget>[
              topArea,
              Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: ScreenUtil().setWidth(28),
                      top: ScreenUtil().setWidth(440),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(694),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(10),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: ScreenUtil().setWidth(94),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xfff5f5f5), width: 1),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().setWidth(4),
                                          height: ScreenUtil().setWidth(26),
                                          margin: EdgeInsets.only(left:ScreenUtil().setWidth(31)),
                                     color: Color(0xffFD8C34),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(10),
                                        ),
                                        Text(
                                          "直播数据",
                                          style: TextStyle(
                                           color: Color(0xffFD8C34),
                                            fontSize: ScreenUtil().setSp(26),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(45),
                                      bottom: ScreenUtil().setWidth(45),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/shop/xq2.png",
                                                width:
                                                    ScreenUtil().setWidth(50),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                "最高在线",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                (obj['max_online'] > 10000
                                                    ? ((obj['max_online'] ~/
                                                                    1000) /
                                                                10)
                                                            .toString() +
                                                        'w'
                                                    : obj['max_online']
                                                        .toString()),
                                                style: TextStyle(
                                                  color: Color(0xfffb5346),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/shop/xq1.png",
                                                width:
                                                    ScreenUtil().setWidth(50),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                "累计互动",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                (obj['interact'] > 10000
                                                    ? ((obj['interact'] ~/
                                                                    1000) /
                                                                10)
                                                            .toString() +
                                                        'w'
                                                    : obj['interact']
                                                        .toString()),
                                                style: TextStyle(
                                                  color: Color(0xfffb5346),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/shop/xq3.png",
                                                width:
                                                    ScreenUtil().setWidth(50),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                "分享次数",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                (obj['share'] > 10000
                                                    ? ((obj['share'] ~/ 1000) /
                                                                10)
                                                            .toString() +
                                                        'w'
                                                    : obj['share'].toString()),
                                                style: TextStyle(
                                                  color: Color(0xfffb5346),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/shop/xq4.png",
                                                width:
                                                    ScreenUtil().setWidth(50),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                "商品点击",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                (obj['click'] > 10000
                                                    ? ((obj['click'] ~/ 1000) /
                                                                10)
                                                            .toString() +
                                                        'w'
                                                    : obj['click'].toString()),
                                                style: TextStyle(
                                                  color: Color(0xfffb5346),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(20),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(694),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(10),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: ScreenUtil().setWidth(94),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xfff5f5f5), width: 1),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().setWidth(4),
                                          height: ScreenUtil().setWidth(26),
                                          margin: EdgeInsets.only(left:ScreenUtil().setWidth(31)),

                                          color: Color(0xffFD8C34),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(10),
                                        ),
                                        Text(
                                          "销售数据",
                                          style: TextStyle(
                                          color: Color(0xffFD8C34),
                                            
                                            fontSize: ScreenUtil().setSp(26),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(45),
                                      bottom: ScreenUtil().setWidth(45),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                (obj['order_num'] > 10000
                                                    ? ((obj['order_num'] ~/
                                                                    1000) /
                                                                10)
                                                            .toString() +
                                                        'w'
                                                    : obj['order_num']
                                                        .toString()),
                                                style: TextStyle(
                                                  color: Color(0xfffb5346),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                "产生订单",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                (obj['c_order_num'] > 10000
                                                    ? ((obj['c_order_num'] ~/
                                                                    1000) /
                                                                10)
                                                            .toString() +
                                                        'w'
                                                    : obj['c_order_num']
                                                        .toString()),
                                                style: TextStyle(
                                                  color: Color(0xfffb5346),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                "佣金订单",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                obj['total'].toString(),
                                                style: TextStyle(
                                                  color: Color(0xfffb5346),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                "销售金额",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                obj['c_total'].toString(),
                                                style: TextStyle(
                                                  color: Color(0xfffb5346),
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Text(
                                                "预估佣金",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                ),
                                              )
                                            ],
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
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
