import 'dart:ui';
import 'package:client/widgets/btn_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/live_service.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import '../widgets/choose_type.dart';
import '../widgets/cached_image.dart';
import '../utils/toast_util.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../common/upload_to_oss.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/loading.dart';
import 'package:flutter_html/flutter_html.dart';
class CreateZhiboPage extends StatefulWidget {
  @override
  CreateZhiboPageState createState() => CreateZhiboPageState();
}

class CreateZhiboPageState extends State<CreateZhiboPage> {
  bool isCheck = false, isNotice = false, isLoading = false;
  bool isSet = true;
  String fengmianimg = '', startTime = '';

  Map liveType = {'id': 0, 'name': ''},
      liveSet = {'id': 0, 'name': ''},
      def = {'id': 0, 'name': ''};
  String tjImg = '', tjId = '', rule = '';
  Map tjGoods = {}; //推荐商品图片
  Map addImgList = {};
  List chooseType = [],
      defList = [
    {"id": 1, "name": "480"},
    {"id": 2, "name": "720"},
  ],
      liveSetList = [
    {"id": 1, "name": "正式直播", "desc": "展示在直播列表"},
    {"id": 2, "name": "试播", "desc": "不展示在直播列表"},
  ];
  String token = "";
  String key = "";
  String isShowNotice = '0';

