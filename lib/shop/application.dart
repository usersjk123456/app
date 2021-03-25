import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../service/store_service.dart';
import '../config/Navigator_util.dart';

class ApplicationPage extends StatefulWidget {
  @override
  ApplicationPageState createState() => ApplicationPageState();
}

class ApplicationPageState extends State<ApplicationPage> {
  bool _flag = true;
  String xieyi = "";
  String zbxieyi = "";
  void updateGroupValue(v) {
    setState(() {
      _flag = v;
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() {
    Map<String, dynamic> map = Map();
    StoreServer().getXieYi(map, (success) {
      setState(() {
        xieyi = success['res']['apply'];
        zbxieyi = success['res']['live'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget content = Expanded(
        flex: 1,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Text(
                '入驻申请协议',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                child: ListView(
                  children: <Widget>[
                    Text(
                      xieyi,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));

    Widget agreement = new Container(
      height: ScreenUtil().setHeight(275),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            offset: new Offset(0.0, 0.1),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(top: 25),
        child: new Column(
          children: <Widget>[
            Container(
                child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: new Container(
                      padding: EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        _flag
                            ? "assets/shop/check1.png"
                            : "assets/shop/check2.png",
                        height: ScreenUtil().setWidth(43),
                        width: ScreenUtil().setWidth(43),
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      if (_flag) {
                        _flag = false;
                      } else {
                        _flag = true;
                      }
                      updateGroupValue(_flag);
                    },
                  )),
              Expanded(
                flex: 4,
                child: Row(children: [
                  Text(
                    '我已阅读完并同意',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(28),
                    ),
                  ),
                  InkWell(
                    child: Text(
                      '《橙子宝宝直播》',
                      style: TextStyle(
                        color: Color(0xfff55a5a),
                        fontSize: ScreenUtil.instance.setWidth(28),
                      ),
                    ),
                    onTap: () {
                      Map obj = {
                        "xieyi": zbxieyi,
                      };
                      NavigatorUtils.toZbXieyiPage(context, obj);
                    },
                  ),
                  Text(
                    '协议',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(28),
                    ),
                  ),
                ]),
              )
            ])),
            Container(
              alignment: Alignment.center,
              child: Container(
                height: ScreenUtil().setWidth(86),
                width: ScreenUtil().setWidth(640),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    gradient: PublicColor.btnlinear,
                    borderRadius: new BorderRadius.circular((8.0))),
                child: new FlatButton(
                  disabledColor: PublicColor.themeColor,
                  onPressed: () {
                    if (_flag) {
                      NavigatorUtils.toAuthenticationOnePage(context);
                    } else {
                      FlutterToast.showToast(
                        msg: "请先阅读橙子宝宝直播协议",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                      );
                    }
                  },
                  child: new Text(
                    '下一步',
                    style: TextStyle(
                        color: PublicColor.btnTextColor,
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '确认申请',
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
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [content, agreement],
            ),
          ),
        ));
  }
}
