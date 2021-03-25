import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/fluro_convert_util.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';

class ManageYlPage extends StatefulWidget {
  final String objs;
  ManageYlPage({this.objs});
  @override
  ManageYlPageState createState() => ManageYlPageState();
}

class ManageYlPageState extends State<ManageYlPage> {
  Map user = {
    "store_name": "",
    "store_img": "",
    "headimgurl": "",
  };
  List shopList = [];
  @override
  void initState() {
    user = FluroConvertUtils.string2map(widget.objs);
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

    Widget banner = new Container(
      alignment: Alignment.topCenter,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(370),
      decoration: BoxDecoration(color: Color(0xfff5f5f5)),
      child: Stack(children: <Widget>[
        //图片
        Positioned(
          top: 0,
          child: user['store_img'] == ''
              ? Container()
              : Image.network(
                  user['store_img'],
                  width: ScreenUtil().setWidth(750),
                  fit: BoxFit.contain,
                ),
        ),
        Positioned(
          bottom: 20,
          left: ScreenUtil().setWidth(60),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: ClipOval(
                  child: user['store_headimg'] == ''
                      ? Container()
                      : Image.network(
                          user['store_headimg'],
                          height: ScreenUtil().setWidth(127),
                          width: ScreenUtil().setWidth(127),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(30),
              ),
              Container(
                width: ScreenUtil().setWidth(500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user['store_name'],
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user['store_desc'],
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );

    Widget shopListBuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (shopList.length != 0) {
        for (var item in shopList) {
          arr.add(
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
              width: ScreenUtil().setWidth(750),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xffe5e5e5)),
                ),
              ),
              child: InkWell(
                onTap: () {
                  NavigatorUtils.toXiangQing(
                      context, item['id'].toString(), '0', '0');
                },
                child: new Column(
                  children: <Widget>[
                    Container(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['thumb'],
                        height: ScreenUtil().setWidth(285),
                        width: ScreenUtil().setWidth(694),
                        fit: BoxFit.cover,
                      ),
                    )),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          item['desc'],
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        )),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: '￥',
                          style: TextStyle(
                              color: Color(0xffe61414),
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil.instance.setWidth(24)),
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
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(750),
              height: ScreenUtil().setWidth(70),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xffe5e5e5)),
                ),
              ),
              child: Text(
                '店铺精选',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
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
              '',
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
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                banner,
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
