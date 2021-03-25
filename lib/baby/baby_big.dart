import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/cached_image.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:client/api/api.dart';
import 'package:client/service/service.dart';

class BigPage extends StatefulWidget {
  @override
  BigPageState createState() => BigPageState();
}

class BigPageState extends State<BigPage> {
  bool isLoading = false;
  String jwt = '', addressId = "";
  List listView = [];
  String id = '';
  String beginTime = '';
  int _page = 0;
  DateTime beginDate;
  String endTime = '';
  DateTime endDate;
  @override
  void initState() {
    getLocal();
    super.initState();

    getList();
  }

  EasyRefreshController _controller = EasyRefreshController();
  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    print(
        '1111111111111111111111111111111111111111111----------------------------------');
    print(id);
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
    }
  }

  void getList() async {
    // _page++;
    // if (_page == 1) {
    //   setState(() {
    //     listView = [];
    //   });
    // }

    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id = prefs.getString('id'));
    // map.putIfAbsent("limit", () => 10);
    // map.putIfAbsent("page", () => _page);
    Service().getData(map, Api.GET_BABY_LIST_URL, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          setState(() {
            listView = success['list'];
          });
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              setState(() {
                listView.insert(listView.length, success['list'][i]);
              });
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
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

    //

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: new Text(
                  '大事记',
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
                      padding: const EdgeInsets.only(right: 14.0, top: 15),
                      child: Text(
                        '添加',
                        style: new TextStyle(
                          color: PublicColor.headerTextColor,
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ),
                    ),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('textarr');
                      NavigatorUtils.goAddBigonePage(context).then((res) {
                        setState(() {
                          listView = [];
                        });
                        getList();
                      });
                    },
                  )
                ],
              ),
              body: ListView.builder(
                itemCount: listView.length,
                padding: EdgeInsets.only(top: 20),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: ScreenUtil.instance.setWidth(750),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(40),
                      right: ScreenUtil().setWidth(28),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: ScreenUtil.instance.setWidth(20),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(11),
                                ),
                                width: ScreenUtil().setWidth(28),
                                height: ScreenUtil().setWidth(28),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        width: 3,
                                        color: PublicColor.themeColor)),
                              ),
                              SizedBox(
                                  height: ScreenUtil.instance.setWidth(20)),
                              Container(
                                height: ScreenUtil().setWidth(250),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: ScreenUtil().setWidth(2),
                                        color: Color(0xffDEDDDD))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setWidth(290),
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(604),
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(1)),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${listView[index]['age']}',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: ScreenUtil().setSp(30)),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(32),
                              ),
                              InkWell(
                                child: Container(
                                  width: ScreenUtil().setWidth(604),
                                  height: ScreenUtil().setWidth(201),
                                  padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(23),
                                    bottom: ScreenUtil().setWidth(23),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(23),
                                          ),
                                          child: Text(
                                            '${listView[index]['title']}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xff333333),
                                              fontSize: ScreenUtil().setSp(32),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        // child: Image.asset(
                                        //   'assets/login/share_logo.png',
                                        //   width: ScreenUtil().setWidth(155),
                                        //   height: ScreenUtil().setWidth(155),
                                        // )
                                        child: CachedImageView(
                                            ScreenUtil.instance.setWidth(155.0),
                                            ScreenUtil.instance.setWidth(155.0),
                                            listView[index]['img'],
                                            null,
                                            BorderRadius.all(
                                                Radius.circular(0))),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  NavigatorUtils.toaffair(context,
                                          listView[index]['id'].toString())
                                      .then((result) {
                                    setState(() {
                                      listView = [];
                                      _page = 0;
                                    });
                                    getList();
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              )),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
