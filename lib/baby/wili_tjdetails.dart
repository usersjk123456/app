import 'package:client/api/api.dart';
import 'package:client/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class WikiTjDetails extends StatefulWidget {
  final bookId;
  WikiTjDetails({this.bookId});
  @override
  WikiTjDetailsState createState() => WikiTjDetailsState();
}

class WikiTjDetailsState extends State<WikiTjDetails> {
  String aboutContent;
  bool isLoading = false;
  Map alldata = {};
  bool dzStatus = true;
  bool scStatus = true;
  @override
  void initState() {
    super.initState();
    // tongji();
    getData();
  }

  void getData() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.bookId);
    Service().getData(map, Api.TJBOOK_DETAILS_URL, (success) async {
      setState(() {
        alldata = success['list'];
      });
      // print(alldata);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // void tongji() {
  //   Map<String, dynamic> map = Map();
  //   map.putIfAbsent("id", () => widget.bookId);
  //   Service().getData(map, Api.FKVISITS_URL, (success) async {},
  //       (onFail) async {
  //     ToastUtil.showToast(onFail);
  //   });
  // }

  void clickZan() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 1);
    map.putIfAbsent("id", () => widget.bookId);
    Service().getData(map, Api.LIKE_URL, (success) async {
      print(success);
      if (alldata['is_like'] == 1) {
        ToastUtil.showToast('已取消点赞');
      } else {
        ToastUtil.showToast('点赞成功');
      }
      setState(() {
        dzStatus = true;
      });
      getData();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void clickSc() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 1);
    map.putIfAbsent("id", () => widget.bookId);
    Service().getData(map, Api.COLLECTION_URL, (success) async {
      print(success);

      if (alldata['is_collection'] == 1) {
        ToastUtil.showToast('已取消收藏');
      } else {
        ToastUtil.showToast('收藏成功');
      }

      setState(() {
        scStatus = true;
      });
      getData();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget viewContent = Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(37), left: ScreenUtil().setWidth(45),right: ScreenUtil().setWidth(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Text(
            '${alldata['title']}',
            style: TextStyle(
              color: PublicColor.textColor,
              fontSize: ScreenUtil.instance.setWidth(32.0),
            ),
          )),
          // Container(
          //     margin: EdgeInsets.only(
          //         top: ScreenUtil().setWidth(35),
          //         bottom: ScreenUtil().setWidth(35)),
          //     child: Text(
          //       '${alldata['visits']}次浏览',
          //       style: TextStyle(
          //         color: PublicColor.grewNoticeColor,
          //         fontSize: ScreenUtil.instance.setWidth(24.0),
          //       ),
          //     )),
          Container(
              child: Text(
            '${alldata['text']}',
            style: TextStyle(
              color: Color(0xfff666666),
              fontSize: ScreenUtil.instance.setWidth(28.0),
            ),
          )),
          // Container(
          //     margin: EdgeInsets.only(
          //       top: ScreenUtil().setWidth(200),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         alldata['is_like'] == 1
          //             ? Container(
          //                 margin:
          //                     EdgeInsets.only(right: ScreenUtil().setWidth(17)),
          //                 child: InkWell(
          //                   child: Image.asset(
          //                     'assets/foods/ic_zan_xuanzhong.png',
          //                     width: ScreenUtil.instance.setWidth(95.0),
          //                   ),
          //                   onTap: () {
          //                     if (dzStatus) {
          //                       setState(() {
          //                         dzStatus = false;
          //                       });
          //                       clickZan();
          //                     }
          //                   },
          //                 ),
          //               )
          //             : Container(
          //                 margin:
          //                     EdgeInsets.only(right: ScreenUtil().setWidth(17)),
          //                 child: InkWell(
          //                   child: Image.asset(
          //                     'assets/foods/ic_zan.png',
          //                     width: ScreenUtil.instance.setWidth(95.0),
          //                   ),
          //                   onTap: () {
          //                     clickZan();
          //                   },
          //                 ),
          //               )
          //       ],
          //     )),
          // Container(
          //     alignment: Alignment.center,
          //     margin: EdgeInsets.only(
          //       top: ScreenUtil().setWidth(20),
          //     ),
          //     child: Text(
          //       '有用${alldata['like']}',
          //       style: TextStyle(
          //         color: PublicColor.foodColor,
          //         fontSize: ScreenUtil.instance.setWidth(26.0),
          //       ),
          //     )),
        ],
      ),
    );
    return MaterialApp(
      title: "详情",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '详情',
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
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.only(right: ScreenUtil().setWidth(37)),
          //     child: InkWell(
          //         child: alldata['is_collection'] == 1
          //             ? Image.asset(
          //                 'assets/foods/ic_shoucang_xuanzhong.png',
          //                 width: ScreenUtil.instance.setWidth(38.0),
          //               )
          //             : Image.asset(
          //                 'assets/foods/ic_shoucang.png',
          //                 width: ScreenUtil.instance.setWidth(38.0),
          //               ),
          //         onTap: () {
          //           if (scStatus) {
          //             setState(() {
          //               scStatus = false;
          //             });
          //             clickSc();
          //           }
          //           print(scStatus);
          //           print('收藏');
          //         }),
          //   ),
          //   Container(
          //     margin: EdgeInsets.only(right: ScreenUtil().setWidth(37)),
          //     child: InkWell(
          //         child: Image.asset(
          //           'assets/foods/ic_fenxiang.png',
          //           width: ScreenUtil.instance.setWidth(38.0),
          //         ),
          //         onTap: () {
          //           print('分享');
          //         }),
          //   )
          // ],
        ),
        body: isLoading
            ? LoadingDialog()
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[viewContent],
                  ),
                ),
              ),
      ),
    );
  }
}