  TextEditingController liveNameController = TextEditingController();
  FocusNode _liveNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    geNoticeState();
  }

  void geNoticeState() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('isShowNotice'));
    isShowNotice = prefs.getString('isShowNotice') != null
        ? prefs.getString('isShowNotice')
        : '0';
    Future.delayed(Duration(milliseconds: 1), () async {
      if (isShowNotice == '0') {
        showNocite();
        //存值
        await prefs.setString('isShowNotice', '1');
      }
    });
  }

  void showNocite() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _noticeWidget(context);
      },
    );
  }

  _handleCameraAndMic() async {
    // 请求权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );

    // // 申请结果
    // PermissionStatus camera =
    //     await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    // PermissionStatus phone = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.microphone);

    //校验权限
    if (permissions[PermissionGroup.camera] != PermissionStatus.granted) {
      ToastUtil.showToast('相机权限获取失败');
      return false;
    }
    if (permissions[PermissionGroup.microphone] != PermissionStatus.granted) {
      ToastUtil.showToast('麦克风权限获取失败');
      return false;
    }
    // return true;
  }

  void unFouce() {
    _liveNameFocus.unfocus(); // input失去焦点
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

  // 创建规则
  void createRule() {
    Map<String, dynamic> map = Map();
    LiveServer().createRule(map, (success) async {
      setState(() {
        rule = success['data'];
      });
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return _shareWidget(context);
        },
      );
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 获取直播分类列表
  void getLiveType() {
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("shangji", () => idController.text);
    LiveServer().getLiveType(map, (success) async {
      for (var item in success['list']) {
        item['id'].toInt();
      }

      setState(() {
        chooseType = success['list'];
      });

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FenleiWidget(
            typeList: chooseType,
            selectId: liveType['id'],
            title: "直播分类",
            onChanged: (item) {
              setState(() {
                liveType = item;
              });
            },
          );
        },
      );
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  bool createInfo() {
    if (fengmianimg == '') {
      ToastUtil.showToast('请添加封面图');
      return false;
    }
    if (liveNameController.text == '') {
      ToastUtil.showToast('请输入直播描述');
      return false;
    }
    if (tjId == '') {
      ToastUtil.showToast('请选择推荐商品');
      return false;
    }
    if (addImgList.length == 0) {
      ToastUtil.showToast('请添加商品');
      return false;
    }
    if (liveType['id'] == 0) {
      ToastUtil.showToast('请选择直播分类');
      return false;
    }
    return true;
  }

  // 创建直播
  void createLive() {
    if (!createInfo()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    List goodsList = [];
    addImgList.forEach((key, value) {
      goodsList.add(value['id']);
    });
    print(goodsList);
    Map<String, dynamic> map = Map();
    map.putIfAbsent("img", () => fengmianimg);
    map.putIfAbsent("desc", () => liveNameController.text);
    map.putIfAbsent("goods_id", () => tjId);
    map.putIfAbsent("goods_list", () => goodsList);
    map.putIfAbsent("type", () => liveType['id']);
    map.putIfAbsent("is_notice", () => isNotice ? 1 : 0);
    map.putIfAbsent("def", () => def['id'] == 0 ? 0 : def['id'] - 1);
    map.putIfAbsent("is_try", () => liveSet['id'] == 0 ? 0 : 1);
    LiveServer().createLive(map, (success) async {
      ToastUtil.showToast('创建成功');
      await Future.delayed(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
        NavigatorUtils.goOpenZhibo(context, success['live'], {}, true);
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void popPage() {
    ToastUtil.showToast('hahahahahh');
    Navigator.pop(context);
  }

  //创建预告
  void createNotice() {
    if (!createInfo()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    List goodsList = [];
    addImgList.forEach((key, value) {
      goodsList.add(value['id']);
    });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("img", () => fengmianimg);
    map.putIfAbsent("desc", () => liveNameController.text);
    map.putIfAbsent("goods_id", () => tjId);
    map.putIfAbsent("goods_list", () => goodsList);
    map.putIfAbsent("type", () => liveType['id']);
    map.putIfAbsent("is_notice", () => isNotice ? 1 : 0);
    map.putIfAbsent("def", () => def['id'] == 0 ? 0 : def['id'] - 1);
    map.putIfAbsent("is_try", () => liveSet['id'] == 0 ? 0 : 1);
    map.putIfAbsent("start_time", () => startTime);

    LiveServer().createNotice(map, (success) async {
      ToastUtil.showToast('创建成功');
      Navigator.pop(context);
      setState(() {
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
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    // Widget goodsImgItem(img) {
    //   return ClipOval(
    //     child: new Image.network(
    //       tjGoods[img],
    //       width: ScreenUtil().setWidth(64),
    //       height: ScreenUtil().setWidth(64),
    //       fit: BoxFit.cover,
    //     ),
    //   );
    // }

    // Widget buildGoodsImg() {
    //   List<Widget> arr = <Widget>[];
    //   Widget content;
    //   for (var item in addImgList) {
    //     arr.add(goodsImgItem(item['img']));
    //     print(item['img']);
    //   }
    //   content = Row(
    //     children: arr,
    //   );
    //   return content;
    // }

    //封面
    Widget cover = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: ScreenUtil().setWidth(236),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Row(children: <Widget>[
          Expanded(
            flex: 0,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: fengmianimg == ''
                    ? Image.asset(
                        "assets/shop/sctp.png",
                        height: ScreenUtil().setWidth(188),
                        width: ScreenUtil().setWidth(188),
                        fit: BoxFit.cover,
                      )
                    : CachedImageView(
                        ScreenUtil.instance.setWidth(188),
                        ScreenUtil.instance.setWidth(188),
                        fengmianimg,
                        null,
                        BorderRadius.vertical(top: Radius.elliptical(0, 0))),
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
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: liveNameController,
                focusNode: _liveNameFocus,
                maxLines: 4,
                decoration:
                    InputDecoration.collapsed(hintText: "名字起的棒，直播销量就上榜~~~"),
              ),
            ),
          )
        ]),
      ),
    );

    Widget goods = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: ScreenUtil().setWidth(306),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          InkWell(
            child: new Container(
              height: ScreenUtil().setWidth(100),
              width: ScreenUtil().setWidth(700),
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
              ),
              child: new Row(children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    '推荐商品',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: tjImg == ''
                        ? Text(
                            '仅可选择一件商品',
                            style: TextStyle(
                              color: Color(0xffeb727d),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          )
                        : ClipOval(
                            child: new Image.network(
                              tjImg,
                              width: ScreenUtil().setWidth(64),
                              height: ScreenUtil().setWidth(64),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff8e8e8e),
                    ),
                  ),
                )
              ]),
            ),
            onTap: () {
              print('推荐商品');
              unFouce();
              NavigatorUtils.toChooseGoodsPage(context, 'tuijian', tjGoods)
                  .then((result) {
                if (result != null) {
                  setState(() {
                    print('tuijian-----------');
                    print(result);
                    tjGoods = result;
                  });
                  result.forEach((key, value) {
                    setState(() {
                      tjImg = value['thumb'];
                      tjId = value['id'].toString();
                    });
                  });
                }
              });
            },
          ),
          InkWell(
            child: new Container(
              height: ScreenUtil().setWidth(100),
              width: ScreenUtil().setWidth(700),
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      '添加商品',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    // child: Row(
                    //   children: <Widget>[
                    // addImgList.length == 0 ? Container() : buildGoodsImg(),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${addImgList.length}件商品',
                        style: TextStyle(
                          color: Color(0xff8e8e8e),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                    //   ],
                    // ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.navigate_next,
                        color: Color(0xff8e8e8e),
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              unFouce();
              NavigatorUtils.toChooseGoodsPage(context, 'add', addImgList)
                  .then((result) {
                if (result != null) {
                  setState(() {
                    print('add-----------');
                    addImgList = result;
                  });
                  print(addImgList);
                }
              });
            },
          ),
          InkWell(
            child: new Container(
              height: ScreenUtil().setWidth(100),
              width: ScreenUtil().setWidth(700),
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
              child: new Row(children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    '直播分类',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      liveType['name'],
                      style: TextStyle(
                        color: Color(0xff8e8e8e),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff8e8e8e),
                    ),
                  ),
                )
              ]),
            ),
            onTap: () {
              unFouce();
              getLiveType();
            },
          ),
        ]),
      ),
    );

    Widget yugao = new Container(
        alignment: Alignment.center,
        child: new InkWell(
          child: Container(
            margin: EdgeInsets.only(top: 15),
            height: ScreenUtil().setWidth(114),
            width: ScreenUtil().setWidth(700),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xffe5e5e5), width: 1),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Checkbox(
                    tristate: false,
                    value: isCheck,
                    onChanged: (bool newValue) {
                      unFouce();
                      if (!createInfo()) {
                        return;
                      }
                      if (startTime == '') {
                        ToastUtil.showToast('请选择开播时间');
                        return;
                      }
                      setState(() {
                        isCheck = !isCheck;
                      });
                    },
                    activeColor: PublicColor.themeColor,
                  ),
                  // ),
                ),
              ),
              Expanded(
                flex: 4,
                child: new Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '创建预告',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '为您的直播添加一些悬念吧',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          color: Color(0xff8e8e8e),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$startTime',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                      color: Color(0xff8e8e8e),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff8e8e8e),
                    ),
                  ),
                ),
              )
            ]),
          ),
          onTap: () {
            unFouce();
            var date = DateTime.now();
            DatePicker.showDateTimePicker(context,
                showTitleActions: true,
                minTime: DateTime(
                    date.year, date.month, date.day, date.hour, date.minute),
                maxTime: DateTime(2050, 6, 7, 05, 09), onChanged: (date) {
              print('change $date in time zone ' +
                  date.timeZoneOffset.inHours.toString());
            }, onConfirm: (date) {
              print('confirm $date');
              var time = '$date';
              setState(() {
                startTime = time.split('.')[0];
              });
            }, locale: LocaleType.zh);
          },
        ));

    Widget moreSet = new Container(
      alignment: Alignment.center,
      child: new InkWell(
          child: Container(
              margin: EdgeInsets.only(top: 15),
              child: RichText(
                  text: TextSpan(
                      text: '更多设置>',
                      style: TextStyle(
                          color: Color(0xffe42239),
                          fontSize: ScreenUtil.instance.setWidth(26)),
                      children: <TextSpan>[
                    TextSpan(
                        text: '正式直播展示在直播列表',
                        style: TextStyle(
                            color: Color(0xff8e8e8e),
                            fontSize: ScreenUtil.instance.setWidth(24))),
                  ]))),
          onTap: () {
            print('更多设置');
            // print(isSet);
            setState(() {
              isSet = !isSet;
            });
          }),
    );

    Widget setArea = new Container(
      alignment: Alignment.center,
      child: Offstage(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          width: ScreenUtil().setWidth(700),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
          ),
          child: new Column(children: <Widget>[
            InkWell(
              child: new Container(
                height: ScreenUtil().setWidth(100),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      '直播设置',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        liveSet["name"],
                        style: TextStyle(
                          color: Color(0xffeb727d),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.navigate_next,
                        color: Color(0xff8e8e8e),
                      ),
                    ),
                  )
                ]),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FenleiWidget(
                      typeList: liveSetList,
                      selectId: liveSet['id'],
                      title: "直播设置",
                      onChanged: (item) {
                        setState(() {
                          liveSet = item;
                        });
                      },
                    );
                  },
                );
              },
            ),
            InkWell(
              child: new Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                ),
                height: ScreenUtil().setWidth(100),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30),
                  0,
                  ScreenUtil().setWidth(20),
                  0,
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Text(
                      '通知所有关注者',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Switch(
                        value: isNotice,
                        onChanged: (newValue) {
                          setState(() {
                            isNotice = newValue;
                          });
                          print(isNotice);
                        },
                        activeTrackColor: PublicColor.themeColor,
                        activeColor: PublicColor.themeColor,
                        inactiveThumbColor: Color(0xffd5d5d5),
                        inactiveTrackColor: Color(0xfff5f5f5),
                      ),
                    ),
                  ),
                ]),
              ),
              onTap: () {
                print('通知');
              },
            ),
            InkWell(
              child: new Container(
                height: ScreenUtil().setWidth(100),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30),
                  0,
                  ScreenUtil().setWidth(20),
                  0,
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Text(
                      '清晰度',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(def['name']),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.navigate_next,
                        color: Color(0xff8e8e8e),
                      ),
                    ),
                  )
                ]),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FenleiWidget(
                      typeList: defList,
                      selectId: def['id'],
                      title: "清晰度",
                      onChanged: (item) {
                        setState(() {
                          def = item;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ]),
        ),
        offstage: isSet,
      ),
    );

    // Widget
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: new Text(
              '创建直播',
              style: new TextStyle(color: PublicColor.headerTextColor),
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
                color: PublicColor.headerTextColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              InkWell(
                child: Container(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: new Icon(
                    Icons.error_outline,
                    color: PublicColor.headerTextColor,
                  ),
                ),
                onTap: () {
                  createRule();
                },
              )
            ],
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cover,
                goods,
                yugao,
                moreSet,
                setArea,
                BigButton(
                  name: isCheck ? '创建预告' : '创建直播',
                  tapFun: () {
                    _handleCameraAndMic();
                    if (isCheck) {
                      createNotice();
                    } else {
                      createLive();
                    }
                  },
                  top: ScreenUtil().setWidth(60),
                )
                // new SizedBox(height: ScreenUtil().setWidth(30)),
              ],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
        // _noticeWidget,
      ],
    );
  }

  Widget _shareWidget(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: new Container(
          width: ScreenUtil.instance.setWidth(710.0),
          height: ScreenUtil.instance.setWidth(880.0),
          padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(20),
            left: ScreenUtil().setWidth(20),
          ),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          child: new Column(children: [
            Container(
              alignment: Alignment.centerRight,
              height: ScreenUtil.instance.setWidth(60.0),
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
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
            Container(
              alignment: Alignment.center,
              child: Text(
                '创建规则',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              // child: Text(
              //   '$rule',
              //   style: TextStyle(
              //     fontSize: ScreenUtil().setSp(28),
              //     color: Color(0xff787878),
              //   ),
              // ),
               child: Html(data: rule),
            )
          ]),
        ),
      ),
    );
  }

  Widget _noticeWidget(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: new Container(
          width: ScreenUtil.instance.setWidth(710.0),
          height: ScreenUtil.instance.setWidth(880.0),
          padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(20),
            left: ScreenUtil().setWidth(20),
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          child: new Column(children: [
            Image.asset(
              "assets/zhibo/notice.png",
              width: ScreenUtil().setWidth(564.0),
            ),
            SizedBox(height: ScreenUtil().setWidth(80)),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: ScreenUtil().setWidth(350),
                height: ScreenUtil().setWidth(90),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(90))),
                alignment: Alignment.center,
                child: Text(
                  '我知道了',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28), color: Colors.white),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
