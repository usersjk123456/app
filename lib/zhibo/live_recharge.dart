import 'dart:async';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'live_pay.dart';

//充值金币
class RechargeWidget extends StatefulWidget {
  final String myCoin;
  final Function getInfo;
  RechargeWidget({this.myCoin, this.getInfo});
  @override
  RechargeWidgetState createState() => RechargeWidgetState();
}

class RechargeWidgetState extends State<RechargeWidget> {
  List rechargeList = [];
  String open = "1";
  bool isloading = false;
  Timer _timer;
  String orderId = '';

  @override
  void initState() {
    super.initState();
    getRecharge();
  }

  void popContent() {
    Navigator.pop(context);
  }

  // 获取充值金额列表
  void getRecharge() async {
    Map<String, dynamic> map = Map();
    LiveServer().getRecharge(map, (success) async {
      if (mounted) {
        setState(() {
          rechargeList = success['list'];
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void startTimer(orderId) {
    isloading = true;
    //设置 1 秒回调一次
    const period = const Duration(seconds: 2);
    _timer = Timer.periodic(period, (timer) {
      getPayStatus(orderId);
      //更新界面
    });
  }

  // 充值回调
  void getPayStatus(orderId) async {
    print('支付中..');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => orderId);
    map.putIfAbsent("type", () => "5");
    UserServer().getPayStatus(map, (success) async {
      isloading = false;
      widget.getInfo();
      cancelTimer();
      ToastUtil.showToast('充值成功');
      Navigator.pop(context);
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 230)..init(context);

    Widget topnone = new SizedBox(
      height: ScreenUtil().setWidth(25),
    );

    Widget topArea = new Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      width: ScreenUtil().setWidth(750),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Text('金币: '),
                Image.asset(
                  'assets/zhibo/jb.png',
                  height: ScreenUtil().setWidth(30),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(8),
                ),
                new Text(widget.myCoin),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text('充值'),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );

    Widget rechargeItem(item) {
      return InkWell(
        child: new Container(
          height: ScreenUtil().setWidth(120),
          width: ScreenUtil().setWidth(230),
          decoration: BoxDecoration(
            color: Color(0xffececec),
            borderRadius: new BorderRadius.circular(10),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/zhibo/jb.png',
                    height: ScreenUtil().setWidth(40),
                  ),
                  Text(
                    ' ' + item['coin'],
                    style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                  ),
                ],
              ),
              Container(
                child: Text(
                  item['rmb'] + ' 元',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          print('充金币');
          // toRecharge(item);
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return LivePay(
                  getInfo: widget.getInfo,
                  item: item,
                  startTimer: startTimer,
                  // popContent: popContent,
                );
              });
        },
      );
    }

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (rechargeList.length == 0) {
        arr.add(
          Container(
            height: ScreenUtil().setWidth(700),
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(300),
            ),
            child: Text(
              '暂无数据',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(35),
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      for (var item in rechargeList) {
        arr.add(rechargeItem(item));
      }

      content = new Wrap(
        spacing: 10.0, // 主轴(水平)方向间距
        runSpacing: 10.0,
        children: arr,
      );
      return content;
    }

    return Container(
      height: ScreenUtil().setWidth(600),
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                child:
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[topnone, topArea, listArea()]),
              ),
            ],
          ),
          isloading ? LoadingDialog(types: "1") : Container()
        ],
      ),
    );
  }
}
