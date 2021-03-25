import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../service/store_service.dart';

class ShopManagePage extends StatefulWidget {
  @override
  ShopManagePageState createState() => ShopManagePageState();
}

class ShopManagePageState extends State<ShopManagePage> {
  bool isLoading = false;
  List shopList = [];
  Map user = {
    "store_name": "",
    "store_img": "",
    "headimgurl": "",
  };
  int type = 1;
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    StoreServer().getStoreMassage(map, (success) {
      setState(() {
        if (type == 1) {
          user = success['user'];
        }
        shopList = success['list'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

//发布素材
  void releaseApi(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    StoreServer().sendMaterial(map, (success) {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('发布成功');
    }, (onFail) {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget banner = new Container(
      alignment: Alignment.topCenter,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(370),
      child: Stack(children: <Widget>[
        //图片
        Positioned(
          top: 0,
          child: user['store_img'] == ''
              ? Container()
              : Image.network(
                  user['store_img'],
                  width: ScreenUtil().setWidth(750),
                  fit: BoxFit.contain,
                ),
        ),
        Positioned(
          bottom: 20,
          left: ScreenUtil().setWidth(60),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: ClipOval(
                  child: user['store_headimg'] == null
                      ? Container()
                      : Image.network(
                          user['store_headimg'],
                          height: ScreenUtil().setWidth(127),
                          width: ScreenUtil().setWidth(127),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(30),
              ),
              Container(
                width: ScreenUtil().setWidth(500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${user['store_name']}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${user['store_desc']}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );

    Widget tabBar = Material(
      //这里设置tab的背景色
      color: Colors.white,
      child: TabBar(
        onTap: (value) {
          type = value + 1;
          getList();
        },
        indicatorWeight: 3.0,
        indicatorColor: PublicColor.themeColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: PublicColor.themeColor,
        unselectedLabelColor: PublicColor.textColor,
        tabs: [
          Tab(text: '店铺精选'),
          Tab(text: '品牌专柜'),
        ],
      ),
    );

    //店铺精选
    Widget buildList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (shopList.length == 0) {
        arr.add(
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(150)),
            child: Image.asset(
              'assets/mine/zwsj.png',
              width: ScreenUtil().setWidth(400),
            ),
          ),
        );
      } else {
        for (var item in shopList) {
          arr.add(Container(
            margin: EdgeInsets.only(top: 10),
            child: new Column(children: <Widget>[
              new InkWell(
                child: new Container(
                  width: ScreenUtil().setWidth(750),
                  // height: ScreenUtil().setWidth(256),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setWidth(20),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: PublicColor.lineColor, width: 1),
                    color: Colors.white,
                  ),
                  child: new Row(children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  item['thumb'],
                                  height: ScreenUtil().setWidth(204),
                                  width: ScreenUtil().setWidth(204),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            child: Container(
                                child: Image.asset(
                              "assets/shop/rx.png",
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              fit: BoxFit.cover,
                            )),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: new Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(40),
                              ScreenUtil().setWidth(0),
                              ScreenUtil().setWidth(20),
                              0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${item['desc']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(40),
                            top: ScreenUtil().setWidth(40),
                          ),
                          child: new Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: RichText(
                                  text: TextSpan(
                                    text: '￥',
                                    style: TextStyle(
                                        color: Color(0xff454545),
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            ScreenUtil.instance.setWidth(24)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${item['now_price']}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              ScreenUtil.instance.setWidth(28),
                                        ),
                                      ),
                                      TextSpan(
                                          text: '/赚',
                                          style: TextStyle(
                                              color: Color(0xffe61414),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(26))),
                                      TextSpan(
                                          text: item['commission'],
                                          style: TextStyle(
                                              color: Color(0xffe61414),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(26))),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(10),
                        ),
                        Container(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40),
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    '库存${item['stock'].toString()}',
                                    style: TextStyle(
                                      color: Color(0xffb6b6b6),
                                      fontSize:
                                          ScreenUtil.instance.setWidth(28),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(20),
                                ),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(20),
                                        ),
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(138),
                                        height: ScreenUtil().setWidth(54),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              new BorderRadius.circular((8.0)),
                                          border: Border.all(
                                              color: PublicColor.redColor,
                                              width: 1),
                                        ),
                                        child: Text(
                                          '发布素材',
                                          style: TextStyle(
                                            color: PublicColor.redColor,
                                            fontSize: ScreenUtil.instance
                                                .setWidth(26),
                                          ),
                                        ),
                                      ),
                                      onTap: () => releaseApi(item['id']),
                                    ),
                                    InkWell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(20),
                                        ),
                                        width: ScreenUtil().setWidth(138),
                                        height: ScreenUtil().setWidth(54),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    (8.0)),
                                            gradient: PublicColor.linearBtn),
                                        child: Text(
                                          '分享购买',
                                          style: TextStyle(
                                            color: PublicColor.btnTextColor,
                                            fontSize: ScreenUtil.instance
                                                .setWidth(26),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        NavigatorUtils.toXiangQing(context,
                                                item['id'].toString(), '0', '0')
                                            .then((res) => getList());
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ))
                      ]),
                    )
                  ]),
                ),
                onTap: () {
                  print('商品');
                },
              ),
            ]),
          ));
        }
      }

      content = new ListView(
        children: arr,
      );
      return content;
    }

    return new DefaultTabController(
      length: 2,
      child: Stack(
        children: <Widget>[
          new Scaffold(
            appBar: new AppBar(
              title: new Text(''),
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
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Text(
                        '编辑',
                        style: new TextStyle(
                          color: PublicColor.textColor,
                          fontSize: ScreenUtil().setSp(30),
                          height: 2.7,
                        ),
                      )),
                  onTap: () {
                    NavigatorUtils.toManageBjPage(context)
                        .then((res) => getList());
                  },
                ),
                InkWell(
                  child: Container(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Text(
                        '预览',
                        style: new TextStyle(
                          color: PublicColor.textColor,
                          fontSize: ScreenUtil().setSp(30),
                          height: 2.7,
                        ),
                      )),
                  onTap: () {
                    NavigatorUtils.toManageYlPage(context, user)
                        .then((res) => getList());
                  },
                )
              ],
            ),
            body: Container(
              decoration: BoxDecoration(color: Color(0xfff5f5f5)),
              child: Column(
                children: <Widget>[
                  banner,
                  new SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
                  tabBar,
                  Expanded(
                    flex: 1,
                    child: buildList(),
                  ),
                ],
              ),
            ),
          ),
          isLoading ? LoadingDialog() : Container()
        ],
      ),
    );
  }
}
