import 'package:client/config/Navigator_util.dart';
import 'package:client/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';

class AuthenticationWaitingPage extends StatefulWidget {
  @override
  _AuthenticationWaitingPageState createState() =>
      _AuthenticationWaitingPageState();
}

class _AuthenticationWaitingPageState extends State<AuthenticationWaitingPage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
      child: Column(
        children: <Widget>[
          Image.asset("assets/shop/waiting.png",
              width: ScreenUtil().setWidth(216)),
          SizedBox(
            height: ScreenUtil().setWidth(30),
          ),
          Text('已提交审核，请耐心等待平台人员处理',
              style: TextStyle(fontSize: ScreenUtil().setSp(30)))
        ],
      ),
    );

    Widget inforArea = new Container(
      child: Column(
        children: <Widget>[
          Text(
            '填写完成后请耐心等待1~3个工作日',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
              color: Colors.red,
            ),
          ),
          Text(
            '属于你的精美店铺就可以开业啦',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
              color: Colors.red,
            ),
          )
        ],
      ),
    );

    Widget btnArea = BigButton(
      name: '返回',
      tapFun: () {
        NavigatorUtils.goHomePage(context, "3");
      },
      top: ScreenUtil().setWidth(40),
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
                '供销商认证',
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
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  topArea,
                  btnArea,
                  inforArea,
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
