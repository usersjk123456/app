import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/toTime.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';

class CouponPage extends StatefulWidget {
  final String couponStr;
  CouponPage({this.couponStr});
  @override
  CouponPageState createState() => CouponPageState();
}

class CouponPageState extends State<CouponPage> {
  bool btnActive = false;
  bool isLoading = true;
  String jwt = '', code = '';
  List notUsedList = [], invalidList = [];
  final contentcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  int type = 0; // 分类

  @override
  void initState() {
    super.initState();
    getList(1);
  }

//兑换
  void dhApi() async {
    if (contentcontroller.text == '') {
      ToastUtil.showToast('兑换码不能为空');
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("code", () => contentcontroller.text);

    UserServer().exchangeCoupon(map, (success) async {
      setState(() {
        isLoading = false;
        contentcontroller.text = '';
      });
      getList(1);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void getList(type) async {
    setState(() {
      isLoading = true;
    });
    notUsedList = [];
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);

    UserServer().couponList(map, (success) async {
      if (widget.couponStr != "null") {
        List arr = widget.couponStr.split(',');
        List data = [];
        for (var i = 0; i < arr.length; i++) {
          for (var item in success['list']) {
            if (arr[i].toString() == item['id']) {
              data.insert(i, item);
            }
          }
        }
        setState(() {
          isLoading = false;
          notUsedList = data;
        });
      } else {
        setState(() {
          isLoading = false;
          notUsedList = success['list'];
        });
      }
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
    //兑换
    Widget dhArea = new Container(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: ScreenUtil().setWidth(60),
        width: ScreenUtil().setWidth(700),
        child: new Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15, top: 0),
                height: ScreenUtil().setWidth(60),
                width: ScreenUtil().setWidth(550),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  controller: contentcontroller,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    hintText: '请输入优惠券兑换码',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9.0),
                  ),
                ),
              ),
            ),
            new SizedBox(width: ScreenUtil().setWidth(40)),
            Expanded(
              flex: 1,
              child: Container(
                height: ScreenUtil().setWidth(60),
                width: ScreenUtil().setWidth(120),
                decoration: BoxDecoration(
                  gradient: PublicColor.linearBtn,
                  borderRadius: new BorderRadius.circular(
                    (8.0),
                  ),
                ),
                child: new FlatButton(
                  disabledColor: PublicColor.themeColor,
                  onPressed: () {
                    print('兑换');
                    dhApi();
                  },
                  child: new Text(
                    '兑换',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: PublicColor.btnTextColor),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    //未使用
    Widget notUsedItem() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (notUsedList.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(260)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ));
      } else {
        for (var item in notUsedList) {
          item['startTime'] =
              ToTime.time(item['detail']['start_time'].toString(), 'YY');
          item['endTime'] =
              ToTime.time(item['detail']['end_time'].toString(), 'YY');
          arr.add(Container(
            child: new Column(children: <Widget>[
              Container(
                  child: SingleChildScrollView(
                child: Stack(children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    width: ScreenUtil().setWidth(694),
                    height: ScreenUtil().setWidth(272),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: type == 0
                            ? AssetImage("assets/mine/yhq1.png")
                            : AssetImage("assets/mine/yhq2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(40),
                      right: ScreenUtil().setWidth(40),
                    ),
                    child: Row(children: [
                      Row(children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '￥',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xfff03329),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${item['detail']['price']}",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(50),
                                color: Color(0xfff03329),
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ]),
                      Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                item['detail']['name'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(35),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "满${item['detail']['mini']}减${item['detail']['price']}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "有效期至${item['endTime']}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(24),
                                    color: Color(0xff999999)),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                  Positioned(
                    top: ScreenUtil().setWidth(126),
                    right: ScreenUtil().setWidth(40),
                    child: Container(
                      height: ScreenUtil().setWidth(60),
                      width: ScreenUtil().setWidth(150),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: type == 0
                                  ? Color(0xfffd6d63)
                                  : Color(0xff999999),
                              width: 1),
                          borderRadius: new BorderRadius.circular((15.0))),
                      child: new FlatButton(
                        disabledColor: PublicColor.themeColor,
                        onPressed: () {
                          if (widget.couponStr != "null") {
                            Navigator.pop(context, item);
                          }
                        },
                        child: new Text(
                          '使用',
                          style: TextStyle(
                            color: type == 0
                                ? Color(0xfffd6d63)
                                : Color(0xff999999),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              )),
            ]),
          ));
        }
      }
      content = new ListView(
        children: arr,
      );
      return content;
    }

    return Stack(
      children: <Widget>[
        new DefaultTabController(
          length: 2,
          child: new Scaffold(
            backgroundColor: Color(0xfff5f5f5),
            appBar: new AppBar(
                title: new Text(
                  '优惠券',
                  style: TextStyle(
                    color: PublicColor.headerTextColor,
                  ),
                ),
                centerTitle: true,
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
                actions: <Widget>[
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Text(
                        '规则',
                        style: new TextStyle(
                          color: PublicColor.whiteColor,
                          fontSize: ScreenUtil().setSp(30),
                          height: 2.7,
                        ),
                      ),
                    ),
                    onTap: () {
                      print('规则');
                      NavigatorUtils.goCouponRulePage(context);
                    },
                  )
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                      indicatorWeight: 4.0,
                      // indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: PublicColor.themeColor,
                      unselectedLabelColor: Color(0xff5e5e5e),
                      labelColor: PublicColor.themeColor,
                      tabs: <Widget>[
                        new Tab(
                          child: Text(
                            '未使用',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        new Tab(
                          child: Text(
                            '已失效',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      onTap: ((index) {
                        setState(() {
                          type = index;
                        });
                        getList(index + 1);
                      }),
                    ),
                  ),
                )),
            body: Column(
              children: <Widget>[
                type == 0 ? dhArea : Container(),
                type == 0
                    ? SizedBox(
                        height: ScreenUtil().setHeight(10),
                      )
                    : Container(),
                Expanded(
                  flex: 1,
                  child: notUsedItem(),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
              ],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }
}
