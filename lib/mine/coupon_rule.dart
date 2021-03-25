import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../common/color.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';
import 'package:flutter_html/flutter_html.dart';

class CouponRulePage extends StatefulWidget {
  @override
  _CouponRulePageState createState() => _CouponRulePageState();
}

class _CouponRulePageState extends State<CouponRulePage> {
  bool isLoading = true;
  String coupon = '';
  String coin = '';
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("type", () => type);

    UserServer().couponRule(map, (success) async {
      setState(() {
        isLoading = false;
        coupon = success['res']['coupon'];
        coin = success['res']['coin'];
      });
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
        MaterialApp(
            title: "规则",
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: new Text(
                  '规则',
                  style: new TextStyle(
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
              body: new Container(
                alignment: Alignment.center,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                      child: Html(data: coupon),
                    ),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                      child: Html(data: coin),
                    )
                  ],
                ),
              ),
            )),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }
}
