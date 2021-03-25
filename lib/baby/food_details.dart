import 'package:client/api/api.dart';
import 'package:client/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class FoodDetails extends StatefulWidget {
  final foodId;
  FoodDetails({this.foodId});
  @override
  FoodDetailsState createState() => FoodDetailsState();
}

class FoodDetailsState extends State<FoodDetails> {
  String aboutContent;
  bool isLoading = false;
  List bqList = ['补铁', '泥湖'];
  Map allData = {"img": ''};
  List scData = [];
  List bzData = [];
  bool scStatus = true;
  bool dzStatus = true;
  @override
  void initState() {
    super.initState();
    tongji();
    getData();
  }

  void getData() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("fid", () => widget.foodId);
    Service().getData(map, Api.FOODDETAILS_URL, (success) async {
      setState(() {
        allData = success['list']['data'];
        scData = success['list']['data']['foodmaterials'];
        bzData = success['list']['data']['foodstep'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void tongji() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("fid", () => widget.foodId);
    Service().getData(map, Api.VISITSFOOD_URL, (success) async {},
        (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void clickZan() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 2);
    map.putIfAbsent("id", () => widget.foodId);
    Service().getData(map, Api.LIKE_URL, (success) async {
      print(success);
      if (allData['is_like'] == 1) {
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
    map.putIfAbsent("type", () => 2);
    map.putIfAbsent("id", () => widget.foodId);
    Service().getData(map, Api.COLLECTION_URL, (success) async {
      print(success);

      if (allData['is_collection'] == 1) {
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

  bool isEmpty(Object object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is List && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget headerTop = Container(
        height: ScreenUtil().setWidth(364),
        width: ScreenUtil().setWidth(750),
        child: allData['img'] != ''
            ? Image.network(
                allData['img'],
                width: ScreenUtil().setWidth(750),
                fit: BoxFit.fitWidth,
              )
            : Container());

    //标签
    bqView() {
      List<Widget> list = [];
      for (var i = 0; i < 18; i++) {
        list.add(
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(16),
              top: ScreenUtil().setWidth(16),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfffFCE1CD)),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(6),
                bottom: ScreenUtil().setWidth(6),
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16)),
            child: Text(
              '补铁',
              style: TextStyle(
                fontSize: ScreenUtil.instance.setWidth(24.0),
                color: PublicColor.foodColor,
              ),
            ),
          ),
        );
      }
      return list;
    }

    Widget bqContainer = Container(
      child: Wrap(
        runSpacing: ScreenUtil.instance.setWidth(10.0),
        spacing: ScreenUtil.instance.setWidth(16),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(16),
              top: ScreenUtil().setWidth(16),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfffFCE1CD)),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(6),
                bottom: ScreenUtil().setWidth(6),
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16)),
            child: Text(
              '${allData['nutrients']}',
              style: TextStyle(
                fontSize: ScreenUtil.instance.setWidth(24.0),
                color: PublicColor.foodColor,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(16),
              top: ScreenUtil().setWidth(16),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfffFCE1CD)),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(6),
                bottom: ScreenUtil().setWidth(6),
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16)),
            child: Text(
              '${allData['food']}',
              style: TextStyle(
                fontSize: ScreenUtil.instance.setWidth(24.0),
                color: PublicColor.foodColor,
              ),
            ),
          )
        ],
      ),
    );

