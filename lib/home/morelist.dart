import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/cached_image.dart';
import '../widgets/loading.dart';
import '../utils/toast_util.dart';
import '../service/home_service.dart';
import '../config/Navigator_util.dart';
import '../common/color.dart';

class MoreList extends StatefulWidget {
  final String oid;
  MoreList({this.oid});
  @override
  MoreListState createState() => MoreListState();
}

class MoreListState extends State<MoreList>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  TabController tabController;
  EasyRefreshController _controller = EasyRefreshController();
  int _page = 0;
  List tabTitles = [];
  List listView = [];
  @override
  void initState() {
    super.initState();
    getTabList();
    _controller.finishRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    if (tabController != null) {
      tabController.dispose();
    }
  }

  void getTabList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);
    HomeServer().getFenleiList(map, (success) async {
      setState(() {
        tabTitles = success['children'];
      });
      this.tabController = TabController(
        length: tabTitles.length,
        vsync: this,
      );
      if (tabTitles.length != 0) {
        _page = 0;
        getList(0);
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getList(index) async {
    var id = tabTitles[index]['id'];
    _page++;
    if (_page == 1) {
      listView = [];
    }
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("type", () => 2);
    HomeServer().getGoodsList(map, (success) async {
      setState(() {
        isloading = false;
        if (_page == 1) {
          //赋值
          listView = success['goods'];
        } else {
          if (success['goods'].length == 0) {
            // // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['goods'].length; i++) {
              listView.insert(listView.length, success['goods'][i]);
            }
          }
        }
      });
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('分类'),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: PublicColor.headerTextColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Material(
                color: Colors.white,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: tabTitles.length == 0 ? Container() : tabBar(),
                ),
              ),
            ),
          ),
          body: isloading
              ? LoadingDialog()
              : EasyRefresh(
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
                      ? ListView.builder(
                          itemCount: listView.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: ScreenUtil.instance.setWidth(750),
                              height: ScreenUtil.instance.setWidth(255),
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil.instance.setWidth(30),
                                  ScreenUtil.instance.setWidth(0),
                                  ScreenUtil.instance.setWidth(30),
                                  0),
                              decoration: ShapeDecoration(
                                shape: Border(
                                  top: BorderSide(
                                      color: Color(0xfffececec), width: 1),
                                ), // 边色与边宽度
                                color: Colors.white,
                              ),
                              child: Row(
                                children: <Widget>[
                                  CachedImageView(
                                      ScreenUtil.instance.setWidth(204.0),
                                      ScreenUtil.instance.setWidth(204.0),
                                      listView[index]['thumb'],
                                      null,
                                      BorderRadius.all(Radius.circular(0))),
                                  SizedBox(
                                      width:
                                          ScreenUtil.instance.setWidth(20.0)),
                                  Container(
                                    width: ScreenUtil.instance.setWidth(466.0),
                                    height: ScreenUtil.instance.setWidth(204.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: ScreenUtil.instance
                                                  .setWidth(10.0)),
                                          Text(listView[index]['name'],
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: ScreenUtil.instance
                                                      .setWidth(25.0))),
                                          SizedBox(
                                              height: ScreenUtil.instance
                                                  .setWidth(5.0)),
                                          RichText(
                                            text: TextSpan(
                                                text: '￥' +
                                                    listView[index]['now_price']
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: ScreenUtil
                                                        .instance
                                                        .setWidth(27.0)),
                                                children: [
                                                  TextSpan(
                                                      text: '/赚￥' +
                                                          listView[index]
                                                                  ['commission']
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: ScreenUtil
                                                              .instance
                                                              .setWidth(27.0))),
                                                ]),
                                          ),
                                          Row(children: [
                                            Container(
                                              width: ScreenUtil.instance
                                                  .setWidth(266.0),
                                              height: ScreenUtil.instance
                                                  .setWidth(75.0),
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                '销量' +
                                                    listView[index]['buy_count']
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Color(0xfff9f9c9c),
                                                  fontSize: ScreenUtil.instance
                                                      .setWidth(24.0),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: ScreenUtil.instance
                                                  .setWidth(200.0),
                                              height: ScreenUtil.instance
                                                  .setWidth(75.0),
                                              alignment: Alignment.bottomRight,
                                              child: MaterialButton(
                                                color: Color(0xfffffd405),
                                                textColor: Colors.black,
                                                child: Text(
                                                  '立即抢购',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil
                                                        .instance
                                                        .setWidth(22.0),
                                                  ),
                                                ),
                                                height: ScreenUtil.instance
                                                    .setWidth(55.0),
                                                minWidth: ScreenUtil.instance
                                                    .setWidth(120.0),
                                                onPressed: () {
                                                  print('去详情');
                                                  var oid = listView[index]
                                                          ['id']
                                                      .toString();
                                                  NavigatorUtils.toXiangQing(
                                                    context,
                                                    oid,
                                                    '0',
                                                    '0',
                                                  );
                                                },
                                              ),
                                            )
                                          ])
                                        ]),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(250)),
                          child: Text(
                            '暂无数据',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(35),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                  onRefresh: () async {
                    _controller.finishRefresh();
                  },
                  onLoad: () async {
                    _controller.finishRefresh();
                  },
                ),
        ),
        // isloading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget tabBar() {
    return TabBar(
      controller: tabController,
      indicatorColor: PublicColor.themeColor,
      labelColor: PublicColor.themeColor,
      unselectedLabelColor: Colors.black,
      isScrollable: true,
      tabs: tabTitles.map((i) => Tab(text: i['name'])).toList(),
      unselectedLabelStyle:
          TextStyle(fontSize: ScreenUtil.instance.setWidth(30)),
      labelStyle: TextStyle(fontSize: ScreenUtil.instance.setWidth(30)),
      onTap: ((index) {
        _page = 0;
        getList(index);
      }),
    );
  }
}
