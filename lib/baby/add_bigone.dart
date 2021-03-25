import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import 'package:client/api/api.dart';
import 'package:client/service/service.dart';

class AddBigOnePage extends StatefulWidget {
  final type;
  AddBigOnePage({this.type});
  @override
  AddBigOnePageState createState() => AddBigOnePageState();
}

class AddBigOnePageState extends State<AddBigOnePage> {
  final controller = TextEditingController();
  bool isLoading = false;
  String jwt = '', addressId = "";
  List addressList = [];
  String beginTime = '';
  List textarr = [];
  DateTime beginDate;
  String endTime = '';
  DateTime endDate;
  bool ischeck = true;
  String textsend = '';
  String gotext = '';
  List textList = [];
  @override
  void initState() {
    super.initState();
    getLocal();
    getbq();
  }

  // @override
  // void deactivate() {
  //   //刷新页面
  //   super.deactivate();
  //   var bool = ModalRoute.of(context).isCurrent;
  //   if (bool) {
  //   }
  // }

  void getLocal() async {
    setState(() {
      textarr = [];
    });
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('textarr') == null) {
      return;
    }
    if (prefs.getString('textarr') == '') {
      return;
    }
    setState(() {
      textarr = prefs.getString('textarr').split(',');
    });
  }

  void getbq() {
    Map<String, dynamic> map = Map();

    Service().getData(map, Api.GET_LABEL_URL, (success) async {
      print(success['list']);
      print('~~~~~~~~~~~~~');
      for (var i = 0; i < success['list'].length; i++) {
        setState(() {
          textList.add(success['list'][i]['title']);
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  InkWell buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        color: color,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }

  var wdlist = [
    {
      'type': '未出生',
    },
    {
      'type': '1月龄',
    },
    {
      'type': '2月龄',
    },
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    // Widget leftItemHeader(item, int index) {
    //   return Container(
    //       width: double.infinity,
    //       height: ScreenUtil.instance.setWidth(100),
    //       alignment: Alignment.center,
    //       child: Text(
    //           item['type'],
    //           TextStyle(
    //               fontSize: ScreenUtil.instance.setWidth(26),
    //               color: Colors.black54)),

    //   );
    // }
    bqView(item) {
      List<Widget> list = [];

      for (var i = 0; i < item.length; i++) {
        list.add(
          Container(
            // width: ScreenUtil().setWidth(96),
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
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(40),
                        right: ScreenUtil().setWidth(40),
                      ),
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
                  ],
                ),
                onTap: () {
                  controller.text = item[i];
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length));
                  // save();
                }),
          ),
        );
      }
      return list;
    }

    Widget bqContainer = Container(
      child: Wrap(
        // direction: Axis.horizontal,
        runSpacing: ScreenUtil.instance.setWidth(10.0),
        spacing: ScreenUtil.instance.setWidth(100),
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
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            '大事记',
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
                    '下一步',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(28),
                      // height: 2.7,
                    ),
                  )),
              onTap: () async {
                // save();
                if (ischeck) {
                  textsend = '第一次' + controller.text;
                } else {
                  textsend = controller.text;
                }

                final prefs = await SharedPreferences.getInstance();
                textarr.add(textsend);
                prefs.setString('textarr', textarr.join(','));
                gotext = prefs.getString('textarr');
                // return;
                if (widget.type == 'bj') {
                  Navigator.pop(context, "ok");
                } else {
                  NavigatorUtils.goAddBigtwoPage(context).then((result) {
                    // getLocal();
                    getLocal();
                    print('下边');
                    if (result == 'back') {
                      Navigator.pop(context);
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
    Widget inforArea = new Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: ScreenUtil().setWidth(40),
              ),
              ischeck
                  ? InkWell(
                      child: Image.asset(
                        'assets/index/ic_xuan.png',
                        width: ScreenUtil().setWidth(29),
                        height: ScreenUtil().setWidth(29),
                      ),
                      onTap: () {
                        setState(() {
                          ischeck = false;
                        });
                      },
                    )
                  : InkWell(
                      child: Container(
                        width: ScreenUtil().setWidth(29),
                        height: ScreenUtil().setWidth(29),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: PublicColor.themeColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          ischeck = true;
                        });
                      },
                    ),
              SizedBox(
                width: ScreenUtil().setWidth(18),
              ),
              Text(
                '第一次',
                style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setWidth(27),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: ScreenUtil().setWidth(639),
            alignment: Alignment.center,
            height: 60.0,
            decoration: new BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: new BorderRadius.circular(12.0)),
            child: new TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(110),
          ),
          // Container(
          //   width: ScreenUtil().setWidth(200),
          //   padding: EdgeInsets.only(
          //     left: ScreenUtil().setWidth(40),
          //     right: ScreenUtil().setWidth(40),
          //   ),
          //   child: ,
          // ),
          bqContainer
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
