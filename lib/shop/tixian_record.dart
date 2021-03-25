import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../common/toTime.dart';
import '../service/user_service.dart';

class TixianRecordPage extends StatefulWidget {
  @override
  TixianRecordPageState createState() => TixianRecordPageState();
}

class TixianRecordPageState extends State<TixianRecordPage> {
  bool isLoading = false;
  List tixianList = [];
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    UserServer().getCashLog(map, (success) async {
      setState(() {
        tixianList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget top = new Container(
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setHeight(92),
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
        ),
        child: new Row(children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                '日期',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '时间',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '数量',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '提现方式',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '提现状态',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          )
        ]),
      ),
    );

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (tixianList.length == 0) {
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
        for (var item in tixianList) {
          item['date'] = ToTime.time(item['create_at'].toString(), 'YY');
          item['time'] = ToTime.time(item['create_at'].toString(), 'HH');
          arr.add(Container(
              child: new Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 2),
                      alignment: Alignment.center,
                      child: Text(
                        item['date'].toString(),
                        style: TextStyle(
                          color: Color(0xff5e5e5e),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        item['time'].toString(),
                        style: TextStyle(
                          color: Color(0xff5e5e5e),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        item['amount'],
                        style: TextStyle(
                          color: Color(0xff5e5e5e),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        item['type'] == "2" ? '银行卡' : '支付宝',
                        style: TextStyle(
                          color: Color(0xff5e5e5e),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        item['status'] == 0
                            ? '待审核'
                            : item['status'] == 1 ? '提现成功' : '提现失败,后台拒绝',
                        style: TextStyle(
                          color: Color(0xff5e5e5e),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  )
                ]),
              )
            ],
          )));
        }
      }
      content = new Column(
        children: arr,
      );
      return content;
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '提现记录',
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
            child: new ListView(
              children: [top, listArea()],
            ),
          ),
        ));
  }
}
