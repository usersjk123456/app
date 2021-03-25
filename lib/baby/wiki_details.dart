import 'package:client/api/api.dart';
import 'package:client/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class Wikidetails extends StatefulWidget {
  final bookId;
  Wikidetails({this.bookId});
  @override
  WikidetailsState createState() => WikidetailsState();
}

class WikidetailsState extends State<Wikidetails> {
  String aboutContent;
  bool isLoading = false;
  String title = '', text = '';
  bool scStatus = true;
  int isSc = 2;
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  void clickSc() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 3);
    map.putIfAbsent("id", () => widget.bookId);
    Service().getData(map, Api.COLLECTION_URL, (success) async {
      print(success);

      if (isSc == 1) {
        ToastUtil.showToast('已取消收藏');
      } else {
        ToastUtil.showToast('收藏成功');
      }

      setState(() {
        scStatus = true;
      });
      getDetails();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  getDetails() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.bookId);
    Service().getData(map, Api.BOOK_DETAILS_URL, (success) async {
      print(success);
      setState(() {
        title = success['list']['data']['title'];
        text = success['list']['data']['text'];
        isSc = success['list']['data']['is_collection'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return MaterialApp(
      title: "书名",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '${title}',
            style: new TextStyle(color: PublicColor.headerTextColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(37)),
              child: InkWell(
                  child: isSc == 1
                      ? Image.asset(
                          'assets/foods/ic_shoucang_xuanzhong.png',
                          width: ScreenUtil.instance.setWidth(38.0),
                        )
                      : Image.asset(
                          'assets/foods/ic_shoucang.png',
                          width: ScreenUtil.instance.setWidth(38.0),
                        ),
                  onTap: () {
                    if (scStatus) {
                      setState(() {
                        scStatus = false;
                      });
                      clickSc();
                    }
                    print(scStatus);
                    print('收藏');
                  }),
            ),
            //辅食分享
            // Container(
            //   margin: EdgeInsets.only(right: ScreenUtil().setWidth(37)),
            //   child: InkWell(
            //       child: Image.asset(
            //         'assets/foods/ic_fenxiang.png',
            //         width: ScreenUtil.instance.setWidth(38.0),
            //       ),
            //       onTap: () {
            //         print('分享');
            //       }),
            // )
          ],
        ),
        body: isLoading
            ? LoadingDialog()
            : Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(30),
                    bottom: ScreenUtil().setWidth(20),
                    left: ScreenUtil().setWidth(35),
                    right: ScreenUtil().setWidth(35)),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(40),
                        ),
                        child: Text(
                          '${title}',
                          style: new TextStyle(
                            color: PublicColor.textColor,
                            fontSize: ScreenUtil.instance.setSp(32),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '${text}',
                          style: new TextStyle(
                            color: Color(0xff666666),
                            fontSize: ScreenUtil.instance.setSp(28),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
