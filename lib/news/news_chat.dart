import 'package:client/config/Navigator_util.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatCell extends StatefulWidget {
  @override
  _ChatCellState createState() => _ChatCellState();
}

class _ChatCellState extends State<ChatCell> {
  String kfToken = '';

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          kfToken = success['kf_token'];
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Container();

      new InkWell(
      child: new Container(
        height: ScreenUtil().setHeight(128),
        width: ScreenUtil().setWidth(700),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular((8.0)),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: new Container(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/login/share_logo.png",
                  width: ScreenUtil().setWidth(72),
                  height: ScreenUtil().setSp(72),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                '橙子宝宝直播官方客服',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xff545454),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print('聊天');
        NavigatorUtils.goService(context, kfToken);
      },
    );
  }
}
