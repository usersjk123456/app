import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/grass_service.dart';
import '../service/user_service.dart';
import '../grass/grass_content_build.dart';

class GroupDetails extends StatefulWidget {
  final oid;
  GroupDetails({this.oid});
  @override
  GroupDetailsState createState() => GroupDetailsState();
}

class GroupDetailsState extends State<GroupDetails>
    with TickerProviderStateMixin {
  EasyRefreshController _controller = EasyRefreshController();
  bool isLoading = false;
  bool isLive = false;
  int tabIndex = 0;
  Map anchor = {
    "headimgurl":
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1590049418168&di=75bb1982141baa6739dbb65a7f23105f&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201807%2F01%2F20180701221534_uynKd.jpeg",
    "nickname": "官方信息",
    "desc": "备注",
    "img":
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1590055582960&di=b85630c73fe73775b82a120dc4d55b60&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1308%2F17%2Fc2%2F24561028_1376699679455.jpg",
  };
  List list = [];
  int _page = 0;
  Map user = {};
  @override
  void initState() {
    super.initState();
    getList();
    getInfo();
  }

  //返回刷新
  void backRefash() {
    _page = 0;
    getList();
  }

  void loaduser() async {
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("id", () => widget.oid);

    UserServer().getUserInfo(map, (success) async {
      setState(() {
        user = success;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getList() async {
    _page++;
    if (_page == 1) {
      setState(() {
        list = [];
      });
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);
    map.putIfAbsent("tid", () => widget.oid);
    map.putIfAbsent("type", () => tabIndex + 1);
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 10);
    GrassServer().getGroupDetails(map, (success) async {
      setState(() {
        anchor = success['topic'];
        if (success['list'].length == 0) {
          // ToastUtil.showToast('已加载全部数据');
        } else {
          for (var i = 0; i < success['list'].length; i++) {
            list.insert(list.length, success['list'][i]);
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      setState(() {
        isLive = success['is_live'].toString() == "0" ? false : true;
      });
    }, (onFail) async {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget topArea = new Container(
      height: ScreenUtil().setWidth(400),
      width: ScreenUtil().setWidth(750),
      decoration: anchor['img'] != ""
          ? BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(anchor['img']), fit: BoxFit.fitWidth),
            )
          : BoxDecoration(),
      child: new Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(
                    Icons.chevron_left,
                    color: PublicColor.whiteColor,
                    size: ScreenUtil.instance.setWidth(55.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(80),
          ),
          new Container(
            width: ScreenUtil().setWidth(750),
            child: new ListTile(
              leading: Container(
                child: anchor['img'] != ""
                    ? Image.network(
                        anchor['img'],
                        width: ScreenUtil().setWidth(110),
                        height: ScreenUtil().setWidth(110),
                        fit: BoxFit.contain,
                      )
                    : Container(),
              ),
              title: Text(
                '${anchor["name"]}',
                style: TextStyle(color: PublicColor.whiteColor),
              ),
              // subtitle: Text(
              //   '${anchor["desc"]}',
              //   style: TextStyle(color: PublicColor.whiteColor),
              // ),
            ),
          ),
        ],
      ),
    );

    Widget tabbar = Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(100),
      decoration: BoxDecoration(
        color: PublicColor.whiteColor,
        border: Border(
          bottom: BorderSide(color: Color(0xffe7e7e7), width: 1),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  tabIndex = 0;
                  _page = 0;
                  list = [];
                });
                getList();
              },
              child: Container(
                height: ScreenUtil().setWidth(100),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Color(0xffe7e7e7), width: 1),
                  ),
                ),
                child: Text(
                  '官方',
                  style: TextStyle(
                    color: tabIndex == 0
                        ? PublicColor.themeColor
                        : PublicColor.grewNoticeColor,
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  tabIndex = 1;
                  _page = 0;
                  list = [];
                });
                getList();
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '主播说',
                  style: TextStyle(
                    color: tabIndex == 1
                        ? PublicColor.themeColor
                        : PublicColor.grewNoticeColor,
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget contentBuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (list.length != 0) {
        for (var item in list) {
          arr.add(GrassContentBuild(
            item: item,
            user: user,
          ));
        }
      } else {
        arr.add(Container(
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(100)),
          child: Text(
            '暂无数据',
            style: TextStyle(fontSize: ScreenUtil().setSp(35)),
          ),
        ));
      }
      content = Column(children: arr);
      return content;
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: PreferredSize(
            child: Container(
              child: topArea,
            ),
            preferredSize: Size(double.infinity, ScreenUtil().setWidth(370)),
          ),
          body: Stack(
            children: <Widget>[
              Container(
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
                  child: Container(
                    color: PublicColor.bodyColor,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: ScreenUtil().setWidth(30)),
                        tabbar,
                        contentBuild()
                      ],
                    ),
                  ),
                  onRefresh: () async {
                    _page = 0;
                    getList();
                  },
                  onLoad: () async {
                    getList();
                  },
                ),
              ),
              isLive
                  ? Positioned(
                      left: ScreenUtil().setWidth(240),
                      bottom: ScreenUtil().setWidth(140),
                      child: InkWell(
                        onTap: () {
                          // showModalBottomSheet(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return ShareDjango(
                          //       anchor: anchor,
                          //       backRefash: backRefash,
                          //     );
                          //   },
                          // );
                          print(anchor);
                          // return;
                          NavigatorUtils.goAddGrassPage(context, anchor)
                              .then((result) => backRefash());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(252),
                          height: ScreenUtil().setWidth(82),
                          decoration: BoxDecoration(
                              color: PublicColor.themeColor,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(40))),
                          child: Text(
                            '参与话题',
                            style: TextStyle(
                              color: PublicColor.btnColor,
                              fontSize: ScreenUtil().setSp(30),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}

class ShareDjango extends StatefulWidget {
  final anchor;
  final backRefash;
  ShareDjango({this.anchor, this.backRefash});
  _ShareDjangoState createState() => _ShareDjangoState();
}

class _ShareDjangoState extends State<ShareDjango> {
  // 小程序分享
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      color: Colors.white,
      height: ScreenUtil.instance.setWidth(500.0),
      padding: EdgeInsets.only(
        right: ScreenUtil().setWidth(20),
        top: ScreenUtil().setWidth(15),
      ),
      child: Column(children: [
        Container(
          alignment: Alignment.centerRight,
          child: InkWell(
            child: Image.asset(
              'assets/index/gb.png',
              width: ScreenUtil.instance.setWidth(40.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        new SizedBox(
          height: ScreenUtil.instance.setWidth(100.0),
        ),
        Container(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(25),
          ),
          child: Row(children: [
            Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                    alignment: Alignment.center,
                    child: Column(children: [
                      Image.asset(
                        'assets/login/img.png',
                        width: ScreenUtil.instance.setWidth(104.0),
                      ),
                      new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
                      Text('发布图片',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(30.0),
                              fontWeight: FontWeight.w500)),
                    ])),
                onTap: () {
                  Navigator.pop(context);
                  NavigatorUtils.goAddGrassPage(context, widget.anchor)
                      .then((result) => widget.backRefash());
                },
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: InkWell(
            //     child: Container(
            //         alignment: Alignment.center,
            //         child: Column(children: [
            //           Image.asset(
            //             'assets/login/video.png',
            //             width: ScreenUtil.instance.setWidth(104.0),
            //           ),
            //           new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
            //           Text('发布视频',
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: ScreenUtil.instance.setWidth(30.0),
            //                   fontWeight: FontWeight.w500)),
            //         ])),
            //     onTap: () {
            //       Navigator.pop(context);
            //       NavigatorUtils.goAddGrassVideo(context, widget.anchor)
            //           .then((result) => widget.backRefash());
            //     },
            //   ),
            // ),
          ]),
        )
      ]),
    );
  }
}
