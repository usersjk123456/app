import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './search_card.dart';
import '../config/Navigator_util.dart';

class TopBar extends StatelessWidget {
  // This ui.widget is the root of your application.
  final TextEditingController _keywordTextEditingController =
      TextEditingController();

  final List<String> searchHintTexts;

  TopBar({Key key, this.searchHintTexts}) : super(key: key);

  final FocusNode _focus = new FocusNode();

  // BuildContext _context;

  void _onFocusChange() {
//    print('HomeTopBar._onFocusChange${_focus.hasFocus}');
//    if(!_focus.hasFocus){
//      return;
//    }
//    NavigatorUtils.gotoSearchGoodsPage(_context);
  }

  @override
  Widget build(BuildContext context) {
    // _context = context;
    _focus.addListener(_onFocusChange);

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding:
          EdgeInsets.only(top: statusBarHeight, left: 0, right: 0, bottom: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SearchCardWidget(
                elevation: 0,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  NavigatorUtils.goSearchZbPage(context);
                },
                textEditingController: _keywordTextEditingController,
                focusNode: _focus,
                hintText: '请输入搜索的直播间'),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(
                  right: ScreenUtil.instance.setWidth(12),
                  left: ScreenUtil.instance.setWidth(8.0)),
              height: ScreenUtil.instance.setWidth(70.0),
              width: ScreenUtil.instance.setWidth(70.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/index/gwc.png',
                    width: ScreenUtil().setWidth(44),
                  ),
                  SizedBox(
                    height: ScreenUtil.instance.setWidth(3.0),
                  ),
                  Expanded(
                    child: Text(
                      '购物车',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(20.0),
                        color: Color(0xfffffffff),
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              print('购物车');
              NavigatorUtils.toShoppingCart(context);
            },
          ),
        ],
      ),
    );
  }
}
