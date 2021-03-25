import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/dialog.dart';
import '../service/home_service.dart';
import '../widgets/cached_image.dart';
import '../service/user_service.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class TyClassPage extends StatefulWidget {
  @override
  TyClassPageState createState() => TyClassPageState();
}

class TyClassPageState extends State<TyClassPage> {
  bool isLoading = false;
  String jwt = '', addressId = "";
  List addressList = [], wdlist = [];
  EasyRefreshController _controller = EasyRefreshController();
  int _page = 0;
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    // setState(() {
    //   isLoading = true;
    // });
    _page++;
    if (_page == 1) {
      wdlist = [];
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    UserServer().getbuyList(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          wdlist = success['tiyanclass'];
        } else {
          if (success['tiyanclass'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['tiyanclass'].length; i++) {
              wdlist.insert(wdlist.length, success['tiyanclass'][i]);
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

  Widget getSlides() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (wdlist.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,

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
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(20),
            ),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(24),
                left: ScreenUtil().setWidth(26),
                bottom: ScreenUtil().setWidth(24)),
            child: InkWell(
              onTap: () {
                print(item['id']);
                NavigatorUtils.gobabyXiangqing(context, item['id'].toString());
              },
              //设置圆角
              child: Row(children: [
                Container(
                  child: CachedImageView(
                    ScreenUtil.instance.setWidth(219.0),
                    ScreenUtil.instance.setWidth(219.0),
                    item['img'],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        item['name'],
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil().setSp(32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                          width: ScreenUtil().setWidth(400),
                          child: Text(
                            item['text'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff666666),
                              fontSize: ScreenUtil().setSp(26),
                            ),
                          )),
                      Container(
                        width: ScreenUtil().setWidth(373),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(155),
                              height: ScreenUtil().setWidth(39),
                              decoration: BoxDecoration(
                                color: Color(0xffFDEAE2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                    color: Color(0xffEE9249), width: 1),
                              ),
                              child: Text(
                                item['age'],
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(24),
                                  color: Color(0xffF48051),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(136),
                              height: ScreenUtil().setWidth(53),
                              decoration: BoxDecoration(
                                color: Color(0xffF57C4C),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                    color: Color(0xffF57C4C), width: 1),
                              ),
                              child: InkWell(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '0元领',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(34),
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(11),
                                    ),
                                    Image.asset(
                                      'assets/index/ic_jiantou.png',
                                      width: ScreenUtil().setWidth(13),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  String oid = item['id'].toString();
                              
                                  NavigatorUtils.gobabyXiangqing(
                                      context, oid);
                                },
                              ),
                            ),
                          ],
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
      children: arr,
    );
    return content;
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
                '我的体验课',
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
            body: new Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child:SingleChildScrollView(

              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getSlides(),
                ],
              )
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
