import 'package:client/config/navigator_util.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:client/widgets/no_data.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../service/home_service.dart';
import '../widgets/loading.dart';

class CollectPage extends StatefulWidget {
  final String couponStr;
  CollectPage({this.couponStr});
  @override
  CollectPageState createState() => CollectPageState();
}

class CollectPageState extends State<CollectPage> {
  bool btnActive = false;
  bool isLoading = true;
  String jwt = '', code = '';
  List jingxuanlist = [], notTackList = [], wdlist = [];
  final contentcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  int type = 1; // 分类

  @override
  void initState() {
    super.initState();
    getList();
    getList1();
    getList2();
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    jingxuanlist = [];
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 1);

    HomeServer().getSCList(map, (success) async {
      setState(() {
        isLoading = false;
        jingxuanlist = success['list'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void getList1() async {
    setState(() {
      isLoading = true;
    });
    notTackList = [];
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 2);

    HomeServer().getSCList(map, (success) async {
      setState(() {
        isLoading = false;
        notTackList = success['list'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void getList2() async {
    setState(() {
      isLoading = true;
    });
    wdlist = [];
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 3);

    HomeServer().getSCList(map, (success) async {
      setState(() {
        isLoading = false;
        wdlist = success['list'];
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

    Widget jingxuan() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (jingxuanlist.length == 0) {
        arr.add(NoData(deHeight: 150));
      } else {
        for (var item in jingxuanlist) {
          arr.add(Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
                onTap: () {
                  print(item);
                  String oid = (item['id']).toString();
                  // NavigatorUtils.toXiangQing(context, oid, '0', '0')
                  //     .then((res) {
                  //   getList();
                  // });
                  NavigatorUtils.goFoodyuanzedetails(context, oid).then((res) {
                    getList();
                  });
                },
                child: Container(
                  color: Color(0xffffffff),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  //  RoundedRectangleBorder(
                  //       borderRadius:
                  //           BorderRadius.all(Radius.circular(5.0))), //设置圆角
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ScreenUtil().setWidth(16),
                        ),
                        CachedImageView(
                            ScreenUtil.instance.setWidth(86.0),
                            ScreenUtil.instance.setWidth(86.0),
                            item['img'],
                            null,
                            BorderRadius.all(Radius.circular(50))),
                        SizedBox(
                          width: ScreenUtil().setWidth(40),
                        ),
                        Container(
                            width: ScreenUtil().setWidth(400),
                            child: Text(
                              item['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            )),
                      ]),
                )),
          ));
        }
        // }

      }
      content = new ListView(
        children: arr,
      );
      return content;
    }

    //食谱
    Widget notTack() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (notTackList.length == 0) {
        arr.add(NoData(deHeight: 150));
      } else {
        for (var item in notTackList) {
          arr.add(Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
                onTap: () {
                  print(item);
                  String oid = (item['id']).toString();
                  NavigatorUtils.goFoodDetails(context, oid).then((res) {
                    getList1();
                  });

                  // NavigatorUtils.goLiveStore(context, oid).then((res) {
                  //   // getList(2);
                  // });
                },
                child: Container(
                  color: Color(0xffffffff),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ScreenUtil().setWidth(16),
                        ),
                        CachedImageView(
                            ScreenUtil.instance.setWidth(86.0),
                            ScreenUtil.instance.setWidth(86.0),
                            item['img'],
                            null,
                            BorderRadius.all(Radius.circular(50))),
                        SizedBox(
                          width: ScreenUtil().setWidth(40),
                        ),
                        Container(
                            width: ScreenUtil().setWidth(400),
                            child: Text(
                              item['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            )),
                      ]),
                )),
          ));
        }
      }
      content = new ListView(
        children: arr,
      );
      return content;
    }

    //百科
    Widget baike() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (wdlist.length == 0) {
        arr.add(NoData(deHeight: 150));
      } else {
        for (var item in wdlist) {
          arr.add(Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
                onTap: () {
                  print(item);
                  String oid = (item['id']).toString();

                  // NavigatorUtils.goLiveStore(context, oid).then((res) {
                  //   // getList(2);
                  // });
                  NavigatorUtils.goWikidetails(context, oid).then((res) {
                    getList2();
                  });
                },
                child: Container(
                  color: Color(0xffffffff),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20)),
                            child: Text(
                              item['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            )),
                        // Container(
                        //     child: Text(
                        //   item['text'],
                        //   style: TextStyle(
                        //     color: Color(0xff666666),
                        //     fontSize: ScreenUtil().setSp(26),
                        //   ),
                        // )),
                      ]),
                )),
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
          length: 3,
          child: new Scaffold(
            backgroundColor: Color(0xfff5f5f5),
            appBar: new AppBar(
                title: new Text(
                  '我的收藏',
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
                            '辅食知识',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        new Tab(
                          child: Text(
                            '食谱',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        new Tab(
                          child: Text(
                            '百科',
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
                        // getList(index + 1);
                      }),
                    ),
                  ),
                )),
            body:
                // isLoading
                //     ? LoadingDialog()
                //     :
                new TabBarView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: jingxuan(),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: notTack(),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: baike(),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
