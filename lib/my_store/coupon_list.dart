import 'dart:ui';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../my_store/change_coupon_num.dart';
import '../config/Navigator_util.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';
import '../common/toTime.dart';

class CouponListPage extends StatefulWidget {
  @override
  _CouponListPageState createState() => _CouponListPageState();
}

class _CouponListPageState extends State<CouponListPage> {
  bool isLoading = false;
  int type = 0;
  List couponList = [];
  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type + 1);

    StoreServer().getCouponList(map, (success) async {
      setState(() {
        couponList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List typeList = ["未开始", "进行中", "已过期"];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget listBuild() {
      List<Widget> arr = <Widget>[SizedBox(height: ScreenUtil().setWidth(15))];
      Widget content;
      if (couponList.length != 0) {
        for (var item in couponList) {
          arr.add(Container(
            height: ScreenUtil().setWidth(310),
            margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(15),
            ),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(21),
              right: ScreenUtil().setWidth(21),
            ),
            child: Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(35),
                right: ScreenUtil().setWidth(35),
                top: ScreenUtil().setWidth(25),
                bottom: ScreenUtil().setWidth(25),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: type != 2
                      ? AssetImage("assets/shop/couponbg1.png")
                      : AssetImage("assets/shop/couponbg2.png"),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(200),
                            child: Text(
                              '￥${item['price']}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(50),
                                  fontWeight: FontWeight.w500,
                                  color: type == 2
                                      ? PublicColor.grewNoticeColor
                                      : Color(0xffea3636)),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(15)),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    // margin: EdgeInsets.only(
                                    //   top: ScreenUtil().setWidth(10),
                                    // ),
                                    child: Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(30),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(15),
                                              height: ScreenUtil().setWidth(15),
                                              decoration: new BoxDecoration(
                                                color:
                                                    PublicColor.grewNoticeColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(15))),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(5)),
                                            Text(
                                              '满${item['mini']}可用',
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(26),
                                                color:
                                                    PublicColor.grewNoticeColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(15),
                                              height: ScreenUtil().setWidth(15),
                                              decoration: new BoxDecoration(
                                                color:
                                                    PublicColor.grewNoticeColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(15))),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(5)),
                                            Text(
                                              '每人限领取${item['limit']}张',
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(26),
                                                color:
                                                    PublicColor.grewNoticeColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().setWidth(15),
                                          height: ScreenUtil().setWidth(15),
                                          decoration: new BoxDecoration(
                                            color: PublicColor.grewNoticeColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(15))),
                                          ),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(5)),
                                        Text(
                                          item['type'].toString() == "1"
                                              ? '全部商品'
                                              : '指定商品',
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(26),
                                            color: PublicColor.grewNoticeColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().setWidth(15),
                                          height: ScreenUtil().setWidth(15),
                                          decoration: new BoxDecoration(
                                            color: PublicColor.grewNoticeColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(15))),
                                          ),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(5)),
                                        Text(
                                          '开始时间 ',
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(26),
                                            color: PublicColor.grewNoticeColor,
                                          ),
                                        ),
                                        Text(
                                          ToTime.time(item['start_time']),
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(26),
                                            color: PublicColor.grewNoticeColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().setWidth(15),
                                          height: ScreenUtil().setWidth(15),
                                          decoration: new BoxDecoration(
                                            color: PublicColor.grewNoticeColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(15))),
                                          ),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(5)),
                                        Text(
                                          '结束时间 ',
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(26),
                                            color: PublicColor.grewNoticeColor,
                                          ),
                                        ),
                                        Text(
                                          ToTime.time(item['end_time']),
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(26),
                                            color: PublicColor.grewNoticeColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: "已领取 ",
                            style: TextStyle(
                              color: type == 2
                                  ? PublicColor.grewNoticeColor
                                  : Color(0xffea3636),
                              fontSize: ScreenUtil.instance.setSp(28.0),
                            ),
                            children: [
                              TextSpan(
                                text: item['have'],
                                style: TextStyle(
                                  color: PublicColor.textColor,
                                  fontSize: ScreenUtil.instance.setSp(28.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "已使用 ",
                            style: TextStyle(
                              color: type == 2
                                  ? PublicColor.grewNoticeColor
                                  : Color(0xffea3636),
                              fontSize: ScreenUtil.instance.setSp(28.0),
                            ),
                            children: [
                              TextSpan(
                                text: item['use'],
                                style: TextStyle(
                                  color: PublicColor.textColor,
                                  fontSize: ScreenUtil.instance.setSp(28.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "还剩余 ",
                            style: TextStyle(
                              color: type == 2
                                  ? PublicColor.grewNoticeColor
                                  : Color(0xffea3636),
                              fontSize: ScreenUtil.instance.setSp(28.0),
                            ),
                            children: [
                              TextSpan(
                                text: item['num'],
                                style: TextStyle(
                                  color: PublicColor.textColor,
                                  fontSize: ScreenUtil.instance.setSp(28.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        type == 2
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isDismissible: false,
                                      builder: (BuildContext context) {
                                        return ChangeNums(
                                          id: item['id'],
                                          couponNum: item['num'],
                                          getList: getList,
                                        );
                                      });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(120),
                                  height: ScreenUtil().setHeight(40),
                                  decoration: new BoxDecoration(
                                    color: PublicColor.themeColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(40))),
                                  ),
                                  child: Text(
                                    '增加张数',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(24),
                                      color: PublicColor.whiteColor,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
      }
      content = ListView(children: arr);
      return content;
    }

    return Stack(
      children: <Widget>[
        new DefaultTabController(
          length: typeList.length,
          child: new Scaffold(
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
                        padding: const EdgeInsets.only(right: 14.0, top: 15.0),
                        child: Text(
                          '+ 新增',
                          style: new TextStyle(
                            color: PublicColor.headerTextColor,
                            fontSize: ScreenUtil().setSp(35),
                          ),
                        )),
                    onTap: () {
                      NavigatorUtils.goAddCouponPage(context).then((res)=>getList());
                    },
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                        onTap: ((index) {
                          setState(() {
                            type = index;
                          });
                          getList();
                        }),
                        indicatorWeight: 4.0,
                        labelPadding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                        indicatorColor: PublicColor.themeColor,
                        unselectedLabelColor: Color(0xff5e5e5e),
                        labelColor: PublicColor.themeColor,
                        tabs: typeList.map((f) {
                          return Text(
                            f,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600),
                          );
                        }).toList()),
                  ),
                )),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: listBuild(),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
