import '../widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/cached_image.dart';
import '../widgets/dialog.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';
import '../config/fluro_convert_util.dart';
// import '../common/upload_to_oss.dart';
import '../common/upload_to_oss.dart';

class RealDetailPage extends StatefulWidget {
  final String objs;
  RealDetailPage(this.objs);
  @override
  RealDetailPageState createState() => RealDetailPageState();
}

class RealDetailPageState extends State<RealDetailPage> {
  bool isLoading = false;
  bool _value = false;
  bool isNot = false;
  String id = '';
  String img1 = '';
  String img2 = '';
  String jwt = '';
  String isDefault = '';
  String ischeck = '';
  final namecontroller = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  final cardcontroller = TextEditingController();
  FocusNode _cardFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    Map obj = FluroConvertUtils.string2map(widget.objs);
    print('oooooooooooooooooooooooooooooooooo------>$obj');
    if (obj != null) {
      id = obj['id'];
      namecontroller.text = obj['real_name'];
      cardcontroller.text = obj['id_card'];
      img1 = obj['img1'];
      img2 = obj['img2'];
      ischeck = obj['is_check'];
      _value = obj['is_default'] == "0" ? false : true;
    }
  }

  @override
  void dispose() {
    super.dispose();
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

  void save() async {
    if (namecontroller.text == '') {
      ToastUtil.showToast('请输入姓名');
      return;
    }
    if (cardcontroller.text == '') {
      ToastUtil.showToast('请输入身份证号');
      return;
    }
    if (img1 == '') {
      ToastUtil.showToast('请上传身份证正面照');
      return;
    }
    if (img2 == '') {
      ToastUtil.showToast('请上传身份证背面照');
      return;
    }

    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    if (id != "") {
      map.putIfAbsent("id", () => id);
    }
    map.putIfAbsent("real_name", () => namecontroller.text);
    map.putIfAbsent("id_card", () => cardcontroller.text);
    map.putIfAbsent("img1", () => img1);
    map.putIfAbsent("img2", () => img2);
    map.putIfAbsent("is_default", () => _value ? '1' : '0');

    UserServer().addRealname(map, id, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('保存成功');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  //删除
  void deteleApi() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    UserServer().delRealname(map, id, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('删除成功');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void unFouce() {
    _nameFocus.unfocus();
    _cardFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget inforArea = new Container(
        alignment: Alignment.center,
        child: new Container(
          margin: EdgeInsets.only(top: 10),
          height: ScreenUtil().setWidth(382),
          width: ScreenUtil().setWidth(700),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: PublicColor.lineColor, width: 1),
          ),
          child: new Column(
            children: <Widget>[
              Container(
                  height: ScreenUtil().setWidth(88),
                  width: ScreenUtil().setWidth(700),
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(50), 0,
                      ScreenUtil().setWidth(20), 0),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: PublicColor.lineColor)),
                  ),
                  child: new Row(children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            '个人信息',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                  ])),
              Container(
                  height: ScreenUtil().setWidth(88),
                  width: ScreenUtil().setWidth(700),
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0,
                      ScreenUtil().setWidth(20), 0),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: PublicColor.lineColor)),
                  ),
                  child: new Row(children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            '姓名',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: new TextField(
                          controller: namecontroller,
                          focusNode: _nameFocus,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                              hintText: '请输入姓名', border: InputBorder.none),
                        ),
                      ),
                    )
                  ])),
              Container(
                height: ScreenUtil().setWidth(88),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: PublicColor.lineColor)),
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            '身份证号',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 7,
                      child: Container(
                        child: new TextField(
                          controller: cardcontroller,
                          focusNode: _cardFocus,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                              hintText: '请填写正确身份证号(将加密保存)',
                              border: InputBorder.none),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0,
                      ScreenUtil().setWidth(0), 0),
                  child: new Row(children: <Widget>[
                    Container(
                      child: Text(
                        '设置为默认实名人',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28),
                            height: 2.6),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        '(每次下单时默认使用)',
                        style: TextStyle(
                            color: Color(0xffc7c7c7),
                            fontSize: ScreenUtil().setSp(28),
                            height: 2.6),
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setWidth(62),
                      margin: EdgeInsets.only(top: 15),
                      alignment: Alignment.centerRight,
                      child: new Row(
                        children: <Widget>[
                          Switch(
                            value: _value,
                            onChanged: (newValue) {
                              setState(() {
                                _value = newValue;
                              });
                            },
                            activeTrackColor: PublicColor.themeColor,
                            activeColor: PublicColor.themeColor,
                            inactiveThumbColor: Color(0xffd5d5d5),
                            inactiveTrackColor: Color(0xfff5f5f5),
                          ),
                        ],
                      ),
                    )
                  ]))
            ],
          ),
        ));

    Widget uploadArea = new Container(
      alignment: Alignment.center,
      child: new Container(
        margin: EdgeInsets.only(top: 10),
        // height: ScreenUtil().setWidth(780),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: PublicColor.lineColor, width: 1),
        ),
        child: new Column(children: <Widget>[
          Container(
            height: ScreenUtil().setWidth(88),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(50), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      '上传身份证正反面照片',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ]),
          ),
          Container(
            //  height: ScreenUtil().setWidth(120),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(50), 5, ScreenUtil().setWidth(20), 5),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: Text(
              '橙子宝宝直播温馨提示:请上传原始比例身份证正反面,请勿裁剪体改，保证身份证清晰显示,否则无法通过审核',
              style: TextStyle(
                color: Color(0xff787878),
                fontSize: ScreenUtil().setSp(24),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 5, ScreenUtil().setWidth(20), 0),
            child: Text(
              '请拍摄并上传身份证',
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(250),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            child: new Row(children: <Widget>[
              InkWell(
                child: Container(
                  child: img1 != ''
                      ? CachedImageView(
                          ScreenUtil.instance.setWidth(314),
                          ScreenUtil.instance.setWidth(200),
                          img1,
                          null,
                          BorderRadius.vertical(top: Radius.elliptical(0, 0)))
                      : Image.asset(
                          "assets/mine/zhengmian.png",
                          height: ScreenUtil().setWidth(200),
                          width: ScreenUtil().setWidth(314),
                          fit: BoxFit.cover,
                        ),
                ),
                onTap: () async {
                  print('上传正面');
                  unFouce();
                  Map obj = await openGallery("image", changeLoading);
                  if (obj == null) {
                    changeLoading(type: 2, sent: 0, total: 0);
                    return;
                  }
                  if (obj['errcode'] == 0) {
                    img1 = obj['url'];
                  } else {
                    ToastUtil.showToast(obj['msg']);
                  }
                },
              ),
              InkWell(
                child: Container(
                  child: img2 != ''
                      ? CachedImageView(
                          ScreenUtil.instance.setWidth(314),
                          ScreenUtil.instance.setWidth(200),
                          img2,
                          null,
                          BorderRadius.vertical(top: Radius.elliptical(0, 0)))
                      : Image.asset(
                          "assets/mine/fanmian.png",
                          height: ScreenUtil().setWidth(200),
                          width: ScreenUtil().setWidth(314),
                          fit: BoxFit.cover,
                        ),
                ),
                onTap: () async {
                  print('点击啊啊啊啊啊======');
                  unFouce();
                  Map obj = await openGallery("image", changeLoading);
                  print('obj=======');
                  print(obj);
                  if (obj == null) {
                    changeLoading(type: 2, sent: 0, total: 0);
                    return;
                  }
                  if (obj['errcode'] == 0) {
                    img2 = obj['url'];
                  } else {
                    ToastUtil.showToast(obj['msg']);
                  }
                },
              )
            ]),
          ),
          Container(
            height: ScreenUtil().setWidth(70),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(40), 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      '点击上传正面',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Color(0xff7b7b7b),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '点击上传反面',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Color(0xff7b7b7b),
                      ),
                    ),
                  )
                ]),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(50), 10, ScreenUtil().setWidth(10), 5),
            child: Text(
              '为什么要上传身份信息？',
              style: TextStyle(
                color: Color(0xff787878),
                fontSize: ScreenUtil().setSp(24),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(50), 10, ScreenUtil().setWidth(20), 5),
            child: Text(
              '订单中包含海外商品，海关要求必须提供真实姓名和身份证号进行实名认证，且实名认证与支付人必须一致，错误信息可能导致无法清关，平台保证您的信息安全，绝不对外泄露！',
              maxLines: 4,
              style: TextStyle(
                color: Color(0xff787878),
                fontSize: ScreenUtil().setSp(24),
              ),
            ),
          ),
        ]),
      ),
    );

    Widget btnArea = new Container(
      alignment: Alignment.center,
      child: BigButton(
        name: id != '' ? '修改' : '保存',
        tapFun: () {
          print('修改');
          save();
        },
        top: ScreenUtil().setWidth(40),
      ),
    );
    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: new Text(
                '实名认证详情',
                style: new TextStyle(color: PublicColor.headerTextColor),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: PublicColor.linearHeader,
                ),
              ),
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
                id != '' && ischeck != '1'
                    ? InkWell(
                        child: Container(
                            padding: const EdgeInsets.only(right: 14.0, top: 5),
                            child: Text(
                              '删除',
                              style: new TextStyle(
                                color: PublicColor.headerTextColor,
                                fontSize: ScreenUtil().setSp(28),
                                height: 2.7,
                              ),
                            )),
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return MyDialog(
                                    width: ScreenUtil.instance.setWidth(600.0),
                                    height: ScreenUtil.instance.setWidth(300.0),
                                    queding: () {
                                      print('确定');
                                      Navigator.of(context).pop();
                                      deteleApi();
                                    },
                                    quxiao: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: '温馨提示',
                                    message: '确定删除该条实名认证吗？');
                              });
                        },
                      )
                    : Container()
              ],
            ),
            body: new Container(
              alignment: Alignment.center,
              child: new ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  inforArea,
                  uploadArea,
                  ischeck != '1' ? btnArea : Container(),
                  new SizedBox(height: ScreenUtil().setWidth(40)),
                ],
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
