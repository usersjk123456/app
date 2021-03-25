import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String aboutContent;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getAbout();
  }

  // 获取个人资料
  void getAbout() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    UserServer().getAbout(map, (success) async {
      setState(() {
        aboutContent = success['res']['about'];
        isLoading = false;
      });
    }, (onFail) async {
      isLoading = false;
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget playBox = Container(
      padding: EdgeInsets.all(
        ScreenUtil().setWidth(30)
      ),
      child: Html(data: aboutContent),
    );

    return MaterialApp(
      title: "关于我们",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text(
            '关于我们',
            style: new TextStyle(color: PublicColor.textColor),
          ),
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: PublicColor.textColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:  isLoading ? LoadingDialog() :new ListView(
          children: [playBox],
        ),
      ),
    );
  }
}
