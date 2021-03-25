import 'package:client/api/api.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/read_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class WikiAll extends StatefulWidget {
  @override
  WikiAllState createState() => WikiAllState();
}

class WikiAllState extends State<WikiAll> {
  String aboutContent;
  bool isLoading = false;
  List readlist = [];
  @override
  void initState() {
    super.initState();
    getRead();
  }

  void getRead() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => 1);
    Service().getData(map, Api.BOOK_TJ_URL, (success) async {
      print('~~~~~~~~~~~~~~~');
      setState(() {
        readlist = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget contentView = Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(44)),
      color: PublicColor.whiteColor,
      child: Column(
        children: <Widget>[
          readlist.length > 0 ? Readlist(item: readlist) : Container()
        ],
      ),
    );
    return MaterialApp(
      title: "推荐阅读",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '推荐阅读',
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
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[contentView],
                  ),
                ),
              ),
      ),
    );
  }
}
