import 'package:client/common/color.dart';
import 'package:client/service/store_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//送礼物
class GiftList extends StatefulWidget {
  final String roomId;
  GiftList({this.roomId});

  @override
  GiftListState createState() => GiftListState();
}

class GiftListState extends State<GiftList> {
  List giftsList = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => 1);
    StoreServer().getGiftList(map, (success) async {
      for (var item in success['list']) {
        item['choose'] = false;
      }
      setState(() {
        giftsList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 600)..init(context);

    Widget titleBox = Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(20),
        bottom: ScreenUtil().setWidth(20),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: PublicColor.lineColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '名称',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
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
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '金额',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '时间',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
          )
        ],
      ),
    );

    Widget gitItem(item) {
      return Container(
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(30),
          bottom: ScreenUtil().setWidth(30),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: PublicColor.lineColor),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  item['num'].toString(),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
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
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  item['create_at'],
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;

      if (giftsList.length == 0) {
        return Container(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(300),
          ),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        );
      }

      for (var item in giftsList) {
        arr.add(gitItem(item));
      }

      content = new Wrap(
        spacing: 1.0, // 主轴(水平)方向间距
        runSpacing: 7.0,
        alignment: WrapAlignment.start,
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
            '礼物列表',
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
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              titleBox,
              listArea(),
            ],
          ),
        ),
      ),
    );
  }
}
