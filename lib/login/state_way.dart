import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';
import '../config/Navigator_util.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class WayPage extends StatefulWidget {
  @override
  WayPageState createState() => WayPageState();
}

class WayPageState extends State<WayPage> {
  int groupValue = 0;
  int sex = 1;
  bool isLoading = false;
  bool _value = false;
  bool isNot = false;
  String id = '';
  String hintText = '请选择预产期';
  String jwt = '';
  int yunday;
  int liday;
  int endTime;
  DateTime endDate;

  @override
  void initState() {
    super.initState();

    // if (obj != null) {
    //   id = obj['id'];
    //   namecontroller.text = obj['real_name'];
    //   cardcontroller.text = obj['id_card'];
    //   img1 = obj['img1'];
    //   img2 = obj['img2'];
    //   _value = obj['is_default'] == "0" ? false : true;
    // }
  }

  //设置默认显示的日期为当前
  DateTime initialDate = DateTime.now();

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

    map.putIfAbsent("birth_at", () => hintText);
    map.putIfAbsent("is_parent", () => sex);

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
                  height: ScreenUtil().setWidth(112),
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
                            '预产期',
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
                              hintText = date.toString().split(' ')[0];
                            });
                          },
                              // 确定事件
                              onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              hintText = date.toString().split(' ')[0];
                              print(date.millisecondsSinceEpoch);
                              endTime = //怀孕的日期
                                  date.millisecondsSinceEpoch - 24192000000;
                              print(endTime); //怀孕的时间戳
                              var one =
                                  DateTime.fromMillisecondsSinceEpoch(endTime);
                              print(one); //怀孕的日期

                              var today = DateTime.now(); //获取今日时间
                              print(today.difference(one)); //距离现在怀孕了多少小时
                              var hour = today.difference(one);
                              var hours = hour.toString().split(':')[0];
                              var day = int.parse(hours);
                              var dats = day / 24;
                              var math = dats.round();
                              yunday = math;
                              liday = 280 - yunday;
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
                              color: Color(0xff666666),
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      ),
                    ),
                    yunday == null
                        ? Container()
                        : Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: new Text(
                                    '孕' + yunday.toString() + '天',
                                  ),
                                ),
                                Container(
                                  child: new Text(
                                    '离预产期' + liday.toString() + '天',
                                  ),
                                ),
                              ],
                            ),
                          )
                  ])),
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
                if (yunday == null) {
                  ToastUtil.showToast('请输入预产期');
                  return;
                }
                save();
                // NavigatorUtils.goHomePage(context);
              },
            ),
          ),
        ],
      ),
    );
    Widget jisuan = new Container(
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Image.asset(
              'assets/login/ic_riqi.png',
              width: ScreenUtil().setWidth(28),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            Text(
              '计算预产期',
              style: TextStyle(fontSize: ScreenUtil().setSp(28)),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(34),
            ),
          ],
        ),
        onTap: () {
          // endTime=-hintText
        },
      ),
    );

    Widget bottom = new Container(
      height: ScreenUtil().setWidth(115),
      color: Color(0xffffffff),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
          Text("妈妈"),
          SizedBox(width: ScreenUtil().setWidth(140)),
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
          Text("爸爸"),
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
                  new SizedBox(height: ScreenUtil().setWidth(21)),
                  jisuan,
                  uploadArea,
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
