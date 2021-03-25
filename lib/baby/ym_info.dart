import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import 'package:flutter/rendering.dart';
import '../config/fluro_convert_util.dart';
import '../common/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/user_service.dart';
import '../utils/toast_util.dart';
class YMInfoPage extends StatefulWidget {
  final String oid;
  final String title;
  final String desc;
  YMInfoPage({this.oid, this.title, this.desc});
  @override
  _YMInfoPageState createState() => _YMInfoPageState();
}

class _YMInfoPageState extends State<YMInfoPage>
    with SingleTickerProviderStateMixin {
  List guige = [];
  int buynum = 1;
  int checkindex = 0;
  String name = '', desc = '',id='';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getLocal();
    name = FluroConvertUtils.fluroCnParamsDecode(widget.title);
    // hinttext = FluroConvertUtils.fluroCnParamsDecode(widget.time);
    desc = FluroConvertUtils.fluroCnParamsDecode(widget.desc);
  }
  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
  }


  //修改
  void save() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id);
    map.putIfAbsent("vid", () => widget.oid); //疫苗id
    map.putIfAbsent("is_inoculation", () => 0); //是否接种
    map.putIfAbsent("is_del", () => 0); //没删除
    UserServer().getinoculationList(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('添加成功');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }


  int type = 0;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget inforArea = new Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        // height: ScreenUtil().setWidth(103),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
        child: new Column(children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            child: Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 15),
       
            child: Text(
              desc,
              style: TextStyle(
                color: Color(0xff999999),
                fontSize: ScreenUtil().setSp(28),
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
              '选择剂次',
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(20),
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
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
                  Text(
                    "第1至4剂",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 2,
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
                  Text(
                    "第2至4剂",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 3,
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
                  Text(
                    "第3至4剂",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 4,
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
                  Text(
                    "仅4剂",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]));

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
                  child: Container(
                    // padding: const EdgeInsets.only(right: 14.0, top: 15),
                    margin: EdgeInsets.only(
                      top: 15,
                      bottom: 15
                    ),
                    alignment: Alignment.center,
                    height: ScreenUtil().setWidth(46),
                    width: ScreenUtil().setWidth(96),
                    decoration: BoxDecoration(
                      color: PublicColor.themeColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      '完成',
                      style: new TextStyle(
                        color: Color(0xffffffff),
                        fontSize: ScreenUtil().setSp(30),
                      ),
                    ),
                  ),
                  onTap: () {
                  save();
                  },
                )
              ],
            ),
            body: new Container(
              alignment: Alignment.center,
              child: new ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  inforArea,
                  // ym,
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
