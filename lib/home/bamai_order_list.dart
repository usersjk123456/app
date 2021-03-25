import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/loading.dart';
import '../utils/toast_util.dart';

import '../common/color.dart';
import '../home/bamai_product.dart';
import '../api/api.dart';
import '../utils/serivice.dart';

class BaiMaiOrderList extends StatefulWidget {
  @override
  _BaiMaiOrderListState createState() => _BaiMaiOrderListState();
}

class _BaiMaiOrderListState extends State<BaiMaiOrderList>
    with TickerProviderStateMixin {
  bool isloading = false, isLive = false, isStore = false;
  EasyRefreshController _controller = EasyRefreshController();
  int _page = 0;
  List listView = [];
  @override
  void initState() {
    super.initState();
    _page = 0;
    getList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getList() async {
    _page++;
    if (_page == 1) {
      listView = [];
    }
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    Service().sget(Api.BAMAI_INDEX_URL, map, (success) async {
      setState(() {
        isloading = false;
        if (_page == 1) {
          //赋值
          listView = success['goods'];
        } else {
          if (success['goods'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['goods'].length; i++) {
              listView.insert(listView.length, success['goods'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // 列表部分
    Widget listBox() {
      return listView.length == 0
          ? Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(50),
                bottom: ScreenUtil().setWidth(50),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/zhibo/zanwuzhibo_bg.png',
                width: ScreenUtil().setWidth(258),
              ),
            )
          : ProductView(listView);
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              "拼团订单",
              style: TextStyle(
                color: PublicColor.headerTextColor,
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
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
          ),
          backgroundColor: PublicColor.bodyColor,
          body: EasyRefresh(
            controller: _controller,
            header: BezierCircleHeader(
              backgroundColor: PublicColor.themeColor,
            ),
            footer: BezierBounceFooter(
              backgroundColor: PublicColor.themeColor,
            ),
            enableControlFinishRefresh: true,
            enableControlFinishLoad: false,
            child: listView.length > 0
                ? SingleChildScrollView(
                    child: listBox(),
                  )
                : Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(250)),
                    child: Text(
                      '暂无数据',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(35),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            onRefresh: () async {
              _page = 0;
              getList();
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 1), () {
                getList();
              });
            },
          ),
        ),
        isloading ? LoadingDialog() : Container(),
      ],
    );
  }
}
