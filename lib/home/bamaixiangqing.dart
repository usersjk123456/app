import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import '../widgets/swiper.dart';
import '../widgets/cached_image.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../common/color.dart';
import '../service/goods_service.dart';
import '../api/api.dart';
import '../utils/serivice.dart';
import '../common/Global.dart';
import 'package:client/api/api.dart';
import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import './share_django.dart';
import '../service/user_service.dart';

class BaiMaiXiangQing extends StatefulWidget {
  final String oid;
  final String type; // 商品类型。1-正常商品，2-分享商品
  BaiMaiXiangQing({this.oid, this.type});
  @override
  _BaiMaiXiangQingState createState() => _BaiMaiXiangQingState();
}

List guige = [];
int buynum = 1;
int checkindex = 0;
String shipId = "0";
String roomId = "0";

class _BaiMaiXiangQingState extends State<BaiMaiXiangQing>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  EasyRefreshController _controller = EasyRefreshController();
  GlobalKey globalKey = GlobalKey();
  String jwt = '';
  int checkindex1 = -1;
  Map goods = {
    "id": 5,
    "name": "",
    "keywords": "",
    "type": 0,
    "brand": 0,
    "is_love": 0,
    "sort": 0,
    "category_id": 0,
    "store_id": 0,
    "flash_id": 0,
    "thumb": "",
    "is_attr": 0,
    "now_price": "0.00",
    "old_price": "0.00",
    "love_price": "0.00",
    "commission": 0,
    "desc": "",
    "content": "",
    "stock": 0,
    "is_up": 0,
    "is_flash": 0,
    "is_hot": "0",
    "is_recommend": 0,
    "is_limit": 0,
    "buy_count": 0,
    "limit": 0,
    "freight_id": 0,
    "post_id": 0,
    "house_id": 0,
    "update_at": "0",
    "create_at": "0",
    "rule": ["", ""],
    "store_name": "",
    "cart_num": 0,
    "bamaizongnum": 1,
    "bamainum": 1
  };
  Map user = {
    "id": 0,
    'phone': 0,
    "headimgurl":
        "https://pic1.zhimg.com/v2-fda399250493e674f2152c581490d6eb_1200x500.jpg",
    "nickname": "1",
  };
  List xiangqingimglist = [];
  List bannerList = [];
  List tuijianlist = [];
  String kfToken = '';
  int tuanNum = 0;
  int count = 0;
  String starttime = "0";
  String endtime = "0";
  int userInfo = 0;
  List tuanList = [];
  @override
  void initState() {
    super.initState();
    getGoodsDetails();
    getDetails();
    getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserInfo() async {
    print(
        'ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      user = success['user'];
      userInfo = success['user']['is_live'];
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getGoodsDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    GoodsServer().getGoodsDetails(map, (success) async {
      setState(() {
        isLoading = false;
        bannerList = success['banner'];
        kfToken = success['kfToken'];
        goods = success['goods'];
        guige = success['specs'];
        xiangqingimglist = success['detail_img'];
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

  Future<ByteData> _capturePngToByteData() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      ByteData _byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return _byteData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// 把图片ByteData写入File，并触发微信分享
  Future<Null> _shareUiImage(type) async {
    print('生成图片');
    ByteData sourceByteData = await _capturePngToByteData();
    Uint8List sourceBytes = sourceByteData.buffer.asUint8List();

    if (type == 1) {
      shareToWeChat(
        WeChatShareImageModel(WeChatImage.binary(sourceBytes),
            scene: WeChatScene.SESSION, description: "image"),
      );
    } else if (type == 2) {
      shareToWeChat(
        WeChatShareImageModel(WeChatImage.binary(sourceBytes),
            scene: WeChatScene.TIMELINE, description: "image"),
      );
    } else {
      var filePath = await ImageGallerySaver.saveImage(sourceBytes);
      var savedFile = File.fromUri(Uri.file(filePath));
      setState(() {
        Future<File>.sync(() => savedFile);
      });
      ToastUtil.showToast('保存到相册成功');
      // '���存成功'
    }
  }

  void getDetails() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);
    Service().sget(Api.BAMAI_DETAILS_URL, map, (success) async {
      print(
          'tuannumtuannumtuannumtuannumtuannumtuannumtuan-------------------------->${success["tuannum"]}');
      setState(() {
        isLoading = false;
        tuanNum = success['tuannum'];
        count = success['count'];
        starttime = success['starttime'];
        endtime = success['endtime'];
        tuanList = success['list'];
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

  void shareGoods() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("goods_id", () => widget.oid);
    GoodsServer().shareGoods(map, (success) async {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return _shareWidget(context, success['data']);
          });
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
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: Text(
              '商品详情',
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
          ),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget contentWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(100.0)),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SwiperView(
                  bannerList,
                  0,
                  ScreenUtil.instance.setWidth(750.0),
                  "xq",
                ),
                Container(
                  width: ScreenUtil.instance.setWidth(750.0),
                  color: Colors.white,
                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  text: '拼团价 ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: ScreenUtil().setSp(26),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '￥${goods["now_price"]} ',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: ScreenUtil().setSp(35),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '￥${goods["old_price"]}',
                                      style: TextStyle(
                                        color: PublicColor.grewNoticeColor,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            PublicColor.grewNoticeColor,
                                        fontSize: ScreenUtil().setSp(24),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(5)),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                              ),
                              decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xffFD5392),
                                Color(0xffF86F64),
                              ]),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "拼团",
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(26.0),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              '            ${goods['name']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(30.0),
                                color: Color(0xfff000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // new SizedBox(height: ScreenUtil.instance.setWidth(5.0)),
                Container(
                  height: ScreenUtil.instance.setWidth(15.0),
                  color: Color(0xffff5f5f5),
                ),
                Container(
                  // color: Colors.white,
                  // padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(25),
                      left: ScreenUtil().setWidth(25),
                      right: ScreenUtil().setWidth(25)),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '$tuanNum 人参团',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(30.0),
                              color: Color(0xfff000000),
                            ),
                          ),
                          Text(
                            // '${goods['bamaizongnum']} 人成团',
                            '${goods['bamainum']} 人成团',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(30.0),
                              color: Color(0xfff000000),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: ScreenUtil().setWidth(30),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation(PublicColor.themeColor),
                          value: tuanNum / goods['bamainum'],
                        ),
                      ),
                      Container(
                        child: Text(
                          '$starttime 至 $endtime 结束',
                          style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(30.0),
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                Container(
                    color: Colors.white,
                    child: FlatButton(
                      onPressed: () {
                        // ToastUtil.showToast('暂未开放');
                        print('ssss');
                        if (jwt == null) {
                          ToastUtil.showToast(Global.NO_LOGIN);
                          return;
                        }
                        // ToastUtil.showToast('暂未开放');
                        // if (userInfo == 0) {
                        //   //        builder: (BuildContext context) {
                        //   //   return AlertDialogDemo(
                        //   //       _choice: 'goods');
                        //   // },
                        //   // Navigator.pushAndRemoveUntil(
                        //   //   context,
                        //   //   new MaterialPageRoute(
                        //   //       builder: (context) => new HomePage()),
                        //   //   (Route<dynamic> route) => false,
                        //   // );
                        //   ToastUtil.showToast('邀请好友，请到我的页面升级播商');
                        //   Future.delayed(const Duration(milliseconds: 500), () {
                        //     NavigatorUtils.goHomePage(context, '4');
                        //   });
                        // } else {
                        print('~~~~~~~~~~~~~~');
                        print(user);
                        print(goods);
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ShareDjango(
                                goods: goods,
                                shareGoods: shareGoods,
                                user: user,
                                fromType: '1');
                          },
                        );
                        // }
                      },
                      child: Text(
                        '邀请好友参团拼团，赚取额外补贴',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: PublicColor.themeColor,
                  
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    )),

                Container(
                  height: ScreenUtil.instance.setWidth(15.0),
                  color: Color(0xffff5f5f5),
                ),
                // Container(
                //   height: ScreenUtil().setWidth(100),
                //   decoration: BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(
                //         width: 1, //宽度
                //         color: Color(0xffff5f5f5), //边框颜色
                //       ),
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: <Widget>[
                //       Container(
                //           padding:
                //               EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                //           child: Text('0人中奖')),
                //       Container(
                //           child: Row(
                //         children: <Widget>[
                //           Text('查看中奖名单'),
                //           Icon(
                //             Icons.keyboard_arrow_right,
                //             // color:Color(0xffff5f5f5),
                //           )
                //         ],
                //       ))
                //     ],
                //   ),
                // ),
                // // **
                // Container(
                //     child: Column(
                //   children: <Widget>[
                //     Row(
                //       children: <Widget>[
                //         Expanded(
                //             child: CachedImageView(
                //           ScreenUtil.instance.setWidth(50.0),
                //           ScreenUtil.instance.setWidth(50.0),
                //           'https://thirdwx.qlogo.cn/mmopen/vi_32/ibrribpzsQUhu3qLuES0vnBrnzEY7B2IITgr1fhN7U9sAjx1rhkgqGvxrJIG1Ne4TthB12plNu5GXJVeAIibliaelg/132',
                //           null,
                //           BorderRadius.all(
                //             Radius.circular(50.0),
                //           ),
                //         )),

                //       ],
                //     )
                //   ],
                // )),

                Container(
                  height: ScreenUtil.instance.setWidth(15.0),
                  color: Color(0xffff5f5f5),
                ),
                Container(
                  width: ScreenUtil.instance.setWidth(750.0),
                  height: ScreenUtil.instance.setWidth(100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil.instance.setWidth(135.0),
                        height: ScreenUtil.instance.setWidth(2.0),
                        color: Color(0xfff7a7a7a),
                      ),
                      Container(
                        width: ScreenUtil.instance.setWidth(15.0),
                        height: ScreenUtil.instance.setWidth(2.0),
                      ),
                      Text('宝贝信息',
                          style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(35),
                              color: Color(0xfff7a7a7a))),
                      Container(
                        width: ScreenUtil.instance.setWidth(15.0),
                        height: ScreenUtil.instance.setWidth(2.0),
                      ),
                      Container(
                        width: ScreenUtil.instance.setWidth(135.0),
                        height: ScreenUtil.instance.setWidth(2.0),
                        color: Color(0xfff7a7a7a),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  color: Colors.white,
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: Text("${goods['rule']}"),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  color: Colors.white,
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: Text("${goods['desc']}"),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  color: Colors.white,
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: Text("${goods['content']}"),
                ),
                new Column(
                  children: xiangqingimglist
                      .map((i) => CachedImageView(
                          ScreenUtil.instance.setWidth(750.0),
                          ScreenUtil.instance.setWidth(750.0),
                          i['img'],
                          null,
                          BorderRadius.all(Radius.circular(0))))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            goods['num'] = 1;
            goods['buy_type'] = "1";
            goods['ship_id'] = "0";
            goods['room_id'] = "0";
            goods['share_id'] = "0"; //分享id 暂时没有
            Map obj = {
              "list": [
                {
                  "title": goods['store_name'],
                  "store_id": goods['store_id'],
                  "list": [goods],
                  "goods": goods,
                  "user": user
                }
              ]
            };
            NavigatorUtils.goBmOrder(context, obj);
          },

          // child: new Row(children: <Widget>[
          //   new Expanded(
          //       flex: 1,
          //       child: new Container(
          //         height: ScreenUtil.instance.setWidth(100.0),
          //         child: RaisedButton(
          //           onPressed: () {
          //             goods['num'] = 1;
          //             goods['buy_type'] = "1";
          //             goods['ship_id'] = "0";
          //             goods['room_id'] = "0";
          //             goods['share_id'] = "0"; //分享id 暂时没有
          //             Map obj = {
          //               "list": [
          //                 {
          //                   "title": goods['store_name'],
          //                   "store_id": goods['store_id'],
          //                   "list": [goods]
          //                 }
          //               ]
          //             };
          //             NavigatorUtils.goBmOrder(context, obj);
          //           },
          //           color: Color(0xffF83189),
          //           child: new Text('拼团'),
          //         ),
          //       )),
          //   new Container(
          //     height: ScreenUtil.instance.setWidth(100.0),
          //     child: RaisedButton(
          //       onPressed: () {
          //         // ToastUtil.showToast('暂未开放');
          //         if (jwt == null) {
          //           ToastUtil.showToast(Global.NO_LOGIN);
          //           return;
          //         }
          //         showModalBottomSheet(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return ShareDjango(
          //                 goods: goods, shareGoods: shareGoods, user: user);
          //           },
          //         );
          //       },
          //       color: const Color(0xff5D1CD3),
          //       child: new Text('分享'),
          //     ),
          //   )
          // ]),
          child: Container(
            width: double.infinity,
            height: ScreenUtil.instance.setWidth(100.0),
            color:PublicColor.themeColor,
            alignment: Alignment.center,
            child: Text(
              "参团",
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(35),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _shareWidget(BuildContext context, url) {
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: new Container(
          width: ScreenUtil.instance.setWidth(710.0),
          height: ScreenUtil.instance.setWidth(880.0),
          padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(20),
              left: ScreenUtil().setWidth(20)),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          child: new Column(children: [
            Container(
              alignment: Alignment.centerRight,
              height: ScreenUtil.instance.setWidth(60.0),
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
              child: InkWell(
                child: Image.asset(
                  'assets/index/gb.png',
                  width: ScreenUtil.instance.setWidth(40.0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            RepaintBoundary(
              key: globalKey,
              child: Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(goods['store_name'],
                          style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(28.0),
                              color: Colors.black)),
                    ),
                    new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
                    Row(
                      children: [
                        CachedImageView(
                          ScreenUtil.instance.setWidth(155.0),
                          ScreenUtil.instance.setWidth(155.0),
                          goods['thumb'],
                          null,
                          BorderRadius.all(
                            Radius.circular(0),
                          ),
                        ),
                        new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                        Container(
                          width: ScreenUtil.instance.setWidth(406.0),
                          height: ScreenUtil.instance.setWidth(155.0),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(10.0)),
                                RichText(
                                  text: TextSpan(
                                      text: '￥${goods['now_price']}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: ScreenUtil.instance
                                              .setWidth(27.0)),
                                      children: [
                                        TextSpan(
                                            text: '￥${goods['old_price']}',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Color(0xfffcccccc),
                                                fontSize: ScreenUtil.instance
                                                    .setWidth(27.0))),
                                      ]),
                                ),
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(10.0)),
                                Text(goods['name'],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(27.0))),
                              ]),
                        )
                      ],
                    ),
                    new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
                    Container(
                      child: Image.network(
                        url,
                        width: ScreenUtil().setWidth(200),
                      ),
                    ),
                    // Container(
                    //   child: new QrImage(
                    //     data: 'http://wwww.baidu.com',
                    //     size: ScreenUtil.instance.setWidth(200.0),
                    //   ),
                    // ),
                    new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
                    Row(
                      children: [
                        new SizedBox(
                            width: ScreenUtil.instance.setWidth(180.0)),
                        CachedImageView(
                            ScreenUtil.instance.setWidth(100.0),
                            ScreenUtil.instance.setWidth(100.0),
                            user['headimgurl'],
                            null,
                            BorderRadius.all(Radius.circular(50))),
                        new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                        Container(
                          width: ScreenUtil.instance.setWidth(200.0),
                          height: ScreenUtil.instance.setWidth(100.0),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['nickname'],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(27.0))),
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(10.0)),
                                Text(user['phone'].toString(),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(27.0))),
                              ]),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            new SizedBox(height: ScreenUtil.instance.setWidth(30.0)),
            Container(
              decoration: new ShapeDecoration(
                shape: Border(
                  top: BorderSide(color: Color(0xfffececec), width: 1),
                ), // 边色与边���度
                color: Colors.white,
              ),
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(25)),
              child: Row(children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(children: [
                          Image.asset(
                            'assets/index/weixin.png',
                            width: ScreenUtil.instance.setWidth(97.0),
                          ),
                          new SizedBox(
                              height: ScreenUtil.instance.setWidth(10.0)),
                          Text('微信好友',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil.instance.setWidth(26.0),
                                  fontWeight: FontWeight.w500)),
                        ])),
                    onTap: () {
                      print('微信好友');
                      _shareUiImage(1);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(children: [
                          Image.asset(
                            'assets/index/pyq.png',
                            width: ScreenUtil.instance.setWidth(97.0),
                          ),
                          new SizedBox(
                              height: ScreenUtil.instance.setWidth(10.0)),
                          Text('朋友圈',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil.instance.setWidth(26.0),
                                  fontWeight: FontWeight.w500)),
                        ])),
                    onTap: () {
                      _shareUiImage(2);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/index/phone.png',
                            width: ScreenUtil.instance.setWidth(97.0),
                          ),
                          new SizedBox(
                              height: ScreenUtil.instance.setWidth(10.0)),
                          Text('保存相册',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil.instance.setWidth(26.0),
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    onTap: () {
                      _shareUiImage(3);
                    },
                  ),
                ),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
