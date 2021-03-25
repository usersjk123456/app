import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../api/api.dart';
import '../utils/serivice.dart';

class Quanxian extends StatefulWidget {
  @override
  QuanxianState createState() => QuanxianState();
}

class QuanxianState extends State<Quanxian> {
  bool isLoading = false;
  String jwt = '', balance = '0';
  List consumptionList = [];
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();
  TextEditingController bankidcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    _page++;
    if (_page == 1) {
      consumptionList = [];
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    Service().sget(Api.ZENGSONG_LIST_URL, map, (success) async {
      setState(() {
        isLoading = false;
        if (_page == 1) {
          //赋值
          consumptionList = success['list'];
        } else {
          if (success['list'].length == 0) {
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              consumptionList.insert(
                  consumptionList.length, success['list'][i]);
            }
          }
        }
        balance = success['user']['accountnum'].toString();
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  void zengsong() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("to_uid", () => bankidcontroller.text);
    Service().sget(Api.ZENGSONG_URL, map, (success) async {
      ToastUtil.showToast('赠送成功');
      setState(() {
        isLoading = false;
        bankidcontroller.text = "";
      });
      _page = 0;
      getList();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  // 列表项
  Container listItem(String date, String time, String toUid) {
    return new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20, right: 20),
        height: ScreenUtil().setWidth(91),
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: new Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    date,
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    time,
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    toUid,
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
      alignment: Alignment.center,
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: ScreenUtil().setWidth(111),
            width: ScreenUtil().setWidth(750),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
            ),
            child: new Row(
              children: <Widget>[
                Container(
                  child: Text(
                    '赠送权限名额 ',
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '($balance)',
                    style: TextStyle(
                      color: Color(0xffe92f2f),
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget searchWidget = Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
        top: ScreenUtil().setWidth(10),
        bottom: ScreenUtil().setWidth(10),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextField(
              controller: bankidcontroller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
              ),
              decoration: new InputDecoration(
                hintText: '请输入赠送播商ID',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xffa1a1a1)),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (bankidcontroller.text == "") {
                ToastUtil.showToast('请输入赠送播商ID');
                return;
              }
              zengsong();
            },
            child: Container(
              width: ScreenUtil().setWidth(147),
              height: ScreenUtil().setHeight(73),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: PublicColor.btnlinear,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "赠送",
                style: TextStyle(
                  color: PublicColor.btnColor,
                ),
              ),
            ),
          )
        ],
      ),
    );

    Widget tableHead = Container(
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: ScreenUtil().setWidth(91),
            width: ScreenUtil().setWidth(750),
            decoration: BoxDecoration(
              color: PublicColor.bodyColor,
            ),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '日期',
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '时间',
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ID号',
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (consumptionList.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Text(
            '没有更多了',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold),
          ),
        ));
      } else {
        for (var item in consumptionList) {
          arr.add(listItem(
            item['day'].toString(),
            item['time'].toString(),
            item['to_uid'].toString(),
          ));
        }
      }
      content = ListView(
        children: arr,
      );
      return content;
    }

    Widget withdrawList = Container(
      child: EasyRefresh(
        controller: _controller,
        header: BezierCircleHeader(
          backgroundColor: Color(0xfffffd302),
        ),
        footer: BezierBounceFooter(
          backgroundColor: Color(0xfffffd302),
        ),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: false,
        onRefresh: () async {
          _page = 0;
          getList();
        },
        onLoad: () async {
          if (_page * 10 > consumptionList.length) {
            return;
          }
          getList();
        },
        child: listArea(),
      ),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '权限赠送',
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
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                topArea,
                searchWidget,
                tableHead,
                Expanded(flex: 1, child: withdrawList)
              ],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
