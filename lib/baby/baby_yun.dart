import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../service/user_service.dart';
import '../widgets/cached_image.dart';
import '../widgets/search_card.dart';
import '../common/upload_to_oss.dart';

class YunPage extends StatefulWidget {
  final String id;
  YunPage({this.id});
  @override
  YunPageState createState() => YunPageState();
}

class YunPageState extends State<YunPage> {
  bool isLoading = false;
  String jwt = '', addressId = "", id = '', all = '', thumb = '', day = '';
  List addressList = [], wdlist = [], img1 = [], img2 = [];
  String mainImg = '';
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  final FocusNode _focus = new FocusNode();
  @override
  void initState() {
    getLocal();
    super.initState();
    getList();
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

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    print(
        '1111111111111111111111111111111111111111111----------------------------------');
    print(id);
  }

  void createShop() {
    setState(() {
      isLoading = true;
    });
    var now = new DateTime.now();

    Map<String, dynamic> map = Map();
    map.putIfAbsent("imgurl", () => mainImg);
    map.putIfAbsent("time", () => now.toString().split(' ')[0]);
    UserServer().addalbum(map, (success) async {
      setState(() {
        isLoading = false;
      });
      NavigatorUtils.toAllPhoto(context).then((res) => getList());
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void _onFocusChange() {}
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
    UserServer().getyunList(map, (success) async {
      setState(() {
        all = success['all'].toString();
        day = success['day'].toString();
      });
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

  @override
  Widget build(BuildContext context) {
    _focus.addListener(_onFocusChange);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget getSlides = new InkWell(
      child: Container(
        width: ScreenUtil.instance.setWidth(195.0),
        height: ScreenUtil.instance.setWidth(66.0),
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(150),
        ),
        decoration: BoxDecoration(
            color: PublicColor.themeColor,
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            )),
        alignment: Alignment.center,
        child: Text('开始导入',
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.instance.setWidth(28.0))),
      ),
      onTap: () async {
        // sendPlant();
        Map obj = await openGallery("image", changeLoading);
        if (obj == null) {
          changeLoading(type: 2, sent: 0, total: 0);
          return;
        }
        if (obj['errcode'] == 0) {
          mainImg = obj['url'];
          createShop();
        } else {
          ToastUtil.showToast(obj['msg']);
        }
      },
    );
    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: new Text(
                '云相册',
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
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Image.asset(
                      'assets/index/ic_tianjia.png',
                      width: ScreenUtil().setWidth(39),
                      height: ScreenUtil().setWidth(39),
                    ),
                  ),
                  onTap: () async {
                    // sendPlant();
                    Map obj = await openGallery("image", changeLoading);
                    if (obj == null) {
                      changeLoading(type: 2, sent: 0, total: 0);
                      return;
                    }
                    if (obj['errcode'] == 0) {
                      mainImg = obj['url'];
                      createShop();
                    } else {
                      ToastUtil.showToast(obj['msg']);
                    }
                  },
                )
              ],
            ),
            body: all == '0'
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/index/shangc.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: getSlides)
                : Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            right: ScreenUtil().setWidth(20)),
                        child: SearchCardWidget(
                          elevation: 0,
                          hintText: '点击搜索',
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            NavigatorUtils.goYunSearchPage(context);
                          },
                          textEditingController: _keywordTextEditingController,
                          focusNode: _focus,
                        ),
                      ),
                      // list(),
                      Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(29),
                                  ScreenUtil().setWidth(19),
                                  ScreenUtil().setWidth(29),
                                  0),
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(29)),
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(130),
                                    height: ScreenUtil().setWidth(155),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/index/photo.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(480),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '最近上传',
                                              style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                              ),
                                            ),
                                            Text(
                                              '共' + day + '张照片',
                                              style: TextStyle(
                                                color: Color(0xff666666),
                                                fontSize:
                                                    ScreenUtil().setSp(26),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          color: Color(0xffC0C0C0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              NavigatorUtils.toTimePhoto(context);
                            },
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(29),
                                  ScreenUtil().setWidth(19),
                                  ScreenUtil().setWidth(29),
                                  0),
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(29)),
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(130),
                                    height: ScreenUtil().setWidth(155),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/index/photo.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(480),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '所有照片',
                                              style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                              ),
                                            ),
                                            Text(
                                              '共' + all + '张照片',
                                              style: TextStyle(
                                                color: Color(0xff666666),
                                                fontSize:
                                                    ScreenUtil().setSp(26),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          color: Color(0xffC0C0C0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              NavigatorUtils.toAllPhoto(context)
                                  .then((res) => getList());
                            },
                          ),
                        ],
                      ),
                    ],
                    //             Expanded(
                    //   flex: 1,
                    //   child:
                    // ),
                  ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
