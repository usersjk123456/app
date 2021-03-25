import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:client/service/live_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import '../utils/toast_util.dart';

class LiveShare extends StatefulWidget {
  final Map objs;
  final Map userinfo;
  final String ewm;
  final String roomId;
  final Function shareOver;
  final Function closeShare;
  LiveShare(
      {this.objs,
      this.ewm,
      this.roomId,
      this.shareOver,
      this.userinfo,
      this.closeShare});
  @override
  LiveShareState createState() => LiveShareState();
}

class LiveShareState extends State<LiveShare> {
  GlobalKey globalKey = GlobalKey();
  bool isLoading = false;
  // 小程序分享
  WeChatScene scene = WeChatScene.SESSION;
  String _webPageUrl = "http://sharezhibo.yunzhonghulu.cn";
  String _thumbnail = "";
  String _title = "";
  String _userName = "gh_8ea5bb721e96";
  String _path = "";
  String _description = "橙子宝宝商城";
  String ewmimg = '';
  @override
  void initState() {
    super.initState();
    // 小程序
    _thumbnail = widget.objs['room']['img'];
    _title = widget.objs['room']['desc'];
    _path = "pages/zhibo/zhibo?room_id=" +
        widget.objs['room']['id'].toString() +
        "&id=" +
        "${widget.userinfo['id']}";
    fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is fluwx.WeChatShareResponse) {
        if (res.errCode == 0) {
          if (widget.shareOver.toString() != "null") {
            widget.shareOver();
          }
        }
      }
    });
    clickShare();
    debugPrint('-----------------------------');
    print(widget.userinfo);
    debugPrint(widget.ewm);
  }

  Future<ByteData> _capturePngToByteData() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
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
      // '保存成功'
    }
  }

  void _share() {
    var model;
    setState(() {
      this.scene = WeChatScene.SESSION;
    });
    model = new WeChatShareMiniProgramModel(
      webPageUrl: _webPageUrl,
      userName: _userName,
      title: _title,
      path: _path,
      description: _description,
      thumbnail: WeChatImage.network(_thumbnail),
    );
    shareToWeChat(model);
  }

  void clickShare() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    LiveServer().clickshare(map, (success) async {
      print('成功');
      print(success);
      setState(() {
        ewmimg = success['data'];
      });
    }, (onFail) async {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget share = RepaintBoundary(
      key: globalKey,
      child: Container(
        width: ScreenUtil().setWidth(650),
        height: ScreenUtil().setWidth(1020),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(550),
              width: ScreenUtil().setWidth(650),
              alignment: Alignment.centerLeft,
              child: Image.network(
                widget.objs['room']['img'],
                // 'http://yzhlimgserver.yunzhonghulu.cn/2020-09-17/images_55774febb65ea025c023d37c4543f5ae.png',
                width: ScreenUtil().setWidth(650),
                height: ScreenUtil().setWidth(550),
                fit: BoxFit.fitWidth,
              ),
            ),
            // new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(30),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.objs['room']['desc'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(35)),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(50)),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      widget.userinfo['headimgurl'],
                                      fit: BoxFit.fill,
                                      width: ScreenUtil().setWidth(120),
                                      height: ScreenUtil().setWidth(120),
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(20)),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${widget.userinfo['nickname']}推荐",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(30)),
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(20)),
                                        Text(
                                          "长按扫码观看",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(26)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ewmimg != ""
                        ? Image.network(
                            ewmimg,
                            width: ScreenUtil().setWidth(200),
                          )
                        : Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
    return InkWell(
      onTap: () {
        widget.closeShare();
      },
      child: Container(
          width: ScreenUtil.instance.setWidth(750.0),
          height: ScreenUtil.instance.setHeight(1334.0),
          // color: Colors.red,
          child: Stack(
            children: <Widget>[
              Container(
                // color: Colors.white,
                height: ScreenUtil.instance.setHeight(1334.0),
                child: Column(children: [
                  SizedBox(
                    height: ScreenUtil.instance.setHeight(1334) -
                        ScreenUtil.instance.setWidth(250.0),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(50)),
                    height: ScreenUtil.instance.setWidth(250.0),
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/index/weixin.png',
                                  width: ScreenUtil.instance.setWidth(97.0),
                                ),
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(10.0)),
                                Text(
                                  '微信好友',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(26.0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // clickShare();
                            // Navigator.pop(context);
                            widget.closeShare();
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
                                        fontSize:
                                            ScreenUtil.instance.setWidth(26.0),
                                        fontWeight: FontWeight.w500)),
                              ])),
                          onTap: () {
                            // clickShare();
                            // Navigator.pop(context);
                            widget.closeShare();
                            _shareUiImage(2);
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
                                  'assets/index/xcx.png',
                                  width: ScreenUtil.instance.setWidth(97.0),
                                ),
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(10.0)),
                                Text('小程序',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            ScreenUtil.instance.setWidth(26.0),
                                        fontWeight: FontWeight.w500)),
                              ])),
                          onTap: () {
                            // clickShare();
                            // Navigator.pop(context);
                            widget.closeShare();
                            _share();
                          },
                        ),
                      ),
                    ]),
                  ),
                ]),
              ),
              Positioned(
                left: ScreenUtil.instance.setWidth(50.0),
                top: ScreenUtil.instance.setWidth(130.0),
                child: share,
              ),
              // isLoading? LoadingDialog() : Container(),
            ],
          )),
    );
  }
}
