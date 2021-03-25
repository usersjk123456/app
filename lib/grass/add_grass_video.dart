import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../common/upLoading.dart';
import '../widgets/loading.dart';
import '../service/grass_service.dart';
import '../config/Navigator_util.dart';
import '../common/upload_to_oss.dart';


class AddGrassVideo extends StatefulWidget {
  final objs;
  AddGrassVideo({this.objs});
  @override
  _AddGrassVideoState createState() => _AddGrassVideoState();
}

class _AddGrassVideoState extends State<AddGrassVideo> {
  String jwt = '';
  String name = '';
  bool btnActive = false;
  bool isLoading = false;
  bool isUpLoading = false;
  List imgList = ["assets/zhibo/addimg.png"];
  Map tjGoods = {};
  Map obj = {};
  String tjId = "";
  Map shopDesc = {
    "content": '',
    "desc": '',
    "detail_img": [],
  };
  int sents = 0;
  int totals = 100;
  FocusNode _contentFocus = FocusNode();
  TextEditingController contentController = TextEditingController();
  VideoPlayerController _controller;

  @override
  void initState() {
    // obj = FluroConvertUtils.string2map(widget.objs);
    super.initState();
  }

  void unFouce() {
    _contentFocus.unfocus(); // input失去焦点
  }

  void changeLoading({type = 2, sent = 0, total = 100}) {
    print('sent-->>>$sent');
    print('total-->>>$total');
    if (type == 1) {
      setState(() {
        isUpLoading = true;
        sents = sent;
        totals = total;
      });
    } else {
      setState(() {
        isUpLoading = false;
        sents = 0;
        totals = 100;
      });
    }
  }

  void sendPlant() async {
    if (contentController.text == "") {
      ToastUtil.showToast('请输入内容');
      return;
    }

    if (imgList.length == 1) {
      ToastUtil.showToast('请上传视频');
      return;
    }
    if (tjId == "") {
      ToastUtil.showToast('请选择推荐商品');
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("pid", () => obj['id']);
    map.putIfAbsent("content", () => contentController.text);
    map.putIfAbsent("goods_id", () => tjId);
    map.putIfAbsent("img", () => imgList);
    map.putIfAbsent("url_type", () => 2);

    GrassServer().sendPlant(map, (success) async {
      ToastUtil.showToast('发布成功');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
          appBar: AppBar(
            elevation: 0,
            title: new Text(
              '发起话题',
              style: TextStyle(
                color: PublicColor.headerTextColor,
              ),
            ),
            backgroundColor: PublicColor.headerColor,
            centerTitle: true,
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
              InkWell(
                child: Container(
                  padding: const EdgeInsets.only(right: 14.0, top: 15.0),
                  child: Text(
                    '发布',
                    style: TextStyle(
                      color: PublicColor.themeColor,
                    ),
                  ),
                ),
                onTap: () {
                  sendPlant();
                },
              )
            ],
          ),
          body: new Container(
            color: PublicColor.bodyColor,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(height: ScreenUtil().setWidth(20)),
                // Container(
                //   padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                //   color: Colors.white,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Text(
                //         '参与话题',
                //         style: TextStyle(
                //           color: PublicColor.textColor,
                //         ),
                //       ),
                //       Text(
                //         obj['name'],
                //         style: TextStyle(
                //           color: PublicColor.themeColor,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(height: ScreenUtil().setWidth(20)),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            btnActive = value.length == 0 ? false : true;
                            name = value;
                          });
                        },
                        focusNode: _contentFocus,
                        controller: contentController,
                        keyboardType: TextInputType.text,
                        maxLines: 8,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "说说你得心得",
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: ScreenUtil().setWidth(160),
                          height: ScreenUtil().setWidth(160),
                          child: InkWell(
                            onTap: () async {
                              unFouce();
                              Map obj = await openGallery("mp4", changeLoading);
                              if (obj == null) {
                                changeLoading(type: 2, sent: 0, total: 100);
                                return;
                              }
                              if (obj['errcode'] == 0) {
                                setState(() {
                                  if (imgList.length == 1) {
                                    imgList.insert(0, obj['url']);
                                  } else {
                                    imgList[0] = obj['url'];
                                  }
                                });
                                print('imgList--->>>$imgList');
                                _controller =
                                    VideoPlayerController.network(obj['url'])
                                      ..initialize().then((_) {
                                        setState(() {
                                          _controller.play();
                                        });
                                      });
                              } else {
                                ToastUtil.showToast(obj['msg']);
                              }
                            },
                            child: imgList.length == 1
                                ? Image.asset(
                                    "assets/zhibo/addimg.png",
                                    width: ScreenUtil().setWidth(160),
                                    height: ScreenUtil().setWidth(160),
                                    fit: BoxFit.cover,
                                  )
                                : VideoPlayer(_controller),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(20)),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                  color: PublicColor.whiteColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '推荐商品',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                      InkWell(
                        child: Row(
                          children: <Widget>[
                            tjGoods.length == 0
                                ? Text(
                                    '添加',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      color: PublicColor.grewNoticeColor,
                                    ),
                                  )
                                : Text(
                                    '已添加商品',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      color: Colors.red,
                                    ),
                                  ),
                            new Icon(
                              Icons.navigate_next,
                              color: Color(0xff999999),
                            )
                          ],
                        ),
                        onTap: () {
                          unFouce();
                          NavigatorUtils.toChooseGoodsPage(
                                  context, 'tuijian', tjGoods)
                              .then((result) {
                            if (result != null) {
                              setState(() {
                                tjGoods = result;
                              });
                              result.forEach((key, value) {
                                setState(() {
                                  tjId = value['id'].toString();
                                });
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
        isUpLoading ? UpLoadingDialog(sent: sents, total: totals) : Container()
      ],
    );
  }
}
