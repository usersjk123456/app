import 'package:client/api/api.dart';
import 'package:client/service/goods_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../utils/toast_util.dart';
import '../common/color.dart';

class Logistics extends StatefulWidget {
  final String orderId;
  Logistics({this.orderId});

  @override
  LogisticsState createState() => LogisticsState();
}

class LogisticsState extends State<Logistics> {
  bool isloading = false;
  List list = [{}];
  List resultList = [];
  String logisticsNum = '', logisticsName = '';

  @override
  void initState() {
    getLogistics();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getLogistics() {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_order_id", () => widget.orderId);
    GoodsServer().getServer(map, Api.LOGISTICS, (success) async {
      setState(() {
        isloading = false;
        resultList = success['result']['Traces'];
        logisticsNum = success['result']['LogisticCode'];
        logisticsName = success['express_name'];
      });
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

    Widget titleBox = Container(
      decoration: BoxDecoration(
        color: Color(0xfffffced),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ScreenUtil().setWidth(20.0)),
          topRight: Radius.circular(ScreenUtil().setWidth(20.0)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(20),
        ScreenUtil().setWidth(30),
        ScreenUtil().setWidth(20),
        ScreenUtil().setWidth(30),
      ),
      child: Text(
        '$logisticsName快递 ' + ' $logisticsNum',
        style: TextStyle(
          fontSize: ScreenUtil().setWidth(30),
        ),
      ),
    );

    Widget logisticsItem(item) {
      return Container(
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(15),
                right: ScreenUtil().setWidth(25),
              ),
              child: Container(
                width: ScreenUtil().setWidth(14),
                height: ScreenUtil().setWidth(14),
                decoration: BoxDecoration(
                  color: PublicColor.themeColor,
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setWidth(7),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(600),
                  margin: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(8),
                  ),
                  child: Text(
                    item['AcceptStation'],
                    style: TextStyle(
                      fontSize: ScreenUtil().setWidth(30),
                    ),
                  ),
                ),
                Text(
                  item['AcceptTime'],
                  style: TextStyle(
                      fontSize: ScreenUtil().setWidth(26),
                      color: PublicColor.grewNoticeColor),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget buildList() {
      List<Widget> arr = <Widget>[];
      Widget content;

      for (var item in resultList) {
        arr.add(logisticsItem(item));
      }

      content = Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(ScreenUtil().setWidth(20.0)),
            bottomRight: Radius.circular(ScreenUtil().setWidth(20.0)),
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(20),
          ScreenUtil().setWidth(30),
          ScreenUtil().setWidth(20),
          ScreenUtil().setWidth(30),
        ),
        child: Column(
          children: arr,
        ),
      );
      return content;
    }

    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '物流详情',
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
      body: isloading
          ? LoadingDialog()
          : Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(16),
                bottom: ScreenUtil().setWidth(16),
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30),
              ),
              child: ListView(
                children: <Widget>[
                  titleBox,
                  buildList(),
                ],
              ),
            ),
    );
  }
}
