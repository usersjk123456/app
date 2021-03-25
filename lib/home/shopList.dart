import 'package:client/config/fluro_convert_util.dart';
import 'package:client/widgets/base_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/loading.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/home_service.dart';
import '../service/user_service.dart';
import '../common/color.dart';

class ShopList extends StatefulWidget {
  final String oid;
  final String name;
  final String type;

  ShopList({this.oid, this.name, this.type});

  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList>
    with SingleTickerProviderStateMixin {
  bool isloading = false, isLive = false, isStore = false;
  EasyRefreshController _controller = EasyRefreshController();
  int _page = 0;
  List tabTitles = [];
  List listView = [];
  String sateId = '';
  String jwt = '', sort = '';
  String name = '分类';

  @override
  void initState() {
    super.initState();

    getLocal();
    _page = 0;
    getList(0);
    _controller.finishRefresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString('jwt');
      name = FluroConvertUtils.fluroCnParamsDecode(widget.name);
    });
    if (jwt != null) {
      getInfo();
    }
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          isLive = success['is_live'].toString() == "0" ? false : true;
          isStore = success['is_store'].toString() == "0" ? false : true;
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getList(sort) async {
    _page++;
    if (_page == 1) {
      listView = [];
    }
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);
    map.putIfAbsent("type", () => widget.type);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("sort", () => sort);
    HomeServer().getGoodsList(map, (success) async {
      setState(() {
        isloading = false;
        if (_page == 1) {
          //赋值
          listView = success['goods'];
        } else {
          if (success['goods'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            var idValues = listView.map((e) => e["id"]).toSet();
            List goods = success['goods'];
            var noteRepeatGoods = goods
                .where((element) => !idValues.contains(element['id']))
                .toList();
            listView.addAll(noteRepeatGoods);
          }
        }
      });
      // _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  // 上架、下家
  void upDown(index, isUp) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => listView[index]['id']);
    map.putIfAbsent("is_up", () => isUp);
    HomeServer().upGoods(map, (success) async {
      if (isUp == "0") {
        ToastUtil.showToast('下架成功');
        setState(() {
          listView[index]['isup'] = 0;
        });
      } else {
        ToastUtil.showToast('上架成功');
        setState(() {
          listView[index]['isup'] = 1;
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              name,
              style: TextStyle(
                color: PublicColor.headerTextColor,
              ),
            ),
            leading: new IconButton(
              icon: Icon(Icons.navigate_before,
                  color: PublicColor.headerTextColor),
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
          body: listView.length > 0
              ? Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    EasyRefresh(
                      controller: _controller,
                      header: BezierCircleHeader(
                        backgroundColor: PublicColor.themeColor,
                      ),
                      footer: BezierBounceFooter(
                        backgroundColor: PublicColor.themeColor,
                      ),
                      enableControlFinishRefresh: true,
                      enableControlFinishLoad: false,
                      onRefresh: () async {
                        _page = 0;
                        getList(sort);
                      },
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 1), () {
                          getList(sort);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil.instance.setWidth(100.0)),
                        color: Color(0xff666666),
                        child: new ListView.builder(
                          itemCount: listView.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                var oid = listView[index]['id'].toString();
                                NavigatorUtils.toXiangQing(
                                    context, oid, '0', '0');
                              },
                              child: Container(
                                width: ScreenUtil.instance.setWidth(750),
                                padding: EdgeInsets.fromLTRB(
                                  ScreenUtil.instance.setWidth(30),
                                  ScreenUtil.instance.setWidth(30),
                                  ScreenUtil.instance.setWidth(30),
                                  ScreenUtil.instance.setWidth(30),
                                ),
                                decoration: new ShapeDecoration(
                                  shape: Border(
                                    top: BorderSide(
                                        color: Color(0xfffececec), width: 1),
                                  ), // 边色与边宽度
                                  color: Colors.white,
                                ),
                                child: new Row(
                                  children: <Widget>[
                                    Container(
                                        height:
                                            ScreenUtil.instance.setWidth(204.0),
                                        width:
                                            ScreenUtil.instance.setWidth(204.0),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              listView[index]['thumb'],
                                              width: ScreenUtil().setWidth(204),
                                              fit: BoxFit.fitWidth,
                                            ),
                                            _buildEmptyStockHint(
                                                listView[index])
                                          ],
                                        )),
                                    SizedBox(
                                      width: ScreenUtil.instance.setWidth(20.0),
                                    ),
                                    Container(
                                        width:
                                            ScreenUtil.instance.setWidth(466.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: ScreenUtil.instance
                                                    .setWidth(10.0),
                                              ),
                                              Text(
                                                listView[index]['name'],
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil.instance
                                                      .setWidth(28.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: ScreenUtil.instance
                                                    .setWidth(5.0),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: '¥' +
                                                        listView[index]
                                                                ['now_price']
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: ScreenUtil
                                                            .instance
                                                            .setWidth(27.0)),
                                                    /*children: listView[index]['type'].toString() != '7' ? [
                                                            TextSpan(
                                                              text: '/赚¥' +
                                                                  listView[index]
                                                                          [
                                                                          'commission']
                                                                      .toString(),
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: ScreenUtil
                                                                    .instance
                                                                    .setWidth(
                                                                        27.0),
                                                              ),
                                                            ),
                                                          ]
                                                        : []*/),
                                              ),
                                              /*Container(
                                                alignment: Alignment.bottomLeft,
                                                margin: EdgeInsets.only(
                                                    top: ScreenUtil()
                                                        .setWidth(10)),
                                                child: Text(
                                                  '销量' +
                                                      listView[index]
                                                              ['buy_count']
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Color(0xfff9f9c9c),
                                                    fontSize: ScreenUtil
                                                        .instance
                                                        .setWidth(24.0),
                                                  ),
                                                ),
                                              ),*/
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  /*!isLive && !isStore
                                                      ? Container()
                                                      : InkWell(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: ScreenUtil
                                                                .instance
                                                                .setWidth(
                                                                    150.0),
                                                            height: ScreenUtil
                                                                .instance
                                                                .setWidth(60.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: new Border
                                                                  .all(
                                                                color: PublicColor
                                                                    .themeColor,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5.0)),
                                                            ),
                                                            child: Text(
                                                              listView[index][
                                                                          'isup'] ==
                                                                      0
                                                                  ? '上架商品'
                                                                  : '下架商品',
                                                              style: TextStyle(
                                                                color: PublicColor
                                                                    .themeColor,
                                                                fontSize:
                                                                    ScreenUtil
                                                                        .instance
                                                                        .setWidth(
                                                                            26),
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            if (listView[index]
                                                                    ['isup'] ==
                                                                0) {
                                                              sateId = '1';
                                                            }

                                                            if (listView[index]
                                                                    ['isup'] ==
                                                                1) {
                                                              sateId = '0';
                                                            }

                                                            if (jwt == null) {
                                                              ToastUtil
                                                                  .showToast(
                                                                      '请先登录');
                                                            } else {
                                                              if (!isStore &&
                                                                  !isLive) {
                                                                ToastUtil.showToast(
                                                                    '您没有权限上架商品');
                                                              } else {
                                                                // 可以上架商品
                                                                upDown(index,
                                                                    sateId);
                                                              }
                                                            }
                                                          },
                                                        ),*/
                                                  Container(
                                                    width: ScreenUtil.instance
                                                        .setWidth(200.0),
                                                    height: ScreenUtil.instance
                                                        .setWidth(75.0),
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: MaterialButton(
                                                      color: PublicColor
                                                          .themeColor,
                                                      textColor: PublicColor
                                                          .btnTextColor,
                                                      child: new Text(
                                                        '立即抢购',
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil
                                                              .instance
                                                              .setWidth(22.0),
                                                        ),
                                                      ),
                                                      height: ScreenUtil
                                                          .instance
                                                          .setWidth(55.0),
                                                      minWidth: ScreenUtil
                                                          .instance
                                                          .setWidth(120.0),
                                                      onPressed: () {
                                                        print('去详情');
                                                        var oid =
                                                            listView[index]
                                                                    ['id']
                                                                .toString();
                                                        NavigatorUtils
                                                            .toXiangQing(
                                                                context,
                                                                oid,
                                                                '0',
                                                                '0');
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // ),
                    ),
                    Container(
                      height: ScreenUtil().setWidth(100),
                      width: ScreenUtil().setWidth(750),
                      color: PublicColor.bodyColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                gradient: PublicColor.btnlinear,
                              ),
                              child: Text(
                                '默认',
                                style:
                                    TextStyle(color: PublicColor.btnTextColor),
                              ),
                            ),
                            onTap: () {
                              listView = [];
                              sort = '0';
                              // getLocal();
                              _page = 0;

                              // _controller.finishRefresh();
                              getList(sort);
                            },
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                gradient: PublicColor.btnlinear,
                              ),
                              child: Text(
                                '利润 ↓', //利润又高到低
                                style:
                                    TextStyle(color: PublicColor.btnTextColor),
                              ),
                            ),
                            onTap: () {
                              listView = [];
                              sort = '3';
                              // getLocal();
                              _page = 0;

                              // _controller.finishRefresh();
                              getList(sort);
                            },
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                gradient: PublicColor.btnlinear,
                              ),
                              child: Text(
                                '利润 ↑', //利润由低到高
                                style:
                                    TextStyle(color: PublicColor.btnTextColor),
                              ),
                            ),
                            onTap: () {
                              listView = [];
                              sort = '4';
                              // getLocal();
                              _page = 0;

                              // _controller.finishRefresh();
                              getList(sort);
                            },
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                gradient: PublicColor.btnlinear,
                              ),
                              child: Text(
                                '价格 ↑', //价格由低到高
                                style:
                                    TextStyle(color: PublicColor.btnTextColor),
                              ),
                            ),
                            onTap: () {
                              listView = [];
                              sort = '2';
                              // getLocal();
                              _page = 0;

                              // _controller.finishRefresh();
                              getList(sort);
                            },
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                                ScreenUtil.instance.setWidth(20),
                                ScreenUtil.instance.setWidth(10),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                gradient: PublicColor.btnlinear,
                              ),
                              child: Text(
                                '价格 ↓', //价格由高到低
                                style:
                                    TextStyle(color: PublicColor.btnTextColor),
                              ),
                            ),
                            onTap: () {
                              listView = [];
                              sort = '1';
                              // getLocal();
                              _page = 0;

                              // _controller.finishRefresh();
                              getList(sort);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  // margin: EdgeInsets.only(top: ScreenUtil().setHeight(250)),
                  child: Text(
                    '暂无数据',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
        isloading ? LoadingDialog() : Container(),
      ],
    );
  }

  Widget _buildEmptyStockHint(Map<String, dynamic> value) {
    num stock = num.tryParse(value['stock']);
    if (stock > 0) {
      return Container();
    }
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: BaseText("补货中", color: Colors.white),
        ),
      ),
    );
  }
}
