import 'package:client/api/api.dart';
import 'package:client/widgets/base_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/swiper.dart';
import '../widgets/cached_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:async';
import 'package:flutter/rendering.dart';
import '../utils/toast_util.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Navigator_util.dart';
import './share_django.dart';
import '../common/Global.dart';
import '../service/goods_service.dart';
import '../service/user_service.dart';
import '../common/color.dart';
import './goodsSpec.dart';
import 'detail_comment.dart';

class XiangQingPage extends StatefulWidget {
  final String oid;
  final String shipId;
  final String roomId;
  XiangQingPage({this.oid, this.shipId, this.roomId});
  @override
  _XiangQingPageState createState() => _XiangQingPageState();
}

List guige = [];
int buynum = 1;
int checkindex = 0;

class _XiangQingPageState extends State<XiangQingPage>
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
  };
  Map user = {
    'phone': 0,
    "headimgurl":
        "https://pic1.zhimg.com/v2-fda399250493e674f2152c581490d6eb_1200x500.jpg",
    "nickname": "1",
  };
  List xiangqingimglist = [];
  List bannerList = [];
  List tuijianlist = [];
  int _page = 0;
  String kfToken = '';
  List commentList = [];
  String count = '0';
  bool isLive = false, isStore = false;

  @override
  void initState() {
    super.initState();
    print('roomId===${widget.roomId}');
    buynum = 1;
    getLocal();
    _page = 0;

    _controller.finishRefresh();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getLocal();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString('jwt');
    if (jwt != null) {
      await loaduser(); // 分享加载头像
    }
    await getGoodsDetails();
    await loadtuijian(); // 加载推荐商品
    await getComment();
  }

  Future loaduser() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    UserServer().getUserInfo(map, (success) async {
      setState(() {
        user = success["user"];
        isLive = success['is_live'].toString() == "0" ? false : true;
        isStore = success['is_store'].toString() == "0" ? false : true;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 商品详情
  Future getGoodsDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    GoodsServer().getGoodsDetails(map, (success) async {
      setState(() {
        isLoading = false;
        bannerList = success['banner'];
        kfToken = success['kf_token'];
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

  // 评论
  Future getComment() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);
    map.putIfAbsent("page", () => 1);
    map.putIfAbsent("limit", () => 2);
    GoodsServer().getServer(map, Api.GET_COMMENT, (success) async {
      if (mounted) {
        setState(() {
          commentList = success['list'];
          count = success['count'].toString();
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 推荐商品
  Future loadtuijian() async {
    _page++;
    Map<String, dynamic> map = Map();
    map.putIfAbsent("category_id", () => goods['category_id'].toString());
    map.putIfAbsent("limit", () => 20);
    map.putIfAbsent("page", () => _page);

    GoodsServer().getRecommentList(map, (success) async {
      if (_page == 1) {
        tuijianlist = [];
      }
      setState(() {
        if (_page == 1) {
          tuijianlist = success['goods'];
        } else {
          if (success['goods'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['goods'].length; i++) {
              tuijianlist.insert(tuijianlist.length, success['goods'][i]);
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: Text(
              '宝贝详情',
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
            // actions: <Widget>[
            //   MaterialButton(
            //       child: Icon(
            //         Icons.share,
            //         size: 25.0,
            //         color: Colors.black,
            //       ),
            //       onPressed: () {
            //         print('分享');
            //         if (jwt == null) {
            //           ToastUtil.showToast(Global.NO_LOGIN);
            //           return;
            //         }
            //         shareGoods();
            //         // showDialog(
            //         //     context: context,
            //         //     barrierDismissible: true,
            //         //     builder: (BuildContext context) {
            //         //       return _shareWidget(context);
            //         //     });
            //       }),
            // ],
          ),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container()
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

  Widget contentWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(100.0)),
          color: Color(0xffff5f5f5),
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
            onRefresh: () async {
              getLocal();
            },
            onLoad: () async {
              loadtuijian();
            },
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Stack(
                children: <Widget>[
                  SwiperView(
                    bannerList,
                    0,
                    ScreenUtil.instance.setWidth(750.0),
                    'xq',
                  ),
                  /*Positioned(
                    left: 10,
                    bottom: 10,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/index/rx.png',
                          width: ScreenUtil().setWidth(40),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Text('热销${goods["buy_count"]}件',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color(0xfffe0036),
                            )),
                      ],
                    ),
                  ),*/
                ],
              ),

              Container(
                height: ScreenUtil.instance.setWidth(105.0),
                width: ScreenUtil.instance.setWidth(750.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/index/xstm.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(children: [
                  Container(
                    height: ScreenUtil.instance.setWidth(105.0),
                    // padding: EdgeInsets.only(left:ScreenUtil.instance.setWidth(25.0)),
                    width: ScreenUtil.instance.setWidth(200.0),
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '￥${goods['is_love'] == 1 ? goods['love_price'] : goods['now_price']}',
                            style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(32.0),
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            ' 原价￥${goods['old_price']}',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(24.0),
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        ]),
                  ),
                  Container(
                      width: ScreenUtil.instance.setWidth(520.0),
                      alignment: Alignment.centerRight,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: ScreenUtil.instance.setWidth(240.0),
                                  height: ScreenUtil.instance.setWidth(30.0),
                                  alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: Colors.white),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: ScreenUtil.instance
                                              .setWidth(30.0),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              child: LinearProgressIndicator(
                                                value: goods['stock'] /
                                                    (goods['stock'] +
                                                        goods['buy_count'] +
                                                        0.1),
                                                backgroundColor:
                                                    Color(0xfffffffff),
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(0xffff2432a)),
                                              )),
                                        ),
                                        Text('仅剩${goods['stock']}件',
                                            style: TextStyle(
                                                fontSize: ScreenUtil.instance
                                                    .setWidth(20.0),
                                                color: PublicColor.themeColor)),
                                      ]),
                                ),
                              ],
                            ),
                            // Text('距离结束剩 07:36:45',
                            //     style: TextStyle(
                            //         fontSize:
                            //             ScreenUtil.instance.setWidth(24.0),
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.w700))
                          ]))
                ]),
              ),
              Container(
                height: ScreenUtil.instance.setWidth(115.0),
                width: ScreenUtil.instance.setWidth(750.0),
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(25),
                  right: ScreenUtil().setWidth(25),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/index/temai.png',
                          //   width: ScreenUtil.instance.setWidth(70.0),
                          // ),
                          Padding(
                              padding: new EdgeInsets.all(5.0),
                              child: Text(
                                '特卖',
                                style: TextStyle(
                                    backgroundColor: Color(0xffFB1F29),
                                    color: Colors.white),
                              )),

                          SizedBox(
                            width: ScreenUtil().setWidth(16),
                          ),
                          Container(
                            // color: Colors.black87,
                            alignment: Alignment.centerLeft,
                            width: ScreenUtil().setWidth(430),
                            child: Text(
                              '${goods['name']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(32.0),
                                color: Color(0xfff000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/index/qd.png',
                              width: ScreenUtil.instance.setWidth(40.0),
                            ),
                            Text('￥${goods['commission']}',
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.instance.setWidth(24.0),
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700))
                          ],
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              Container(
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(15),
                ),
                height: ScreenUtil.instance.setWidth(80.0),
                width: ScreenUtil.instance.setWidth(750.0),
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Text(
                        '规格',
                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(26.0),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            checkindex1 == -1
                                ? '请选择 >'
                                : guige[checkindex1]['name'],
                            style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(26.0),
                                color: Colors.black),
                          ),
                        ),
                        onTap: () {
                          print('选择规格=====${widget.shipId}');
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return GuigeWidget(
                                  onChanged: (index) {
                                    if (index == -1) {
                                      getLocal();
                                    } else {
                                      setState(() {
                                        checkindex1 = index;
                                      });
                                    }
                                  },
                                  jwt: jwt.toString(),
                                  goods: goods,
                                  isLive: isLive,
                                  shipId: widget.shipId.toString() == 'null'
                                      ? '0'
                                      : widget.shipId,
                                  roomId: widget.roomId,
                                  guige: guige,
                                );
                              });
                        },
                      ),
                    )
                  ],
                ),
              ),
                  Container(
                    height: ScreenUtil.instance.setWidth(80.0),

                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/shop/check.png",
                          width: 14,
                          height: 14,
                        ),
                        BaseText("7天无理由退货（拆封后不支持）",
                        color: Colors.grey,
                        fontSize: 12,),
                        Container(
                          margin: EdgeInsets.only(
                              left: 15
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/shop/check.png",
                                width: 14,
                                height: 14,
                              ),
                              BaseText("假一赔四",color: Colors.grey,
                                fontSize: 12,
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
              commentList.length != 0
                  ? CommentWidget(
                      goodsId: widget.oid,
                      commentList: commentList,
                      count: count)
                  : Container(),
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
                    Text(
                      '宝贝详情',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(35),
                        color: Color(0xfff7a7a7a),
                      ),
                    ),
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
                padding: EdgeInsets.all(
                  ScreenUtil().setWidth(20),
                ),
                child: Text(
                  '${goods['content']}',
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
              // i['img'],
              new Column(
                mainAxisSize: MainAxisSize.max,
                children: xiangqingimglist
                    .map(
                      (i) => Container(
                        width: ScreenUtil().setWidth(750),
                        child: Image.network(
                          i['img'],
                          width: ScreenUtil().setWidth(750),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    )
                    .toList(),
              ),
              tuijianlist.length > 0
                  ? Container(
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
                          Text(
                            '为你推荐',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(35),
                              color: Color(0xfff7a7a7a),
                            ),
                          ),
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
                    )
                  : Container(),
              Container(
                width: ScreenUtil.instance.setWidth(750.0),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25)),
                child: tuijianlist.length > 0
                    ? GridView.builder(
                        shrinkWrap: true,
                        itemCount: tuijianlist.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.675,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return _getGridViewItem(context, tuijianlist[index]);
                        })
                    : Text(''),
              )
            ])),
          ),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(100.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: InkWell(
                  child: Container(
                    height: ScreenUtil.instance.setWidth(100.0),
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(children: [
                          Icon(
                            Icons.face,
                          ),
                        ]),
                        Text(
                          '客服',
                          style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(28.0),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    print('客服');
                    NavigatorUtils.goService(context, kfToken);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  child: Container(
                    height: ScreenUtil.instance.setWidth(100.0),
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(children: [
                          Icon(
                            Icons.local_grocery_store,
                          ),
                          Positioned(
                              child: Container(
                                alignment: Alignment.center,
                                width: ScreenUtil.instance.setWidth(25.0),
                                height: ScreenUtil.instance.setWidth(25.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  color: Colors.red,
                                ),
                                child: Text('${goods['cart_num']}',
                                    style: TextStyle(
                                      fontSize:
                                          ScreenUtil.instance.setWidth(18.0),
                                      color: Colors.white,
                                    )),
                              ),
                              right: 0,
                              top: 0)
                        ]),
                        Text(
                          '购物车',
                          style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(28.0),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    print('购物车');
                    NavigatorUtils.toShoppingCart(context);
                  },
                ),
              ),
              Expanded(
                flex: !isLive && !isStore ? 10 : 5,
                child: InkWell(
                  onTap: goods['stock'] <= 0 ? (){
                    ToastUtil.showToast("商品剩余不足，无法购买");
                  } : () {
                    print('省钱购=====${widget.shipId}');
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return GuigeWidget(
                          onChanged: (index) {
                            if (index == -1) {
                              getLocal();
                            } else {
                              setState(() {
                                checkindex1 = index;
                              });
                            }
                          },
                          jwt: jwt.toString(),
                          goods: goods,
                          isLive: isLive,
                          shipId: widget.shipId.toString() == 'null'
                              ? '0'
                              : widget.shipId,
                          roomId: widget.roomId,
                          guige: guige,
                        );
                      },
                    );
                  },
                  child: !isLive &&
                          (widget.roomId == '0' ||
                              widget.roomId.toString() == 'null')
                      ? Container(
                          alignment: Alignment.center,
                          color: Color(0xfffe483b),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '立即购买',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          color: Color(0xffF2117A),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '省钱购',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '省${goods['commission']}',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
              !isLive && !isStore
                  ? Container()
                  : Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          // ToastUtil.showToast('暂未开放');
                          if (jwt == null) {
                            ToastUtil.showToast(Global.NO_LOGIN);
                            return;
                          }
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ShareDjango(
                                goods: goods,
                                shareGoods: shareGoods,
                                user: user,
                              );
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Color(0xff5D1CD3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '分享赚',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Colors.white,
                                ),
                              ),
                           /*   Text(
                                '赚${goods['commission']}',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Colors.white,
                                ),
                              )*/
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getGridViewItem(BuildContext context, productEntity) {
    return Container(
      child: InkWell(
          onTap: () {
            print(productEntity);
            String oid = (productEntity['id']).toString();
            NavigatorUtils.toXiangQing(context, oid, '0', '0');
          },
          child: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))), //设置圆角
            child: Stack(children: [
              Container(
                child: CachedImageView(
                  100000,
                  ScreenUtil.instance.setWidth(340.0),
                  productEntity['thumb'],
                  null,
                  BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(350),
                    left: ScreenUtil().setWidth(5),
                    right: ScreenUtil().setWidth(5)),
                child: Column(
                  children: <Widget>[
                    Text(productEntity['name'],
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.instance.setWidth(26.0))),
                    new SizedBox(height: ScreenUtil.instance.setWidth(8.0)),
                    Row(children: [
                      Expanded(
                        flex: 3,
                        child: RichText(
                          text: TextSpan(
                            text: '￥' + productEntity['now_price'].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil.instance.setWidth(28)),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' /赚￥' +
                                    productEntity['commission'].toString(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: ScreenUtil.instance.setWidth(28),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenUtil().setWidth(50),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xfffffd509),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Text(
                            '购买',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26),
                            ),
                          ),
                        ),
                      ),
                    ])
                  ],
                ),
              )
            ]),
          )),
    );
  }
}
