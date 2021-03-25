import '../widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/dialog.dart';

class AddCouponPage extends StatefulWidget {
  @override
  _AddCouponPage createState() => _AddCouponPage();
}

class _AddCouponPage extends State<AddCouponPage> {
  bool isLoading = false;
  String shopType = "1";
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController miniController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  String beginTime = '';
  DateTime beginDate;
  String endTime = '';
  DateTime endDate;
  String goodsId = "";
  Map addImgList = {};
  @override
  void initState() {
    super.initState();
  }

  void addConfig() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => shopType);
    map.putIfAbsent("name", () => nameController.text);
    map.putIfAbsent("price", () => priceController.text);
    map.putIfAbsent("mini", () => miniController.text);
    map.putIfAbsent("num", () => numController.text);
    map.putIfAbsent("limit", () => limitController.text);
    map.putIfAbsent("start_time", () => beginTime);
    map.putIfAbsent("end_time", () => endTime);
    map.putIfAbsent("goods_ids", () => goodsId);

    StoreServer().addCoupon(map, (success) async {
      ToastUtil.showToast('添加成功');
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
      title: '温馨提示',
      message: '添加优惠券后不可更改,是否确认添加?',
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
      margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(40), bottom: ScreenUtil().setWidth(40)),
      alignment: Alignment.center,
      child: BigButton(
        name: '确认添加',
        tapFun: () {
          if (nameController.text == '') {
            ToastUtil.showToast('请输入优惠券名称');
            return;
          }
          if (priceController.text == '') {
            ToastUtil.showToast('请输入券的面额');
            return;
          }
          if (miniController.text == '') {
            ToastUtil.showToast('请输入使用条件');
            return;
          }
          if (numController.text == '') {
            ToastUtil.showToast('请输入券的数量');
            return;
          }
          if (limitController.text == '') {
            ToastUtil.showToast('请输入限领数量');
            return;
          }
          if (beginTime == '') {
            ToastUtil.showToast('请选择有效期');
            return;
          }
          if (endTime == '') {
            ToastUtil.showToast('请选择有效期');
            return;
          }
          if (shopType == "2") {
            if (addImgList.length == 0) {
              ToastUtil.showToast('请选择商品');
              return;
            }
          }
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return addDjango(context);
            },
          );
        },
        top: ScreenUtil().setWidth(10),
      ),
    );

    Widget contentWidget = ListView(
      children: <Widget>[
        new Container(
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
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('商品选择'),
                          Text(
                            '全部商品为全铺商品可用',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(24),
                                color: PublicColor.grewNoticeColor),
                          ),
                        ],
                      ),
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
                                groupValue: shopType,
                                onChanged: (value) {
                                  setState(() {
                                    shopType = value;
                                  });
                                },
                              ),
                            ),
                            Text('全部商品'),
                            SizedBox(width: ScreenUtil().setWidth(30)),
                            Container(
                              width: ScreenUtil().setWidth(50),
                              child: Radio(
                                value: '2',
                                activeColor: PublicColor.themeColor,
                                groupValue: shopType,
                                onChanged: (value) {
                                  setState(() {
                                    shopType = value;
                                  });
                                },
                              ),
                            ),
                            Text('指定商品'),
                          ],
                        ),
                      ),
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
                      child: Text('券的名称'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入优惠券名称",
                        ),
                      ),
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
                      child: Text('券的面额'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "￥1-￥500",
                        ),
                      ),
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
                      child: Text('使用条件'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: miniController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "用券最低订单金额",
                        ),
                      ),
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
                      child: Text('券的数量'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: numController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "1-100000",
                        ),
                      ),
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
                      child: Text('每人限领'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: limitController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "1-10",
                        ),
                      ),
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
                      child: Text('开始时间'),
                    ),
                    Expanded(
                      flex: 7,
                      child: InkWell(
                        onTap: () {
                          var date = DateTime.now();
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(date.year, date.month, date.day,
                                  date.hour, date.minute),
                              maxTime: endTime == ''
                                  ? DateTime(2050, 6, 7, 05, 09)
                                  : endDate, onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            setState(() {
                              beginTime = date.toString().split('.')[0];
                              beginDate = DateTime(date.year, date.month,
                                  date.day, date.hour, date.minute);
                            });
                          }, locale: LocaleType.zh);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(beginTime == '' ? '请选择开始时间' : beginTime),
                        ),
                      ),
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
                      child: Text('结束时间'),
                    ),
                    Expanded(
                      flex: 7,
                      child: InkWell(
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: beginTime == ''
                                  ? DateTime(2020, 4, 1, 20, 50)
                                  : beginDate,
                              maxTime: DateTime(2050, 6, 7, 05, 09),
                              onChanged: (date) {}, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              endTime = date.toString().split('.')[0];
                              endDate = DateTime(date.year, date.month,
                                  date.day, date.hour, date.minute);
                            });
                          }, locale: LocaleType.zh);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(endTime == '' ? '请选择开始时间' : endTime),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setWidth(15)),
              shopType == "2"
                  ? Container(
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
                            '选择商品',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                          InkWell(
                            child: Row(
                              children: <Widget>[
                                addImgList.length == 0
                                    ? Text(
                                        '请选择',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(28),
                                          color: PublicColor.grewNoticeColor,
                                        ),
                                      )
                                    : Text(
                                        '已选:${addImgList.length}件商品',
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
                              NavigatorUtils.goMyChooseGoodsPage(
                                      context, addImgList)
                                  .then((result) {
                                if (result != null) {
                                  setState(() {
                                    addImgList = result;
                                  });
                                  addImgList.forEach((key, value) {
                                    if (goodsId == '') {
                                      goodsId += key;
                                    } else {
                                      goodsId += ',' + key;
                                    }
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
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
                  '新增优惠券',
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
