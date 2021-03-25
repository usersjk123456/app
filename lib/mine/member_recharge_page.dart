import 'package:client/model/member_recharge.dart';
import 'package:client/model/vip_recharge.dart';
import 'package:client/pay_order/vip_pay.dart';
import 'package:client/service/live_service.dart';
import 'package:client/widgets/base_text.dart';
import 'package:client/zhibo/live_pay.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../service/user_service.dart';
import '../service/home_service.dart';
import '../widgets/cached_image.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

class MemberRechargePage extends StatefulWidget {
  @override
  MemberRechargePageState createState() => MemberRechargePageState();
}

class MemberRechargePageState extends State<MemberRechargePage> {
  bool isLoading = false;
  String jwt = '', addressId = "", vip = '', viptime = '', ji = '1';

  MemberRecharge _memberRecharge = MemberRecharge();
  List<MemberRecharge> allList = [];

  Timer _timer;

  int isLive = 0;

  @override
  void initState() {
    super.initState();
    getRecharge();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
    /*  if (mounted) {
        setState(() {
          myCoin = success['coin'].toString();
          userInfo = success;
        });
      }*/
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 获取充值金额列表
  void getRecharge() async {
    Map<String, dynamic> map = Map();
    LiveServer().getRecharge(map, (success) async {
      List result = success['list'];
      allList = result.map((json) => MemberRecharge.fromJson(json)).toList();
      if (allList.isNotEmpty) {
        _memberRecharge = allList.elementAt(0);
      }
      setState(() {
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
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
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      // getList();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("会员充值"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (allList.isEmpty) {
      return Container();
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    "请选择充值金额",
                    color: Color(0xFFF0D4A6),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    margin: EdgeInsets.only(
                      bottom: 20,
                    ),
                  ),
                  Wrap(
                    children: allList
                        .map((e) => _buildMoneyItem(e))
                        .toList(),
                    spacing: 5,
                    runSpacing: 5,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: LivePay(
                getInfo: getInfo,
                item: _memberRecharge.toMap(),
                startTimer: startTimer,
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyItem(MemberRecharge memberRecharge) {
    bool checked = memberRecharge == _memberRecharge;
    return GestureDetector(
      onTap: () {
        setState(() {
          _memberRecharge = memberRecharge;
        });
      },
      child: Card(
        color: checked ? PublicColor.themeColor : Colors.white,
        elevation: 0.5,
        margin: EdgeInsets.only(bottom: 15),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.4,
          height: 60,
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseText(
                '充${memberRecharge.rmb}元',
                fontSize: 18,
                color: checked ? Colors.white : Colors.black,
              ),
              BaseText(
                '送${memberRecharge.give}元',
                fontSize: 14,
                color: checked ? Colors.white : PublicColor.themeColor ,
                margin: EdgeInsets.only(
                  top: 5,
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
