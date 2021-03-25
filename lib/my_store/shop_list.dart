import 'package:client/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/cached_image.dart';
import '../utils/toast_util.dart';
import '../widgets/dialog.dart';
import '../common/color.dart';
import '../config/Navigator_util.dart';
import '../service/store_service.dart';

class ShangpinguanliPage extends StatefulWidget {
  @override
  ShangpinguanliPagePageState createState() => ShangpinguanliPagePageState();
}

class ShangpinguanliPagePageState extends State<ShangpinguanliPage>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  bool isbianji = true;
  List listview = [];
  List checklist = [];
  int type = 1;
  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
    }
  }

  void getList() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("is_up", () => type);
    StoreServer().getShopList(map, (success) async {
      setState(() {
        listview = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void upShop(id, status) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("type", () => status);
    StoreServer().upShopList(map, (success) async {
      if (status == 0) {
        ToastUtil.showToast('已下架');
      } else {
        ToastUtil.showToast('已上架');
      }
      getList();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  Widget deleDjango(context, id) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        delShop(id);
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: '确定删除该商品吗？',
    );
  }

  Widget upDjango(context, id, status) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        upShop(id, status);
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: status == 0 ? '确定下架该商品吗？' : '确定上架该商品吗？',
    );
  }

  void delShop(id) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    StoreServer().delShopList(map, (success) async {
      ToastUtil.showToast('删除成功');
      getList();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget contentWidget() {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: ScreenUtil.getInstance().setWidth(700.0),
            child: ListView.builder(
              itemCount: listview.length,
              itemBuilder: (BuildContext context, int index) {
                return gouwuitem(context, listview[index], index);
              },
            ),
          ),
          Positioned(
            child: Container(
              color: Colors.white,
              height: ScreenUtil().setWidth(108),
              width: ScreenUtil().setWidth(750),
              child: Column(
                children: <Widget>[
                  BigButton(
                    name: '+添加商品',
                    tapFun: () {
                      NavigatorUtils.goTianjiashangpinPage(context).then((res) {
                        getList();
                      });
                    },
                    top: ScreenUtil().setWidth(10),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }

    return Stack(
      children: <Widget>[
        new DefaultTabController(
          length: 2,
          //  initialIndex: int.parse(widget.type),
          child: new Scaffold(
            appBar: new AppBar(
              elevation: 0,
              centerTitle: true,
              title: new Text(
                '商品管理',
                style: TextStyle(
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Material(
                  color: Colors.white,
                  child: TabBar(
                    onTap: (value) {
                      setState(() {
                        type = value == 0 ? 1 : 0;
                      });
                      getList();
                    },
                    indicatorWeight: 4.0,
                    labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                    // indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: PublicColor.themeColor,
                    unselectedLabelColor: Color(0xff5e5e5e),
                    labelColor: PublicColor.themeColor,
                    tabs: <Widget>[
                      new Tab(
                        child: Text(
                          '出售中',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      new Tab(
                        child: Text(
                          '已下架',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
              alignment: Alignment.center,
              color: Colors.grey[100],
              child: contentWidget(),
            ),
          ),
        ),
        isloading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget gouwuitem(BuildContext context, item, index) {
    return Container(
      width: ScreenUtil.instance.setWidth(730),
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
      child: Column(
        children: [
          Container(
            color: PublicColor.whiteColor,
            child: new Row(
              children: <Widget>[
                CachedImageView(
                  ScreenUtil.instance.setWidth(204.0),
                  ScreenUtil.instance.setWidth(204.0),
                  item['thumb'],
                  null,
                  BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
                new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                Container(
                  width: ScreenUtil.instance.setWidth(380.0),
                  height: ScreenUtil.instance.setWidth(214.0),
                  color: PublicColor.whiteColor,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text(
                        item['name'],
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: PublicColor.textColor,
                          fontSize: ScreenUtil.instance.setSp(28),
                        ),
                      ),
                      new SizedBox(height: ScreenUtil.instance.setWidth(5.0)),
                      Text(
                        item['desc'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: PublicColor.textColor,
                          fontSize: ScreenUtil.instance.setWidth(24.0),
                        ),
                      ),
                      new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                      new Row(children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: RichText(
                            text: TextSpan(
                                text: '￥${item['now_price']}     ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(27.0)),
                                children: [
                                  TextSpan(
                                      text: '￥${item['old_price']}',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Color(0xfffcccccc),
                                          fontSize:
                                              ScreenUtil.instance.setSp(27.0))),
                                ]),
                          ),
                        ),
                      ]),
                      new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                      Row(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: '库存:',
                              style: TextStyle(
                                color: PublicColor.textColor,
                                fontSize: ScreenUtil.instance.setSp(26.0),
                              ),
                              children: [
                                TextSpan(
                                  text: '${item['stock']}      ',
                                  style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(26.0),
                                  ),
                                ),
                                TextSpan(
                                  text: '限购:',
                                  style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(26.0),
                                  ),
                                ),
                                TextSpan(
                                  text: '${item['limit']}',
                                  style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(26.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(90),
            color: Color(0xffeeeeee),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                type == 1
                    ? InkWell(
                        onTap: () {
                          NavigatorUtils.toXiangQing(
                                  context, item['id'], "0", "0")
                              .then((res) {
                            getList();
                          });
                        },
                        child: Row(children: [
                          Image.asset(
                            "assets/shop/icon_yulan.png",
                            width: ScreenUtil().setWidth(30),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(15),
                          ),
                          Text(
                            '预览',
                            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                          ),
                        ]),
                      )
                    : Container(),
                InkWell(
                  onTap: () {
                    NavigatorUtils.goTianjiashangpinPage(
                            context, item['id'].toString())
                        .then((res) {
                      getList();
                    });
                  },
                  child: Row(children: [
                    Image.asset(
                      "assets/shop/icon_bianji.png",
                      width: ScreenUtil().setWidth(30),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(15),
                    ),
                    Text(
                      '编辑',
                      style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                    ),
                  ]),
                ),
                type == 1
                    ? InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return upDjango(context, item['id'], 0);
                              });
                        },
                        child: Row(children: [
                          Image.asset(
                            "assets/shop/icon_xiajia.png",
                            width: ScreenUtil().setWidth(30),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(15),
                          ),
                          Text(
                            '下架',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ]),
                      )
                    : InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return upDjango(context, item['id'], 1);
                              });
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/shop/icon_shangjia.png",
                              width: ScreenUtil().setWidth(30),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(15),
                            ),
                            Text(
                              '上架',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ],
                        ),
                      ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return deleDjango(context, item['id']);
                      },
                    );
                  },
                  child: Row(children: [
                    Image.asset(
                      "assets/shop/icon_shanchu.png",
                      width: ScreenUtil().setWidth(30),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(15),
                    ),
                    Text(
                      '删除',
                      style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                    ),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
