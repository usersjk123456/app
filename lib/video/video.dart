import 'dart:async';
import 'package:client/common/color.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/config/fluro_convert_util.dart';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/cached_image.dart';
import '../utils/toast_util.dart';
import '../service/video_service.dart';
import './message.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class VideoPage extends StatefulWidget {
  final String typeId;
  final String objs;
  VideoPage({this.typeId, this.objs});

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> with TickerProviderStateMixin {
  VideoPlayerController _controller;
  IjkMediaController controller = IjkMediaController();
  StreamSubscription subscription;
  PageController pagecontroller = PageController();
  bool isloading = false;
  bool isPlaying = false;
  double slider = 30;
  bool isguanzhu = false;
  List list = [];
  Map obj = {
    "id": "",
    "name": "",
    "url": "",
    "like": 0,
    "desc": "",
    "comment": 0,
    "is_follow": 0,
    "user": {
      "id": 0,
      "headimgurl": '',
    }
  },
      videoItem = {};

  Map goods = {};
  int length = 0;
  int _page = 1;
  String uid = '';

  @override
  void initState() {
    videoItem = FluroConvertUtils.string2map(widget.objs);

    subscriptPlayFinish();
    getInfo();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    controller?.dispose();
    pagecontroller?.dispose();
    subscription?.cancel();
    super.dispose();
  }

  void getliveurl(productEntity) async {
    if (productEntity['user']['is_open'].toString() == "1") {
      Map<String, dynamic> map = Map();
      map.putIfAbsent("room_id", () => productEntity['roomid']);
      LiveServer().inRoom(map, (success) async {
        controller.stop();

        NavigatorUtils.goLookZhibo(
                context, productEntity['id'].toString(), success)
            .then((result) {
          controller.play();
        });
      }, (onFail) async {
        ToastUtil.showToast(onFail);
      });
    } else {
      controller.stop();
      NavigatorUtils.goInformationLivePage(context, obj['user']['id'], '2')
          .then((result) {
        controller.play();
      });
    }
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      setState(() {
        uid = success['id'].toString();
      });
      getList();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => widget.typeId);
    map.putIfAbsent("uid", () => uid);
    map.putIfAbsent("id", () => videoItem['id']); // 点击的视频id
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 10);
    VideoServer().getVideo(map, (success) async {
      setState(() {
        if (_page == 1) {
          list = success['list'];
          obj = list[0];
          print('pinlun======${obj["comment"]}');
          videoPlay(obj['url']);
        } else {
          if (success['list'].length != 0) {
            for (var i = 0; i < success['list'].length; i++) {
              list.insert(list.length, success['list'][i]);
            }
          }
        }
        length = success['list'].length;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void videoPlay(url) async {
    controller.setNetworkDataSource(
      url,
      autoPlay: true,
    );
  }

  subscriptPlayFinish() {
    controller.ijkStatusStream.listen((data) {
      print('data---->>>>$data');
      if (mounted) {
        setState(() {
          if (data == IjkStatus.complete) {
            // 监听播放完毕
            controller.play();
          } else if (data == IjkStatus.prepared ||
              data == IjkStatus.error ||
              data == IjkStatus.preparing) {
            isPlaying = false;
          } else {
            isPlaying = true;
          }
        });
      }
    });
  }

  // 关注
  void follow() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 1);
    map.putIfAbsent("anchor_id", () => obj['user']['id']);
    VideoServer().videoFollow(map, (success) async {
      setState(() {
        obj['is_follow'] = 1;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void like() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => obj['id']);
    VideoServer().videoLike(map, (success) async {
      setState(() {
        obj['like'] += 1;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void messageNum() {
    setState(() {
      obj['comment'] += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
      body: Container(
        height: ScreenUtil.instance.setHeight(1334.0),
        child: PageView.builder(
          itemBuilder: (context, index) {
            return Stack(
              children: <Widget>[
                Container(
                  height: ScreenUtil.instance.setHeight(1334.0),
                  width: ScreenUtil.instance.setWidth(750.0),
                  color: Colors.black,
                  child: isPlaying
                      ? IjkPlayer(
                          mediaController: controller,
                          controllerWidgetBuilder: (mediaController) {
                            return DefaultIJKControllerWidget(
                              controller: controller,
                              doubleTapPlay: true,
                              verticalGesture: false,
                              horizontalGesture: false,
                              showFullScreenButton: false,
                            ); // 自定义
                          },
                        )
                      : Container(
                          child: Image.network(videoItem['img']),
                        ),
                ),
                Positioned(
                  left: ScreenUtil().setWidth(30),
                  top: ScreenUtil().setWidth(30),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/zhibo/backIcon.png",
                      width: ScreenUtil().setWidth(56),
                      height: ScreenUtil().setWidth(57),
                    ),
                  ),
                ),
                Container(
                  height: ScreenUtil.instance.setHeight(1334.0),
                  width: ScreenUtil.instance.setWidth(750.0),
                  // padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil.instance.setWidth(650.0),
                        child: Row(children: [
                          new SizedBox(
                              width: ScreenUtil.instance.setWidth(30.0)),
                          Container(
                            width: ScreenUtil.instance.setWidth(520.0),
                            height: ScreenUtil.instance.setWidth(650.0),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  obj['goods_id'].toString() != '0'
                                      ? InkWell(
                                          onTap: () {
                                            controller.stop();
                                            NavigatorUtils.toXiangQing(
                                                    context,
                                                    obj['goods']['id']
                                                        .toString(),
                                                    obj['user']['id']
                                                        .toString(),
                                                    "0")
                                                .then((result) {
                                              controller.play();
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              bottom: ScreenUtil().setWidth(10),
                                            ),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(
                                              ScreenUtil().setWidth(10),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.black26),
                                            child: Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/zhibo/huangche.png',
                                                  width:
                                                      ScreenUtil().setWidth(44),
                                                ),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  obj['goods']['name'],
                                                  style: TextStyle(
                                                      color: PublicColor
                                                          .whiteColor,
                                                      fontSize: ScreenUtil()
                                                          .setSp(26)),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Text(
                                    obj['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(30.0),
                                    ),
                                  ),
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(20.0)),
                                  Text(obj['desc'],
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.instance
                                              .setWidth(28.0)))
                                ]),
                          ),
                          new SizedBox(
                              width: ScreenUtil.instance.setWidth(60.0)),
                          Container(
                            width: ScreenUtil.instance.setWidth(100.0),
                            height: ScreenUtil.instance.setWidth(650.0),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: ScreenUtil.instance.setWidth(100.0),
                                    height: ScreenUtil.instance.setWidth(120.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              // controller.pause();
                                              controller.stop();
                                              getliveurl(obj);
                                            },
                                            child: obj['user']['headimgurl'] !=
                                                    ""
                                                ? CachedImageView(
                                                    ScreenUtil.instance
                                                        .setWidth(100.0),
                                                    ScreenUtil.instance
                                                        .setWidth(100.0),
                                                    obj['user']['headimgurl'],
                                                    null,
                                                    BorderRadius.all(
                                                      Radius.circular(50),
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: ScreenUtil.instance
                                              .setWidth(27.0),
                                          child: InkWell(
                                            child: obj['is_follow'] == 1
                                                ? Text('')
                                                : Image.asset(
                                                    'assets/zhibo/guanzhu.png',
                                                    width: ScreenUtil.instance
                                                        .setWidth(50.0)),
                                            onTap: () {
                                              if (obj['is_follow'] == 0) {
                                                follow();
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(30.0)),
                                  InkWell(
                                    child: Image.asset('assets/zhibo/dz.png',
                                        width:
                                            ScreenUtil.instance.setWidth(80.0)),
                                    onTap: () {
                                      like();
                                    },
                                  ),
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(5.0)),
                                  Text(
                                    (obj['like'] > 10000
                                        ? ((obj['like'] ~/ 1000) / 10)
                                                .toString() +
                                            'w'
                                        : obj['like'].toString()),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(26.0),
                                    ),
                                  ),
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(30.0)),
                                  InkWell(
                                    child: Image.asset('assets/zhibo/pl.png',
                                        width:
                                            ScreenUtil.instance.setWidth(80.0)),
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return XiaoxiWidget(
                                                videoId: obj['id'],
                                                messageNum: messageNum);
                                          });
                                    },
                                  ),
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(5.0)),
                                  Text(
                                    (obj['comment'] > 10000
                                        ? ((obj['comment'] ~/ 1000) / 10)
                                                .toString() +
                                            'w'
                                        : obj['comment'].toString()),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(26.0),
                                    ),
                                  ),
                                  new SizedBox(
                                      height:
                                          ScreenUtil.instance.setWidth(30.0)),
                                ]),
                          ),
                        ]),
                      ),
                      new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                      new SizedBox(height: ScreenUtil.instance.setWidth(80.0)),
                    ],
                  ),
                )
              ],
            );
          },
          scrollDirection: Axis.vertical,
          itemCount: list.length,
          controller: pagecontroller,
          onPageChanged: (idx) {
            if (list.length - 1 == idx) {
              _page++;
              getList();
            }
            setState(() {
              obj = list[idx];
              videoPlay(obj['url']);
              videoItem = obj;
            });
          },
        ),
      ),
    );
  }
}
