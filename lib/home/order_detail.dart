import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/cached_image.dart';
import 'package:flutter/services.dart';
import '../config/fluro_convert_util.dart';
import '../utils/toast_util.dart';
import '../api/log_util.dart';
import '../widgets/dialog.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import '../config/Navigator_util.dart';
import '../common/Global.dart';
import '../service/user_service.dart';
import '../common/color.dart';

class OrderDetailPage extends StatefulWidget {
  final String objs;
  final String type;
  OrderDetailPage({this.objs, this.type});
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  String name = '',
      tel = '',
      storeName = '',
      storeId = '',
      province = '',
      region = '',
      city = '',
      address = '',
      time = '',
      allMoney = '',
      freight = '',
      coupon = '',
      status = '0',
      orderId = '0',
      afterStatus = '0',
      payTime = '',
      isExpress = '0',
      amount = '';
  List listview = [];
  int cancelTime = 0;
  int currentTime = 0;
  int chaTime = 0;
  Timer _timer;
  int _page = 0;
  int clickIndex = 0;
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();
    Map obj = FluroConvertUtils.string2map(widget.objs);
    LogUtil.d("obj---->>>$obj");
    storeName = obj['store_name'];
    storeId = obj['store_id'];
    name = obj['nickname'];
    tel = obj['phone'];
    province = obj['province'];
    city = obj['city'];
    region = obj['region'];
    address = obj['address'];
    time = obj['create_at'];
    listview = obj['goods'];
    allMoney = obj['total'];
    freight = obj['freight'];
    amount = obj['amount'];
    coupon = obj['coupon_price'];
    orderId = obj['store_order_id'];
    payTime = obj['pay_at'];
    print('123====${obj['pay_at']}');
    status = obj['pay_status'];
    isExpress = obj['isExpress'].toString();
    if (status == "0") {
      cancelTime = obj['time'] + (60 * 15);
      startTimer();
    }
    print(obj);
    print('~~~~~~~~~');
    getList(clickIndex);
  }

  void getList(clickIndex) async {
    _page++;
    // if (_page == 1) {
    //   listview = [];
    // }

    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => clickIndex + 1);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);

    UserServer().orderList(map, (success) async {
      print('=========vvvvvvvvvvvvvvvvvvvvvv------------------>$success');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
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

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      currentTime =
          ((new DateTime.now().millisecondsSinceEpoch) ~/ 1000).toInt();
      if (mounted) {
        setState(() {
          chaTime = cancelTime - currentTime;
        });
      }
      if (chaTime <= 0) {
        //倒计时秒数为0，取消定时器
        cancelTimer();
        cancelOrder();
      }
    });
  }

  void cancelOrder() {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_order_id", () => orderId);
    UserServer().cancelOrder(map, (success) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast('订单已取消');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isloading = false;
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
              '订单详情',
              style: TextStyle(
                color: PublicColor.headerTextColor,
                fontSize: ScreenUtil.instance.setWidth(30.0),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: PublicColor.headerTextColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
          ),
          body: contentWidget(),
        ),
        isloading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget contentWidget() {
    return ListView(
      children: <Widget>[
        Container(
          width: ScreenUtil.instance.setWidth(750.0),
          height: ScreenUtil.instance.setWidth(115.0),
          color: PublicColor.themeColor,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
                  Image.asset(
                    'assets/index/dsh.png',
                    width: ScreenUtil.getInstance().setWidth(50.0),
                  ),
                  new SizedBox(width: ScreenUtil.instance.setWidth(15.0)),
                  Text(
                    status == "0"
                        ? '待付款'
                        : status == "1"
                            ? '待发货'
                            : status == "2"
                                ? '待收货'
                                : status == "3" ? '已完成' : '已取消',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(28.0),
                    ),
                  )
                ],
              ),
              status == "0"
                  ? new SizedBox(height: ScreenUtil.instance.setWidth(15.0))
                  : Container(),
              status == "0"
                  ? Row(
                      children: [
                        new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
                        Text(
                          '还剩${Global.constructTime(chaTime).substring(2, 4)}分${Global.constructTime(chaTime).substring(4)}秒自动关闭',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.instance.setWidth(28.0),
                          ),
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          width: ScreenUtil.instance.setWidth(750.0),
          height: ScreenUtil.instance.setWidth(35.0),
          color: PublicColor.themeColor,
        ),
        new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
        Container(
          // height: ScreenUtil.instance.setWidth(240.0),
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(25),
              right: ScreenUtil().setWidth(25)),
          child: Container(
            // height: ScreenUtil.instance.setWidth(240.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenUtil.instance.setWidth(120.0),
                  decoration: ShapeDecoration(
                    shape: Border(
                      bottom: BorderSide(color: Color(0xfffececec), width: 1),
                    ),
                  ),
                  child: Row(children: [
                    new SizedBox(width: ScreenUtil.instance.setWidth(15.0)),
                    Image.asset(
                      'assets/index/dingwei.png',
                      width: ScreenUtil.getInstance().setWidth(30.0),
                    ),
                    new SizedBox(width: ScreenUtil.instance.setWidth(15.0)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name + '    ' + tel,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil.instance.setWidth(28.0))),
                        Container(
                            width: ScreenUtil().setWidth(620),
                            child: Text(province + city + region + address,
                                maxLines: 5,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(28.0)))),
                      ],
                    )
                  ]),
                ),
                (status == "2" && isExpress == '1') ||
                        (status == "3" && isExpress == '1')
                    ? InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(120.0),
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                          child: Row(children: [
                            Expanded(
                                flex: 1,
                                child: Image.asset(
                                  'assets/index/car.png',
                                  width:
                                      ScreenUtil.getInstance().setWidth(30.0),
                                )),
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            Expanded(
                              flex: 15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '查看物流',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(28.0),
                                    ),
                                  ),
                                  Text(
                                    time,
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(24.0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(Icons.chevron_right),
                            ),
                          ]),
                        ),
                        onTap: () {
                          print(orderId);
                          NavigatorUtils.goLogistics(context, orderId);
                        },
                      )
                    : Container()
              ],
            ),
          ),
        ),
        new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
        Container(
          height: ScreenUtil.instance.setWidth(215.0) * listview.length,
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(25),
              right: ScreenUtil().setWidth(25)),
          child: ListView.builder(
              physics: new NeverScrollableScrollPhysics(),
              itemCount: listview.length,
              itemBuilder: (BuildContext context, int index) {
                return dingdanitem(context, listview[index], index);
              }),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(330.0),
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(25),
              right: ScreenUtil().setWidth(25)),
          child: Container(
            height: ScreenUtil.instance.setWidth(330.0),
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(25),
                right: ScreenUtil().setWidth(25)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.elliptical(10, 10)),
            ),
            child: new Column(children: [
              new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text('商品合计',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(30.0)))),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: Text('¥' + amount,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: ScreenUtil.instance.setWidth(28.0))),
                  ))
                ],
              ),
              new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text('运费',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setWidth(28.0)))),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: Text('+¥' + freight,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: ScreenUtil.instance.setWidth(28.0))),
                  ))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text('余额',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setWidth(28.0)))),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: Text('-¥' + amount,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: ScreenUtil.instance.setWidth(28.0))),
                  ))
                ],
              ),
              // new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //         child: Text('余额',
              //             style: TextStyle(
              //                 color: Colors.black54,
              //                 fontSize: ScreenUtil.instance.setWidth(28.0)))),
              //     Expanded(
              //         child: Container(
              //       alignment: Alignment.centerRight,
              //       child: Text('-¥' + balance,
              //           style: TextStyle(
              //               color: Colors.black54,
              //               fontSize: ScreenUtil.instance.setWidth(28.0))),
              //     ))
              //   ],
              // ),
              new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: Text(
              //         '优惠券',
              //         style: TextStyle(
              //           color: Colors.black54,
              //           fontSize: ScreenUtil.instance.setWidth(28.0),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //         child: Container(
              //       alignment: Alignment.centerRight,
              //       child: Text('-¥' + coupon,
              //           style: TextStyle(
              //               color: Colors.black54,
              //               fontSize: ScreenUtil.instance.setWidth(28.0))),
              //     ))
              //   ],
              // ),
              new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              Container(
                height: ScreenUtil.instance.setWidth(25.0),
                decoration: ShapeDecoration(
                  shape: Border(
                    top: BorderSide(color: Color(0xfffececec), width: 1),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text('应付金额',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(30.0)))),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: Text('¥' + allMoney,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenUtil.instance.setWidth(28.0))),
                  ))
                ],
              ),
            ]),
          ),
        ),
        new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
        Container(
          // height: ScreenUtil.instance.setWidth(180.0),
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(25),
              right: ScreenUtil().setWidth(25)),
          child: Container(
            // height: ScreenUtil.instance.setWidth(200.0),
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(25),
                right: ScreenUtil().setWidth(25)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text('订单编号 $orderId',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setWidth(28.0))),
                    ),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              border: new Border.all(
                                  color: Color(0xfff979797), width: 2),
                            ),
                            child: Text('复制',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(28.0))),
                          ),
                          onTap: () {
                            print('fuzhi');
                            ToastUtil.showToast('复制成功');
                            Clipboard.setData(ClipboardData(text: '$orderId'));
                          },
                        ))
                  ],
                ),
                new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                Text('创建时间$time',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: ScreenUtil.instance.setWidth(28.0))),
                new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                Text('付款时间$payTime',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: ScreenUtil.instance.setWidth(28.0))),
                new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              ],
            ),
          ),
        ),
        status == "0"
            ? Container(
                width: ScreenUtil.instance.setWidth(750.0),
                height: ScreenUtil.instance.setWidth(100.0),
                margin: EdgeInsets.only(top: ScreenUtil().setWidth(100)),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
                    Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
                      child: InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(55.0),
                          width: ScreenUtil.instance.setWidth(165.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: new Border.all(
                                color: Color(0xfff979797), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text('取消订单',
                              style: TextStyle(
                                  color: Color(0xfff979797),
                                  fontSize:
                                      ScreenUtil.instance.setWidth(27.0))),
                        ),
                        onTap: () {
                          print('取消订单');
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return MyDialog(
                                    width: ScreenUtil.instance.setWidth(600.0),
                                    height: ScreenUtil.instance.setWidth(300.0),
                                    queding: () {
                                      cancelOrder();
                                      Navigator.pop(context);
                                    },
                                    quxiao: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: '温馨提示',
                                    message: '确定要取消订单吗？');
                              });
                        },
                      ),
                    ),
                    new SizedBox(width: ScreenUtil.instance.setWidth(15.0)),
                    Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
                      child: InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(55.0),
                          width: ScreenUtil.instance.setWidth(165.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: new Border.all(
                                color: Color(0xfffffd408), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text('去付款',
                              style: TextStyle(
                                  color: Color(0xfffffd408),
                                  fontSize:
                                      ScreenUtil.instance.setWidth(27.0))),
                        ),
                        onTap: () {
                          print('去付款');
                          Map obj = {
                            "list": [
                              {
                                "title": storeName,
                                "store_id": storeId,
                                "list": listview
                              }
                            ]
                          };
                          NavigatorUtils.toTijiaoDingdan(context, obj);
                        },
                      ),
                    ),
                    new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  Widget dingdanitem(BuildContext context, item, index) {
    return Container(
      height: ScreenUtil.instance.setWidth(215.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.elliptical(10, 10)),
      ),
      child: new Column(children: [
        new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
        Container(
            height: ScreenUtil.instance.setWidth(185.0),
            child: Row(children: <Widget>[
              new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
              CachedImageView(
                  ScreenUtil.instance.setWidth(168.0),
                  ScreenUtil.instance.setWidth(168.0),
                  item['img'],
                  null,
                  BorderRadius.all(Radius.circular(10))),
              new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
              Container(
                width: ScreenUtil.instance.setWidth(470.0),
                height: ScreenUtil.instance.setWidth(185.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text(item['goods_name'],
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(25.0))),
                      new SizedBox(height: ScreenUtil.instance.setWidth(5.0)),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(item['specs_name'],
                                style: TextStyle(
                                    color: Color(0xfff9f9c9c),
                                    fontSize:
                                        ScreenUtil.instance.setWidth(24.0))),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text("x${item['num']}",
                                      style: TextStyle(
                                          color: Color(0xfff8f8c8d),
                                          fontSize: ScreenUtil.instance
                                              .setWidth(27.0)))))
                        ],
                      ),
                      new Row(children: [
                        Container(
                          width: ScreenUtil.instance.setWidth(300.0),
                          height: ScreenUtil.instance.setWidth(60.0),
                          alignment: Alignment.bottomLeft,
                          child: RichText(
                            text: TextSpan(
                                text: "￥${item['now_price']}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(27.0)),
                                children: [
                                  TextSpan(
                                      text: "￥${item['old_price']}",
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Color(0xfffcccccc),
                                          fontSize: ScreenUtil.instance
                                              .setWidth(27.0))),
                                ]),
                          ),
                        ),
                        (status == "1" || status == "2" || status == "3") &&
                                widget.type != '2'
                            ? InkWell(
                                child: Container(
                                  width: ScreenUtil.instance.setWidth(150.0),
                                  height: ScreenUtil.instance.setWidth(50.0),
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(20)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: new Border.all(
                                        color: Color(0xfff979797), width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    item['after_status'] == '0'
                                        ? '申请售后'
                                        : item['after_status'] == '1'
                                            ? '审核中'
                                            : item['after_status'] == '2'
                                                ? '审核通过'
                                                : item['after_status'] == '3'
                                                    ? '审核拒绝'
                                                    : item['after_status'] ==
                                                            '4'
                                                        ? '买家退货'
                                                        : '已退款',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(26.0),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (item['after_status'] == '0' ||
                                      item['after_status'] == '3') {
                                    item['freight'] = freight;
                                    item['allMoney'] = allMoney;
                                    item['amount'] = amount;
                                    NavigatorUtils.toShouHouPage(context, item)
                                        .then((result) {
                                      if (result != null) {
                                        item['after_status'] = result;
                                      }
                                    });
                                  }
                                },
                              )
                            : Container()
                      ])
                    ]),
              ),
            ])),
        Container(
          height: ScreenUtil.instance.setWidth(20.0),
          decoration: ShapeDecoration(
            shape: Border(
              top: BorderSide(color: Color(0xfffececec), width: 1),
            ),
          ),
        )
      ]),
    );
  }
}
