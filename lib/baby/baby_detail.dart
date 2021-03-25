import 'package:client/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/cached_image.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/goods_service.dart';
import '../common/color.dart';
import '../baby/baby_lq.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
class BabyXiangQingPage extends StatefulWidget {
  final String oid;
  final String type;
  final String roomId;
  BabyXiangQingPage({this.oid, this.type, this.roomId});
  @override
  _BabyXiangQingPageState createState() => _BabyXiangQingPageState();
}

class _BabyXiangQingPageState extends State<BabyXiangQingPage>
    with SingleTickerProviderStateMixin {

  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  bool isLoading = false;
  EasyRefreshController _controller = EasyRefreshController();
  GlobalKey globalKey = GlobalKey();
  bool isplay = false;
  int checkindex1 = -1;
  
List guige = [];
int buynum = 1;
int checkindex = 0;

  String jwt = '',
      detail = '',
      img = '',
      teacher = '',
      name = '',
      text = '',
      age = '',
      oldprice = '',
      oid = '';
  Map goods = {
    "id": 3,
    "teacher_id": 1,
    "type": "66",
    "name": "name3",
    "img": "111111",
    "now_price": "11.00",
    "old_price": "22.00",
    "age": "1-100岁",
    "text": "这是一课",
    "is_vip": 0,
    "is_tiyan": 1,
    "sort": 1,
    "is_del": 0,
    "create_at": "2020-11-19 10:24:05",
    "teacher": {
      "id": 1,
      "text": "这uhcoisdoidahoivdhduifhuoudfiowj",
      "img": "qbcdefgh",
      "name": "陈老师",
      "is_del": 0,
      "create_at": "2020-11-19 10:13:12"
    },
    "child": []
  };

  List xiangqingimglist = [];
  List bannerList = [];
  List tuijianlist = [];
  int _page = 0,urltype;
  String kfToken = '';
  List commentList = [];
  String count = '0';
  bool isLive = false, isStore = false;

  @override
  void initState() {
    super.initState();
    print('roomId===${widget.oid}');
    buynum = 1;
    getGoodsDetails();
    _page = 0;

    _controller.finishRefresh();
  }



  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      // getLocal();
    }
  }

  @override

  @override
  void dispose() {
    _videoPlayerController1?.dispose();
    _chewieController?.dispose();
    super.dispose();
    // cancelTimer();
  }

  void playsss() {
    _videoPlayerController1 = VideoPlayerController.network(img);
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
  // 商品详情
  Future getGoodsDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    GoodsServer().gethkGoodsDetails(map, (success) async {
      setState(() {
        isLoading = false;
        goods = success['list'];
        oid = success['list']['id'].toString();
        img = success['list']['img'];
        urltype=success['list']['urltype'];
        name = success['list']['name'];
        text = success['list']['text'];
        detail = success['list']['detail'];
        age = success['list']['age'];
        teacher = success['list']['teacher']['name'];
        oldprice = success['list']['now_price'];
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: Text(
              '宝贝详情',
              style: TextStyle(
                color: PublicColor.headerTextColor,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
            centerTitle: true,
            leading: new IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget contentWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(100.0)),
          color: Color(0xffff5f5f5),
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
            onRefresh: () async {},
            onLoad: () async {
              // loadtuijian();
            },
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Stack(
                children: <Widget>[
                  // Container(
                  //   child: CachedImageView(
                  //     ScreenUtil.instance.setWidth(750.0),
                  //     ScreenUtil.instance.setWidth(420.0),
                  //     img,
                  //     null,
                  //     BorderRadius.only(
                  //       topLeft: Radius.circular(15),
                  //       topRight: Radius.circular(15),
                  //       bottomLeft: Radius.circular(15),
                  //       bottomRight: Radius.circular(5),
                  //     ),
                  //   ),
                  // ),
              
            urltype==2? Container(
                    width: ScreenUtil().setWidth(750),
                              height: ScreenUtil().setWidth(420),
                      color: Colors.black,
                      child: isplay
                          ? Chewie(
                              controller: _chewieController,
                            )
                          : Container(
                              width: ScreenUtil().setWidth(750),
                              height: ScreenUtil().setWidth(420),
                              decoration: img != ""
                                  ? BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          img,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : BoxDecoration(),
                              child: InkWell(
                                onTap: () {
                                  playsss();
                                },
                                child: Image.asset(
                                  "assets/zhibo/play.png",
                                  width: ScreenUtil().setWidth(90),
                                  height: ScreenUtil().setWidth(90),
                                ),
                              ),
                            ),
                    ):  Container(
                    child: CachedImageView(
                      ScreenUtil.instance.setWidth(750.0),
                      ScreenUtil.instance.setWidth(420.0),
                      img,
                      null,
                      BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                  ),
                 
                ],
              ),
              Container(
                height: ScreenUtil.instance.setWidth(138.0),
                width: ScreenUtil.instance.setWidth(750.0),
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(25),
                  right: ScreenUtil().setWidth(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                // '${goods['name']}',
                                '￥0.00',
                                overflow: TextOverflow.ellipsis,

                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(41.0),
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(17),
                              ),
                              Text(
                                oldprice,
                                style: TextStyle(
                                  color: const Color(0xff666666),
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: const Color(0xff000000),
                                  fontSize: ScreenUtil.instance.setWidth(30.0),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            age,
                            style: TextStyle(
                              color: PublicColor.themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.black87,
                      alignment: Alignment.centerLeft,

                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/index/ic_xsmf.png',
                            width: ScreenUtil().setWidth(125),
                            height: ScreenUtil().setWidth(44),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(26),
                          ),
                          Text(
                            // '${goods['name']}',
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(28.0),
                              color: Color(0xff4E4E4E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              Container(
                width: ScreenUtil.instance.setWidth(750.0),
                height: ScreenUtil.instance.setWidth(100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.instance.setWidth(135.0),
                      height: ScreenUtil.instance.setWidth(2.0),
                      color: Color(0xfff7a7a7a),
                    ),
                    Container(
                      width: ScreenUtil.instance.setWidth(15.0),
                      height: ScreenUtil.instance.setWidth(2.0),
                    ),
                    Text(
                      '宝贝详情',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(35),
                        color: Color(0xfff7a7a7a),
                      ),
                    ),
                    Container(
                      width: ScreenUtil.instance.setWidth(15.0),
                      height: ScreenUtil.instance.setWidth(2.0),
                    ),
                    Container(
                      width: ScreenUtil.instance.setWidth(135.0),
                      height: ScreenUtil.instance.setWidth(2.0),
                      color: Color(0xfff7a7a7a),
                    ),
                  ],
                ),
              ),
              // new Column(
              //   mainAxisSize: MainAxisSize.max,
              //   children: xiangqingimglist
              //       .map(
              //         (i) => Container(
              //           width: ScreenUtil().setWidth(750),
              //           child: Image.network(
              //             i['img'],
              //             width: ScreenUtil().setWidth(750),
              //             fit: BoxFit.fitWidth,
              //           ),
              //         ),
              //       )
              //       .toList(),
              // ),
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                child: Html(data: detail),
              ),
            ])),
          ),
        ),
        /*Container(
          height: ScreenUtil.instance.setWidth(100.0),
          decoration: BoxDecoration(color: Color(0xffffffff), boxShadow: [
            BoxShadow(
              color: Color(0xff6C6C6C),
              blurRadius: 5.0,
            ),
          ]),
          width: ScreenUtil().setWidth(750),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: ScreenUtil().setWidth(40)),
                  Text(
                    '0',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(50),
                      color: Color(0xffFB1F29),
                    ),
                  ),
                  Text(
                    '元',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: Color(0xffFB1F29),
                    ),
                  ),
                ],
              ),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(36),
                  ),
                  width: ScreenUtil().setWidth(136),
                  height: ScreenUtil().setWidth(53),
                  decoration: BoxDecoration(
                    color: Color(0xffFD8C34),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    '购买',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(34),
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return LingquWidget(
                          onChanged: (index) {
                            if (index == -1) {
                     
                            } else {
                              setState(() {
                                checkindex1 = index;
                              });
                            }
                          },
                          jwt: jwt.toString(),
                          goods: goods,
                          type: widget.type,
                          isLive: isLive,
                          roomId: widget.roomId,
                          guige: guige,
                                                   );
                      });
                },
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  Widget _getGridViewItem(BuildContext context, productEntity) {
    return Container(
      child: InkWell(
          onTap: () {
            print(productEntity);
            String oid = (productEntity['id']).toString();
            NavigatorUtils.toXiangQing(context, oid, '0', '0');
          },
          child: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))), //设置圆角
            child: Stack(children: [
              Container(
                child: CachedImageView(
                  100000,
                  ScreenUtil.instance.setWidth(340.0),
                  productEntity['thumb'],
                  null,
                  BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(350),
                    left: ScreenUtil().setWidth(5),
                    right: ScreenUtil().setWidth(5)),
                child: Column(
                  children: <Widget>[
                    Text(productEntity['name'],
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.instance.setWidth(26.0))),
                    new SizedBox(height: ScreenUtil.instance.setWidth(8.0)),
                    Row(children: [
                      Expanded(
                        flex: 3,
                        child: RichText(
                          text: TextSpan(
                            text: '￥' + productEntity['now_price'].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil.instance.setWidth(28)),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' /赚￥' +
                                    productEntity['commission'].toString(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: ScreenUtil.instance.setWidth(28),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenUtil().setWidth(50),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xfffffd509),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Text(
                            '购买',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26),
                            ),
                          ),
                        ),
                      ),
                    ])
                  ],
                ),
              )
            ]),
          )),
    );
  }
}
