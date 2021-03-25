import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/cached_image.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';
import '../common/upload_to_oss.dart';
import '../config/Navigator_util.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../service/home_service.dart';

class BabyInfoPage extends StatefulWidget {
  final String type;
  final String oid;

  BabyInfoPage({this.type, this.oid});
  @override
  BabyInfoPageState createState() => BabyInfoPageState();
}

class BabyInfoPageState extends State<BabyInfoPage> {
  int groupValue = 0;
  int sex = 1;
  bool isLoading = false;
  bool _value = false;
  bool isNot = false;
  String id = '';
  String img1 = '';
  String hintText = '请输入宝宝的生日';
  String img2 = '';
  String jwt = '';
  String isDefault = '';
  final namecontroller = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  final cardcontroller = TextEditingController();
  FocusNode _cardFocus = FocusNode();
  @override
  void initState() {
    super.initState();

    // Map obj = FluroConvertUtils.string2map(widget.type);
    print(widget.type);
    print(widget.oid);
    // if (obj != null) {
    //   id = obj['id'];
    //   namecontroller.text = obj['real_name'];
    //   cardcontroller.text = obj['id_card'];
    //   img1 = obj['img1'];
    //   img2 = obj['img2'];
    //   _value = obj['is_default'] == "0" ? false : true;
    // }

    if (widget.oid != 'null') {
      getBaby();
    } else {
      namecontroller.text = '';
      hintText = '请输入宝宝的生日';
      img1 = '';
      //  sex
    }
  }

  void getBaby() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);
    HomeServer().getbaby(map, (success) async {
      setState(() {
        isLoading = false;

        namecontroller.text = success['data']['nickname'];
        img1 = success['data']['headimgurl'];
        sex = success['data']['is_parent'];
        hintText = DateTime.fromMillisecondsSinceEpoch(
                success['data']['birth_at'] * 1000)
            .toString()
            .split(' ')[0];
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
      ToastUtil.showToast('请输入宝宝小名');
      return;
    }
    if (hintText == '请输入宝宝的生日') {
      ToastUtil.showToast('请输入宝宝的生日');
      return;
    }
    // if (img1 == '') {
    //   ToastUtil.showToast('请上传宝宝正面照');
    //   return;
    // }
    if (sex == null) {
      ToastUtil.showToast('请选择和宝宝的关系');
      return;
    }

    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    if (id != "") {
      map.putIfAbsent("id", () => id);
    }
    map.putIfAbsent("nickname", () => namecontroller.text);
    map.putIfAbsent("birth_at", () => hintText);
    map.putIfAbsent("headimgurl", () => img1); //
    map.putIfAbsent("sex", () => widget.type);
    map.putIfAbsent("id", () => widget.oid);
    map.putIfAbsent("is_parent", () => sex);
    map.putIfAbsent("is_birth", () => 2);
    print(sex);
    print('111111111111111111111111111111111111111111');
    UserServer().babyInfo(map, id, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('保存成功');
      // NavigatorUtils.goHomePage(context);
      NavigatorUtils.addBaby(context);
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
          width: ScreenUtil().setWidth(750),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: new Column(
            children: <Widget>[
              Container(
                  height: ScreenUtil().setWidth(109),
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
                            '小名',
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
                              hintText: '请输入宝宝的小名', border: InputBorder.none),
                        ),
                      ),
                    )
                  ])),
              Container(
                height: ScreenUtil().setWidth(115),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            '生日',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 6,
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
                          hintText,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color(0xff999999),
                              fontSize: ScreenUtil().setSp(26)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));

    Widget uploadArea = new Container(
      alignment: Alignment.centerLeft,
      height: ScreenUtil().setWidth(66),
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
      child: Text(
        '你与宝宝的关系',
        style: TextStyle(
          color: Color(0xff666666),
          fontSize: ScreenUtil().setSp(26),
        ),
      ),
    );
    Widget appBar = new Container(
      color: Color(0xffffffff),
      height: ScreenUtil().setWidth(112),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: PublicColor.headerTextColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            '宝宝信息',
            style: new TextStyle(
                color: PublicColor.headerTextColor,
                fontSize: ScreenUtil().setSp(32)),
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
                    '完成',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(28),
                      // height: 2.7,
                    ),
                  )),
              onTap: () {
                save();
              },
            ),
          ),
        ],
      ),
    );

    Widget head = new Container(
      height: ScreenUtil().setWidth(279),
      width: ScreenUtil().setWidth(750),
      color: Color(0xffffffff),
      child: InkWell(
        child: Container(
          // margin: EdgeInsets.only(
          //   top: ScreenUtil().setWidth(58),
          // ),
          child: img1 != ''
              ? CachedImageView(
                  ScreenUtil.instance.setWidth(169),
                  ScreenUtil.instance.setWidth(169),
                  img1,
                  null,
                  BorderRadius.vertical(top: Radius.elliptical(0, 0)))
              : Image.asset(
                  "assets/login/ic_tian_touxiang.png",
                  height: ScreenUtil().setWidth(169),
                  width: ScreenUtil().setWidth(160),
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
    );

    Widget bottom = new Container(
      height: ScreenUtil().setWidth(115),
      color: Color(0xffffffff),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: 1,
            hoverColor: Color(0xFFFD8C34),
            activeColor: Color(0xFFFD8C34),
            focusColor: Color(0xFFFFFFFF),
            groupValue: this.sex,
            onChanged: (value) {
              setState(() {
                this.sex = value;
              });
            },
          ),
          Text("爸爸"),
          SizedBox(width: ScreenUtil().setWidth(120)),
          Radio(
            value: 2,
            hoverColor: Color(0xFFFD8C34),
            activeColor: Color(0xFFFD8C34),
            focusColor: Color(0xFFFFFFFF),
            groupValue: this.sex,
            onChanged: (value) {
              setState(() {
                this.sex = value;
              });
            },
          ),
          Text("妈妈"),
          SizedBox(width: ScreenUtil().setWidth(120)),
          Radio(
            value: 3,
            hoverColor: Color(0xFFFD8C34),
            activeColor: Color(0xFFFD8C34),
            focusColor: Color(0xFFFFFFFF),
            groupValue: this.sex,
            onChanged: (value) {
              setState(() {
                this.sex = value;
              });
            },
          ),
          Text("其他"),
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: new Container(
              alignment: Alignment.center,
              child: new ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appBar,

                  head,
                  new SizedBox(height: ScreenUtil().setWidth(21)),
                  inforArea,
                  new SizedBox(height: ScreenUtil().setWidth(21)),
                  uploadArea,
                  // btnArea,
                  bottom,
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
