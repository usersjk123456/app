
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';
import '../config/fluro_convert_util.dart';
// import '../common/upload_to_oss.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class YMXiangQingPage extends StatefulWidget {
  final String oid;
  final String name;
  final String time;
  final String desc;
  YMXiangQingPage({this.oid, this.name, this.time, this.desc});
  @override
  YMXiangQingPageState createState() => YMXiangQingPageState();
}

class YMXiangQingPageState extends State<YMXiangQingPage> {
  String beginTime = '';
  DateTime beginDate;
  String endTime = '';
  DateTime endDate;
  bool isLoading = false;
  bool _value = false;
  bool isNot = false;
  String id = '';
  String img1 = '';
  int type = 1;
  String img2 = '';
  String jwt = '', name = '', hinttext = '请选择', desc = '';
  String isDefault = '';
  final namecontroller = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  final cardcontroller = TextEditingController();
  FocusNode _cardFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    getLocal();
    name = FluroConvertUtils.fluroCnParamsDecode(widget.name);
    // hinttext = FluroConvertUtils.fluroCnParamsDecode(widget.time);
    desc = FluroConvertUtils.fluroCnParamsDecode(widget.desc);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
  }

  //修改
  void extApi() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id);
    map.putIfAbsent("vid", () => widget.oid); //疫苗id
    map.putIfAbsent("is_inoculation", () => type); //是否接种
    map.putIfAbsent("create_at", () => hinttext); //接种时间
    map.putIfAbsent("is_del", () => 0); //没删除
    UserServer().getinoculationList(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('修改成功');
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
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id);
    map.putIfAbsent("vid", () => widget.oid); //疫苗id
    map.putIfAbsent("is_inoculation", () => type); //是否接种
    map.putIfAbsent("is_del", () => 1); //删除
    UserServer().getinoculationList(map, (success) async {
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
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: ScreenUtil().setWidth(103),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
        child: new Row(children: <Widget>[
          Expanded(
              flex: 3,
              child: Container(
                child: Text(
                  '接种状态',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              )),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: 0,
                  hoverColor: Color(0xFFFD8C34),
                  activeColor: Color(0xFFFD8C34),
                  focusColor: Color(0xFFFFFFFF),
                  groupValue: this.type,
                  onChanged: (value) {
                    setState(() {
                      this.type = value;
                    });
                  },
                ),
                Text("未接种"),
                // SizedBox(width: ScreenUtil().setWidth(140)),
                Radio(
                  value: 1,
                  hoverColor: Color(0xFFFD8C34),
                  activeColor: Color(0xFFFD8C34),
                  focusColor: Color(0xFFFFFFFF),
                  groupValue: this.type,
                  onChanged: (value) {
                    setState(() {
                      this.type = value;
                    });
                  },
                ),
                Text("已接种"),
              ],
            ),
          )
        ]));

    Widget uploadArea = new Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: ScreenUtil().setWidth(103),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
        child: new Row(children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                child: Text(
                  '接种日期',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              )),
          Expanded(
            flex: 7,
            child: InkWell(
              onTap: () {
                // var date = DateTime.now();
                // DatePicker.showDateTimePicker(context,
                //     showTitleActions: true,
                //     minTime: DateTime(date.year, date.month, date.day,
                //         date.hour, date.minute),
                //     maxTime: endTime == ''
                //         ? DateTime(2050, 6, 7, 05, 09)
                //         : endDate, onChanged: (date) {
                //   print('change $date in time zone ' +
                //       date.timeZoneOffset.inHours.toString());
                // }, onConfirm: (date) {
                //   setState(() {
                //     beginTime = date.toString().split('.')[0];
                //     beginDate = DateTime(date.year, date.month, date.day,
                //         date.hour, date.minute);
                //   });
                // }, locale: LocaleType.zh);

                DatePicker.showDatePicker(context,
                    // 是否展示顶部操作按钮
                    showTitleActions: true,
                    // 最小时间
                    minTime: DateTime(2018, 3, 5),
                    // 最大时间
                    maxTime: DateTime(2999, 6, 7),
                    // change事件
                    onChanged: (date) {
                  setState(() {
                    hinttext = date.toString().split(' ')[0];
                  });
                },
                    // 确定事件
                    onConfirm: (date) {
                  print('confirm $date');
                  setState(() {
                    hinttext = date.toString().split(' ')[0];
                  });
                },
                    // 当前时间
                    currentTime: DateTime.now(),
                    // 语言
                    locale: LocaleType.zh);
              },
              child: Container(
                alignment: Alignment.centerRight,
                child: beginTime == ''
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            hinttext,
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(28)),
                          ),
                          Icon(Icons.navigate_next)
                        ],
                      )
                    : Text(
                        beginTime,
                      ),
              ),
            ),
          ),
        ]));

// 疫苗介绍
    Widget ym = new Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        child: new Column(children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '疫苗介绍',
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(20),
          ),
          Container(
            child: Text(
              desc,
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: ScreenUtil().setSp(26),
              ),
            ),
          )
        ]));

    Widget btnArea = new InkWell(
        onTap: () {
          deteleApi();
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(700),
          height: ScreenUtil().setWidth(90),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            '删除记录',
            style: TextStyle(
                color: PublicColor.themeColor,
                fontSize: ScreenUtil().setSp(30)),
          ),
        ));

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: new Text(
                name,
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
                InkWell(
                  onTap: () {
                    extApi();
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
                      '保存修改',
                      style: new TextStyle(
                        color: PublicColor.textColor,
                        fontSize: ScreenUtil().setSp(28),
                        // height: 2.7,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: new Container(
              alignment: Alignment.center,
              child: new ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  inforArea,
                  uploadArea,
                  ym,
                  btnArea,
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
