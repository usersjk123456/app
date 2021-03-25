import 'package:client/common/Global.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/dialog.dart';
import '../service/user_service.dart';
import '../widgets/cached_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBabyPage extends StatefulWidget {
  @override
  AddBabyPageState createState() => AddBabyPageState();
}

class AddBabyPageState extends State<AddBabyPage> {
  bool isLoading = false;
  String jwt = '', id = '', addressId = "";
  List list = [];
  @override
  void initState() {
    super.initState();
    getList();
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
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    UserServer().getbabyList(map, (success) async {
      setState(() {
        // isLoading = false;
        list = success['list'];
        // Global.isShow = success['display'] == 1 ? false : true;
      });
      print('变了吗');
      print(Global.isShow);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void deleteAddrss() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => addressId);
    UserServer().delAddress(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('删除成功');
      getList();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget deleDjango(context) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        deleteAddrss();
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: '确定删除该地址吗？',
    );
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

  List<SlideButton> lists;
  List<SlideButton> getSlides() {
    lists = List<SlideButton>();
    for (var i = 0; i < list.length; i++) {
      var key = GlobalKey<SlideButtonState>();
      var slide = SlideButton(
        key: key,
        singleButtonWidth: 80,
        onSlideStarted: () {
          lists.forEach((slide) {
            if (slide.key != key) {
              slide.key.currentState?.close();
            }
          });
        },
        child: InkWell(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            // 存值
            await prefs.setString('id', list[i]['id']);
            print('111111111111111111111');
            print(id = prefs.getString('id'));
            // await NavigatorUtils.goHomePage(context);
            await Future.delayed(Duration(seconds: 1), () {
              NavigatorUtils.goHomePage(context);
            });
          },
          child: Container(
            // margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(29),
            //     ScreenUtil().setWidth(19), ScreenUtil().setWidth(29), 0),
            padding: EdgeInsets.all(ScreenUtil().setWidth(29)),
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              // borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: <Widget>[
                list[i]['headimgurl'].length != 0
                    ? CachedImageView(
                        ScreenUtil().setWidth(101),
                        ScreenUtil().setWidth(101),
                        list[i]['headimgurl'],
                        null,
                        BorderRadius.all(
                            Radius.circular(ScreenUtil.instance.setWidth(100))),
                      )
                    : Image.asset(
                        "assets/foods/headImg.png",
                        height: ScreenUtil().setWidth(101),
                        width: ScreenUtil().setWidth(101),
                      ),
                SizedBox(
                  width: ScreenUtil().setWidth(20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      list[i]['nickname'],
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: ScreenUtil().setSp(30),
                      ),
                    ),
                    list[i]['week'] == null
                        ? Container()
                        : Row(
                            children: <Widget>[
                              Text(
                                '孕',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(26),
                                ),
                              ),
                              Text(
                                list[i]['week'].toString(),
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(26),
                                ),
                              ),
                              Text(
                                '周',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(26),
                                ),
                              ),
                              Text(
                                list[i]['day'].toString(),
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(26),
                                ),
                              ),
                              Text(
                                '天',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: ScreenUtil().setSp(26),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
        buttons: <Widget>[
          // list[i]['is_birth']=='0'?
          buildAction(key, "编辑", Colors.amber, () {
            key.currentState.close();
            addressId = list[i]['id'].toString();
            // print('add-->>>${addressList[i]}');
            var oid = list[i]['id'].toString();
            NavigatorUtils.goBabyPage(context, oid);
          })
        ],
      );
      lists.add(slide);
    }
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: new Text(
                '宝宝',
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
                  NavigatorUtils.goHomePage(context);
                },
              ),
              actions: <Widget>[
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.only(right: 14.0, top: 10.0),
                    child: Image.asset(
                      'assets/index/ic_tianjia.png',
                      width: ScreenUtil().setWidth(39),
                      height: ScreenUtil().setWidth(39),
                    ),
                  ),
                  onTap: () {
                    // sendPlant();
                    // NavigatorUtils.goBabyPage(context);
                    NavigatorUtils.gootherBabyPage(context);
                  },
                )
              ],
            ),
            body: new SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: getSlides(),
                ),
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
