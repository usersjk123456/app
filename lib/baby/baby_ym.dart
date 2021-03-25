import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/dialog.dart';
import '../service/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class YiMiaoPage extends StatefulWidget {
  final String id;
  YiMiaoPage({this.id});
  @override
  YiMiaoPageState createState() => YiMiaoPageState();
}

class YiMiaoPageState extends State<YiMiaoPage> {
  bool isLoading = false;
  String jwt = '', id = '', addressId = "";
  List addressList = [], wdlist = [];
  String beginTime = '';
  String hintText = '请设置接种日期';
  DateTime beginDate;
  String endTime = '';
  DateTime endDate;
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();

    getLocal();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    getList();
  }

  // @override
  // void deactivate() {
  //   //刷新页面
  //   super.deactivate();
  //   var bool = ModalRoute.of(context).isCurrent;
  //   if (bool) {
  //     getList();
  //   }
  // }

  void getList() async {
    _page++;
    if (_page == 1) {
      wdlist = [];
    }

    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id = prefs.getString('id'));
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);

    UserServer().getYmList(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          wdlist = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              wdlist.insert(wdlist.length, success['list'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  void deleteAddrss() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => addressId);
    UserServer().delAddress(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('删除成功');
      getList();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget deleDjango(context) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        deleteAddrss();
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: '确定删除该地址吗？',
    );
  }

  InkWell buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        color: color,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }

  weeklist(item) {
    List<Widget> list = [];

    for (var data in item['data']) {
      if (item['data'].length <= 0) {
        list.add(Container(
            child: Text(
          '暂无数据',
        )));
      } else {
        list.add(
          InkWell(
            onTap: () {
              if (data['is_inoculation'] == 0) {
                String oid = data['id'].toString();
                String name = data['title'].toString();
                String time = data['create_at'].toString();
                String desc = data['desc'].toString();
                wdlist = [];
                NavigatorUtils.goYmDetail(context, oid, name, time, desc)
                    .then((res) {
                  setState(() {
                    _page = 0;
                  });
                  getLocal();
                });
              }
            },
            child: Container(
              width: ScreenUtil().setWidth(700),
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(38),
                bottom: ScreenUtil().setWidth(38),
              ),
              // height: ScreenUtil().setWidth(95),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                border: Border(
                  bottom: BorderSide(
                    width: ScreenUtil().setWidth(1),
                    color: Color(0xffD5D5D5),
                  ),
                ),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data['title'],
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                      data['create_at'] == ''
                          ? InkWell(
                              child: Text(
                                hintText,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Color(0xffA2BD52),
                                    fontSize: ScreenUtil().setSp(30)),
                              ),
                              onTap: () {},
                            )
                          : Container(),
                    ],
                  ),
                  data['is_inoculation'] == 0
                      ? Container(
                          height: ScreenUtil().setWidth(52),
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(24),
                            right: ScreenUtil().setWidth(24),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: PublicColor.themeColor,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              )),
                          child: Text(
                            '未接种',
                            style: TextStyle(
                                color: PublicColor.themeColor,
                                fontSize: ScreenUtil().setSp(28)),
                          ),
                        )
                      : Text(
                          '已接种',
                          style: TextStyle(
                              color: Color(0xff999999),
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return list;
  }

  Widget getSlides() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (wdlist.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in wdlist) {
        arr.add(Container(
          child: Column(
            children: <Widget>[
              item['data'].length <= 0
                  ? Container()
                  : Container(
                      alignment: Alignment.centerLeft,
                      height: ScreenUtil().setWidth(81),
                      child: Text(item['title']),
                    ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weeklist(item),
              ),
            ],
          ),
        ));
      }
    }
    content = new Column(
      children: arr,
    );
    return content;
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
                '疫苗接种',
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
              actions: <Widget>[
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.only(right: 14.0, top: 15),
                    child: Text(
                      '添加',
                      style: new TextStyle(
                        color: PublicColor.headerTextColor,
                        fontSize: ScreenUtil().setSp(30),
                      ),
                    ),
                  ),
                  onTap: () {
                    wdlist = [];
                    NavigatorUtils.goAddYmPage(context).then((res) {
                      setState(() {
                        _page = 0;
                      });
                      getLocal();
                    });
                  },
                )
              ],
            ),
            body: new Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: new ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getSlides(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
