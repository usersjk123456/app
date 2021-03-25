import 'package:client/common/color.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/user_service.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/live_service.dart';
import './liveVideoWidget.dart';

class InformationLive extends StatefulWidget {
  final oid;
  final String type;
  InformationLive({this.oid, this.type});
  @override
  _InformationLiveState createState() => _InformationLiveState();
}

class _InformationLiveState extends State<InformationLive>
    with TickerProviderStateMixin {
  var historyContentList = [], jwt, listLength = 1;
  bool isLoading = false;
  Map anchor = {
    "headimgurl": "",
    "nickname": "",
    "store_img": "",
    "fans": "",
    "isfollow": 0,
  };
  int isFollow = 0;
  int fans = 0;
  var list = [];
  String uid = "";
  bool followOpen = true;

  @override
  void initState() {
    super.initState();
    getHistoryList();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      setState(() {
        uid = success['id'].toString();
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getHistoryList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("aid", () => widget.oid);
    map.putIfAbsent("type", () => widget.type);
    map.putIfAbsent("page", () => 1);
    map.putIfAbsent("limit", () => 200);
    LiveServer().getLiveAnchor(map, (success) async {
      for (var item in success["list"]) {
        if (!item.containsKey('isplay')) {
          item['isplay'] = false;
        }
      }
      setState(() {
        anchor = success["anchor"];
        fans = success["anchor"]["fans"];
        list = success["list"];
        isFollow = success["is_follow"];
        print('is_follow====$isFollow');
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  //关注
  follow(type) async {
    isLoading = true;
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    map.putIfAbsent("anchor_id", () => anchor['id']);
    LiveServer().follow(map, (success) async {
      isLoading = false;
      setState(() {
        followOpen = true;
        if (success['type'].toString() == "1") {
          ToastUtil.showToast('关注成功');
          isFollow = 1;
        } else {
          isFollow = 0;
          ToastUtil.showToast('已取消成功');
        }
      });
    }, (onFail) async {
      isLoading = false;
      ToastUtil.showToast(onFail);
    });
  }

  void changePlay(item) {
    setState(() {
      for (var i in list) {
        if (i['id'] != item['id']) {
          i['isplay'] = false;
        }
      }
    });
  }

  Widget build(BuildContext context) {
    Widget topPart = Container(
      width: ScreenUtil.instance.setWidth(750.0),
      height: ScreenUtil.instance.setWidth(300.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/zhibo/hfbg.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(top: ScreenUtil.instance.setWidth(40)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil.instance.setWidth(25),
                right: ScreenUtil.instance.setWidth(25)),
            height: ScreenUtil.instance.setWidth(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
//头部第一个icon
                InkWell(
                  child: Container(
                    height: ScreenUtil.instance.setWidth(40.0),
                    child: Icon(Icons.navigate_before, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
//头部第二个icon
                anchor['is_store'] != 0
                    ? InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(40.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  right: ScreenUtil.instance.setWidth(10),
                                ),
                                height: ScreenUtil().setWidth(40),
                                width: ScreenUtil().setWidth(40),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/zhibo/house.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '进入店铺',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          NavigatorUtils.goLiveStore(context, widget.oid);
                        },
                      )
                    : Container(),
              ],
            ),
          ),
          //下半图片部分
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  bottom: ScreenUtil.instance.setWidth(30),
                  right: ScreenUtil.instance.setWidth(290),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(65)),
                      child: ClipOval(
                        child: anchor["headimgurl"] != ""
                            ? Image.network(
                                anchor["headimgurl"],
                                width: ScreenUtil().setWidth(100),
                                height: ScreenUtil().setWidth(100),
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${anchor["nickname"]}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(30)),
                            ),
                          ),
                          Text(
                            '粉丝 ' +
                                (fans > 10000
                                    ? ((fans ~/ 1000) / 10).toString() + 'w'
                                    : fans.toString()),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(26),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              anchor['id'].toString() != uid
                  ? Positioned(
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil.instance.setWidth(124),
                          height: ScreenUtil.instance.setWidth(56),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isFollow == 0 ? '未关注' : '已关注',
                            style: TextStyle(
                                fontSize: ScreenUtil().setWidth(24),
                                color: Color(0xff474747)),
                          ),
                        ),
                        onTap: () {
                          print('关注================');
                          if (followOpen) {
                            followOpen = false;
                            if (isFollow == 1) {
                              //取关
                              follow(2);
                            } else {
                              // 关注
                              follow(1);
                            }
                          }
                        },
                      ),
                      right: 100,
                      top: 14,
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );

    Widget centerPart = Container(
      padding: EdgeInsets.only(
        top: ScreenUtil.instance.setWidth(17),
        left: ScreenUtil.instance.setWidth(15),
        bottom: ScreenUtil.instance.setWidth(18),
      ),
      margin: EdgeInsets.only(
        left: ScreenUtil.instance.setWidth(26),
        right: ScreenUtil.instance.setWidth(27),
        top: ScreenUtil.instance.setWidth(20),
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(
      //     color: Color(0xffe9e9e9),
      //     width: 1,
      //   ),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //   正在直播
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                anchor['is_open'] == 1
                    ? Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil.instance.setWidth(24),
                          right: ScreenUtil.instance.setWidth(20),
                        ),
                        margin: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(18),
                        ),
                        width: ScreenUtil.instance.setWidth(205),
                        height: ScreenUtil.instance.setWidth(54),
                        decoration: BoxDecoration(
                          gradient: PublicColor.linear,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(
                              'assets/zhibo/video.png',
                              width: ScreenUtil().setWidth(42),
                              height: ScreenUtil().setWidth(28),
                              fit: BoxFit.cover,
                            ),
                            Text(
                              '正在直播',
                              style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(24),
                                color: Color(0xffffffff),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),

                // Text(
                //   '观看人数10086',
                //   style: TextStyle(
                //     fontSize: ScreenUtil.instance.setWidth(26),
                //     color: Color(0xff969696),
                //   ),
                // )
              ],
            ),
          ),
          // Container(
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: <Widget>[
          //         Text(
          //           '新春衣服，等你来选!!!',
          //           style: TextStyle(
          //               fontSize: ScreenUtil.instance.setWidth(28),
          //               color: Color(0xff474747)),
          //         )
          //       ]),
          // ),
        ],
      ),
    );

    Widget live() {
      List<Widget> arr = <Widget>[];
      Widget content;
      for (var item in list) {
        arr.add(LiveVideo(
            listItem: item, changePlay: changePlay, type: widget.type));
      }
      content = new Column(
        mainAxisSize: MainAxisSize.max,
        children: arr,
      );
      return content;
    }

    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: isLoading
            ? LoadingDialog()
            : new ListView(
                children: <Widget>[
                  topPart,
                  centerPart,
                  Container(
                    margin: EdgeInsets.only(
                      left: ScreenUtil.instance.setWidth(26),
                      right: ScreenUtil.instance.setWidth(27),
                      top: ScreenUtil.instance.setWidth(20),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xffe9e9e9),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.type == '1'
                            ? Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(30),
                                  left: ScreenUtil().setWidth(20),
                                  bottom: ScreenUtil().setWidth(30),
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff474747),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(156),
                                height: ScreenUtil().setWidth(55),
                                child: Text(
                                  '历史回放',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(30),
                                ),
                              ),
                        live(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
