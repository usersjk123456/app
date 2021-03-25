import 'package:chewie/chewie.dart';
import 'package:client/common/color.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/live_service.dart';

class LiveDetails extends StatefulWidget {
  final oid;
  LiveDetails({this.oid});
  @override
  _LiveDetailsState createState() => _LiveDetailsState();
}

class _LiveDetailsState extends State<LiveDetails>
    with TickerProviderStateMixin {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  bool isLoading = false;
  bool isplay = false;
  String storeImg = "";
  String headimgurl = "";
  String nickname = "";
  int fans = 0;
  int views = 0;
  String ishuifang = "";
  String time = "";
  String desc = "";
  String url = "";
  String img = "";
  String roomId = '';

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  void getDetails() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    LiveServer().getRoomDetails(map, (success) async {
      setState(() {
        storeImg = success['auser']['store_img'];
        headimgurl = success['auser']['headimgurl'];
        nickname = success['auser']['nickname'];
        fans = success['auser']['fans'];
        views = success['room']['views'];
        ishuifang = success['room']['is_huifang'].toString();
        time = success['room']['create_at'];
        desc = success['room']['desc'];
        url = success['room']['huifang_url'];
        img = success['room']['img'];
        roomId = success['room']['id'].toString();
        isLoading = false;
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void dispose() {
    _videoPlayerController1?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void playsss() {
    _videoPlayerController1 = VideoPlayerController.network(url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 2 / 3,
      autoPlay: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {
      isplay = true;
    });
  }

  Widget build(BuildContext context) {
    Widget topPart = Container(
      width: ScreenUtil.instance.setWidth(750.0),
      height: ScreenUtil.instance.setWidth(300.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: storeImg == ""
              ? AssetImage("assets/zhibo/banner.png")
              : NetworkImage(storeImg),
          fit: BoxFit.cover,
        ),
        // color: Colors.yellow,
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
                // InkWell(
                //   child: Container(
                //     height: ScreenUtil.instance.setWidth(40.0),
                //     child: Row(
                //       children: <Widget>[
                //         Container(
                //           margin: EdgeInsets.only(
                //             right: ScreenUtil.instance.setWidth(10),
                //           ),
                //           height: ScreenUtil().setWidth(40),
                //           width: ScreenUtil().setWidth(40),
                //           decoration: BoxDecoration(
                //             image: DecorationImage(
                //               image: AssetImage("assets/zhibo/house.png"),
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //         Text(
                //           '进入店铺',
                //           style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                //         ),
                //       ],
                //     ),
                //   ),
                //   onTap: () {
                //     NavigatorUtils.goLiveStore(
                //       context,
                //     );
                //   },
                // ),
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
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(65)),
                        child: ClipOval(
                          child: headimgurl != ""
                              ? Image.network(
                                  headimgurl,
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
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                '$nickname',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(30)),
                              ),
                            ),
                            Text(
                              '粉丝 ' +
                                  (fans > 10000
                                      ? ((fans ~/ 1000) / 10).toString() + 'w'
                                      : fans.toString()),
                              style: TextStyle(
                                color: PublicColor.textColor,
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ],
      ),
    );

    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: <Widget>[
            topPart,
            isLoading
                ? LoadingDialog()
                : Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil.instance.setWidth(26),
                        right: ScreenUtil.instance.setWidth(27),
                        top: ScreenUtil.instance.setWidth(20),
                      ),
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.instance.setWidth(30),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xffe9e9e9),
                          width: 1,
                        ),
                      ),
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
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
                              ),
                              InkWell(
                                onTap: () {
                                  NavigatorUtils.goGift(context,roomId);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(20),
                                    right: ScreenUtil().setWidth(20),
                                    top: ScreenUtil().setWidth(5),
                                    bottom: ScreenUtil().setWidth(5),
                                  ),
                                  margin: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(20),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xffefefef),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/shop/liwu.png',
                                        width: ScreenUtil().setWidth(43),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(10),
                                      ),
                                      Text(
                                        '礼物列表',
                                        style: TextStyle(
                                          color: Color(0xffff3f28),
                                          fontSize: ScreenUtil().setSp(26),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: ScreenUtil.instance.setWidth(40),
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: ScreenUtil.instance.setWidth(40),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().setWidth(550),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "$time",
                                            style: TextStyle(
                                              color: Color(0xff969696),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(24),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            bottom: ScreenUtil.instance
                                                .setWidth(18),
                                          ),
                                          width: ScreenUtil().setWidth(550),
                                          child: Text(
                                            "$desc",
                                            style: TextStyle(
                                              color: Color(0xff474747),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(26),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Stack(
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(555),
                                              // height: ScreenUtil().setWidth(655),
                                              color: Colors.black,
                                              child: isplay
                                                  ? Chewie(
                                                      controller:
                                                          _chewieController,
                                                    )
                                                  : Container(
                                                      width: ScreenUtil()
                                                          .setWidth(555),
                                                      height: ScreenUtil()
                                                          .setWidth(300),
                                                      decoration: img != ""
                                                          ? BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                  img,
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          : BoxDecoration(),
                                                      child: InkWell(
                                                        onTap: () {
                                                          playsss();
                                                        },
                                                        child: Image.asset(
                                                          "assets/zhibo/play.png",
                                                          width: ScreenUtil()
                                                              .setWidth(90),
                                                          height: ScreenUtil()
                                                              .setWidth(90),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Positioned(
                                              left: ScreenUtil().setWidth(10),
                                              top: ScreenUtil().setWidth(10),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    width: ScreenUtil()
                                                        .setWidth(200),
                                                    height: ScreenUtil()
                                                        .setWidth(40),
                                                    padding: EdgeInsets.only(
                                                        right: ScreenUtil()
                                                            .setWidth(14)),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xaa000000),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: ScreenUtil()
                                                                .setWidth(15),
                                                            right: ScreenUtil()
                                                                .setWidth(15),
                                                          ),
                                                          height: ScreenUtil()
                                                              .setWidth(40),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xaa000000),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Text(
                                                            ishuifang == "1"
                                                                ? '生成中'
                                                                : '可回放',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          20),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          (views > 10000
                                                                  ? ((views ~/ 1000) /
                                                                              10)
                                                                          .toString() +
                                                                      'w'
                                                                  : views
                                                                      .toString()) +
                                                              '人观看',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          14),
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
