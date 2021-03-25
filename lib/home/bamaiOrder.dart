import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../pay_order/order_goods.dart';
import '../widgets/dialog.dart';
import '../config/Navigator_util.dart';
import '../utils/toast_util.dart';
import '../service/goods_service.dart';
import '../config/fluro_convert_util.dart';
import '../pay_order/bm_wx_pay.dart';
import '../api/log_util.dart';
import '../common/color.dart';
import '../service/user_service.dart';
import '../api/api.dart';
import '../utils/serivice.dart';
import 'bmsuccess.dart';

class BamaiOrder extends StatefulWidget {
  final String objs;
  BamaiOrder({this.objs});
  @override
  BamaiOrderState createState() => BamaiOrderState();
}

class BamaiOrderState extends State<BamaiOrder>
    with SingleTickerProviderStateMixin {
  // TextEditingController _bzController = TextEditingController();
  bool isLoading = false;
  Timer _timer;
  bool havedizhi = true;
  bool flag = false;
  String jwt = '';
  String orderId = '';
  double total = 0.00;
  double couponTotal = 0.00; // 优惠券金额
  double fishTotal = 0.00; // 金币金额
  double totalMoney = 0.00; // 可用余额
  double useMoney = 0.00; // 花费钱数
  String isbalance = '0';
  List cartId = [];
  Map address = {
    "id": "",
    "name": "",
    "phone": "",
    "province": "",
    "city": "",
    "region": "",
    "address": "",
  };
  Map user = {"coin": ""};
  Map couponResult = {
    "coupon_id": "",
    "detail": {"price": "0"},
  };
  Map coinResult = {
    "coin_id": "",
    "price": "0",
  };
  List listview = [];
  List yhqId = [];
  Map lists = {"list": []};
  List getList = [];
  @override
  void initState() {
    lists = FluroConvertUtils.string2map(widget.objs);
    // Future.delayed(Duration(seconds: 1), () {
    //   showDialog<Null>(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return BMDialog(uid: '123', sure: sure, goods: lists);
    //     },
    //   );
    // });
    print(lists);
    print('移除多余元素');
    // 移除多余元素
    for (var i = 0; i < lists['list'].length; i++) {
      lists['list'][i].remove('title');
      for (var j = 0; j < lists['list'][i]['list'].length; j++) {
        getList.add(lists['list'][i]['list'][j]);
      }
    }
    if (getList.length != 0) {
      for (var i = 0; i < getList.length; i++) {
        getList[i].remove('child_id');
        getList[i].remove('keywords');
        getList[i].remove('type');
        getList[i].remove('brand');
        getList[i].remove('is_love');
        getList[i].remove('sort');
        getList[i].remove('category_id');
        getList[i].remove('store_id');
        getList[i].remove('stock');
        getList[i].remove('is_up');
        getList[i].remove('is_flash');
        getList[i].remove('flash_id');
        getList[i].remove('is_hot');
        getList[i].remove('is_recommend');
        getList[i].remove('is_limit');
        getList[i].remove('limit');
        getList[i].remove('buy_count');
        getList[i].remove('is_del');
        getList[i].remove('name');
        getList[i].remove('thumb');
        getList[i].remove('is_attr');
        getList[i].remove('now_price');
        getList[i].remove('old_price');
        getList[i].remove('love_price');
        getList[i].remove('commission');
        getList[i].remove('desc');
        getList[i].remove('content');
        getList[i].remove('post_id');
        getList[i].remove('house_id');
        getList[i].remove('store_name');
        getList[i].remove('attr_name');
        getList[i].remove('attr_img');
        getList[i].remove('check');
        getList[i].remove('specs_name');
        getList[i].remove('img');
        getList[i].remove('create_at');
        getList[i].remove('goods_name');
        getList[i].remove('after_status');
        getList[i].remove('specs');
      }
    }
    getOrders();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  void sure() {
    // String type = "2";
    // NavigatorUtils.goMyOrderPage(context, type);
    NavigatorUtils.goHomePage(context);
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

  void popContent() {
    String type = "1";
    NavigatorUtils.goMyOrderPage(context, type);
  }

  void getPayStatus(orderId) async {
    print(lists);
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

      await Future.delayed(Duration(seconds: 1), () {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return BMDialog(uid: '123', sure: sure, goods: lists);
          },
        );
      });
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  void getOrders() async {
    // setState(() {
    //   isLoading = true;
    // });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("aid", () => address['id']);
    map.putIfAbsent("list", () => getList);
    Service().spost(Api.BAMAIORDER_URL, map, (success) async {
      LogUtil.d('success--->>>$success');
      setState(() {
        isLoading = false;
        havedizhi = success['address'].length == 0 ? false : true;
        if (havedizhi) {
          address = success['address'];
        }
        cartId = success['cart'];
        listview = success['list'];
        total = 0.0;
        user = success['user'];
        for (var i = 0; i < listview.length; i++) {
          total += double.parse(listview[i]['amount'].toString());
          listview[i]['coupon_price'] = "0";
          listview[i]['coin_price'] = "0";
          listview[i]['smalltotal'] = listview[i]['amount'];
        }
      });
      //测试
      // await Future.delayed(Duration(seconds: 1), () {
      //   showDialog<Null>(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (BuildContext context) {
      //       return BMDialog(
      //         uid: '123',
      //         sure: sure,
      //       );
      //     },
      //   );
      // });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void payOrder() async {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("aid", () => address['id']);
    map.putIfAbsent("pay_state", () => 3);
    map.putIfAbsent("cart", () => cartId);
    map.putIfAbsent("balance", () => useMoney.toStringAsFixed(2));
    map.putIfAbsent("amount", () => total);
    map.putIfAbsent("is_balance", () => isbalance);
    map.putIfAbsent("list", () => listview);
    GoodsServer().payOrder(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('支付成功');
      await Future.delayed(Duration(seconds: 1), () {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return BMDialog(uid: '123', sure: sure, goods: lists);
          },
        );
      });
      // NavigatorUtils.goMyOrderPage(context, "0", 1);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
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
            centerTitle: true,
            title: Text(
              '提交订单',
              style: TextStyle(
                color: PublicColor.headerTextColor,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
            leading: new IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: PublicColor.headerTextColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: contentWidget(),
        ),
        isLoading
            ? LoadingDialog(
                types: "1",
              )
            : Container(),
      ],
    );
  }

  List<Widget> listBoxs(listView, listindex) =>
      List.generate(listView.length, (index) {
        return OrderGoodsBuilder.build(listView, index);
      });

  Widget gouwuitem(BuildContext context, item, index) {
    print('item-->>$item');
    return Container(
      child: new Column(children: [
        Offstage(
          offstage: index != 0,
          child: InkWell(
            child: Container(
              width: ScreenUtil.getInstance().setWidth(750.0),
              // padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              alignment: Alignment.center,
              child: !havedizhi
                  ? Container(
                      width: ScreenUtil.getInstance().setWidth(750.0),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
                      alignment: Alignment.center,
                      child: Text(
                        '+新增收货地址',
                        style: TextStyle(
                          color: PublicColor.themeColor,
                          fontSize: ScreenUtil.instance.setWidth(28.0),
                        ),
                      ),
                    )
                  : Container(
                      width: ScreenUtil.getInstance().setWidth(750.0),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  '收货人:${address["name"]}' +
                                      '    ' +
                                      '${address["phone"]}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(28.0))),
                              Text(
                                  "${address["province"] + address["city"] + address["region"] + address["address"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(28.0)))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.chevron_right)),
                        )
                      ]),
                    ),
            ),
            onTap: () {
              // 选择
              NavigatorUtils.goHarvestAddressPage(context, "1").then((result) {
                print('addressresult=--->>>$result');
                if (result != null) {
                  setState(() {
                    havedizhi = true;
                    flag = false;
                    address = result;
                    getOrders();
                  });
                }
              });
            },
          ),
        ),
        Offstage(
          offstage: index != 0,
          child: Image.asset(
            'assets/index/xiantiao.png',
            width: ScreenUtil.getInstance().setWidth(750.0),
          ),
        ),
        new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: new Border.all(color: Color(0xfffececec), width: 0.5),
          ),
          child: Column(children: [
            Container(
              height: ScreenUtil.getInstance().setWidth(80.0),
              child: Row(children: [
                new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
                Image.asset(
                  'assets/index/dp2.png',
                  width: ScreenUtil.instance.setWidth(32.0),
                ),
                new SizedBox(width: ScreenUtil.instance.setWidth(5.0)),
                Text(
                  item['title'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(26.0)),
                )
              ]),
            ),
            new Column(children: listBoxs(item['list'], index)),
            // Container(
            //   height: ScreenUtil.getInstance().setWidth(120.0),
            //   width: ScreenUtil.getInstance().setWidth(750.0),
            //   padding: EdgeInsets.only(
            //       left: ScreenUtil().setWidth(25),
            //       right: ScreenUtil().setWidth(25)),
            //   decoration: ShapeDecoration(
            //     color: Colors.white,
            //     shape: Border(
            //       bottom: BorderSide(color: Color(0xfffececec), width: 1),
            //     ),
            //   ),
            //   child: Row(children: [
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerLeft,
            //           child: Text('运费',
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: ScreenUtil.instance.setWidth(28.0))),
            //         )),
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerRight,
            //           child: Text('${item["freight"]}',
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: ScreenUtil.instance.setWidth(28.0))),
            //         )),
            //   ]),
            // ),
            // Container(
            //   height: ScreenUtil.getInstance().setWidth(120.0),
            //   width: ScreenUtil.getInstance().setWidth(750.0),
            //   padding: EdgeInsets.only(
            //       left: ScreenUtil().setWidth(25),
            //       right: ScreenUtil().setWidth(25)),
            //   decoration: ShapeDecoration(
            //     color: Colors.white,
            //     shape: Border(
            //       bottom: BorderSide(color: Color(0xfffececec), width: 1),
            //     ),
            //   ),
            //   child: Row(children: [
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             '备注',
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontSize: ScreenUtil.instance.setWidth(28.0),
            //             ),
            //           ),
            //         )),
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerRight,
            //           child: new TextField(
            //             keyboardType: TextInputType.text,
            //             textAlign: TextAlign.right,
            //             style: TextStyle(
            //               fontSize: ScreenUtil.instance.setWidth(28.0),
            //             ),
            //             decoration: new InputDecoration(
            //               hintText: '选填',
            //               border: InputBorder.none,
            //             ),
            //             onChanged: (value) {
            //               setState(() {
            //                 item['comment'] = value;
            //               });
            //             },
            //           ),
            //         )),
            //   ]),
            // ),
            // Container(
            //   height: ScreenUtil.getInstance().setWidth(120.0),
            //   width: ScreenUtil.getInstance().setWidth(750.0),
            //   padding: EdgeInsets.only(
            //       left: ScreenUtil().setWidth(25),
            //       right: ScreenUtil().setWidth(25)),
            //   decoration: ShapeDecoration(
            //     color: Colors.white,
            //     shape: Border(
            //       bottom: BorderSide(color: Color(0xfffececec), width: 1),
            //     ),
            //   ),
            //   child: Row(children: [
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerLeft,
            //           child: Text('优惠券',
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: ScreenUtil.instance.setWidth(28.0))),
            //         )),
            //     Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         child: Container(
            //           alignment: Alignment.centerRight,
            //           child: item['coupon_price'] == '0'
            //               ? Text(
            //                   '可使用优惠券${item['coupon_num']}张',
            //                   style: TextStyle(
            //                     color: Colors.black,
            //                     fontSize: ScreenUtil.instance.setWidth(28.0),
            //                   ),
            //                 )
            //               : Text(
            //                   '-￥${item['coupon_price']}',
            //                   style: TextStyle(
            //                     color: Colors.red,
            //                     fontSize: ScreenUtil.instance.setWidth(28.0),
            //                   ),
            //                 ),
            //         ),
            //         onTap: () {
            //           if (item['coupon_num'].toString() != "0") {
            //             String coinList = item['coupon_list'];
            //             NavigatorUtils.goCouponPage(context, coinList)
            //                 .then((result) {
            //               // result
            //               if (result != null) {
            //                 setState(() {
            //                   flag = false;
            //                   couponResult = result;
            //                   item['coupon_price'] =
            //                       couponResult['detail']['price'].toString();
            //                   item['coupon_id'] = couponResult['id'].toString();
            //                   item['smalltotal'] =
            //                       double.parse(item['amount'].toString()) -
            //                           double.parse(item['coupon_price']) -
            //                           double.parse(item['coin_price']);
            //                   total = 0.0; // 计算总额
            //                   for (var i = 0; i < listview.length; i++) {
            //                     total += listview[i]['smalltotal'];
            //                   }
            //                 });
            //               }
            //             });
            //           }
            //         },
            //       ),
            //     ),
            //   ]),
            // ),
            // Container(
            //   height: ScreenUtil.getInstance().setWidth(120.0),
            //   width: ScreenUtil.getInstance().setWidth(750.0),
            //   padding: EdgeInsets.only(
            //       left: ScreenUtil().setWidth(25),
            //       right: ScreenUtil().setWidth(25)),
            //   decoration: ShapeDecoration(
            //     color: Colors.white,
            //     shape: Border(
            //       bottom: BorderSide(color: Color(0xfffececec), width: 1),
            //     ),
            //   ),
            //   child: Row(children: [
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerLeft,
            //           child: Text('葫芦',
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: ScreenUtil.instance.setWidth(28.0))),
            //         )),
            //     Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         child: Container(
            //           alignment: Alignment.centerRight,
            //           child: item['coin_price'] == '0'
            //               ? Text(
            //                   '可使用葫芦券${item['coin_num']}张',
            //                   style: TextStyle(
            //                     color: Colors.black,
            //                     fontSize: ScreenUtil.instance.setWidth(28.0),
            //                   ),
            //                 )
            //               : Text(
            //                   '-￥${item['coin_price']}',
            //                   style: TextStyle(
            //                     color: Colors.red,
            //                     fontSize: ScreenUtil.instance.setWidth(28.0),
            //                   ),
            //                 ),
            //         ),
            //         onTap: () {
            //           if (item['coin_num'].toString() != "0") {
            //             String couponList = item['coin_list'];
            //             NavigatorUtils.goFishCurrencyPage(context, couponList)
            //                 .then((result) {
            //               if (result != null) {
            //                 setState(() {
            //                   coinResult = result;
            //                   flag = false;
            //                   item['coin_price'] =
            //                       coinResult['detail']['price'].toString();
            //                   item['coin_id'] = coinResult['id'].toString();
            //                   item['smalltotal'] =
            //                       double.parse(item['amount'].toString()) -
            //                           double.parse(item['coupon_price']) -
            //                           double.parse(item['coin_price']);
            //                   total = 0.0; // 计算总额
            //                   for (var i = 0; i < listview.length; i++) {
            //                     total += listview[i]['smalltotal'];
            //                   }
            //                 });
            //               }
            //             });
            //           }
            //         },
            //       ),
            //     ),
            //   ]),
            // ),
            // Container(
            //   height: ScreenUtil.getInstance().setWidth(120.0),
            //   width: ScreenUtil.getInstance().setWidth(750.0),
            //   padding: EdgeInsets.only(
            //       left: ScreenUtil().setWidth(25),
            //       right: ScreenUtil().setWidth(25)),
            //   decoration: ShapeDecoration(
            //     color: Colors.white,
            //     shape: Border(
            //       bottom: BorderSide(color: Color(0xfffececec), width: 1),
            //     ),
            //   ),
            //   child: Row(children: [
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerLeft,
            //           child: Text('小计',
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: ScreenUtil.instance.setWidth(28.0))),
            //         )),
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerRight,
            //           child: Text('￥${item['smalltotal']}',
            //               style: TextStyle(
            //                   color: Colors.red,
            //                   fontSize: ScreenUtil.instance.setWidth(28.0))),
            //         )),
            //   ]),
            // ),
          ]),
        ),
        double.parse(user["balance"]) <= 0
            ? Container()
            : Offstage(
                offstage: index != listview.length - 1,
                child: Container(
                  height: ScreenUtil.getInstance().setWidth(150.0),
                  width: ScreenUtil.getInstance().setWidth(750.0),
                  decoration: ShapeDecoration(
                    shape: Border(
                      bottom: BorderSide(color: Color(0xfffececec), width: 1),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      new Container(
                          height: ScreenUtil.instance.setWidth(20.0),
                          width: ScreenUtil.instance.setWidth(750.0)),
                      Container(
                        height: ScreenUtil.getInstance().setWidth(120.0),
                        width: ScreenUtil.getInstance().setWidth(750.0),
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(25)),
                        color: Colors.white,
                        child: Row(children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text('可用余额',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(28.0))),
                              )),
                          Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('我的余额¥${user["balance"]}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ScreenUtil.instance
                                              .setWidth(28.0))),
                                  Switch(
                                    value: this.flag,
                                    activeColor: PublicColor.themeColor,
                                    activeTrackColor: PublicColor.themeColor,
                                    inactiveThumbColor: Color(0xfffd4d4d5),
                                    inactiveTrackColor: Color(0xffff5f5f5),
                                    onChanged: (value) {
                                      totalMoney =
                                          double.parse(user["balance"]);
                                      print(totalMoney);
                                      if (totalMoney - total > 0) {
                                        setState(() {
                                          this.flag = value;
                                          isbalance = value ? '1' : '0';
                                          if (this.flag) {
                                            // if (total - totalMoney <= 0) {
                                            useMoney = total;
                                            total = 0;
                                            print("余额充足");
                                            // } else {
                                            //   useMoney = totalMoney;
                                            //   total = total - totalMoney;
                                            //   print("余额不足");
                                            // }
                                          } else {
                                            totalMoney = 0.00;
                                            total = 0.00; // 计算总额
                                            useMoney = 0.00;
                                            for (var i = 0;
                                                i < listview.length;
                                                i++) {
                                              total += double.parse(listview[i]
                                                      ['smalltotal']
                                                  .toString());
                                            }
                                          }
                                        });
                                      } else {
                                        ToastUtil.showToast('余额不足请选择微信付款');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
      ]),
    );
  }

  Widget contentWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: ScreenUtil.getInstance().setWidth(750.0),
          padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(100)),
          child: ListView.builder(
              itemCount: listview.length,
              itemBuilder: (BuildContext context, int index) {
                return gouwuitem(context, listview[index], index);
              }),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(100.0),
          decoration: ShapeDecoration(
              shape: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
              color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
              Container(
                width: ScreenUtil.getInstance().setWidth(200.0),
                child: RichText(
                  text: TextSpan(
                      text: '总额',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: ScreenUtil.instance.setWidth(30.0)),
                      children: [
                        TextSpan(
                          text: '￥${total <= 0 ? 0 : total.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenUtil.instance.setWidth(30.0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  height: ScreenUtil.instance.setWidth(100.0),
                  child: MaterialButton(
                    height: ScreenUtil.instance.setWidth(100.0),
                    minWidth: ScreenUtil.instance.setWidth(245.0),
                    onPressed: () async {
                      print(lists);
                      // print('@@@@@@@@@@@!!!!!!!!!@@@@@@@@@@');
                      // await Future.delayed(Duration(seconds: 1), () {
                      //   showDialog<Null>(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     builder: (BuildContext context) {
                      //       return BMDialog(
                      //           uid: '123', sure: sure, goods: lists);
                      //     },
                      //   );
                      // });

                      // return;

                      if (address['id'] == '') {
                        ToastUtil.showToast('请选择收货地址');
                        return;
                      }
                      if (total == 0) {
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
                                total: total,
                                aid: address['id'].toString(),
                                cartId: cartId,
                                balance: useMoney.toStringAsFixed(2),
                                isbalance: isbalance,
                                listview: listview,
                                jwt: jwt,
                                startTimer: startTimer,
                                popContent: popContent,
                              );
                            });
                      }
                    },
                    color: PublicColor.themeColor,
                    child: Text(
                      '提交订单',
                      style: TextStyle(color: PublicColor.btnColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
