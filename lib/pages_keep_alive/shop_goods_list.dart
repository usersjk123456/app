import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';

class ShopGoodsList extends StatefulWidget {
  @override
  _ShopGoodsListState createState() => _ShopGoodsListState();
}

class _ShopGoodsListState extends State<ShopGoodsList> {
  List shopList = [];
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    StoreServer().storeChoice(map, (success) {
      setState(() {
        shopList = success['goods'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget shopListBuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (shopList.length != 0) {
        for (var item in shopList) {
          arr.add(
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
              // height: ScreenUtil().setWidth(455),
              width: ScreenUtil().setWidth(750),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xffe5e5e5)),
                ),
              ),
              child: InkWell(
                onTap: () {
                  NavigatorUtils.toXiangQing(context, item['id'].toString(),'0','0');
                },
                child: new Column(
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['thumb'],
                          height: ScreenUtil().setWidth(328),
                          width: ScreenUtil().setWidth(694),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        item['desc'],
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.bold,
                            color: Color(0xff333333)),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(4),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: '￥',
                          style: TextStyle(
                              color: Color(0xffe61414),
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil.instance.setWidth(26)),
                          children: <TextSpan>[
                            TextSpan(
                              text: "${item['now_price']}",
                              style: TextStyle(
                                color: Color(0xffe61414),
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil.instance.setWidth(28),
                              ),
                            ),
                            TextSpan(
                              text: " ￥${item['old_price']}",
                              style: TextStyle(
                                color: Color(0xffb7b7b7),
                                decoration: TextDecoration.lineThrough,
                                decorationColor: const Color(0xffb7b7b7),
                                fontSize: ScreenUtil.instance.setWidth(26),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
      content = ListView(children: arr);
      return content;
    }

    Widget shopSelected = new Container(
      child: Container(
          width: ScreenUtil().setWidth(750),
          // margin: EdgeInsets.only(top: 20),
          child: new Column(children: <Widget>[
            Expanded(
              flex: 1,
              child: shopListBuild(),
            )
          ])),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '店铺精选',
              style: new TextStyle(color: PublicColor.headerTextColor),
            ),
            flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: PublicColor.linearHeader,
                  ),
                ),

            // leading: new IconButton(
            //   icon: Icon(
            //     Icons.navigate_before,
            //     color: PublicColor.textColor,
            //   ),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: shopSelected,
                )
              ],
            ),
          ),
        ));
  }
}
