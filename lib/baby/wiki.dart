import 'package:client/api/api.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:client/widgets/no_data.dart';
import 'package:client/widgets/read_list.dart';
import 'package:client/widgets/xuxian.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';

class WikiClass extends StatefulWidget {
  WikiClass({Key key}) : super(key: key);
  @override
  _WikiClassState createState() => _WikiClassState();
}

class _WikiClassState extends State<WikiClass>
    with SingleTickerProviderStateMixin {
  String aboutContent;
  bool isLoading = false;

  List readlist = [];

  List tabshowList = [];
  int clickIndex = 0;
  List listview = [];
  int _page = 0;
  TabController tabController;
  List tabTitles = [];
  @override
  void initState() {
    super.initState();
    getRead();
    getBkInf();
  }

  void getBkInf() async {
    await getBkFirst();
  }

  void getRead() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("limit", () => 1);
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

  void getBkFirst() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 3);
    Service().getData(map, Api.ORANGELIST_URL, (success) async {
      setState(() {
        tabTitles = success['list'];
      });
      tabController = new TabController(length: tabTitles.length, vsync: this);
      tabController.addListener(() {
        print(tabController.index);
      });
      getBkNext(tabTitles[0]['id']);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getBkNext(id) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    Service().getData(map, Api.BAIKE_URL, (success) async {
      setState(() {
        tabshowList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget title(text) {
      return Container(
          width: ScreenUtil().setWidth(690),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setWidth(35),
                    width: ScreenUtil().setWidth(8),
                    decoration: BoxDecoration(
                      color: PublicColor.foodColor,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  Expanded(
                      flex: 9,
                      child: Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(23)),
                        child: Text(
                          '${text}',
                          style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(32.0),
                            color: PublicColor.textColor,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: InkWell(
                        child: Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                          alignment: Alignment.centerRight,
                          child: Text(
                            '全部',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                              color: PublicColor.grewNoticeColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          NavigatorUtils.goWikiall(context);
                        },
                      ))
                ],
              ),
              SizedBox(
                height: ScreenUtil().setWidth(25),
              ),
              const MySeparator(color: Colors.grey),
            ],
          ));
    }

    Widget booktitle(text) {
      return Container(
        child: Row(
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(35),
              width: ScreenUtil().setWidth(8),
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(28),
              ),
              decoration: BoxDecoration(
                color: PublicColor.foodColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(23)),
              child: Text('${text}',
                  style: TextStyle(
                    fontSize: ScreenUtil.instance.setWidth(32.0),
                    color: PublicColor.textColor,
                  )),
            )
          ],
        ),
      );
    }

    Widget topHeadContent = Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(44)),
      color: PublicColor.whiteColor,
      child: Column(
        children: <Widget>[title('推荐阅读'), Readlist(item: readlist)],
      ),
    );

    Widget tabBar() {
      return SafeArea(
        child: TabBar(
          controller: tabController,
          indicatorColor: null,
          indicator: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xffEE9249), width: 3)),
          ),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.black,
          unselectedLabelColor: Color(0xff666666),
          indicatorPadding: EdgeInsets.zero,
          isScrollable: true,
          tabs: tabTitles.map((i) => Tab(text: i['name'])).toList(),
          unselectedLabelStyle:
              TextStyle(fontSize: ScreenUtil.instance.setWidth(34)),
          labelStyle: TextStyle(
              fontSize: ScreenUtil.instance.setWidth(36),
              fontWeight: FontWeight.bold),
          onTap: ((index) {
            _page = 0;
            setState(() {
              clickIndex = index;
            });
            getBkNext(tabTitles[index]['id']);
          }),
        ),
      );
    }

    bookListView(item) {
      List<Widget> list = [];
      for (var i = 0; i < item.length; i++) {
        list.add(
          Container(
              child: InkWell(
            child: Column(
              children: <Widget>[
                Container(
                  child: CachedImageView(
                    ScreenUtil.instance.setWidth(194.0),
                    ScreenUtil.instance.setWidth(257.0),
                    item[i]['img'],
                    null,
                    BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                ),
                Container(
                    width: ScreenUtil.instance.setWidth(194.0),
                    margin: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                    child: Text('${item[i]['name']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(26.0),
                          color: PublicColor.textColor,
                        )))
              ],
            ),
            onTap: () {
              print(1);
              print(2);
              print(item[i]['id']);
              NavigatorUtils.goWikilist(context, item[i]['id']);
            },
          )),
        );
      }
      return list;
    }

    Widget bookListContainer(item) {
      return Container(
        margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(38), bottom: ScreenUtil().setWidth(36)),
        child: Wrap(
          runSpacing: ScreenUtil.instance.setWidth(58.0),
          spacing: ScreenUtil.instance.setWidth(50),
          children: bookListView(item),
        ),
      );
    }

    ;

    tabShowView() {
      List<Widget> list = [];
      for (var i = 0; i < tabshowList.length; i++) {
        list.add(
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   margin: EdgeInsets.only(
                //       top: ScreenUtil().setWidth(26),
                //       left: ScreenUtil().setWidth(28),
                //       bottom: ScreenUtil().setWidth(36)),
                //   child: CachedImageView(
                //     ScreenUtil.instance.setWidth(694.0),
                //     ScreenUtil.instance.setWidth(159.0),
                //     '${tabshowList[i]['img']}',
                //     null,
                //     BorderRadius.all(
                //       Radius.circular(4.0),
                //     ),
                //   ),
                // ),
                Container(
                  child: booktitle(tabshowList[i]['name']),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(28),
                      right: ScreenUtil().setWidth(28)),
                  child: bookListContainer(tabshowList[i]['children']),
                )
              ],
            ),
          ),
        );
      }
      return list;
    }

    Widget tabShowContainer = Container(
      child: Wrap(
        runSpacing: ScreenUtil.instance.setWidth(10.0),
        spacing: ScreenUtil.instance.setWidth(26),
        children: tabShowView(),
      ),
    );

    Widget tabShow() {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(26),
                  bottom: ScreenUtil().setWidth(36)),
              child: tabTitles.length > 0
                  ? CachedImageView(
                      ScreenUtil.instance.setWidth(694.0),
                      ScreenUtil.instance.setWidth(159.0),
                      tabTitles[clickIndex]['img'],
                      null,
                      BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    )
                  : Container(),
            ),
            tabshowList.length > 0 ? tabShowContainer : NoData(deHeight: 600)
          ],
        ),
      );
    }



    Widget btmContainer = Container(
        margin: EdgeInsets.only(top: ScreenUtil().setWidth(14)),
        width: ScreenUtil().setWidth(750),
        color: PublicColor.whiteColor,
        child: Column(
          children: <Widget>[tabBar(), tabShow()],
        ));

    return MaterialApp(
      title: "育儿百科",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '育儿百科',
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
                  child: Image.asset(
                    'assets/foods/ic_sousuo.png',
                    width: ScreenUtil.instance.setWidth(38.0),
                  ),
                  onTap: () {
                    NavigatorUtils.goBooksearch(context);
                  }),
            ),
          ],
        ),
        body: isLoading
            ? LoadingDialog()
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      readlist.length > 0 ? topHeadContent : Container(),
                      tabTitles.length > 0 ? btmContainer : Container()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
