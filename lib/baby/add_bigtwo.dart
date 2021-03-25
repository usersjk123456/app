import 'package:amap_location/amap_location.dart';
import 'package:client/common/upload_to_oss.dart';
import 'package:client/utils/string_util.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_permissions/location_permissions.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:client/api/api.dart';
import 'package:client/service/service.dart';

class AddBigTwoPage extends StatefulWidget {
  final type;
  final oid;
  AddBigTwoPage({this.type, this.oid});
  @override
  _AddBigTwoPageState createState() => _AddBigTwoPageState();
}

class _AddBigTwoPageState extends State<AddBigTwoPage> {
  String jwt = '', bid = '';
  String name = '';
  bool btnActive = false;
  bool isLoading = false;
  List imgList = ["assets/index/ic_tianjia_zhaopian.png"];
  Map tjGoods = {};
  Map obj = {};
  String tjId = "";
  Map shopDesc = {
    "content": '',
    "desc": '',
    "detail_img": [],
  };

  List textList = [];
  List delText = [];
  String nowdate = '';
  String fengmianimg = '';
  List listInf = [];
  String backStatus = '';
  String local = '';
  String hintText;
  FocusNode _contentFocus = FocusNode();
  FocusNode _ageFocus = FocusNode();
  TextEditingController contentController = TextEditingController();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPersmission();
    getLocal();
  }

  void getInf() async {
    //接口获取信息
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => prefs.getString('id'));
    map.putIfAbsent("id", () => widget.oid);
    Service().getData(map, Api.GET_BABY_LIST_URL, (success) async {
      setState(() {
        // listInf = success['list'][0];
        textList = success['list'][0]['title'];
        contentController.text = success['list'][0]['text'];
        controller.text = success['list'][0]['age'];
        hintText = success['list'][0]['create_at'];
        // imgList.insert(0, success['list'][0]['img']); 多图
        fengmianimg = success['list'][0]['img'];
      });
      prefs.setString('textarr', textList.join(','));
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void _checkPersmission() async {
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
    await LocationPermissions().requestPermissions();
    AMapLocation loc = await AMapLocationClient.getLocation(true);
    setState(() {
      loc = loc;
    });
    final prefs = await SharedPreferences.getInstance();
    // 存值
    await prefs.setString('loc', loc.city);
    print(
        "定位成功: \n时间${loc.timestamp}\n经纬度:${loc.latitude} ${loc.longitude}\n 地址:${loc.formattedAddress} 城市:${loc.city} 省:${loc.province}");

    setState(() {
      local = prefs.getString('loc');
    });
    print('地址');
    print(prefs.getString('loc'));
    print('地址');
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();

    print(widget.oid);
    print(widget.type);
    print('@@@@@@@@@@@');
    if (widget.type == 'bj') {
      bid = prefs.getString('id');
      setState(() {
        nowdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      });
      if (backStatus == 'ok') {
        //如果是从编辑页进入此页然后点击标签跳入选择标签页后返回，则更新textList
        textList = prefs.getString('textarr').split(',');
      } else {
        getInf();
      }
    } else {
      setState(() {
        textList = prefs.getString('textarr').split(',');
        nowdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        bid = prefs.getString('id');
      });
    }
  }

  void addList() async {
    if (contentController.text == "") {
      ToastUtil.showToast('请输入内容');
      return;
    }
    if (controller.text == "") {
      ToastUtil.showToast('请输入年龄');
      return;
    }

    // if (imgList.length == 1) {
    //   ToastUtil.showToast('请上传图片');
    //   return;
    // }
    // if (tjId == "") {
    //   ToastUtil.showToast('请选择推荐商品');
    //   return;
    // }
    if (textList.length == 0) {
      ToastUtil.showToast('请添加标签');
      return;
    }
    if (StringUtils.isEmpty(hintText)) {
      ToastUtil.showToast('请选择记录时间');
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => bid);
    map.putIfAbsent("age", () => controller.text);
    map.putIfAbsent("title", () => textList);
    map.putIfAbsent("img", () => fengmianimg);
    map.putIfAbsent("address", () => local);
    map.putIfAbsent("text", () => contentController.text);
    map.putIfAbsent("create_at", () => hintText);
    if (widget.type == 'bj') {
      map.putIfAbsent("id", () => widget.oid);
    }
    Service().post(map, Api.ADD_BABYEVENT_URL, (success) async {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context, "back");
    }, (onFail) async {
      ToastUtil.showToast(onFail);
      setState(() {
        isLoading = false;
      });
    });
  }

  void unFouce() {
    _contentFocus.unfocus(); // input失去焦点
    _ageFocus.unfocus();
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
    print('wc');
    print('???????????????????????');
    setState(() {
      imgList.insert(0, images);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
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
                  Icon(
                    Icons.close,
                    color: PublicColor.themeColor,
                    size: ScreenUtil().setSp(25),
                  ),
                ],
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                setState(() {
                  textList.removeAt(i);
                  delText = textList;
                });
                if (textList.length > 0) {
                  prefs.setString('textarr', textList.join(','));
                } else {
                  prefs.remove('textarr');
                }

                //点击标签删除数组中的当前项并更新标签本地存储
                // save();
              },
            ),
          ),
        );
      }
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
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
          child: InkWell(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: PublicColor.themeColor,
                  size: ScreenUtil().setSp(25),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '标签',
                    style: new TextStyle(
                      color: PublicColor.themeColor,
                      fontSize: ScreenUtil().setSp(28),
                      // height: 2.7,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              if (widget.type == 'bj') {
                NavigatorUtils.goAddBigonePage(context, 'bj').then((result) {
                  // getLocal();
                  print(result);
                  setState(() {
                    backStatus = result;
                  });
                  print('??????');
                  getLocal();
                });
              } else {
                Navigator.pop(context);
              }
              // Navigator.pop(context);
              // save();
            },
          ),
        ),
      );

      return list;
    }

    Widget bqContainer = Container(
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: ScreenUtil.instance.setWidth(10.0),
        spacing: ScreenUtil.instance.setWidth(30),
        children: bqView(textList),
      ),
    );

    Widget appBar = new Container(
      color: Color(0xffffffff),
      height: ScreenUtil().setWidth(112),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: Text(
              '取消',
              // color: PublicColor.headerTextColor,
              style: new TextStyle(
                  color: PublicColor.headerTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('textarr');
              Navigator.pop(context);
            },
          ),
          Container(
            width: ScreenUtil().setWidth(96),
            height: ScreenUtil().setWidth(46),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              color: Color(0xffFD8C34),
            ),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
            child: InkWell(
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '保存',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(28),
                      // height: 2.7,
                    ),
                  )),
              onTap: () {
                // save();
                // NavigatorUtils.toBig(context, id);
                addList();
              },
            ),
          ),
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动

          body: new Container(
            color: Color(0xffffffff),
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
                appBar,
                SizedBox(height: ScreenUtil().setWidth(20)),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                  decoration: BoxDecoration(
                      // color: Colors.white,

                      border: Border(
                          bottom: BorderSide(
                    width: 1,
                    color: Color(0xffF5F5F5),
                  ))),
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
                        focusNode: _contentFocus,
                        controller: contentController,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "把孕期的珍贵时光记录下来吧",
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
                      bqContainer,
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              right: ScreenUtil().setWidth(40),
                            ),
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Container(
                //   padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       border: Border(
                //           bottom: BorderSide(
                //         width: 1,
                //         color: Color(0xffF5F5F5),
                //       ))),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Row(
                //         children: <Widget>[
                //           Image.asset(
                //             'assets/index/ic_suo.png',
                //             width: ScreenUtil().setWidth(35),
                //             height: ScreenUtil().setWidth(35),
                //           ),
                //           SizedBox(
                //             width: ScreenUtil().setWidth(19),
                //           ),
                //           Text(
                //             '谁可以看',
                //             style: TextStyle(
                //               fontSize: ScreenUtil().setSp(28),
                //             ),
                //           ),
                //         ],
                //       ),
                //       InkWell(
                //         child: Row(
                //           children: <Widget>[
                //             tjGoods.length == 0
                //                 ? Text(
                //                     '所有亲',
                //                     style: TextStyle(
                //                       fontSize: ScreenUtil().setSp(28),
                //                       color: PublicColor.grewNoticeColor,
                //                     ),
                //                   )
                //                 : Text(
                //                     '仅自己',
                //                     style: TextStyle(
                //                       fontSize: ScreenUtil().setSp(28),
                //                       color: Colors.red,
                //                     ),
                //                   ),
                //             new Icon(
                //               Icons.navigate_next,
                //               color: Color(0xff999999),
                //             )
                //           ],
                //         ),
                //         onTap: () {
                //           unFouce();
                //           // NavigatorUtils.toChooseGoodsPage(
                //           //         context, 'tuijian', tjGoods)
                //           //     .then((result) {
                //           //   if (result != null) {
                //           //     setState(() {
                //           //       tjGoods = result;
                //           //     });
                //           //     result.forEach((key, value) {
                //           //       setState(() {
                //           //         tjId = value['id'].toString();
                //           //       });
                //           //     });
                //           //   }
                //           // });
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(40)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                        width: 1,
                        color: Color(0xffF5F5F5),
                      ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/index/age.png',
                            width: ScreenUtil().setWidth(35),
                            height: ScreenUtil().setWidth(35),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(19),
                          ),
                          Text(
                            '年龄',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          child: new TextField(
                            controller: controller,
                            focusNode: _ageFocus,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                                hintText: '请输入年龄', border: InputBorder.none),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                        width: 1,
                        color: Color(0xffF5F5F5),
                      ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/index/ic_weizhi.png',
                            width: ScreenUtil().setWidth(35),
                            height: ScreenUtil().setWidth(35),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(19),
                          ),
                          Text(
                            '所在位置',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${local ?? ''}',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                color: PublicColor.grewNoticeColor,
                              ),
                            ),
                            Icon(
                              Icons.navigate_next,
                              color: Color(0xff999999),
                            )
                          ],
                        ),
                        onTap: () {
                          unFouce();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                        width: 1,
                        color: Color(0xffF5F5F5),
                      ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/index/ic_shijian.png',
                            width: ScreenUtil().setWidth(35),
                            height: ScreenUtil().setWidth(35),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(19),
                          ),
                          Text(
                            '记录时间',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () {
                            DateTime victoryDay = new DateTime.now();
                            print(victoryDay.year - 12);
                            DatePicker.showDatePicker(context,
                                // 是否展示顶部操作按钮
                                showTitleActions: true,
                                // 最小时间
                                minTime: DateTime(victoryDay.year - 12, 3, 5),
                                // 最大时间
                                maxTime: DateTime(victoryDay.year + 3, 6, 7),
                                // change事件
                                onChanged: (date) {
                              setState(() {
                                hintText = date.toString().split(' ')[0];
                              });
                            },
                                // 确定事件
                                onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                hintText = date.toString().split(' ')[0];
                              });
                            },
                                // 当前时间
                                currentTime: DateTime.now(),
                                // 语言
                                locale: LocaleType.zh);
                          },
                          child: Text(
                            hintText ?? '请选择日期',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Color(0xff999999),
                                fontSize: ScreenUtil().setSp(26)),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   child: Row(
                      //     children: <Widget>[
                      //       Text(
                      //         '${nowdate}',
                      //         style: TextStyle(
                      //           fontSize: ScreenUtil().setSp(28),
                      //           color: PublicColor.grewNoticeColor,
                      //         ),
                      //       ),
                      //       Icon(
                      //         Icons.navigate_next,
                      //         color: Color(0xff999999),
                      //       )
                      //     ],
                      //   ),
                      //   onTap: () {
                      //     unFouce();
                      //     // NavigatorUtils.toChooseGoodsPage(
                      //     //         context, 'tuijian', tjGoods)
                      //     //     .then((result) {
                      //     //   if (result != null) {
                      //     //     setState(() {
                      //     //       tjGoods = result;
                      //     //     });
                      //     //     result.forEach((key, value) {
                      //     //       setState(() {
                      //     //         tjId = value['id'].toString();
                      //     //       });
                      //     //     });
                      //     //   }
                      //     // });
                      //   },
                      // ),
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
