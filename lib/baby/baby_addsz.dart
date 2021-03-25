import 'package:client/widgets/abstract_text_input_formatter.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/config/fluro_convert_util.dart';

class AddSZPage extends StatefulWidget {
  final String title;
  final String old;
  final String weight;
  final String height;
  final String head;
  final String desc;
  AddSZPage({
    this.title,
    this.old,
    this.weight,
    this.height,
    this.head,
    this.desc,
  });
  @override
  AddSZPageState createState() => AddSZPageState();
}

class AddSZPageState extends State<AddSZPage> {
  bool isLoading = false;
  bool _value = false;
  bool isNot = false;
  String id = '', desc = '', title = '', descs = '';

  String jwt = '';

  TextEditingController oldcontroller = TextEditingController();
  TextEditingController heightcontroller = TextEditingController();
  TextEditingController weightcontroller = TextEditingController();
  TextEditingController headcontroller = TextEditingController();
  TextEditingController xtcontroller = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  final cardcontroller = TextEditingController();
  FocusNode _cardFocus = FocusNode();
  FocusNode _weightFocus = FocusNode();
  FocusNode _descFocus = FocusNode();
  FocusNode _headFocus = FocusNode();

  DateTime dateTime = DateTime.now();

  var now = new DateTime.now();

  @override
  void initState() {
    super.initState();
    // Map obj = FluroConvertUtils.string2map(widget.objs);

    print(descs);
    if (widget.old != 'null') {
      desc = FluroConvertUtils.fluroCnParamsDecode(widget.desc);
      descs = desc.split('"')[1];
      print('走没走');
      oldcontroller.text = widget.old;
      heightcontroller.text = widget.height;
      weightcontroller.text = widget.weight;
      headcontroller.text = widget.head;
      xtcontroller.text = descs;
    } else if (widget.old == 'null') {
      print('走了没');
      oldcontroller.text = '';
      heightcontroller.text = '';
      weightcontroller.text = '';
      headcontroller.text = '';
      xtcontroller.text = '';
    }

    getLocal();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    print(
        '1111111111111111111111111111111111111111111----------------------------------');
    print(id);
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
    if (oldcontroller.text == '') {
      ToastUtil.showToast('请输入宝宝年龄');
      return;
    }
    if (heightcontroller.text == '') {
      ToastUtil.showToast('请输入宝宝身高');
      return;
    }
    if (weightcontroller.text == '') {
      ToastUtil.showToast('请输入宝宝体重');
      return;
    }
    if (headcontroller.text == '') {
      ToastUtil.showToast('请输入宝宝头围');
      return;
    }
    if (xtcontroller.text == '') {
      ToastUtil.showToast('请输入宝宝形体描述');
      return;
    }

    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    if (id != "") {
      map.putIfAbsent("bid", () => id);
    }
    map.putIfAbsent("time", () => dateTime);
    map.putIfAbsent("age", () => oldcontroller.text);
    map.putIfAbsent("height", () => heightcontroller.text);
    map.putIfAbsent("weight", () => weightcontroller.text);
    map.putIfAbsent("circumference", () => headcontroller.text);
    map.putIfAbsent("desc", () => xtcontroller.text);

    UserServer().addGrowthRecord(map, id, (success) async {
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
    _weightFocus.unfocus();
    _headFocus.unfocus();
    _descFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget inforArea = new Container(
        alignment: Alignment.center,
        child: new Container(
          margin: EdgeInsets.only(top: 10),
          // height: ScreenUtil().setWidth(382),
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
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                child: new Row(children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          '日期',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(30),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 6,
                    child: Text(
                      dateTime.year.toString() +
                          '-' +
                          dateTime.month.toString() +
                          '-' +
                          dateTime.day.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(30),
                      ),
                    ),
                  )
                ]),
              ),
              Container(
                  height: ScreenUtil().setWidth(88),
                  width: ScreenUtil().setWidth(700),
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0,
                      ScreenUtil().setWidth(20), 0),
                  child: new Row(children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Text(
                            '宝宝年龄 ：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: new TextField(
                          controller: oldcontroller,
                          focusNode: _nameFocus,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                              hintText: '请输入年龄', border: InputBorder.none),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Text(
                          '岁',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    )
                  ])),
              Container(
                height: ScreenUtil().setWidth(88),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Text(
                            '宝宝身高 ：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: new TextField(
                          controller: heightcontroller,
                          focusNode: _cardFocus,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: new InputDecoration(
                              hintText: '请输入身高', border: InputBorder.none),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Text(
                          'cm',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().setWidth(88),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Text(
                            '体       重 ：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: new TextField(
                          controller: weightcontroller,
                          focusNode: _weightFocus,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: new InputDecoration(
                              hintText: '请输入体重', border: InputBorder.none),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Text(
                          'kg',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().setWidth(88),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Text(
                            '头       围 ：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: new TextField(
                          controller: headcontroller,
                          focusNode: _headFocus,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: new InputDecoration(
                              hintText: '请输入头围', border: InputBorder.none),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Text(
                          'cm',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().setWidth(88),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Text(
                            '形体描述 ：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: new TextField(
                          controller: xtcontroller,
                          focusNode: _descFocus,
                          keyboardType: TextInputType.name,
                          decoration: new InputDecoration(
                              hintText: '请输入描述', border: InputBorder.none,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().setWidth(150),
                width: ScreenUtil().setWidth(700),
              ),
            ],
          ),
        ));

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
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            '生长记录',
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
                    '保存',
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
                  new SizedBox(height: ScreenUtil().setWidth(21)),
                  inforArea,
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
