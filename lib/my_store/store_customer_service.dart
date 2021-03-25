import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../widgets/cached_image.dart';
import '../service/store_service.dart';
import '../config/Navigator_util.dart';

class StoreCustomerServicePage extends StatefulWidget {
  @override
  _StoreCustomerServicePageState createState() =>
      _StoreCustomerServicePageState();
}

class _StoreCustomerServicePageState extends State<StoreCustomerServicePage> {
  bool isLoading = false;
  String jwt = '';
  List afterList = [];
  int type = 1;
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      _page = 0;
      getList();
    }
  }

  void getList() async {
    _page++;
    if (_page == 1) {
      afterList = [];
    }

    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    StoreServer().getStoreAfterList(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          afterList = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              afterList.insert(afterList.length, success['list'][i]);
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

//全部
  Widget allItem() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (afterList.length == 0) {
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
      for (var item in afterList) {
        arr.add(Container(
          child: new Column(children: <Widget>[
            new InkWell(
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: ScreenUtil().setWidth(700),
                  height: ScreenUtil().setHeight(270),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: new Column(children: <Widget>[
                    Container(
                        child: new Row(children: <Widget>[
                      // Expanded(
                      //   // flex: 1,
                      //   child: Container(
                      //     height: ScreenUtil().setWidth(32),
                      //     width: ScreenUtil().setWidth(32),
                      //     alignment: Alignment.centerLeft,
                      //     child: Image.asset(
                      //       'assets/mine/dp.png',
                      //       height: ScreenUtil().setWidth(32),
                      //       width: ScreenUtil().setWidth(32),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   flex: 9,
                      //   child: Text(
                      //     item['store_name'],
                      //     style: TextStyle(
                      //         color: Color(0xff454545),
                      //         fontSize: ScreenUtil().setSp(28),
                      //         fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      Expanded(
                        flex: 3,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              item['after_status'] == "1"
                                  ? '未审核'
                                  : item['after_status'] == "2"
                                      ? '审核通过'
                                      : item['after_status'] == "3"
                                          ? '审核拒绝'
                                          : item['after_status'] == "4" &&
                                                  item['after_type'] == "1"
                                              ? '买家退货'
                                              : item['after_status'] == "5"
                                                  ? '已退款'
                                                  : '已完成',
                              style: TextStyle(
                                color: item['after_status'] == "6"
                                    ? Color(0xffa0a0a0)
                                    : item['after_status'] == "1"
                                        ? Color(0xffe61414)
                                        : Color(0xff454545),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            )),
                      )
                    ])),
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        // height: ScreenUtil().setHeight(150),
                        child: new Row(children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: Container(
                              child: new Column(
                                children: <Widget>[
                                  CachedImageView(
                                      ScreenUtil.instance.setWidth(170.0),
                                      ScreenUtil.instance.setWidth(170.0),
                                      item['img'],
                                      null,
                                      BorderRadius.all(Radius.circular(10.0))),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    width: ScreenUtil().setWidth(500),
                                    child: Text(
                                      item['goods_name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(28),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    width: ScreenUtil().setWidth(500),
                                    child: Text(
                                      item['specs_name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(28),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(20)),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: new Row(children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            '￥',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(26),
                                                color: Color(0xffe61414),
                                                fontWeight: FontWeight.w600),
                                          )),
                                      Expanded(
                                          flex: 8,
                                          child: Text(
                                            item['now_price'],
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                                color: Color(0xffe61414),
                                                fontWeight: FontWeight.w600),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'X' + item['num'],
                                              style: TextStyle(
                                                color: Color(0xffa0a0a0),
                                                fontSize:
                                                    ScreenUtil().setSp(28),
                                              ),
                                            )),
                                      )
                                    ]),
                                  )
                                ]),
                          )
                        ]))
                  ])),
              onTap: () {
                NavigatorUtils.goStoreCustomerDetailsPage(context, item['id']);
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        new DefaultTabController(
          length: 4,
          child: new Scaffold(
            appBar: new AppBar(
                elevation: 0,
                title: new Text(
                  '售后列表',
                  style: TextStyle(
                    color: PublicColor.headerTextColor,
                  ),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: PublicColor.linearHeader,
                  ),
                ),

                centerTitle: true,
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
                        labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                        // indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: PublicColor.themeColor,
                        unselectedLabelColor: Color(0xff5e5e5e),
                        labelColor: PublicColor.themeColor,
                        onTap: (index) {
                          type = index + 1;
                          _page = 0;
                          getList();
                        },
                        tabs: <Widget>[
                          new Tab(
                            child: Text(
                              '全部',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '未审核',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '未退款',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '已完成',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ]),
                  ),
                )),
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
              child: allItem(),
              onRefresh: () async {
                _page = 0;
                getList();
              },
              onLoad: () async {
                getList();
              },
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
