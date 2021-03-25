import 'package:client/service/store_service.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/cached_image.dart';

class MuyuCollegePage extends StatefulWidget {
  @override
  MuyuCollegePageState createState() => MuyuCollegePageState();
}

class MuyuCollegePageState extends State<MuyuCollegePage>
    with TickerProviderStateMixin {
  bool isLoading = true;
  String jwt = '';
  List collegeList = [];
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();
    getHelp();
  }

  void getHelp() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    StoreServer().getHelp(map, (success) async {
      setState(() {
        isLoading = false;
        collegeList = success['list'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget listArea(item) {
    print(item);
    return Container(
      margin: EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: new Column(children: <Widget>[
        new InkWell(
          child: Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new Row(
                    children: <Widget>[
                      CachedImageView(
                        ScreenUtil.instance.setWidth(140.0),
                        ScreenUtil.instance.setWidth(140.0),
                        item['img'],
                        null,
                        BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: ScreenUtil().setWidth(140),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          width: ScreenUtil().setWidth(530),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/shop/zbsx.png',
                                width: ScreenUtil.instance.setWidth(110.0),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(10),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(355),
                                child: Text(
                                  item['title'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(30),
                                    color: Color(0xfff000000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: ScreenUtil().setWidth(550),
                          child: Image.asset(
                            "assets/shop/xsmf.png",
                            height: ScreenUtil().setWidth(35),
                            width: ScreenUtil().setWidth(145),
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            print('商品');
          },
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '橙子宝宝',
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
        body: contentWidget(),
      ),
    );
  }

  Widget contentWidget() {
    return Stack(
      children: <Widget>[
        Container(
          child: EasyRefresh(
            controller: _controller,
            enableControlFinishRefresh: true,
            enableControlFinishLoad: false,
            header: BezierCircleHeader(
              backgroundColor: PublicColor.themeColor,
            ),
            footer: BezierBounceFooter(
              backgroundColor: PublicColor.themeColor,
            ),
            child: ListView.builder(
              itemCount: collegeList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: ScreenUtil.getInstance().setWidth(750.0),
                  child: new Column(children: [
                    Container(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          collegeList[index]['name'],
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(34),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: ScreenUtil.getInstance().setWidth(180.0) *
                          collegeList[index]['help'].length,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context1, int index1) {
                          return listArea(collegeList[index]['help'][index1]);
                        },
                        itemCount: collegeList[index]['help'].length,
                      ),
                    ),
                  ]),
                );
              },
            ),
            onRefresh: () async {
              print('121121222111');
              getHelp();
              _controller.finishRefresh();
            },
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }
}
