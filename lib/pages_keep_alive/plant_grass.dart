import 'package:client/config/Navigator_util.dart';
import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/img_list.dart';
import '../service/grass_service.dart';
import '../widgets/loading.dart';
import '../grass/grass_content_build.dart';

class PlantGrass extends StatefulWidget {
  @override
  _PlantGrassState createState() => _PlantGrassState();
}

class _PlantGrassState extends State<PlantGrass> with TickerProviderStateMixin {
  bool isLoading = false;
  EasyRefreshController _controller = EasyRefreshController();
  int _page = 0;
  bool isLive = false;
  List list = [];
  List groupList = [];
  Map user = {};
  @override
  void initState() {
    super.initState();
    loaduser();
    getList();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  //返回刷新
  void backRefash() {
    _page = 0;
    getList();
  }

  void getList() async {
    _page++;
    if (_page == 1) {
      setState(() {
        list = [];
      });
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 10);
    GrassServer().getPlant(map, (success) {
      setState(() {
        print(
            "topic___+++++=====================______======______> $success['topic']");
        groupList = success['topic'];
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

  void loaduser() async {
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("id", () => widget.oid);

    UserServer().getUserInfo(map, (success) async {
      setState(() {
        user = success;
        isLive = success['is_live'].toString() == "0" ? false : true;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget groupBuild = Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
        bottom: ScreenUtil().setWidth(20),
        top: ScreenUtil().setWidth(20),
      ),
      decoration: BoxDecoration(
          color: PublicColor.whiteColor,
          border: Border(top: BorderSide(color: Color(0xffF5F5F5), width: 1))),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              '发现小组',
              style: TextStyle(
                color: PublicColor.grewNoticeColor,
                fontSize: ScreenUtil().setSp(26),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Container(
            alignment: Alignment.topLeft,
            child: groupList.length != 0
                ? BuildImg(
                    imgList: groupList,
                    backRefash: backRefash,
                  )
                : Container(),
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
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(100)),
          child: Text(
            '暂无数据',
            style: TextStyle(
              color: PublicColor.textColor,
              fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
      }
      content = Column(children: arr);
      return content;
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '种草',
              style: TextStyle(
                color: PublicColor.headerTextColor,
              ),
            ),
            leading: new InkWell(
              child: Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.instance.setWidth(20),
                    right: ScreenUtil.instance.setWidth(12),
                    left: ScreenUtil.instance.setWidth(16)),
                height: ScreenUtil.instance.setWidth(70.0),
                width: ScreenUtil.instance.setWidth(70.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/index/xiaoxi.png',
                      width: ScreenUtil().setWidth(44),
                    ),
                    SizedBox(
                      height: ScreenUtil.instance.setWidth(3.0),
                    ),
                    Expanded(
                      child: Text(
                        '消息',
                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(20.0),
                          color: Color(0xffffffff),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                print('消息');
                NavigatorUtils.goNewsPage(context);
              },
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
          ),
          body: new Container(
            alignment: Alignment.center,
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
              child: new ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  groupBuild,
                  SizedBox(height: ScreenUtil().setWidth(16)),
                  contentBuild()
                ],
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
        ),
        // isLive
        //     ? Positioned(
        //         left: ScreenUtil().setWidth(240),
        //         bottom: ScreenUtil().setWidth(140),
        //         child: InkWell(
        //           onTap: () {
        //             // showModalBottomSheet(
        //             //   context: context,
        //             //   builder: (BuildContext context) {
        //             //     return ShareDjango(
        //             //       // anchor: anchor,
        //             //       backRefash: backRefash,
        //             //     );
        //             //   },
        //             // );
        //             // Navigator.pop(context);
        //             NavigatorUtils.goAddGrassPage(context, null)
        //                 .then((result) => backRefash());
        //           },
        //           child: Container(
        //             alignment: Alignment.center,
        //             width: ScreenUtil().setWidth(252),
        //             height: ScreenUtil().setWidth(82),
        //             decoration: BoxDecoration(
        //                 color: PublicColor.themeColor,
        //                 borderRadius:
        //                     BorderRadius.circular(ScreenUtil().setWidth(40))),
        //             child: Text(
        //               '参与话题',
        //               style: TextStyle(
        //                 color: PublicColor.whiteColor,
        //                 fontSize: ScreenUtil().setSp(30),
        //               ),
        //             ),
        //           ),
        //         ),
        //       )
        //     : Container(),
        isLoading ? LoadingDialog() : Container(),
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
