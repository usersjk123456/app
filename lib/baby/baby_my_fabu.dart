import 'package:client/api/api.dart';
import 'package:client/config/fluro_convert_util.dart';
import 'package:client/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import 'package:client/widgets/cached_image.dart';

import '../service/grass_service.dart';
import '../config/Navigator_util.dart';
import '../grass/up_img_build.dart';
import 'package:client/common/upload_to_oss.dart';

class BabyMyFb extends StatefulWidget {
  @override
  _BabyMyFbState createState() => _BabyMyFbState();
}

class _BabyMyFbState extends State<BabyMyFb> {
  String jwt = '';
  String name = '';
  bool btnActive = false;
  bool isLoading = false;
  List imgList = ["assets/index/ic_tianjia_zhaopian.png"];
  Map tjGoods = {};
  Map obj = {};
  String fengmianimg = '';
  String tjId = "";
  Map shopDesc = {
    "content": '',
    "desc": '',
    "detail_img": [],
  };
  FocusNode _contentFocus = FocusNode();
  TextEditingController contentController = TextEditingController();

  FocusNode _titlecontentFocus = FocusNode();
  TextEditingController titlecontentController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void unFouce() {
    _contentFocus.unfocus(); // input失去焦点
  }

  void changeLoading({type = 2, sent = 0, total = 0}) {
    if (type == 1) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void upImgLoad(images) async {
    setState(() {
      imgList.insert(0, images);
    });
  }

  void sendPlant() async {
    print('~~~~~~~~~~~~~~');
    print(obj);
    print('~~~~~~~~~~~~~~');
    if (titlecontentController.text == "") {
      ToastUtil.showToast('请输入标题');
      return;
    }
    if (contentController.text == "") {
      ToastUtil.showToast('请输入内容');
      return;
    }

    // if (imgList.length == 1) {
    //   ToastUtil.showToast('请上传图片');
    //   return;
    // }

    setState(() {
      isLoading = true;
    });
    // imgList.removeLast();
    Map<String, dynamic> map = Map();
    print(titlecontentController.text);
    print('~~~~~~~~~~~~~~~~~~~~~~~~');
    map.putIfAbsent("desc", () => titlecontentController.text);
    map.putIfAbsent("text", () => contentController.text);
    map.putIfAbsent("img", () => fengmianimg);

    Service().getData(map, Api.SEND_PROBLEM_URL, (success) async {
      // setState(() {
      //   tabTitles = success['list'];
      // });
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('发表成功');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
    // GrassServer().sendPlant(map, (success) async {
    //   ToastUtil.showToast('发布成功');
    //   Navigator.pop(context);
    // }, (onFail) async {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   ToastUtil.showToast(onFail);
    // });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
          appBar: new AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              '发表问题',
              style: TextStyle(
                color: PublicColor.headerTextColor,
              ),
            ),
            leading: IconButton(
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
                onTap: () {
                  sendPlant();
                },
                child: Container(
                  alignment: Alignment.center,
                  // width: ScreenUtil().setWidth(36),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // color: Color(0xffFD8C34),
                  ),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                  child: Text(
                    '保存',
                    style: new TextStyle(
                      color: PublicColor.textColor,
                      fontSize: ScreenUtil().setSp(28),
                      // height: 2.7,
                    ),
                  ),
                ),
              )
            ],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
          ),
          body: new Container(
            color: Color(0xffffffff),
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: ScreenUtil().setWidth(20)),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border(
                    //     bottom: BorderSide(
                    //   width: 1,
                    //   color: Color(0xffF5F5F5),
                    // ))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            btnActive = value.length == 0 ? false : true;
                            name = value;
                          });
                        },
                        focusNode: _titlecontentFocus,
                        controller: titlecontentController,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入问题标题",
                        ),
                      ),
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
                        maxLines: 5,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入评论内容",
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.topLeft,
                      //   child: BuildImg(
                      //     imgList: imgList,
                      //     upImgLoad: upImgLoad,
                      //     changeLoading: changeLoading,
                      //     unFouce: unFouce,
                      //   ),
                      // ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: fengmianimg == ''
                              ? Image.asset(
                                  "assets/index/ic_tianjia_zhaopian.png",
                                  height: ScreenUtil().setWidth(188),
                                  width: ScreenUtil().setWidth(188),
                                  fit: BoxFit.cover,
                                )
                              : CachedImageView(
                                  ScreenUtil.instance.setWidth(188),
                                  ScreenUtil.instance.setWidth(188),
                                  fengmianimg,
                                  null,
                                  BorderRadius.vertical(
                                      top: Radius.elliptical(0, 0))),
                        ),
                        onTap: () async {
                          Map obj = await openGallery("image", changeLoading);
                          if (obj == null) {
                            changeLoading(type: 2, sent: 0, total: 0);
                            return;
                          }
                          if (obj['errcode'] == 0) {
                            fengmianimg = obj['url'];
                          } else {
                            ToastUtil.showToast(obj['msg']);
                          }
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(55),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
