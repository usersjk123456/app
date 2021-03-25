import 'package:client/api/api.dart';
import 'package:client/common/style.dart';
import 'package:client/service/service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/btn_big.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendCoupon extends StatefulWidget {
  final String roomId;
  SendCoupon({this.roomId});
  @override
  SendCouponState createState() => SendCouponState();
}

class SendCouponState extends State<SendCoupon> {
  TextEditingController timeController = new TextEditingController();
  List couponList = [];
  int couponNum = 1;
  Map couponMap = {'select': false};

  @override
  void initState() {
    getCouponList();
    super.initState();
  }

  // 获取优惠券列表
  void getCouponList() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    Service().getData(map, Api.GET_ROOM_COUPON, (success) async {
      if (mounted) {
        setState(() {
          for (var item in success['couponList']) {
            item['select'] = false;
          }
          couponList = success['couponList'];
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 发放优惠券
  void sendCoupon() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    map.putIfAbsent("coupon_id", () => couponMap['id']);
    map.putIfAbsent("limit", () => timeController.text);
    map.putIfAbsent("num", () => couponNum);
    Service().getData(map, Api.SEND_COUPON, (success) async {
      ToastUtil.showToast('发放成功');
      Navigator.pop(context);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget couponItem(item, index) {
      return InkWell(
        onTap: () {
          if (mounted) {
            setState(() {
              for (var cell in couponList) {
                cell['select'] = false;
              }
              item['select'] = true;
              couponMap = item;
            });
          }
        },
        child: Container(
          width: ScreenUtil().setWidth(334),
          height: ScreenUtil().setWidth(157),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: item['select']
                  ? AssetImage("assets/zhibo/yhq2.png")
                  : AssetImage("assets/zhibo/yhq1.png"),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item['price'],
                    style: TextStyle(
                      color: PublicColor.redColor,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(32),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  // color: Colors.white,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/zhibo/line.png',
                    width: ScreenUtil().setWidth(1),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '优惠券',
                        style: TextStyle(
                          color: PublicColor.redColor,
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ),
                      Text(
                        '满${item["mini"]}使用',
                        style: TextStyle(
                          color: Color(0xff893f1f),
                          fontSize: ScreenUtil().setSp(20),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget buildList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (couponList.length > 0) {
        var i = 0;
        for (var item in couponList) {
          arr.add(couponItem(item, i));
          i++;
        }
      }
      content = Container(
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(25),
          bottom: ScreenUtil().setWidth(45),
        ),
        height: ScreenUtil().setWidth(300),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Wrap(
                spacing: ScreenUtil().setWidth(10),
                runSpacing: ScreenUtil().setWidth(10),
                children: arr,
              ),
            ),
          ],
        ),
      );
      return content;
    }

    // 数量操作
    Widget couponNumBox = Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(40),
      ),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('发放数量'),
          Container(
            width: ScreenUtil.instance.setWidth(200.0),
            height: ScreenUtil.instance.setWidth(50.0),
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: new Border.all(color: Color(0xfffcccccc), width: 0.5),
            ),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: new ShapeDecoration(
                      shape: Border(
                        right: BorderSide(color: Color(0xfffececec), width: 1),
                      ), // 边色与边宽度
                    ),
                    child: Text('-'),
                  ),
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        couponNum--;
                      });
                    }
                    if (couponNum <= 1) {
                      return;
                    }
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('$couponNum'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: new ShapeDecoration(
                      shape: Border(
                        left: BorderSide(color: Color(0xfffececec), width: 1),
                      ), // 边色与��宽度
                    ),
                    child: Text('+'),
                  ),
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        couponNum++;
                      });
                    }
                  },
                ),
              ),
            ]),
          )
        ],
      ),
    );

    // 时间操作
    Widget timeBox = Container(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('显示时间（秒）'),
          Container(
            width: ScreenUtil.instance.setWidth(400.0),
            height: ScreenUtil.instance.setWidth(60.0),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: new Border.all(color: Color(0xfffcccccc), width: 0.5),
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: ScreenUtil().setSp(24)),
              controller: timeController,
              decoration: new InputDecoration(
                hintText: '请输入时间',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                print(value);
              },
            ),
          )
        ],
      ),
    );

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setWidth(94),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
            ),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffdddddd),
                ),
              ),
            ),
            child: Text(
              '发放优惠券',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w600,
                color: Color(0xff454545),
              ),
            ),
          ),
          buildList(),
          // 数量操作
          timeBox,
          couponNumBox,
          BigButton(
            name: '确认发放',
            tapFun: () async {
              if (!couponMap['select']) {
                ToastUtil.showToast('请选择优惠券');
                return;
              }
              if (timeController.text == '') {
                ToastUtil.showToast('请输入显示时间');
                return;
              }
              sendCoupon();
            },
            top: ScreenUtil().setWidth(40),
          )
        ],
      ),
    );
  }
}
