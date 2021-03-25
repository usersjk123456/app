import 'package:client/common/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../service/live_service.dart';
import '../config/Navigator_util.dart';
import '../home/goodsSpec.dart';

class LiveGoods extends StatefulWidget {
  final roomId;
  final jwt;
  final userId;
  final userinfo;

  LiveGoods({
    this.roomId,
    this.jwt,
    this.userId,
    this.userinfo,
  });
  @override
  LiveGoodsState createState() => LiveGoodsState();
}

class LiveGoodsState extends State<LiveGoods> {
  List goodsList = [];
  bool isLoading = false;
  String cartNums = "0";
  @override
  void initState() {
    getGoodsList();
    super.initState();
  }

  void getGoodsList() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    LiveServer().getZbShopList(map, (success) async {
      setState(() {
        isLoading = false;
        goodsList = success['goods'];
        cartNums = success['cartnum'].toString();
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void optGoods(index) {
    setState(() {
      isLoading = true;
    });
    List goods = [];
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    map.putIfAbsent("goods_ids", () => goods);
    LiveServer().goodsDo(map, (success) async {}, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget contentWidget() {
      List<Widget> arr = <Widget>[];
      if (goodsList.length != 0) {
        for (var i = 0; i < goodsList.length; i++) {
          arr.add(
            new InkWell(
              child: new Container(
                width: ScreenUtil().setWidth(750),
                height: ScreenUtil().setWidth(256),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Stack(children: <Widget>[
                      Positioned(
                        child: Container(
                          child: Image.network(
                            goodsList[i]['thumb'],
                            height: ScreenUtil().setWidth(202),
                            width: ScreenUtil().setWidth(202),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: ScreenUtil().setWidth(35),
                          width: ScreenUtil().setWidth(65),
                          decoration: BoxDecoration(
                            color: Color(0xff666666),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0)),
                          ),
                          child: Text(
                            Global.addNums(i + 1),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  Expanded(
                    flex: 1,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: Text(
                                goodsList[i]['name'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                            child: new Row(children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: RichText(
                                  text: TextSpan(
                                    text: '￥',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(26),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '${goodsList[i]['now_price']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(30))),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: InkWell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: ScreenUtil().setWidth(56),
                                      width: ScreenUtil().setWidth(142),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        '库存${goodsList[i]['stock']}',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(28),
                                        ),
                                      )),
                                  onTap: () {
                                    print('购买');
                                  },
                                ),
                              )
                            ]),
                          )
                        ]),
                  ),
                  Expanded(
                    flex: 0,
                    child: InkWell(
                        child: Container(
                            height: ScreenUtil().setWidth(55),
                            // width: ScreenUtil().setWidth(55),
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                                top: ScreenUtil().setWidth(5),
                                bottom: ScreenUtil().setWidth(5)),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffe42239),
                              // shape: BoxShape
                              //     .rectangle, //可以设置角度，BoxShape.circle直接圆形
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              '马上抢',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            )),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return GuigeWidget(
                                  onChanged: (index) {
                                    if (index == -1) {
                                      getGoodsList();
                                    } else {
                                      setState(() {
                                        // checkindex1 = index;
                                      });
                                    }
                                  },
                                  jwt: widget.jwt,
                                  goods: goodsList[i],
                                  isLive:
                                      widget.userinfo['is_live'].toString() ==
                                              "0"
                                          ? false
                                          : true,
                                  shipId: widget.userId.toString(),
                                  roomId: widget.roomId.toString(),
                                  guige: goodsList[i]['specs'],
                                );
                              });
                        }),
                  )
                ]),
              ),
              onTap: () {
                print('商品');
                print(goodsList[i]);
                NavigatorUtils.toXiangQing(
                    context, goodsList[i]['id'].toString());
              },
            ),
          );
        }
      }

      return Container(child: ListView(children: arr));
    }

    return new Container(
      child: new Column(children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setWidth(94),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Text(
                    '全部商品 ${goodsList.length}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w600),
                  ))),
              Expanded(
                flex: 0,
                child: InkWell(
                  child: Container(
                    width: ScreenUtil().setWidth(160),
                    height: ScreenUtil().setWidth(60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xffc2c2c2), width: 1),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 5,
                          left: 4,
                          child: InkWell(
                            child: Image.asset(
                              "assets/index/gwc.png",
                              height: ScreenUtil().setWidth(40),
                              width: ScreenUtil().setWidth(40),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          left: 20,
                          child: Container(
                            height: ScreenUtil().setWidth(30),
                            width: ScreenUtil().setWidth(30),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffe42239),
                              shape: BoxShape
                                  .rectangle, //可以设置角度，BoxShape.circle直接圆形
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(
                              cartNums,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(24),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          top: 5,
                          child: Container(
                            child: Text(
                              '购物车',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    NavigatorUtils.toShoppingCart(context);
                  },
                ),
              )
            ])),
        Expanded(
          flex: 1,
          child: contentWidget(),
        ),
      ]),
    );
  }
}
