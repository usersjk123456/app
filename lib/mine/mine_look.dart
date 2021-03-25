import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../service/user_service.dart';
import '../widgets/cached_image.dart';


class MineLookPage extends StatefulWidget {
  @override
  MineLookPageState createState() => MineLookPageState();
}

class MineLookPageState extends State<MineLookPage> {
  bool isLoading = false;
  String jwt = '', addressId = "", newcount = '';
  List addressList = [],wdlist=[];
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  final FocusNode _focus = new FocusNode();
  @override
  void initState() {
    super.initState();
    getList();
    getlookList();
  }

  void _onFocusChange() {}
  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
      getlookList();
    }
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          newcount = success['new_count'].toString();
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

    void getlookList() async {
    Map<String, dynamic> map = Map();
    UserServer().getlookList(map, (success) async {
      if (mounted) {
        setState(() {
          wdlist=success['list'];
          // newcount = success['new_count'].toString();
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
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
          '全部关注',
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
    if (wdlist.length == 0) {
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
      for (var item in wdlist) {
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
                      Container(
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
                          border:
                              Border.all(color: Color(0xffEE9249), width: 1),
                        ),
                        child: Text(
                          '已关注',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Color(0xffF48051),
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
                '关注',
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
                        '关注数量',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(34),
                          color: Color(0xff333333),
                        ),
                      ),
                      Text(
                        newcount,
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