    sclistContainer() {
      List<Widget> list = [];
      for (var i = 0; i < scData.length; i++) {
        list.add(Container(
            child: Column(children: <Widget>[
          InkWell(
            child: Container(
              height: ScreenUtil().setWidth(100),
              width: ScreenUtil().setWidth(700),
              // padding: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(20), 0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
              ),
              child: Row(children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    '${scData[i]['name']}',
                    style: TextStyle(
                      color: PublicColor.textColor,
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${scData[i]['num']}",
                      style: TextStyle(
                        color: PublicColor.grewNoticeColor,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.navigate_next,
                        color: PublicColor.grewNoticeColor,
                      ),
                    )),
              ]),
            ),
            onTap: () {},
          ),
        ])));
      }
      return list;
    }

    Widget scView = Container(
      child: Column(
        children: sclistContainer(),
      ),
    );

    bzContainer() {
      List<Widget> list = [];
      for (var i = 0; i < bzData.length; i++) {
        list.add(Container(
            child: Column(children: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
              width: ScreenUtil().setWidth(700),
              // padding: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(20), 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '步骤${i + 1}:',
                        style: TextStyle(
                          color: PublicColor.textColor,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setWidth(27)),
                        child: Image.network(
                          bzData[i]['img'],
                          width: ScreenUtil().setWidth(750),
                          fit: BoxFit.fitWidth,
                        )),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setWidth(27)),
                      child: Text(
                        '${bzData[i]['text']}',
                        style: TextStyle(
                          color: PublicColor.textColor,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ]),
            ),
            onTap: () {},
          ),
        ])));
      }
      return list;
    }

    Widget bzView = Container(
      child: Column(
        children: bzContainer(),
      ),
    );

    Widget viewContent = Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(45), right: ScreenUtil().setWidth(29)),
      color: PublicColor.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(28)),
            child: Text(
              '${allData['name']}',
              style: TextStyle(
                  color: PublicColor.textColor,
                  fontSize: ScreenUtil.instance.setWidth(32)),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(25),
          ),
          // bqView(),
          bqContainer,
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(32)),
              child: Text(
                '${allData['text']}',
                style: TextStyle(
                    color: Color(0xfff666666),
                    fontSize: ScreenUtil.instance.setWidth(32)),
              )),

          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(32)),
              child: Text(
                '食材清单',
                style: TextStyle(
                    color: PublicColor.textColor,
                    fontSize: ScreenUtil.instance.setWidth(32)),
              )),

          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(36)),
              child: Text(
                '主料',
                style: TextStyle(
                    color: PublicColor.textColor,
                    fontSize: ScreenUtil.instance.setWidth(28)),
              )),
          scView,
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(32)),
              child: Text(
                '烹饪步骤',
                style: TextStyle(
                    color: PublicColor.textColor,
                    fontSize: ScreenUtil.instance.setWidth(32)),
              )),
          bzView
        ],
      ),
    );

    Widget dzContent = Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(37),
          left: ScreenUtil().setWidth(45),
          right: ScreenUtil().setWidth(45)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(35),
                  bottom: ScreenUtil().setWidth(35)),
              child: Text(
                '${allData['visits']}次浏览',
                style: TextStyle(
                  color: PublicColor.grewNoticeColor,
                  fontSize: ScreenUtil.instance.setWidth(24.0),
                ),
              )),
          Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  allData['is_like'] == 1
                      ? Container(
                          child: InkWell(
                            child: Image.asset(
                              'assets/foods/ic_zan_xuanzhong.png',
                              width: ScreenUtil.instance.setWidth(95.0),
                            ),
                            onTap: () {
                              if (dzStatus) {
                                setState(() {
                                  dzStatus = false;
                                });
                                clickZan();
                              }
                            },
                          ),
                        )
                      : Container(
                          child: InkWell(
                            child: Image.asset(
                              'assets/foods/ic_zan.png',
                              width: ScreenUtil.instance.setWidth(95.0),
                            ),
                            onTap: () {
                              clickZan();
                            },
                          ),
                        )
                ],
              )),
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(20),
              ),
              child: Text(
                '有用${allData['like']}',
                style: TextStyle(
                  color: PublicColor.foodColor,
                  fontSize: ScreenUtil.instance.setWidth(26.0),
                ),
              )),
          SizedBox(
            height: ScreenUtil().setWidth(60),
          ),
        ],
      ),
    );
    return MaterialApp(
      title: "辅食添加基本规则",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '辅食添加基本规则',
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
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(37)),
              child: InkWell(
                  child: allData['is_collection'] == 1
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
                color: PublicColor.whiteColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      allData['img'] != '' ? headerTop : Container(),
                      viewContent,
                      dzContent
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
