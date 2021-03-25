import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../news/news_chat.dart';
import '../news/news_order.dart';
import '../news/news_notice.dart';

class NewsPage extends StatefulWidget {
  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  bool isLoading = false;
  int _page = 0;
  List newsList = [];
  int tabIndex = 0;
  EasyRefreshController _controller = EasyRefreshController();

  TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  void getNewsList() async {
    _page++;
    if (_page == 1) {
      newsList = [];
    }

    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => tabIndex + 1);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);

    UserServer().getNewsList(map, (success) async {
      setState(() {
        isLoading = false;
      });
      setState(() {
        if (_page == 1) {
          newsList = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              newsList.insert(newsList.length, success['list'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  // 列表循环赋值
  Widget newsListBox() {
    List<Widget> arr = <Widget>[];
    Widget content;

    if (tabIndex == 0) {
      arr.add(ChatCell());
      content = Column(
        children: arr,
      );
      return content;
    }
    if (newsList.length == 0) {
      arr.add(
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ),
      );
    } else {
      for (var item in newsList) {
        arr.add(
          Container(
            child: Column(
              children: <Widget>[
                tabIndex == 1 ?  NoticeCell(item: item): OrderCell(item: item)
              ],
            ),
          ),
        );
      }
    }
    content = Column(
      children: arr,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget contentWidget() {
      return Container(
        child: EasyRefresh(
          controller: _controller,
          header: BezierCircleHeader(
            backgroundColor: PublicColor.themeColor,
          ),
          footer: BezierBounceFooter(
            backgroundColor: PublicColor.themeColor,
          ),
          enableControlFinishRefresh: true,
          enableControlFinishLoad: false,
          child: SingleChildScrollView(
            child: newsListBox(),
          ),
          onRefresh: () async {
            getNewsList();
            _controller.finishRefresh();
          },
          onLoad: () async {
            getNewsList();
            _controller.finishRefresh();
          },
        ),
      );
    }

    return Stack(
      children: <Widget>[
        new DefaultTabController(
          length: 1,
          initialIndex: 0,
          child: new Scaffold(
              appBar: new AppBar(
                elevation: 0,
                centerTitle: true,
                title: new Text(
                  '消息中心',
                  style: TextStyle(
                    color: PublicColor.headerTextColor,
                  ),
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
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                        onTap: (index) {
                          setState(() {
                            tabIndex = index;
                            _page = 0;
                          });
                          if (tabIndex == 0) {
                            return;
                          }
                          getNewsList();
                        },
                        controller: tabController,
                        indicatorWeight: 4.0,
                        // indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor:PublicColor.themeColor,
                        unselectedLabelColor: Color(0xff5e5e5e),
                        labelColor:PublicColor.themeColor,
                        tabs: <Widget>[
                       /*   new Tab(
                            child: Text(
                              '聊天',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),*/
                          // new Tab(
                          //   child: Text(
                          //     '订单',
                          //     style: TextStyle(
                          //       fontSize: ScreenUtil().setSp(28),
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //   ),
                          // ),
                          new Tab(
                            child: Text(
                              '公告',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              body: contentWidget()),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
