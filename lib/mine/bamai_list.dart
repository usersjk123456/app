import 'package:client/config/Navigator_util.dart';
import 'package:client/widgets/cached_image.dart';
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

class BmOrderPage extends StatefulWidget {
  @override
  BmOrderListState createState() => BmOrderListState();
}

class BmOrderListState extends State<BmOrderPage>
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
    Service().sget(Api.BAMAI_LIST_URL, map, (success) async {
      setState(() {
        isloading = false;
        if (_page == 1) {
          //赋值
          listView = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              listView.insert(listView.length, success['list'][i]);
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
    List<Widget> listBoxs(listView, listindex, itemType) =>
        List.generate(listView.length, (index) {
          return Container(
              width: ScreenUtil.instance.setWidth(700),
              height: ScreenUtil.instance.setWidth(245),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border(
                  top: BorderSide(color: Color(0xfffececec), width: 1),
                ),
              ),
              child: new InkWell(
                child: new Row(
                  children: <Widget>[
                    new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                    CachedImageView(
                        ScreenUtil.instance.setWidth(204.0),
                        ScreenUtil.instance.setWidth(204.0),
                        listView[index]['img'],
                        null,
                        BorderRadius.all(Radius.circular(0))),
                    new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                    Container(
                      width: ScreenUtil.instance.setWidth(420.0),
                      height: ScreenUtil.instance.setWidth(204.0),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new SizedBox(
                                height: ScreenUtil.instance.setWidth(10.0)),
                            Text(
                              listView[index]['goods_name'],
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil.instance.setWidth(25.0),
                              ),
                            ),
                            new SizedBox(
                              height: ScreenUtil.instance.setWidth(10.0),
                            ),
                            Text(
                              listView[index]['specs_name'],
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil.instance.setWidth(25.0),
                              ),
                            ),
                            new Row(children: [
                              Expanded(
                                child: Container(
                                  height: ScreenUtil.instance.setWidth(75.0),
                                  alignment: Alignment.bottomLeft,
                                  child: RichText(
                                    text: TextSpan(
                                        text:
                                            '￥${listView[index]['now_price']} ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: ScreenUtil.instance
                                                .setWidth(27.0)),
                                        children: itemType != '2'
                                            ? [
                                                TextSpan(
                                                    text:
                                                        "/赚￥${listView[index]['commission']}",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: ScreenUtil
                                                            .instance
                                                            .setWidth(27.0))),
                                              ]
                                            : []),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                  child: Container(
                                    height: ScreenUtil.instance.setWidth(75.0),
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "x${listView[index]['num']}",
                                      style: TextStyle(
                                          color: Color(0xfffcccccc),
                                          fontSize: ScreenUtil.instance
                                              .setWidth(27.0)),
                                    ),
                                  ),
                                  flex: 1),
                            ])
                          ]),
                    )
                  ],
                ),
                onTap: () {
                  print(listView[index]['bamaistate']);
                  if (listView[index]['bamaistate'] == 0) {
                    ToastUtil.showToast('下架不能参团，请选择其他产品拼团');
                  } else {
                    NavigatorUtils.toBaMaiXiangQing(
                        context, listView[index]['goods_id'], "1");
                  }
                },
              ));
        });
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

    Widget gouwuitem(BuildContext context, listView) {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (listView.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ));
      } else {
        int index = 0;
        for (var item in listView) {
          index++;
          arr.add(
            Container(
              child: new Column(
                children: [
                  new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border:
                          new Border.all(color: Color(0xfffececec), width: 0.5),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: ScreenUtil.getInstance().setWidth(80.0),
                          padding: EdgeInsets.only(
                              right: ScreenUtil.instance.setWidth(20.0)),
                          child: Row(children: [
                            new SizedBox(
                                width: ScreenUtil.instance.setWidth(20.0)),
                            Image.asset(
                              'assets/index/dp2.png',
                              width: ScreenUtil.instance.setWidth(32.0),
                            ),
                            new SizedBox(
                                width: ScreenUtil.instance.setWidth(5.0)),
                            Text(
                              item['store_name'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil.instance.setWidth(26.0)),
                            ),
                            Expanded(
                              child: Container(
                                child: Text(item['pay_at'],
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(26.0))),
                                alignment: Alignment.centerRight,
                              ),
                              flex: 1,
                            )
                          ]),
                        ),
                        new Column(
                            children:
                                listBoxs(item['goods'], index, item['type'])),
                        Container(
                          height: ScreenUtil.getInstance().setWidth(150.0),
                          decoration: ShapeDecoration(
                            shape: Border(
                                top: BorderSide(
                                    color: Color(0xfffececec), width: 1.0)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                    '共 ${item['num']} 件商品 合计:￥${item['total']}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(28.0))),
                                alignment: Alignment.centerRight,
                                height: ScreenUtil.getInstance().setWidth(65.0),
                                padding: EdgeInsets.only(
                                    right: ScreenUtil.instance.setWidth(25.0)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
      content = new ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: arr,
      );
      return content;
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              "拼团下单记录",
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
                    child: gouwuitem(context, listView),
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
