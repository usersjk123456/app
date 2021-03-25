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
import '../widgets/search_card.dart';

class MineFensiPage extends StatefulWidget {
  @override
  MineFensiPageState createState() => MineFensiPageState();
}

class MineFensiPageState extends State<MineFensiPage> {
  bool isLoading = false;
  String jwt = '', addressId = '';
   String fans = '';

  List addressList = [],fansList = [];
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  final FocusNode _focus = new FocusNode();
  @override
  void initState() {
    super.initState();
       getfans();
    getList();
  }

  void _onFocusChange() {}
  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
       getfans();
    }
  }

  void getfans() async {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    UserServer().getfansList(map, (success) async {
      setState(() {
        fansList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }
  void getList() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          fans = success['fans'].toString();
        });
      }
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


  Widget middle = new Container(
    height: ScreenUtil().setWidth(93),
    width: ScreenUtil().setWidth(750),
    color: Color(0xffffffff),
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: ScreenUtil().setWidth(28),
        ),
        Container(
          height: ScreenUtil().setWidth(29),
          width: ScreenUtil().setWidth(5),
          color: PublicColor.themeColor,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(12),
        ),
        Text(
          '全部粉丝',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(30),
            color: Color(0xff333333),
          ),
        ),
      ],
    ),
  );


  Widget getSlides() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (fansList.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in fansList) {
        arr.add(
          Container(
            height: ScreenUtil().setHeight(226),
            decoration: BoxDecoration(
                color: Color(0xffffffff),
                border: Border(
                    bottom: BorderSide(
                        width: ScreenUtil().setWidth(1),
                        color: Color(0xffE5E5E5)))),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(24),
                left: ScreenUtil().setWidth(26),
                bottom: ScreenUtil().setWidth(24)),
            child: InkWell(
              onTap: () {
                print(item);
                String oid = (item['id']).toString();
                NavigatorUtils.gobabyXiangqing(context);
              },
              //设置圆角
              child: Row(children: [
                Container(
                  child: CachedImageView(
                    ScreenUtil.instance.setWidth(219.0),
                    ScreenUtil.instance.setWidth(219.0),
                    item['user']['headimgurl'],
                    null,
                    BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(29),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: ScreenUtil().setWidth(250),
                              child:  Text(
                             item['user']['nickname'],
                                      overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: ScreenUtil().setSp(32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ),
                          // Container(
                          //     width: ScreenUtil().setWidth(250),
                          //     child: Text(
                          //       item['desc'],
                          //       overflow: TextOverflow.ellipsis,
                          //       style: TextStyle(
                          //         color: Color(0xff5E5E5E),
                          //         fontSize: ScreenUtil().setSp(28),
                          //       ),
                          //     )),
                          Text(
                             item['user']['city'],
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xff5E5E5E),
                            ),
                          ),
                        ],
                      ),
                      item['is_like'] ==true
                          ? InkWell(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setWidth(58),
                                padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(35),
                                  0,
                                  ScreenUtil().setWidth(35),
                                  0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border: Border.all(
                                      color: PublicColor.themeColor, width: 1),
                                ),
                                child: Text(
                                  '互相关注',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(24),
                                    color: PublicColor.themeColor,
                                  ),
                                ),
                              ),
                            ) 
                          : InkWell(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setWidth(58),
                                padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(35),
                                  0,
                                  ScreenUtil().setWidth(35),
                                  0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border: Border.all(
                                      color: Color(0xffBEBEBD), width: 1),
                                ),
                                child: Text(
                                  '未关注',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(24),
                                    color: Color(0xffBEBEBD),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      }
    }
    content = new ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 0, left: 10, right: 10),
      children: arr,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    _focus.addListener(_onFocusChange);
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
                '粉丝',
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
            ),
            body: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setWidth(15),
                ),
                Container(
    height: ScreenUtil().setWidth(221),
    width: ScreenUtil().setWidth(750),
    color: Color(0xffffffff),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          '粉丝数量',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(34),
            color: Color(0xff333333),
          ),
        ),
        Text(
          fans,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(62),
            color: PublicColor.themeColor,
          ),
        ),
      ],
    ),
  ),
                SizedBox(
                  height: ScreenUtil().setWidth(15),
                ),
                middle,
                SizedBox(
                  height: ScreenUtil().setWidth(10),
                ),
                getSlides(),
              ],
            )),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
