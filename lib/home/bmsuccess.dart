import 'dart:io';
import 'dart:typed_data';

import 'package:client/config/Navigator_util.dart';
import 'package:client/config/fluro_convert_util.dart';
import 'package:client/home/share_django.dart';
import 'package:client/service/goods_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:client/widgets/checkbox.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import '../widgets/loading.dart';
import 'dart:ui' as ui;

class BMDialog extends Dialog {
  final String uid;
  final Function sure;
  final Map goods;
  BMDialog({this.uid, this.sure, this.goods});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Agreement(uid: uid, sure: sure, goods: goods),
    );
  }
}

class Agreement extends StatefulWidget {
  final String uid;
  final Function sure;
  final Map goods;
  Agreement({this.uid, this.sure, this.goods});
  @override
  _AgreementState createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  // OpenLive({@required this.krPrice, @required this.expendStore});
  TextEditingController idController = TextEditingController();
  var btnActive = false;
  var inviteId = '';
  bool checkStatus = false;
  bool isLoading = false;
  String orderId = "";
  GlobalKey globalKey = GlobalKey();
  @override
  void initState() {
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    print(widget.goods);
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    super.initState();
  }

  _checkCart(bool isCheck) {
    setState(() {
      checkStatus = isCheck;
    });
  }

  void shareGoods() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("goods_id", () => widget.goods['list']['id']);
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
        new Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          child: new Center(
            //保证控件居中效果
            child: new Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30),
                bottom: ScreenUtil().setWidth(40),
              ),
              width: ScreenUtil().setWidth(600),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(30),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(50),
                      bottom: ScreenUtil().setWidth(50),
                    ),
                    child: Text(
                      '拼团参团成功',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(34),
                      ),
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text:
                            '拼团参团成功！请您耐心等待成团。成团后若您没拼团成功，将货款+补贴退回，（到我的——我的余额查询，余额可继续参与拼团）。若拼团成功，请等候平台发货。如果在规定时间内没有成团，将货款退回到余额，没有补贴。感谢您的支持！',
                        style: TextStyle(
                          color: PublicColor.fontColor,
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(50),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: FlatButton(
                          onPressed: () {
                            print(widget.goods['list']);
                            // print(widget.goods['list']['list']);
                            print(widget.goods['list'][0]['user']);
                            // ToastUtil.showToast('暂未开放');
                            print('ssss');
                            // if (jwt == null) {
                            //   ToastUtil.showToast(Global.NO_LOGIN);
                            //   return;
                            // }

                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ShareDjango(
                                    goods: widget.goods['list'][0]['goods'],
                                    shareGoods: shareGoods,
                                    user: widget.goods['list'][0]['user'],
                                    fromType: '1');
                              },
                            );
                            // }
                          },
                          child: Text(
                            '邀请好友',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: PublicColor.themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        height: ScreenUtil().setWidth(80),
                        width: ScreenUtil().setWidth(240),
                      ),
                      Container(
                        height: ScreenUtil().setWidth(80),
                        width: ScreenUtil().setWidth(240),
                        decoration: BoxDecoration(
                            color: PublicColor.grewNoticeColor,
                            borderRadius: new BorderRadius.circular((8.0))),
                        child: new FlatButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            widget.sure();
                          },
                          child: new Text(
                            '关闭',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
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
                      child: Text(widget.goods['list']['store_name'],
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
                          widget.goods['list']['thumb'],
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
                                      text:
                                          '￥${widget.goods['list']['now_price']}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: ScreenUtil.instance
                                              .setWidth(27.0)),
                                      children: [
                                        TextSpan(
                                            text:
                                                '￥${widget.goods['list']['old_price']}',
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
                                Text(widget.goods['list']['name'],
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
                            widget.goods['user']['headimgurl'],
                            null,
                            BorderRadius.all(Radius.circular(50))),
                        new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                        Container(
                          width: ScreenUtil.instance.setWidth(200.0),
                          height: ScreenUtil.instance.setWidth(100.0),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.goods['user']['nickname'],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(27.0))),
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(10.0)),
                                Text(widget.goods['user']['phone'].toString(),
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
