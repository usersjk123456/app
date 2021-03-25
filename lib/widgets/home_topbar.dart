import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import './search_card.dart';
import '../common/color.dart';
import '../service/home_service.dart';

class TopBar extends StatelessWidget {
  // This ui.widget is the root of your application.

  final TextEditingController _keywordTextEditingController =
      TextEditingController();

  final List<String> searchHintTexts;
  final String newcount;

  TopBar({Key key, this.searchHintTexts, this.newcount}) : super(key: key);

  final FocusNode _focus = new FocusNode();

  void _onFocusChange() {}

  void getHome() async {
    Map<String, dynamic> map = Map();
    HomeServer().getHome(map, (success) async {}, (onFail) async {});
  }

  @override
  Widget build(BuildContext context) {
    _focus.addListener(_onFocusChange);

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.only(
                  right: ScreenUtil.instance.setWidth(12),
                  left: ScreenUtil.instance.setWidth(8.0)),
              height: ScreenUtil.instance.setWidth(75.0),
              width: ScreenUtil.instance.setWidth(70.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/index/xiaoxi.png',
                    width: ScreenUtil().setWidth(44),
                  ),
                  // SizedBox(
                  //   height: ScreenUtil.instance.setWidth(3.0),
                  // ),
                  Expanded(
                    child: Text(
                      '消息',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(20.0),
                        color: Color(0xffffffff),
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              print('消息');
              NavigatorUtils.goNewsPage(context);
            },
          ),
          Expanded(
            flex: 1,
            child: SearchCardWidget(
              elevation: 0,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                NavigatorUtils.goSearchPage(context);
              },
              textEditingController: _keywordTextEditingController,
              focusNode: _focus,
            ),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(
                  // right: ScreenUtil.instance.setWidth(12),
                  left: ScreenUtil.instance.setWidth(8.0)),
              height: ScreenUtil.instance.setWidth(75.0),
              width: ScreenUtil.instance.setWidth(65.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Image.asset(
                      'assets/index/gwc.png',
                      width: ScreenUtil().setWidth(44),
                    ),
                    int.parse(newcount) > 0
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setWidth(20),
                              child: Text(
                                newcount,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: ScreenUtil().setSp(15)),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          )
                        : Container(),
                  ]),
                  // SizedBox(
                  //   height: ScreenUtil.instance.setWidth(3.0),
                  // ),
                  Expanded(
                    child: Text(
                      '购物车',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(20.0),
                        color: Color(0xffffffff),
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              NavigatorUtils.toShoppingCart(context);
            },
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(
                right: ScreenUtil.instance.setWidth(0),
                left: ScreenUtil.instance.setWidth(8.0),
              ),
              height: ScreenUtil.instance.setWidth(75.0),
              width: ScreenUtil.instance.setWidth(65.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/index/fl.png',
                    width: ScreenUtil().setWidth(44),
                  ),
                  // SizedBox(
                  //   height: ScreenUtil.instance.setWidth(3.0),
                  // ),
                  Expanded(
                    child: Text(
                      '分类',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(20.0),
                        color: Color(0xffffffff),
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              // 分类
              NavigatorUtils.goFenleiPage(context);
            },
          )
        ],
      ),
    );
  }
}
