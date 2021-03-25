import 'package:client/config/fluro_convert_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/grass_service.dart';
import '../config/Navigator_util.dart';
import '../grass/up_img_build.dart';

class AddGrass extends StatefulWidget {
  final objs;
  AddGrass({this.objs});
  @override
  _AddGrassState createState() => _AddGrassState();
}

class _AddGrassState extends State<AddGrass> {
  String jwt = '';
  String name = '';
  bool btnActive = false;
  bool isLoading = false;
  List imgList = ["assets/zhibo/addimg.png"];
  Map tjGoods = {};
  Map obj = {};
  String tjId = "";
  Map shopDesc = {
    "content": '',
    "desc": '',
    "detail_img": [],
  };
  FocusNode _contentFocus = FocusNode();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    obj = FluroConvertUtils.string2map(widget.objs);
    print('~~~~~~~~~~');
    print(obj);
    print('~~~~~~~~~~');
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
    if (contentController.text == "") {
      ToastUtil.showToast('请输入内容');
      return;
    }

    if (imgList.length == 1) {
      ToastUtil.showToast('请上传图片');
      return;
    }
    if (tjId == "") {
      ToastUtil.showToast('请选择推荐商品');
      return;
    }

    setState(() {
      isLoading = true;
    });
    // imgList.removeLast();
    Map<String, dynamic> map = Map();
    map.putIfAbsent("pid", () => obj['id']);
    map.putIfAbsent("tid", () => obj['id']);
    map.putIfAbsent("content", () => contentController.text);
    map.putIfAbsent("goods_id", () => tjId);
    map.putIfAbsent("img", () => imgList);
    map.putIfAbsent("url_type", () => 1);

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
                color: PublicColor.textColor,
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
                      color: PublicColor.whiteColor,
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
                        child: BuildImg(
                          imgList: imgList,
                          upImgLoad: upImgLoad,
                          changeLoading: changeLoading,
                          unFouce: unFouce,
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
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
