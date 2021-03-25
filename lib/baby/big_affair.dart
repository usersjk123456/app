import 'package:client/api/api.dart';
import 'package:client/bottom_input/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/swiper.dart';
import '../widgets/cached_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:async';
import 'package:flutter/rendering.dart';
import '../utils/toast_util.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Navigator_util.dart';
import '../home/share_django.dart';
import '../common/Global.dart';
import '../service/goods_service.dart';
import '../service/user_service.dart';
import '../common/color.dart';
import '../baby/baby_lq.dart';
import '../home/detail_comment.dart';
import '../bottom_input/input_dialog.dart';
import 'package:client/api/api.dart';
import 'package:client/service/service.dart';

class AffairPage extends StatefulWidget {
  final String oid;
  final String shipId;
  final String roomId;
  AffairPage({this.oid, this.shipId, this.roomId});
  @override
  _AffairPageState createState() => _AffairPageState();
}

List guige = [];
int buynum = 1;
int checkindex = 0;
Map listInf = {'img': ''};
List textList = [];
List wdlist = [];
String babyname = '';

class _AffairPageState extends State<AffairPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  EasyRefreshController _controller = EasyRefreshController();
  GlobalKey globalKey = GlobalKey();
  String jwt = '';
  int checkindex1 = -1;
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _commentFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    print(widget.oid);
    getBabyInf();
    getInf();
  }

  void getBabyInf() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    //获取宝宝信息
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    Service().getData(map, Api.GET_BABY_URL, (success) async {
      setState(() {
        babyname = success['data']['nickname'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getInf() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => prefs.getString('id'));
    map.putIfAbsent("id", () => widget.oid);
    Service().getData(map, Api.GET_BABY_LIST_URL, (success) async {
      setState(() {
        listInf = success['list'][0];
        textList = success['list'][0]['title'];
        wdlist = success['list'][0]['log'];
        // nowdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void delThis() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => prefs.getString('id'));
    map.putIfAbsent("id", () => widget.oid);
    Service().getData(map, Api.DEL_BABYEVENT_URL, (success) async {
      Navigator.pop(context);
      ToastUtil.showToast('删除成功');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void sendmessage() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("eid", () => widget.oid);
    map.putIfAbsent("text", () => _textEditingController.text);
    // map.putIfAbsent("create_at", () => _textEditingController.text);
    Service().post(map, Api.PL_BABYEVENT_URL, (success) async {
      setState(() {
        _textEditingController.text = '';
      });
      ToastUtil.showToast('评论成功');
      _commentFocus.unfocus();
      getInf();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget iptView = Container(
        color: PublicColor.whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              decoration: new BoxDecoration(
                //背景
                color: Color(0xfffEEEEEE),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(30)),
                //设置四周边框
              ),
              // height: ScreenUtil().setWidth(65),
              width: ScreenUtil().setWidth(594),
              child: TextField(
                controller: _textEditingController,
                focusNode: _commentFocus,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    hintText: '说点什么吧', border: InputBorder.none),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setWidth(65),
              decoration: new BoxDecoration(
                //背景
                color: PublicColor.themeColor,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(30)),
                //设置四周边框
              ),
              child: InkWell(
                child: Text(
                  '发送',
                  style: TextStyle(
                    fontSize: 18,
                    color: PublicColor.whiteColor,
                  ),
                ),
                onTap: () {
                  sendmessage();
                  // sendCommit();
                },
              ),
            )
          ],
        ));
    bqView(item) {
      List<Widget> list = [];
      for (var i = 0; i < item.length; i++) {
        list.add(
          Container(
            // width: ScreenUtil().setWidth(96),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(21),
              right: ScreenUtil().setWidth(21),
            ),
            height: ScreenUtil().setWidth(54),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
              border: Border.all(width: 1, color: PublicColor.themeColor),
              color: Color(0xffFBE9DB),
            ),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${item[i]}',
                      style: new TextStyle(
                        color: PublicColor.themeColor,
                        fontSize: ScreenUtil().setSp(28),
                        // height: 2.7,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () async {},
            ),
          ),
        );
      }

      return list;
    }

    Widget bqContainer = Container(
      width: ScreenUtil().setWidth(750),
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: ScreenUtil.instance.setWidth(10.0),
        spacing: ScreenUtil.instance.setWidth(30),
        children: bqView(textList),
      ),
    );
    Widget contentWidget() {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(100.0)),
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
              onLoad: () async {},
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                SizedBox(height: ScreenUtil().setWidth(18)),
                Container(
                  // height: ScreenUtil().setWidth(573),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(42)),
                  color: Color(0xffffffff),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '${babyname}',
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: ScreenUtil().setSp(32),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(28),
                          ),
                          Text(
                            '${listInf['age']}',
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(38),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${listInf['text']}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(38),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: CachedImageView(
                              ScreenUtil.instance.setWidth(188),
                              ScreenUtil.instance.setWidth(188),
                              listInf['img'],
                              null,
                              BorderRadius.vertical(
                                  top: Radius.elliptical(0, 0)))),
                      SizedBox(
                        height: ScreenUtil().setWidth(32),
                      ),
                      bqContainer,
                      SizedBox(
                        height: ScreenUtil().setWidth(24),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${listInf['is_parent'] == 1 ? '爸爸' : '妈妈'},${listInf['create_at']}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color(0xff999999),
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Image.asset(
                              'assets/index/ic_pinglun.png',
                              width: ScreenUtil().setWidth(41),
                              height: ScreenUtil().setWidth(41),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(24),
                ),
                Container(
                  color: Color(0xffffffff),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(50),
                      top: ScreenUtil().setWidth(40),
                      bottom: ScreenUtil().setWidth(40)),
                  child: Text(
                    '评论',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      slider(),
                    ],
                  ),
                ),
              ])),
            ),
          ),
          Container(
            height: ScreenUtil.instance.setWidth(135.0),
            width: ScreenUtil().setWidth(750),
            color: Color(0xffffffff),
            child: iptView,
          ),
        ],
      );
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: Text(
              '宝宝',
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
            actions: <Widget>[
              MaterialButton(
                  child: Icon(
                    Icons.more_horiz,
                    size: 25.0,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            height: ScreenUtil().setWidth(321),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(50),
                                        right: ScreenUtil().setWidth(50)),
                                    height: ScreenUtil().setWidth(106),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: PublicColor.lineColor)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '编辑',
                                      style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: ScreenUtil().setSp(30),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    NavigatorUtils.goAddBigtwoPage(
                                            context, "bj", widget.oid)
                                        .then((result) {
                                      getInf();
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(50),
                                        right: ScreenUtil().setWidth(50)),
                                    height: ScreenUtil().setWidth(106),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: PublicColor.lineColor)),
                                    ),
                                    child: Text(
                                      '删除',
                                      style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: ScreenUtil().setSp(30),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    delThis();
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    height: ScreenUtil().setWidth(106),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '取消',
                                      style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: ScreenUtil().setSp(30),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  }),
            ],
          ),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget slider() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (wdlist.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in wdlist) {
        arr.add(
          Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(20),
            ),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(24),
                left: ScreenUtil().setWidth(50),
                bottom: ScreenUtil().setWidth(24)),
            child: InkWell(
              onTap: () {
                print(item);
                String oid = (item['id']).toString();
                NavigatorUtils.gobabyXiangqing(context);
              },
              //设置圆角
              child: Column(
                children: <Widget>[
                  Row(children: [
                    Container(
                      child: CachedImageView(
                        ScreenUtil.instance.setWidth(55.0),
                        ScreenUtil.instance.setWidth(55.0),
                        item['user']['headimgurl'],
                        null,
                        BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(29),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(500),
                                child: Text(
                                  item['user']['nickname'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(32),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(37),
                              ),
                              // Text(
                              //   item['text'],
                              //   style: TextStyle(
                              //     color: Color(0xff666666),
                              //     fontSize: ScreenUtil().setSp(26),
                              //   ),
                              // ),
                            ],
                          ),
                          Container(
                              width: ScreenUtil().setWidth(400),
                              child: Text(
                                item['create_at'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(26),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: ScreenUtil().setWidth(30),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item['text'],
                      style: TextStyle(
                        color: Color(0xff666666),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(24),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    content = new ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: arr,
    );
    return content;
  }
}
