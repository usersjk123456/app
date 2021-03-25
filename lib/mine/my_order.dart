
import 'dart:async';
import 'package:client/common/global.dart';
import 'package:client/widgets/no_data.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/cached_image.dart';
import '../utils/toast_util.dart';
import '../config/navigator_util.dart';
import '../widgets/dialog.dart';
import '../service/user_service.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../pay_order/order_pay.dart';

class MyOrderPage extends StatefulWidget {
  final String type;
  MyOrderPage(this.type);
  @override
  MyOrderPageState createState() => MyOrderPageState();
}

class MyOrderPageState extends State<MyOrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  int _page = 0;
  String jwt = "";
  List listview = [];
  int clickIndex = 0;
  Timer _timer;
  EasyRefreshController _controller = EasyRefreshController();
  TabController tabController;

  @override
  void initState() {
    super.initState();
    clickIndex = int.parse(widget.type);
    getList(clickIndex);
  }

  void getList(clickIndex) async {
    _page++;
    if (_page == 1) {
      listview = [];
    }

    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => clickIndex + 1);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);

    UserServer().orderList(map, (success) async {
      if (mounted) {
        setState(() {
          if (_page == 1) {
            //赋值
            listview = success['list'];
          } else {
            if (success['list'].length == 0) {
              // ToastUtil.showToast('已加载全部数据');
            } else {
              for (var i = 0; i < success['list'].length; i++) {
                listview.insert(listview.length, success['list'][i]);
              }
            }
          }
        });
      }
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

//删除订单
  void delApi(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_order_id", () => id);
    UserServer().delOrder(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('订单已删除');
      listview.removeWhere((item) => item['store_order_id'] == id);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  //取消订单
  void cancelApi(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_order_id", () => id);
    UserServer().cancelOrder(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('订单已取消');
      listview.removeWhere((item) => item['store_order_id'] == id);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  //确认收货
  void confirmApi(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_order_id", () => id);
    UserServer().configOrder(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('收货成功');
      listview.removeWhere((item) => item['store_order_id'] == id);
      changeTab(4);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
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
    map.putIfAbsent("type", () => "4");
    UserServer().getPayStatus(map, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');
      changeTab(2);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void changeTab(index) {
    clickIndex = index;
    DefaultTabController.of(_scaffoldKey.currentContext).animateTo(index);
    listview = [];
    _page = 0;
    getList(index);
  }

  void popContent() {
    cancelTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 5,
          initialIndex: clickIndex,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                '我的订单',
                style: TextStyle(
                  color: PublicColor.headerTextColor,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: PublicColor.linearHeader,
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Material(
                  color: Colors.white,
                  child: TabBar(
                    controller: tabController,
                    onTap: ((index) {
                      clickIndex = index;
                      listview = [];
                      _page = 0;
                      getList(clickIndex);
                    }),
                    indicatorWeight: 4.0,
                    labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                    indicatorColor: PublicColor.themeColor,
                    unselectedLabelColor: PublicColor.themeColor,
                    labelColor: PublicColor.themeColor,
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          '全部',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Tab(
                        child: Text(
                          '待付款',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Tab(
                        child: Text(
                          '待发货',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Tab(
                        child: Text(
                          '待收货',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Tab(
                        child: Text(
                          '待评价',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
              width: ScreenUtil.getInstance().setWidth(750.0),
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
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    ScreenUtil.instance.setWidth(25),
                    ScreenUtil.instance.setWidth(0),
                    ScreenUtil.instance.setWidth(25),
                    0,
                  ),
                  width: ScreenUtil.getInstance().setWidth(700.0),
                  child: gouwuitem(context, listview),
                ),
                onRefresh: () async {
                  _page = 0;
                  getList(clickIndex);
                },
                onLoad: () async {
                  getList(clickIndex);
                },
              ),
            ),
          ),
        ),
        isLoading
            ? LoadingDialog(
                types: "1",
              )
            : Container()
      ],
    );
  }

  Widget gouwuitem(BuildContext context, listview) {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (listview.length == 0) {
      arr.add(NoData(deHeight: 150));
    } else {
      int index = 0;
      for (var item in listview) {
        index++;
        arr.add(
          Container(
            child: Column(
              children: [
                SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(color: Color(0xfffececec), width: 0.5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: ScreenUtil.getInstance().setWidth(80.0),
                        padding: EdgeInsets.only(
                            right: ScreenUtil.instance.setWidth(20.0)),
                        child: Row(children: [
                          SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                          Image.asset(
                            'assets/index/dp2.png',
                            width: ScreenUtil.instance.setWidth(32.0),
                          ),
                          SizedBox(width: ScreenUtil.instance.setWidth(5.0)),
                          Text(
                            item['store_name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                  Global.getStatus(
                                    Data.string(
                                      Data.string(
                                        item['pay_status'],
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: item['pay_status'] == "3"
                                          ? Color(0xffa0a0a0)
                                          : Colors.red,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(26.0))),
                              alignment: Alignment.centerRight,
                            ),
                            flex: 1,
                          )
                        ]),
                      ),
                      Column(children: listBoxs(item['goods'], index)),
                      Container(
                        height: ScreenUtil.getInstance().setWidth(150.0),
                        decoration: ShapeDecoration(
                          shape: Border(
                              top: BorderSide(
                                  color: Color(0xfffececec), width: 1.0)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                  '共 ${item['num']} 件商品 合计:¥${item['total']}',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(28.0))),
                              alignment: Alignment.centerRight,
                              height: ScreenUtil.getInstance().setWidth(65.0),
                              padding: EdgeInsets.only(
                                  right: ScreenUtil.instance.setWidth(25.0)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                item['pay_status'] == "4"
                                    ? InkWell(
                                        child: Container(
                                          height: ScreenUtil.getInstance()
                                              .setWidth(60.0),
                                          width: ScreenUtil.getInstance()
                                              .setWidth(175.0),
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            border: Border.all(
                                                color: Color(0xfff979797),
                                                width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text('删除订单',
                                              style: TextStyle(
                                                  color: Color(0xfff979797),
                                                  fontSize: ScreenUtil.instance
                                                      .setWidth(28.0))),
                                        ),
                                        onTap: () {
                                          print('删除订单');
                                          print(item['store_order_id']);
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return MyDialog(
                                                    width: ScreenUtil.instance
                                                        .setWidth(600.0),
                                                    height: ScreenUtil.instance
                                                        .setWidth(300.0),
                                                    queding: () {
                                                      delApi(item[
                                                          'store_order_id']);

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    quxiao: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    title: '温馨提示',
                                                    message: '确定要删除订单？');
                                              });
                                        },
                                      )
                                    : InkWell(
                                        child: Container(
                                          height: ScreenUtil.getInstance()
                                              .setWidth(60.0),
                                          width: ScreenUtil.getInstance()
                                              .setWidth(175.0),
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            border: Border.all(
                                                color: Color(0xfff979797),
                                                width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '查看详情',
                                            style: TextStyle(
                                              color: Color(0xfff979797),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(28.0),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          NavigatorUtils.toOrderDetail(
                                                  context, item)
                                              .then((data) {
                                            _page = 0;
                                            getList(clickIndex);
                                          });
                                        },
                                      ),
                                item['pay_status'] == "0"
                                    ? InkWell(
                                        child: Container(
                                          height: ScreenUtil.getInstance()
                                              .setWidth(60.0),
                                          width: ScreenUtil.getInstance()
                                              .setWidth(175.0),
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            border: Border.all(
                                                color: Color(0xfff979797),
                                                width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '取消订单',
                                            style: TextStyle(
                                              color: Color(0xfff979797),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(28.0),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          print('取消订单');
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return MyDialog(
                                                    width: ScreenUtil.instance
                                                        .setWidth(600.0),
                                                    height: ScreenUtil.instance
                                                        .setWidth(300.0),
                                                    queding: () {
                                                      cancelApi(item[
                                                          'store_order_id']);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    quxiao: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    title: '温馨提示',
                                                    message: '确定要取消订单吗？');
                                              });
                                        },
                                      )
                                    : Container(),
                                item['pay_status'] == "0"
                                    ? InkWell(
                                        child: Container(
                                          height: ScreenUtil.getInstance()
                                              .setWidth(60.0),
                                          width: ScreenUtil.getInstance()
                                              .setWidth(175.0),
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            border: Border.all(
                                                color: PublicColor.themeColor,
                                                width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '去付款',
                                            style: TextStyle(
                                              color: PublicColor.themeColor,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(28.0),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          print('去付款');

                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return FukuanWidget(
                                                  storeOrderId:
                                                      item['store_order_id'],
                                                  total: item['total'],
                                                  startTimer: startTimer,
                                                  popContent: popContent,
                                                );
                                              });
                                        },
                                      )
                                    : Container(),
                                item['pay_status'] == "2"
                                    ? InkWell(
                                        child: Container(
                                          height: ScreenUtil.getInstance()
                                              .setWidth(60.0),
                                          width: ScreenUtil.getInstance()
                                              .setWidth(175.0),
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            border: Border.all(
                                                color: PublicColor.themeColor,
                                                width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '确认收货',
                                            style: TextStyle(
                                              color: PublicColor.themeColor,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(28.0),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          print('确认收货');
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return MyDialog(
                                                    width: ScreenUtil.instance
                                                        .setWidth(600.0),
                                                    height: ScreenUtil.instance
                                                        .setWidth(300.0),
                                                    queding: () {
                                                      confirmApi(item[
                                                          'store_order_id']);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    quxiao: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    title: '温馨提示',
                                                    message: '确认收货吗？');
                                              });
                                        },
                                      )
                                    : Container(),
                                item['pay_status'] == "3"
                                    ? InkWell(
                                        child: Container(
                                          height: ScreenUtil.getInstance()
                                              .setWidth(60.0),
                                          width: ScreenUtil.getInstance()
                                              .setWidth(175.0),
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            border: Border.all(
                                                color: PublicColor.themeColor,
                                                width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '去评价',
                                            style: TextStyle(
                                              color: PublicColor.themeColor,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(28.0),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          print('去评价');
                                          NavigatorUtils.goComment(
                                            context,
                                            item,
                                          ).then((data) {
                                            print('评价啊===');
                                            _page = 0;
                                            getList(clickIndex);
                                          });
                                        },
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    content = ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: arr,
    );
    return content;
  }

  List<Widget> listBoxs(listView, listindex) => List.generate(
        listView.length,
        (index) {
          return Container(
            width: ScreenUtil.instance.setWidth(700),
            height: ScreenUtil.instance.setWidth(250),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: Border(
                top: BorderSide(color: Color(0xfffececec), width: 1),
              ),
            ),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                    CachedImageView(
                      ScreenUtil.instance.setWidth(210.0),
                      ScreenUtil.instance.setWidth(210.0),
                      listView[index]['img'],
                      null,
                      BorderRadius.all(Radius.circular(0))),
                  SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                  Container(
                    width: ScreenUtil.instance.setWidth(420.0),
                    height: ScreenUtil.instance.setWidth(250.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                          Text(
                            listView[index]['goods_name'],
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setWidth(25.0),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          Text(
                            listView[index]['specs_name'],
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setWidth(25.0),
                            ),
                          ),
                          Text(
                            " ¥${listView[index]['old_price']}",
                            style: TextStyle(
                              color: PublicColor.grewNoticeColor,
                              decoration: TextDecoration.lineThrough,
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                            ),
                          ),
                          Row(children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                child: RichText(
                                  text: TextSpan(
                                      text: '¥${listView[index]['now_price']} ',
                                      style: TextStyle(
                                        color: PublicColor.themeColor,
                                        fontSize:
                                            ScreenUtil.instance.setWidth(27.0),
                                      ),
                                    /*children: [
                                      TextSpan(
                                        text:
                                        "/赚¥${listView[index]['commission']}",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: ScreenUtil.instance
                                              .setWidth(27.0),
                                        ),
                                      ),
                                    ],*/),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                                child: Container(
                                  height: ScreenUtil.instance.setWidth(75.0),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "x${listView[index]['num']}",
                                    style: TextStyle(
                                        color: Color(0xfffcccccc),
                                        fontSize:
                                            ScreenUtil.instance.setWidth(27.0)),
                                  ),
                                ),
                                flex: 1),
                          ])
                        ]),
                  )
                ],
              ),
              onTap: () {
                NavigatorUtils.toXiangQing(
                    context, listView[index]['goods_id'], "0", "0");
              },
            ),
          );
        },
      );
}
