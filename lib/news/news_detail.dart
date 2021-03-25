import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import 'package:client/service/user_service.dart';

class NewsDetailPage extends StatefulWidget {
  final String id;
  NewsDetailPage(this.id);
  @override
  NewsDetailPageState createState() => NewsDetailPageState();
}

class NewsDetailPageState extends State<NewsDetailPage> {
  bool isLoading = false;
  String title = '';
  String content = '';
  String time = '';
  @override
  void initState() {
    super.initState();
    detailApi();
  }

  void detailApi() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.id);

    UserServer().getNewsDetail(map, (success) async {
      setState(() {
        isLoading = false;
      });
      setState(() {
        title = success['res']['title'];
        content = success['res']['content'];
        time = success['res']['create_at'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget detailArea = new Expanded(

      flex: 1,
      child: ListView(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 10, ScreenUtil().setWidth(20), 0),
            // height: ScreenUtil().setWidth(126),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffe5e5e5),
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color(0xff342816),
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: Color(0xff87837d),
                        fontSize: ScreenUtil().setSp(26),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 10, ScreenUtil().setWidth(20), 15),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    content,
                    style: TextStyle(
                      color: Color(0xff838383),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
    return MaterialApp(
      title: "消息详情",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '公告详情',
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
            : new Container(
                alignment: Alignment.center,
                child: new Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [detailArea],
                ),
              ),
      ),
    );
  }
}
