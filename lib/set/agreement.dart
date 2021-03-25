import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class Agreement extends StatefulWidget {
  final String type;
  Agreement({this.type});

  @override
  _AgreementState createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  String agreeContent;
  bool isLoading = false;
  String title = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.type == 'yonghu') {
        title = '用户协议';
      } else if (widget.type == 'yinsi') {
        title = '隐私政策';
      } else if (widget.type == 'zhuxiao') {
        title = '注销协议';
      }
    });

    getAgree();
  }

  // 获取个人资料
  void getAgree() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    UserServer().getAbout(map, (success) async {
      setState(() {
        if (widget.type == 'zhuxiao') {
          agreeContent = success['res']['logoff'];
        } else if (widget.type == 'yonghu') {
          agreeContent = success['res']['agree'];
        } else if (widget.type == 'yinsi') {
          agreeContent = success['res']['yinsi'];
        }

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
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      child: Html(data: agreeContent),
    );

    return MaterialApp(
      title: "用户协议",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            title,
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
        body: isLoading
            ? LoadingDialog()
            : new ListView(
                children: [playBox],
              ),
      ),
    );
  }
}
