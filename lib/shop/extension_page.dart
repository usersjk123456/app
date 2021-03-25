import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/cached_image.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/store_service.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';

class ExtensionPage extends StatefulWidget {
  @override
  ExtensionPageState createState() => ExtensionPageState();
}

class ExtensionPageState extends State<ExtensionPage> {
  bool isLoading = false;
  int _page = 0;
  String jwt = "";
  List listview = [];
  int clickIndex = 0;
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      _page = 0;
      getList(clickIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    getList(clickIndex);
  }

  void getList(clickIndex) async {
    _page++;
    if (_page == 1) {
      listview = [];
    }

    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => clickIndex + 1);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);

    StoreServer().getExtendOrder(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          listview = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              listview.insert(listview.length, success['list'][i]);
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List typeList = ["全部", "待付款", "待发货", "待收货", "已完成"];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        new DefaultTabController(
          length: typeList.length,
          initialIndex: int.parse('0'),
          child: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                '推广订单',
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Material(
                  color: Colors.white,
                  child: TabBar(
                    onTap: ((index) {
                      clickIndex = index;
                      listview = [];
                      _page = 0;
                      getList(clickIndex);
                    }),
                    indicatorWeight: 4.0,
                    labelPadding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                    indicatorColor: PublicColor.themeColor,
                    unselectedLabelColor: Color(0xff5e5e5e),
                    labelColor: PublicColor.themeColor,
                    tabs: typeList.map((f) {
                      return Text(
                        f,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w600),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            body: Container(
              width: ScreenUtil.getInstance().setWidth(750.0),
              child: EasyRefresh(
                controller: _controller,
                header: BezierCircleHeader(
                  backgroundColor: PublicColor.themeColor,
                ),
                footer: BezierBounceFooter(
                  backgroundColor: PublicColor.themeColor,
                ),
                enableControlFinishRefresh: true,
                enableControlFinishLoad: false,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    ScreenUtil.instance.setWidth(25),
                    ScreenUtil.instance.setWidth(0),
                    ScreenUtil.instance.setWidth(25),
                    0,
                  ),
                  width: ScreenUtil.getInstance().setWidth(700.0),
                  child: gouwuitem(context, listview),
                ),
                onRefresh: () async {
                  _page = 0;
                  getList(clickIndex);
                },
                onLoad: () async {
                  getList(clickIndex);
                },
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget gouwuitem(BuildContext context, listview) {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (listview.length == 0) {
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
      for (var item in listview) {
        index++;
        arr.add(Container(
          child: new Column(children: [
            new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: new Border.all(color: Color(0xfffececec), width: 0.5),
              ),
              child: Column(children: [
                Container(
                  height: ScreenUtil.getInstance().setWidth(80.0),
                  padding: EdgeInsets.only(
                      right: ScreenUtil.instance.setWidth(20.0)),
                  child: Row(children: [
                    new SizedBox(width: ScreenUtil.instance.setWidth(5.0)),
                    Expanded(
                      child: Container(
                        child: Text(
                            item['pay_status'] == "0"
                                ? '待付款'
                                : item['pay_status'] == "1"
                                    ? '待发货'
                                    : item['pay_status'] == "2" ? '待收货' : '已完成',
                            style: TextStyle(
                                color: item['pay_status'] == "3"
                                    ? Color(0xffa0a0a0)
                                    : Colors.red,
                                fontSize: ScreenUtil.instance.setWidth(26.0))),
                        alignment: Alignment.centerRight,
                      ),
                      flex: 1,
                    )
                  ]),
                ),
                new Column(children: listBoxs(item['goods'], index)),
                Container(
                  padding: EdgeInsets.only(
                    top: ScreenUtil.instance.setWidth(10.0),
                    bottom: ScreenUtil.instance.setWidth(10.0),
                  ),
                  decoration: ShapeDecoration(
                    shape: Border(
                        top: BorderSide(color: Color(0xfffececec), width: 1.0)),
                  ),
                  child: Column(children: [
                    Container(
                      child: Text('共 ${item['total']} 件商品 合计:￥${item['total']}',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setWidth(28.0))),
                      alignment: Alignment.centerRight,
                      height: ScreenUtil.getInstance().setWidth(65.0),
                      padding: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(25.0)),
                    ),
                  ]),
                )
              ]),
            ),
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

  List<Widget> listBoxs(goods, listindex) => List.generate(
        goods.length,
        (index) {
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
                      goods[index]['img'],
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
                          goods[index]['goods_name'],
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
                          goods[index]['specs_name'],
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: ScreenUtil.instance.setWidth(25.0),
                          ),
                        ),
                        new Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: ScreenUtil.instance.setWidth(75.0),
                                alignment: Alignment.bottomLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: '￥${goods[index]['now_price']} ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(27.0),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                                child: Container(
                                  height: ScreenUtil.instance.setWidth(75.0),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "x${goods[index]['num']}",
                                    style: TextStyle(
                                        color: Color(0xfffcccccc),
                                        fontSize:
                                            ScreenUtil.instance.setWidth(27.0)),
                                  ),
                                ),
                                flex: 1),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              onTap: () {
                NavigatorUtils.toXiangQing(
                    context, goods[index]['goods_id'], '0', '0');
              },
            ),
          );
        },
      );
}
