import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../widgets/dialog.dart';
import '../widgets/choose_type.dart';

class SendShopPage extends StatefulWidget {
  final oid;
  SendShopPage({this.oid});
  @override
  _SendShopPagePage createState() => _SendShopPagePage();
}

class _SendShopPagePage extends State<SendShopPage> {
  bool isLoading = false;
  TextEditingController numController = TextEditingController();
  Map edObj = {};
  Map shopType = {
    "id": 0,
    "name": "",
    "code": "",
  };
  String edType = "1";
  List typeList = [];
  @override
  void initState() {
    super.initState();
    getList();
  }

  getList() {
    Map<String, dynamic> map = Map();

    StoreServer().getExpressList(map, (success) async {
      setState(() {
        typeList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void addConfig() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_order_id", () => widget.oid);
    map.putIfAbsent("type", () => edType);
    map.putIfAbsent("express_name", () => shopType['name']);
    map.putIfAbsent("express", () => shopType['code']);
    map.putIfAbsent("number", () => numController.text);

    StoreServer().sendShop(map, (success) async {
      ToastUtil.showToast('ๅ่ดงๆๅ');
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget addDjango(context) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        addConfig();
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: 'ๆธฉ้ฆจๆ็คบ',
      message: '่ฏท็กฎไฟๅฟซ้ๅๅทๅกซๅๆญฃ็กฎ',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget btn = Container(
      margin: EdgeInsets.only(top: 20, bottom: 30),
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setWidth(100),
        width: ScreenUtil().setWidth(640),
        margin: EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
            color: PublicColor.themeColor,
            borderRadius: new BorderRadius.circular((8.0))),
        child: new FlatButton(
          disabledColor: PublicColor.grewNoticeColor,
          onPressed: () {
            if (edType == "1") {
              if (shopType['name'] == '') {
                ToastUtil.showToast('่ฏท้ๆฉๅฟซ้ๅฌๅธ');
                return;
              }
              if (numController.text == '') {
                ToastUtil.showToast('่ฏท่พๅฅๅฟซ้ๅๅท');
                return;
              }

              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return addDjango(context);
                  });
            } else {
              addConfig();
            }
          },
          child: new Text(
            '็กฎ่ฎคๅ่ดง',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );

    Widget contentWidget = ListView(
      children: <Widget>[
        Container(
          height: ScreenUtil().setWidth(120),
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
          ),
          color: PublicColor.whiteColor,
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text('ๅฟซ้็ฑปๅ'),
              ),
              Container(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(50),
                        child: Radio(
                          value: '1',
                          activeColor: PublicColor.themeColor,
                          groupValue: edType,
                          onChanged: (value) {
                            setState(() {
                              edType = value;
                            });
                          },
                        ),
                      ),
                      Text('ๆฎ้ๅฟซ้'),
                      SizedBox(width: ScreenUtil().setWidth(30)),
                      Container(
                        width: ScreenUtil().setWidth(50),
                        child: Radio(
                          value: '2',
                          activeColor: PublicColor.themeColor,
                          groupValue: edType,
                          onChanged: (value) {
                            setState(() {
                              edType = value;
                            });
                          },
                        ),
                      ),
                      Text('ๆ?้็ฉๆต'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        edType == '1'
            ? new Container(
                color: Colors.grey[100],
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setWidth(120),
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(30),
                      ),
                      color: PublicColor.whiteColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '้ๆฉๅฟซ้ๅฌๅธ',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                          InkWell(
                            child: Row(
                              children: <Widget>[
                                shopType['name'] == ''
                                    ? Text(
                                        '่ฏท้ๆฉ',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(28),
                                          color: PublicColor.grewNoticeColor,
                                        ),
                                      )
                                    : Text(
                                        shopType['name'],
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(28),
                                          color: Colors.red,
                                        ),
                                      ),
                                new Icon(
                                  Icons.navigate_next,
                                  color: Color(0xff999999),
                                )
                              ],
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FenleiWidget(
                                        typeList: typeList,
                                        selectId: shopType['id'],
                                        title: "ๅๅๅ็ฑป",
                                        onChanged: (item) {
                                          setState(() {
                                            shopType = item;
                                          });
                                        });
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setWidth(120),
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(30),
                      ),
                      color: PublicColor.whiteColor,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text('ๅฟซ้ๅๅท'),
                          ),
                          Expanded(
                            flex: 7,
                            child: TextField(
                              controller: numController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(30)),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "่ฏท่พๅฅๅฟซ้ๅๅท",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        btn,
      ],
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: new Text(
                  'ๅ่ดง',
                  style: new TextStyle(color: PublicColor.headerTextColor),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: PublicColor.linearHeader,
                  ),
                ),

                centerTitle: true,
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
                color: PublicColor.bodyColor,
                child: contentWidget,
              ),
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ));
  }
}
