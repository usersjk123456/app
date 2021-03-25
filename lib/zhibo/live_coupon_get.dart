import 'package:client/api/api.dart';
import 'package:client/service/service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/btn_big.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetCoupon extends Dialog {
  final String roomId;
  final Map couponMap;

  GetCoupon({Key key, this.roomId, this.couponMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
          //保证控件居中效果
          child: GetCouponWidget(roomId: roomId, couponMap: couponMap)),
    );
  }
}

class GetCouponWidget extends StatefulWidget {
  final String roomId;
  final Map couponMap;
  GetCouponWidget({this.roomId, this.couponMap});
  @override
  GetCouponWidgetState createState() => GetCouponWidgetState();
}

class GetCouponWidgetState extends State<GetCouponWidget> {
  @override
  void initState() {
    super.initState();
  }

  void getLiveCoupon() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    Service().getData(map, Api.ROB_COUPON, (success) async {
      ToastUtil.showToast('领取成功');
      Navigator.of(context).pop();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setWidth(900),
      child: new Stack(
        children: <Widget>[
          Positioned(
            top: ScreenUtil().setWidth(2),
            right: ScreenUtil().setWidth(-25),
            child: MaterialButton(
              minWidth: ScreenUtil().setWidth(70),
              shape: StadiumBorder(),
              child: Image.asset(
                'assets/zhibo/guanbi.png',
                width: ScreenUtil().setWidth(70),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: ScreenUtil().setWidth(620),
              height: ScreenUtil().setWidth(808),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/zhibo/bg_yhq.png'),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(100),
                      bottom: ScreenUtil().setWidth(45),
                    ),
                    child: Text(
                      '满${widget.couponMap["mini"]}使用',
                      style: TextStyle(
                        color: Color(0xffe15716),
                        fontSize: ScreenUtil().setSp(36),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '￥',
                        style: TextStyle(
                          color: Color(0xffe15716),
                          fontSize: ScreenUtil().setSp(40),
                        ),
                      ),
                      Text(
                        '${widget.couponMap["price"]}',
                        style: TextStyle(
                          color: Color(0xffe15716),
                          fontSize: ScreenUtil().setSp(70),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  BigButton(
                    name: '领取',
                    tapFun: getLiveCoupon,
                    width: ScreenUtil().setWidth(300),
                    top: ScreenUtil().setWidth(320),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
