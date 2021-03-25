import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import '../utils/toast_util.dart';
import '../service/user_service.dart';
import '../common/Global.dart';

class ShareDjango extends StatefulWidget {
  final String type;
  ShareDjango({this.type});
  _ShareDjangoState createState() => _ShareDjangoState();
}

class _ShareDjangoState extends State<ShareDjango> {
  // 小程序分享
  WeChatScene scene = WeChatScene.SESSION;
  // 分享web
  String _weburl = "";
  String _webtitle = "";
  String _webdesc = "";
  String _webthumnail = "assets/login/share_logo.png";
  String phone = "";

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      Map<String,dynamic> user = success["user"];
      setState(() {
        phone = Global.formatPhone(user['phone'].toString());
      });
      if (widget.type == "open") {
        _webtitle = "橙子宝宝直播邀请您注册";
        _webdesc = "橙子宝宝直播邀请您一起开启创业之旅";
        _weburl = "http://sharezhibo.yunzhonghulu.cn?shangji=" +
            user['id'].toString();
      } else if (widget.type == "invite") {
        // _webtitle = "橙子宝宝给你送豪礼啦";
        // _webdesc = "橙子宝宝直播邀请您成为TA的VIP";
        _webtitle = "橙子宝宝";
        _webdesc = "邀请您免费注册VIP亿元补贴等你拿！";
        _weburl = "http://www.hc-ningbo.com:21000/login.html?yqcode=" +
            user['id'].toString();
      } else if (widget.type == "startLive") {
        _webtitle = "橙子宝宝";
        _webdesc = "橙子宝宝直播";
        _weburl = "http://sharezhibo.yunzhonghulu.cn?shangji=" +
            user['id'].toString();
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void _share(type) {
    var model;
    if (type == 1) {
      // 好友
      setState(() {
        this.scene = WeChatScene.SESSION;
      });
      model = WeChatShareWebPageModel(
        _weburl,
        title: _webtitle,
        thumbnail: WeChatImage.asset(_webthumnail),
        description: _webdesc,
        scene: scene,
      );
    } else if (type == 2) {
      // 朋友圈
      setState(() {
        this.scene = WeChatScene.TIMELINE;
      });
      model = WeChatShareWebPageModel(
        _weburl,
        title: _webtitle,
        thumbnail: WeChatImage.asset(_webthumnail),
        description: _webdesc,
        scene: scene,
      );
    }
    shareToWeChat(model).then((res) {}, onError: (msg) {
      ToastUtil.showToast(msg);
    });
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
        Container(
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
                  print('微信好友');
                  _share(1);
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
                  print('朋友圈');
                  _share(2);
                },
              ),
            ),
          ]),
        )
      ]),
    );
  }
}
