import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import 'package:flutter/services.dart';
import '../utils/toast_util.dart';
import '../widgets/dialog.dart';
import '../service/store_service.dart';

class StoreCustomerDetailsPage extends StatefulWidget {
  final String oid;
  StoreCustomerDetailsPage({this.oid});
  @override
  _StoreCustomerDetailsPageState createState() =>
      _StoreCustomerDetailsPageState();
}

class _StoreCustomerDetailsPageState extends State<StoreCustomerDetailsPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String name = '';
  int goodsId = 0;
  int status = 0;
  int type = 0;
  Map details = {
    "type": 1,
    "num": 0,
    "reason": "",
    "money": "",
    "explain": "",
    "img": "",
    "create_at": ""
  };

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDetails() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    StoreServer().getStoreAfterDetails(map, (success) async {
      setState(() {
        details = success['res'];
        status = success['goods']['after_status'];
        type = success['res']['type'];
        goodsId = success['goods']['id'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void apply(type) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => goodsId);
    map.putIfAbsent("status", () => type);

    StoreServer().configAfterHandle(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('操作成功');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget configDjango(context, type) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        apply(type);
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: '确定操作？',
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget detailsBuild = Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
            color: PublicColor.whiteColor),
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '退款信息',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(35),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setWidth(50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '退款类型',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
                Text(
                  details["type"] == 1 ? '退货退款' : '仅退款',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setWidth(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '退款数量',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
                Text(
                  'x${details["num"]}',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setWidth(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '退款原因',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
                Text(
                  '${details["reason"]}',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setWidth(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '退款金额',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
                Text(
                  "${details['money']}",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setWidth(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '退款说明',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
                Text(
                  details['explain'] == '' ? '无' : details['explain'],
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setWidth(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '申请时间',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
                Text(
                  details['create_at'],
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setWidth(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '凭证',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
                details['img'] != ''
                    ? Image.network(
                        details['img'],
                        width: ScreenUtil().setWidth(100),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );

    Widget btnBuild = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            color: PublicColor.themeColor,
            highlightColor: PublicColor.themeColor,
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            textColor: PublicColor.btnTextColor,
            child: Text("通过审核"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return configDjango(context, 1);
                  });
            },
          ),
          SizedBox(width: ScreenUtil().setWidth(30)),
          FlatButton(
            color: PublicColor.grewNoticeColor,
            highlightColor: PublicColor.themeColor,
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            textColor: PublicColor.btnTextColor,
            child: Text("审核拒绝"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return configDjango(context, 2);
                  });
            },
          ),
          SizedBox(width: ScreenUtil().setWidth(30)),
        ],
      ),
    );

    Widget btnBuild2 = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            color: PublicColor.themeColor,
            highlightColor: PublicColor.themeColor,
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            textColor: PublicColor.btnTextColor,
            child: Text("同意退款"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return configDjango(context, 3);
                  });
            },
          ),
          SizedBox(width: ScreenUtil().setWidth(30)),
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: new Text(
              '售后详情',
              style: TextStyle(color: PublicColor.headerTextColor),
            ),
            centerTitle: true,
            flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: PublicColor.linearHeader,
                  ),
                ),

          ),
          body: ListView(
            children: <Widget>[
              detailsBuild,
              SizedBox(height: ScreenUtil().setWidth(50)),
              status == 1
                  ? btnBuild
                  : status == 4 && type == 1
                      ? btnBuild2
                      : status == 2 && type == 2 ? btnBuild2 : Container()
            ],
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
