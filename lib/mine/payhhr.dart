import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../api/api.dart';
import '../utils/serivice.dart';

class Payhhr extends StatefulWidget {
  @override
  PayhhrState createState() => PayhhrState();
}

class PayhhrState extends State<Payhhr> {
  bool isLoading = false;
  int status = 0;
  int lvl0 = 0;
  int lvl1 = 0;
  TextEditingController bankidcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void payhhr() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    Service().sget(Api.APPLY_HEHUOREN_URL, map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('申请已提交');
      getInfo();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void getInfo() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    Service().sget(Api.TEAM_URL, map, (success) async {
      setState(() {
        isLoading = false;
        lvl0 = success['lvl1'];
        lvl1 = success['tbs'];
        status = success['status'];
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

    Widget nums = Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(63),
        bottom: ScreenUtil().setWidth(63),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$lvl0",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(40),
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(10)),
                Text(
                  "直推播商数量",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$lvl1",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(40),
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(10)),
                Text(
                  "团队累计播商数量",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    //购买成为播商服务商
    // Widget payMoneyBtn = Container(
    //   width: double.infinity,
    //   padding: EdgeInsets.only(
    //     top: ScreenUtil().setWidth(63),
    //     bottom: ScreenUtil().setWidth(63),
    //   ),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       SizedBox(height: ScreenUtil().setWidth(10)),
    //       status == -1 || status == 2
    //           ? InkWell(
    //               onTap: () {
    //                 payhhr();
    //               },
    //               child: Container(
    //                 width: ScreenUtil().setWidth(497),
    //                 height: ScreenUtil().setHeight(83),
    //                 alignment: Alignment.center,
    //                 decoration: BoxDecoration(
    //                   gradient: PublicColor.btnlinear,
    //                   borderRadius: BorderRadius.circular(5),
    //                 ),
    //                 child: Text(
    //                   "购买成为播商服务商",
    //                   style: TextStyle(
    //                     color: PublicColor.btnColor,
    //                   ),
    //                 ),
    //               ),
    //             )
    //           : Container()
    //     ],
    //   ),
    // );

    Widget btn = Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(63),
        bottom: ScreenUtil().setWidth(63),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "当前状态  ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil.instance.setWidth(30)),
              children: <TextSpan>[
                TextSpan(
                    text: status == -1
                        ? '未申请'
                        : status == 0 ? '待审核' : status == 1 ? '审核成功' : '审核拒绝',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: ScreenUtil.instance.setWidth(30))),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          status == -1 || status == 2
              ? InkWell(
                  onTap: () {
                    payhhr();
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(497),
                    height: ScreenUtil().setHeight(83),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: PublicColor.btnlinear,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "申请播商服务商",
                      style: TextStyle(
                        color: PublicColor.btnColor,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text(
          '申请播商服务商',
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
      body: isLoading
          ? LoadingDialog()
          : new Container(
              alignment: Alignment.center,
              child: new Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  nums,
                  btn,
                  // payMoneyBtn,
                ],
              ),
            ),
    );
  }
}
