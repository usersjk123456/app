import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/store_service.dart';

class ZjGuanliPage extends StatefulWidget {
  @override
  ZjGuanliPageState createState() => ZjGuanliPageState();
}

class ZjGuanliPageState extends State<ZjGuanliPage> {
  bool isLoading = false;
  String jwt = '',
      nickname = '',
      balance = '',
      headimgurl = '',
      todayYg = '',
      daijiesuan = '',
      jinridingdancount = '',
      id = '';
  List addressList = [];

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();

    StoreServer().getHome(map, (success) {
      if (mounted) {
        setState(() {
          headimgurl = success['user']['headimgurl'];
          nickname = success['user']['nickname'];
          balance = success['user']['balance'];
          id = success['user']['id'].toString();
          todayYg = success['today'].toString();
          daijiesuan = success['daijiesuan'].toString();
          jinridingdancount = success['jinridingdancount'].toString();
        });
      }
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: new Text(
                  '资金管理',
                  style: new TextStyle(color: PublicColor.headerTextColor),
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setWidth(20),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(750),
                      height: ScreenUtil().setWidth(193),
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(50),
                        bottom: ScreenUtil().setWidth(45),
                      ),
                      color: Color(0xffffffff),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '余额(元)',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color(0xff4F4F4F),
                            ),
                          ),
                          Text(
                            '$balance',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(46),
                              color: Color(0xffFB1419),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(20),
                    ),
                    Container(
                      height: ScreenUtil().setWidth(187),
                      width: ScreenUtil().setWidth(750),
                      color: Color(0xffffffff),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  '今日预估',
                                  style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                )),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      todayYg,
                                      style: TextStyle(
                                          color: Color(0xff4f4f4f),
                                          fontSize: ScreenUtil().setSp(28),
                                          fontWeight: FontWeight.w600),
                                    ))
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  '待结算金额',
                                  style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                )),
                                Container(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(10)),
                                    child: Text(
                                      daijiesuan,
                                      style: TextStyle(
                                          color: Color(0xff4f4f4f),
                                          fontSize: ScreenUtil().setSp(28),
                                          fontWeight: FontWeight.w600),
                                    ))
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  '今日订单数',
                                  style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                )),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      jinridingdancount,
                                      style: TextStyle(
                                          color: Color(0xff4f4f4f),
                                          fontSize: ScreenUtil().setSp(28),
                                          fontWeight: FontWeight.w600),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
