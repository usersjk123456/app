import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/store_service.dart';
import '../widgets/loading.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../common/upload_to_oss.dart';

class ShopInforPage extends StatefulWidget {
  @override
  ShopInforPageState createState() => ShopInforPageState();
}

class ShopInforPageState extends State<ShopInforPage> {
  bool isLoading = false;
  String storename = "";
  String storedesc = "";
  String storeheadimg = "";
  String storeimg = "";
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getInfo();
    }
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    StoreServer().getHome(map, (success) {
      setState(() {
        storename = success['user']['store_name'];
        storedesc = success['user']['store_desc'];
        storeheadimg = success['user']['store_headimg'];
        storeimg = success['user']['store_img'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  void changeLoading({type = 2, sent = 0, total = 0}) {
    if (type == 1) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void changeShopHead(img) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_headimg", () => img);

    StoreServer().setStorHead(map, (success) async {
      setState(() {
        isLoading = false;
        storeheadimg = img;
      });
      ToastUtil.showToast('修改成功');
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void changeShopImg(img) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_img", () => img);

    StoreServer().setStorImg(map, (success) async {
      setState(() {
        isLoading = false;
        storeimg = img;
      });
      ToastUtil.showToast('修改成功');
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget inforArea = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: ScreenUtil().setWidth(700),
        // height: ScreenUtil().setWidth(520),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          new InkWell(
            child: Container(
                padding: EdgeInsets.only(left: 20),
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setWidth(102),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      '店名',
                      style: TextStyle(
                        color: Color(0xff454545),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: new Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        storename,
                        style: TextStyle(
                          color: Color(0xffbababa),
                          fontSize: ScreenUtil().setSp(28),
                        ),
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
                ])),
            onTap: () {
              NavigatorUtils.goSetStoreName(context, storename)
                  .then((res) => getInfo());
            },
          ),
          new InkWell(
            child: Container(
                padding: EdgeInsets.only(left: 20),
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setWidth(102),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      '店铺介绍',
                      style: TextStyle(
                        color: Color(0xff454545),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: new Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        storedesc,
                        style: TextStyle(
                          color: Color(0xffbababa),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                ])),
            onTap: () {
              print('店铺介绍');
              NavigatorUtils.goSetStoreDesc(context, storedesc)
                  .then((res) => getInfo());
            },
          ),
          new InkWell(
            child: Container(
                padding: EdgeInsets.only(left: 20),
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setWidth(102),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      '头像',
                      style: TextStyle(
                        color: Color(0xff454545),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: InkWell(
                      child: storeheadimg == ""
                          ? Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(77),
                              height: ScreenUtil().setWidth(77),
                              decoration: BoxDecoration(
                                color: Color(0xfff5f5f5),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Text(
                                '+',
                                style: TextStyle(
                                    color: Color(0xffcfcfcf),
                                    fontSize: ScreenUtil().setSp(50),
                                    fontWeight: FontWeight.w900),
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                storeheadimg,
                                height: ScreenUtil().setWidth(77),
                                width: ScreenUtil().setWidth(77),
                                fit: BoxFit.cover,
                              ),
                            ),
                      onTap: () async {
                        Map obj = await openGallery("image", changeLoading);
                        if (obj == null) {
                          changeLoading(type: 2, sent: 0, total: 0);
                          return;
                        }
                        if (obj['errcode'] == 0) {
                          changeShopHead(obj['url']);
                        } else {
                          ToastUtil.showToast(obj['msg']);
                        }
                      },
                    ),
                  ),
                  Expanded(
                      flex: 0,
                      child: new Container(
                        alignment: Alignment.centerRight,
                        child: new Icon(
                          Icons.navigate_next,
                          color: Color(0xff999999),
                        ),
                      )),
                ])),
          ),
          new InkWell(
              child: Container(
                  padding: EdgeInsets.only(left: 20),
                  width: ScreenUtil().setWidth(700),
                  height: ScreenUtil().setWidth(102),
                  child: new Row(children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        '店招',
                        style: TextStyle(
                          color: Color(0xff454545),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: InkWell(
                        child: storeimg == ""
                            ? new Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(160),
                                height: ScreenUtil().setWidth(70),
                                decoration: BoxDecoration(
                                  color: Color(0xfff5f5f5),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  '橙子宝宝直播',
                                  style: TextStyle(
                                    color: Color(0xffcfcfcf),
                                  ),
                                ),
                              )
                            : Image.network(
                                storeimg,
                                width: ScreenUtil().setWidth(77),
                                height: ScreenUtil().setWidth(77),
                              ),
                        onTap: () async {
                          Map obj = await openGallery("image", changeLoading);
                          if (obj == null) {
                            changeLoading(type: 2, sent: 0, total: 0);
                            return;
                          }
                          if (obj['errcode'] == 0) {
                            changeShopImg(obj['url']);
                          } else {
                            ToastUtil.showToast(obj['msg']);
                          }
                        },
                      ),
                    ),
                    Expanded(
                        flex: 0,
                        child: new Container(
                          alignment: Alignment.centerRight,
                          child: new Icon(
                            Icons.navigate_next,
                            color: Color(0xff999999),
                          ),
                        )),
                  ]))),
          // new InkWell(
          //   child: Container(
          //       padding: EdgeInsets.only(left: 20),
          //       width: ScreenUtil().setWidth(700),
          //       height: ScreenUtil().setWidth(102),
          //       child: new Row(children: <Widget>[
          //         Expanded(
          //           flex: 5,
          //           child: Text(
          //             '申请成为供应商',
          //             style: TextStyle(
          //               color: Color(0xff454545),
          //               fontSize: ScreenUtil().setSp(28),
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //             flex: 1,
          //             child: new Container(
          //               alignment: Alignment.centerRight,
          //               child: new Icon(
          //                 Icons.navigate_next,
          //                 color: Color(0xff999999),
          //               ),
          //             )),
          //       ])),
          //   onTap: () {
          //     print('供应商');
          //   },
          // )
        ]),
      ),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: new Text(
                  '店铺信息',
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
              ),
              body: new Container(
                alignment: Alignment.center,
                child: new ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [inforArea],
                ),
              ),
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ));
  }
}
