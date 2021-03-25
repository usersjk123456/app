import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../service/grass_service.dart';

class ShareDjango extends StatefulWidget {
  final Map goods;
  final Map user;
  final Function shareGoods;
  final Function setShareCount;
  final Map item;
  String fromType;
  ShareDjango(
      {this.goods,
      this.shareGoods,
      this.setShareCount,
      this.user,
      this.item,
      this.fromType = '2'});
  _ShareDjangoState createState() => _ShareDjangoState();
}

class _ShareDjangoState extends State<ShareDjango> {
  // 小程序分享
  fluwx.WeChatScene scene = fluwx.WeChatScene.SESSION;
  String _webPageUrl = "http://www.qq.com";
  String _thumbnail = "";
  String _title = "";
  String _userName = "gh_8ea5bb721e96";
  String _path = "";
  String _description = "橙子宝宝商城";
  // 分享web
  String _weburl = "";
  String _webtitle = "";
  String _webthumnail = "";
  String _webdesc = "";

  bool isFrist = true;
  @override
  void initState() {
    super.initState();
    // 小程序
    _thumbnail = widget.goods['thumb'];
    _title = widget.goods['name'];

    print('卧槽');
    print('res.errCode--->>>${widget.user}');
    print('无情');
    if (widget.fromType == '1') {
      //霸卖分享
      // pages/bamai/bamaidetail?id='+that.data.id+"&share_id="+that.data.uid
      _path = "/pages/bamai/bamaidetail?share_id=" +
          "${widget.user['id']}" +
          "&id=" +
          "${widget.goods['id']}";
    } else {
      //正常分享
      _path = "/pages/goodsdetail/goodsdetail?share_id=" +
          "${widget.user['id']}" +
          "&goods_id=" +
          "${widget.goods['id']}" +
          "&id=" +
          "${widget.goods['id']}";
    }
    // print(widget.fromType == '1');
    // _path = "/pages/goodsdetail/goodsdetail?share_id=" +
    //     "${widget.user['id']}" +
    //     "&goods_id=" +
    //     "${widget.goods['id']}" +
    //     "&id=" +
    //     "${widget.goods['id']}";
    // print(_path);
    // print("一堆问号");
    // 网页链接
    _weburl = "http://www.hc-ningbo.com:21000/login.html?yqcode=" +
        "${widget.user['id']}" +
        "&goods_id=" +
        "${widget.goods['id']}";
    _webtitle = widget.goods['name'];
    _webthumnail = widget.goods['thumb'];
    _webdesc = widget.goods['desc'];
    print(_weburl);
    print("二堆问号");
    fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is fluwx.WeChatShareResponse) {
        print('res.errCode--->>>${res.errCode}');
        if (res.errCode == 0) {
          if (isFrist && widget.item.toString() != "null") {
            isFrist = false;
            shareSuccess();
          }
        }
      }
    });
  }

  void shareSuccess() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.item['id']);
    GrassServer().plantShare(map, (success) async {
      ToastUtil.showToast('分享成功');
      widget.setShareCount(success['plant']['share']);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void _share(type) {
    var model;
    if (type == 1) {
      // 好友
      setState(() {
        this.scene = fluwx.WeChatScene.SESSION;
      });
      model = fluwx.WeChatShareWebPageModel(
        _weburl,
        title: _webtitle,
        thumbnail: fluwx.WeChatImage.network(_webthumnail),
        description: _webdesc,
        scene: scene,
      );
    } else if (type == 2) {
      // 朋友圈
      setState(() {
        this.scene = fluwx.WeChatScene.TIMELINE;
      });
      model = fluwx.WeChatShareWebPageModel(
        _weburl,
        title: _webtitle,
        thumbnail: fluwx.WeChatImage.network(_webthumnail),
        description: _webdesc,
        scene: scene,
      );
    } else if (type == 3) {
      // 小程序
      setState(() {
        this.scene = fluwx.WeChatScene.SESSION;
      });
      model = fluwx.WeChatShareMiniProgramModel(
        webPageUrl: _webPageUrl,
        userName: _userName,
        title: _title,
        path: _path,
        description: _description,
        thumbnail: fluwx.WeChatImage.network(_thumbnail),
      );
    }
    fluwx.shareToWeChat(model);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      color: Colors.white,
      height: ScreenUtil.instance.setWidth(300.0),
      padding: EdgeInsets.only(
        right: ScreenUtil().setWidth(20),
        top: ScreenUtil().setWidth(15),
      ),
      child: Column(children: [
        Container(
          alignment: Alignment.centerRight,
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
        new SizedBox(
          height: ScreenUtil.instance.setWidth(25.0),
        ),
        /*widget.fromType == '1'
            ? Container()
            : Text(
                '赚${widget.goods['commission']}元',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: ScreenUtil.instance.setWidth(30.0),
                  fontWeight: FontWeight.w700,
                ),
              ),
        widget.fromType == '1'
            ? Container()
            : new SizedBox(
                height: ScreenUtil.instance.setWidth(15.0),
              ),
        widget.fromType == '1'
            ? Container()
            : Text(
                '只要你的好友通过你的链接购买此商品',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil.instance.setWidth(26.0),
                ),
              ),
        widget.fromType == '1'
            ? Container()
            : new SizedBox(
                height: ScreenUtil.instance.setWidth(5.0),
              ),
        widget.fromType == '1'
            ? Container()
            : Text(
                '你就能赚到至少${widget.goods['commission']}元的利润哦~~~',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil.instance.setWidth(26.0),
                ),
              ),
        new SizedBox(
          height: ScreenUtil.instance.setWidth(50.0),
        ),*/
        Container(
          decoration: new ShapeDecoration(
            shape: Border(
              top: BorderSide(color: Color(0xfffececec), width: 1),
            ), // 边色与边宽度
            color: Colors.white,
          ),
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(25),
          ),
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
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text('微信好友',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                              fontWeight: FontWeight.w500)),
                    ])),
                onTap: () {
                  Navigator.pop(context);
                  _share(1);
                  // _share(3);
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
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text('朋友圈',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                              fontWeight: FontWeight.w500)),
                    ])),
                onTap: () {
                  Navigator.pop(context);
                  _share(2);
                },
              ),
            ),
            /*Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                    alignment: Alignment.center,
                    child: Column(children: [
                      Image.asset(
                        'assets/index/xcx.png',
                        width: ScreenUtil.instance.setWidth(97.0),
                      ),
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text('小程序',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                              fontWeight: FontWeight.w500)),
                    ])),
                onTap: () {
                  // Navigator.pop(context);
                  _share(3);
                  // ToastUtil.showToast('暂未开放');
                },
              ),
            ),*/
            // Expanded(
            //   flex: 1,
            //   child: InkWell(
            //     child: Container(
            //         alignment: Alignment.center,
            //         child: Column(children: [
            //           Image.asset(
            //             'assets/index/spewm.png',
            //             width: ScreenUtil.instance.setWidth(97.0),
            //           ),
            //           new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
            //           Text('商品二维码',
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: ScreenUtil.instance.setWidth(26.0),
            //                   fontWeight: FontWeight.w500)),
            //         ])),
            //     onTap: () {
            //       print('商品二维码');
            //       Navigator.pop(context);
            //       widget.shareGoods();
            //     },
            //   ),
            // ),
          ]),
        )
      ]),
    );
  }
}
