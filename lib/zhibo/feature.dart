import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'live_coupon_send.dart';

// 举报弹窗
class FeatureWidget extends StatefulWidget {
  final switchCamera;
  final startmeiyan;
  final controller;
  final String roomId;
  final Function changeVoice;
  FeatureWidget({
    this.switchCamera,
    this.startmeiyan,
    this.controller,
    this.roomId,
    this.changeVoice,
  });
  @override
  FeatureWidgetState createState() => FeatureWidgetState();
}

class FeatureWidgetState extends State<FeatureWidget> {
  String voiceStatue = '1';

  @override
  void initState() {
    super.initState();
    getVoiceStatus();
  }

  Future getVoiceStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      voiceStatue = prefs.getString('voiceStatue');
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 600)..init(context);
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Menu(
            icon: 'assets/zhibo/icon_xuanzhuan.png',
            name: '翻转',
            tapFun: () {
              widget.switchCamera();
            },
          ),
          Menu(
            icon: 'assets/zhibo/icon_meiyan.png',
            name: '美颜',
            tapFun: () {
              widget.startmeiyan();
            },
          ),
          Menu(
            icon: 'assets/zhibo/icon_yulanjingxiang.png',
            name: '直播镜像',
            tapFun: () {
              widget.controller.setPreviewMirror(mirror: true);
            },
          ),
          Menu(
            icon: 'assets/zhibo/icon_tuiliu.png',
            name: '用户镜像',
            tapFun: () {
              widget.controller.setEncodingMirror(mirror: true);
            },
          ),
          // Menu(
          //   icon: 'assets/zhibo/icon_youhui.png',
          //   name: '优惠券',
          //   tapFun: () {
          //     showModalBottomSheet(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return SendCoupon(roomId: widget.roomId);
          //       },
          //     );
          //   },
          // ),
          Menu(
            icon: voiceStatue == '0'
                ? 'assets/zhibo/icon_jingyin.png'
                : 'assets/zhibo/icon_shengyinpng.png',
            name: '声音',
            tapFun: () async {
              print('静音推流');
              await widget.changeVoice();
              await getVoiceStatus();
              widget.controller.mute(mute: true, audioSource: null);
            },
          ),
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final String icon;
  final String name;
  final Function tapFun;
  Menu({this.icon, this.name, this.tapFun});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tapFun();
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(136),
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(20),
        ),
        child: Column(
          children: <Widget>[
            Image.asset(
              icon,
              width: ScreenUtil.instance.setWidth(92.0),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(26),
                color: Color(0xff454545),
              ),
            )
          ],
        ),
      ),
    );
  }
}
