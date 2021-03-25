import 'package:client/service/store_service.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';

class MaterialGlPage extends StatefulWidget {
  @override
  MaterialGlPageState createState() => MaterialGlPageState();
}

class MaterialGlPageState extends State<MaterialGlPage> {
  bool isLoading = false;
  String jwt = '';
  List scList = [];
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    StoreServer().materialManage(map, (success) async {
      setState(() {
        isLoading = false;
        scList = success['list'];
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget listArea() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (scList.length == 0) {
      arr.add(
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ),
      );
    } else {
      for (var item in scList) {
        arr.add(
          Container(
            child: new Column(
              children: <Widget>[
                new InkWell(
                  child: new Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setWidth(256),
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd))),
                      color: Colors.white,
                    ),
                    child: new Row(children: <Widget>[
                      Expanded(
                        flex: 0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    item['goods']['thumb'],
                                    height: ScreenUtil().setWidth(204),
                                    width: ScreenUtil().setWidth(204),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              child: Container(
                                  child: Image.asset(
                                "assets/shop/pp.png",
                                width: ScreenUtil().setWidth(56),
                                height: ScreenUtil().setWidth(40),
                                fit: BoxFit.cover,
                              )),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: new Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 20, 10, 0),
                              width: ScreenUtil().setWidth(500),
                              child: Text(
                                item['goods']['name'].toString() +
                                    '   ' +
                                    item['goods']['desc'].toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: new Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: RichText(
                                      text: TextSpan(
                                        text: '￥',
                                        style: TextStyle(
                                            color: Color(0xff454545),
                                            fontWeight: FontWeight.w600,
                                            fontSize: ScreenUtil.instance
                                                .setWidth(24)),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: item['goods']['now_price']
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(28),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '/赚',
                                            style: TextStyle(
                                              color: Color(0xffe61414),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(26),
                                            ),
                                          ),
                                          TextSpan(
                                            text: item['goods']['commission']
                                                .toString(),
                                            style: TextStyle(
                                              color: Color(0xffe61414),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(26),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                '库存' + item['goods']['stock'].toString(),
                                style: TextStyle(
                                  color: Color(0xffb6b6b6),
                                  fontSize: ScreenUtil.instance.setWidth(28),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                  onTap: () {
                    print('商品');
                  },
                )
              ],
            ),
          ),
        );
      }
    }
    content = Column(
      children: arr,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: new Text(
                '素材管理',
                style: new TextStyle(
                  color: PublicColor.headerTextColor,
                ),
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
            body: contentWidget()));
  }

  Widget contentWidget() {
    return Stack(
      children: <Widget>[
        Container(
          child: EasyRefresh(
            controller: _controller,
            header: BezierCircleHeader(
              backgroundColor: PublicColor.themeColor,
            ),
            footer: BezierBounceFooter(
              backgroundColor: PublicColor.themeColor,
            ),
            enableControlFinishRefresh: true,
            enableControlFinishLoad: false,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  listArea(),
                ],
              ),
            ),
            onRefresh: () async {
              getList();
              _controller.finishRefresh();
            },
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }
}
