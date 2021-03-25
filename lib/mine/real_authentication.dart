import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/user_service.dart';
import '../common/Global.dart';

class RealAuthenticationPage extends StatefulWidget {
  @override
  RealAuthenticationPageState createState() => RealAuthenticationPageState();
}

class RealAuthenticationPageState extends State<RealAuthenticationPage> {
  String jwt = '';
  bool isLoading = true;
  List list = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    UserServer().realNameList(map, (success) async {
      setState(() {
        list = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget inforArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (list.length == 0) {
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
        for (var item in list) {
          arr.add(Container(
            child: new Column(children: <Widget>[
              new InkWell(
                child: new Container(
                    margin: EdgeInsets.only(top: 10),
                    width: ScreenUtil().setWidth(700),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffe5e5e5), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text(
                                item['real_name'],
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                Global.formatIdCard(item['id_card'].toString()),
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(30)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                item['is_default'] == "1".toString()
                                    ? '默认'
                                    : '',
                                style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: new Container(
                                  alignment: Alignment.centerRight,
                                  child: new Icon(
                                    Icons.navigate_next,
                                    color: Color(0xff999999),
                                  ),
                                )),
                          ],
                        ),
                        Text(
                          item['is_check'] == "0"
                              ? "待审核"
                              : item['is_check'] == "1" ? "审核通过" : "审核拒绝",
                          style: TextStyle(
                            color: PublicColor.themeColor,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        )
                      ],
                    )),
                onTap: () {
                  NavigatorUtils.toRealDetailPage(context, item)
                      .then((res) => getList());
                },
              )
            ]),
          ));
        }
      }
      content = new ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: arr,
      );
      return content;
    }

    return MaterialApp(
        title: "实名认证",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '实名认证',
              style: new TextStyle(color: PublicColor.headerTextColor),
            ),
            backgroundColor: Color(0xffffffff),
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
                    padding: const EdgeInsets.only(right: 14.0, top: 5),
                    child: Text(
                      '新增',
                      style: new TextStyle(
                        color: PublicColor.headerTextColor,
                        fontSize: ScreenUtil().setSp(28),
                        height: 2.7,
                      ),
                    )),
                onTap: () {
                  NavigatorUtils.toRealDetailPage(context)
                      .then((res) => getList());
                },
              )
            ],
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // inforArea
                inforArea()
              ],
            ),
          ),
        ));
  }
}
