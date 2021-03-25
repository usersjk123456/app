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
import '../service/home_service.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoodsClassPage extends StatefulWidget {
  @override
  GoodsClassPageState createState() => GoodsClassPageState();
}

class GoodsClassPageState extends State<GoodsClassPage> {
  bool isLoading = false;
  String jwt = '', id = '', addressId = "";
  int _page = 0;
  List addressList = [], wdlist = [];
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();
    getLocal();
    getList();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
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
    _page++;
    if (_page == 1) {
      wdlist = [];
    }

    Map<String, dynamic> map = Map();
    map.putIfAbsent("is_tuijian", () => 1);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    HomeServer().getclass(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          wdlist = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              wdlist.insert(wdlist.length, success['list'][i]);
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
            color: Color(0xffffffff),
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(10),
            ),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(24),
                left: ScreenUtil().setWidth(26),
                bottom: ScreenUtil().setWidth(24)),
            child: InkWell(
              onTap: () {
                NavigatorUtils.togoodClassDetailList(context, item['id'], '2');
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
                Column(
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
                        width: ScreenUtil().setWidth(373),
                        child: Text(
                          item['text'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: ScreenUtil().setSp(26),
                          ),
                        )),
                    Container(
                        width: ScreenUtil().setWidth(373),
                        child: Text(
                          item['teacher']['name'],
                          style: TextStyle(
                            color: Color(0xffA3C265),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '￥',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(30),
                                    color: Color(0xffFA242F),
                                  ),
                                ),
                                Text(
                                  item['now_price'],
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(44),
                                    color: Color(0xffFA242F),
                                  ),
                                ),
                                Text(
                                  '起',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(26),
                                    color: Color(0xffFA242F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                '好课推荐',
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
            body: SingleChildScrollView(child: new Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getSlides(),
                ],
              ),
            ),
          ),),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
