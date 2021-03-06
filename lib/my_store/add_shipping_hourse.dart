import 'package:client/common/regExp.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/fluro_convert_util.dart';

class AddShippingHoursePage extends StatefulWidget {
  final String objs;
  AddShippingHoursePage({this.objs});
  @override
  _AddShippingHoursePageState createState() => _AddShippingHoursePageState();
}

class _AddShippingHoursePageState extends State<AddShippingHoursePage> {
  bool isLoading = false;
  bool isDefault = false;
  String addressType = "0";
  TextEditingController hourseNameController = TextEditingController();
  TextEditingController hourseDescController = TextEditingController();
  TextEditingController receiverController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController explainController = TextEditingController();
  String id = 'null';

  @override
  void initState() {
    Map lists = FluroConvertUtils.string2map(widget.objs);
    if (lists != null) {
      setState(() {
        id = lists['id'];
        hourseNameController.text = lists['house_name'];
        addressType = lists['house_address'];
        hourseDescController.text = lists['house_desc'];
        receiverController.text = lists['receiver'];
        phoneController.text = lists['phone'];
        areaController.text = lists['area'];
        explainController.text = lists['explain'];
        isDefault = lists['is_default'] == "1" ? true : false;
      });
    }
    super.initState();
  }

  void saveConfig() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    if (id != "null") {
      map.putIfAbsent("id", () => id);
    }
    map.putIfAbsent("house_name", () => hourseNameController.text);
    map.putIfAbsent("house_address", () => addressType);
    map.putIfAbsent("house_desc", () => hourseDescController.text);
    map.putIfAbsent("receiver", () => receiverController.text);
    map.putIfAbsent("phone", () => phoneController.text);
    map.putIfAbsent("area", () => areaController.text);
    map.putIfAbsent("explain", () => explainController.text);
    map.putIfAbsent("is_default", () => isDefault ? "1" : "0");

    StoreServer().addShippingHourse(map, id, (success) async {
      ToastUtil.showToast('????????????');
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget setArea = Container(
      height: ScreenUtil().setWidth(120),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      color: PublicColor.whiteColor,
      alignment: Alignment.center,
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              child: Text(
                '??????????????????',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: new Row(
                  children: <Widget>[
                    Switch(
                      value: isDefault,
                      onChanged: (newValue) {
                        setState(() {
                          isDefault = newValue;
                        });
                      },
                      activeTrackColor: PublicColor.themeColor,
                      activeColor: PublicColor.themeColor,
                      inactiveThumbColor: PublicColor.bodyColor,
                      inactiveTrackColor: PublicColor.bodyColor,
                    ),
                  ],
                ),
              ))
        ],
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
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                  bottom: ScreenUtil().setWidth(20),
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(30),
                ),
                color: PublicColor.bodyColor,
                child: Text(
                  '????????????????????????????????????',
                  style: TextStyle(fontSize: ScreenUtil().setSp(28)),
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
                      child: Text('???????????????'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: hourseNameController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "????????????????????????",
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
                      child: Text('???????????????'),
                    ),
                    Container(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(50),
                              child: Radio(
                                value: '0',
                                activeColor: PublicColor.themeColor,
                                groupValue: addressType,
                                onChanged: (value) {
                                  setState(() {
                                    addressType = value;
                                  });
                                },
                              ),
                            ),
                            Text('??????'),
                            SizedBox(width: ScreenUtil().setWidth(30)),
                            Container(
                              width: ScreenUtil().setWidth(50),
                              child: Radio(
                                value: '1',
                                activeColor: PublicColor.themeColor,
                                groupValue: addressType,
                                onChanged: (value) {
                                  setState(() {
                                    addressType = value;
                                  });
                                },
                              ),
                            ),
                            Text('??????'),
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
                      child: Text('???????????????'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: hourseDescController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "???????????????",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                  bottom: ScreenUtil().setWidth(20),
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(30),
                ),
                color: PublicColor.bodyColor,
                child: Text(
                  '?????????????????????????????????????????????????????????',
                  style: TextStyle(fontSize: ScreenUtil().setSp(28)),
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
                      child: Text('?????????'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: receiverController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "????????????????????????",
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
                      child: Text('?????????'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "??????????????????",
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
                      child: Text('????????????'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: areaController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "???????????????",
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
                      child: Text('????????????'),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: explainController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "?????????????????????",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              setArea
            ],
          ),
        ),
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
                    '???????????????',
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
                  actions: <Widget>[
                    InkWell(
                      child: Container(
                          padding:
                              const EdgeInsets.only(right: 14.0, top: 15.0),
                          child: Text(
                            '??????',
                            style: new TextStyle(
                              color: PublicColor.textColor,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          )),
                      onTap: () {
                        if (hourseNameController.text == '') {
                          ToastUtil.showToast('????????????????????????');
                          return;
                        }
                        if (hourseDescController.text == '') {
                          ToastUtil.showToast('????????????????????????');
                          return;
                        }
                        if (receiverController.text == '') {
                          ToastUtil.showToast('????????????????????????');
                          return;
                        }
                        if (phoneController.text == '') {
                          ToastUtil.showToast('??????????????????');
                          return;
                        }
                        if (!RegExpTest.checkPhone
                            .hasMatch(phoneController.text)) {
                          ToastUtil.showToast('????????????????????????');
                          return;
                        }
                        if (areaController.text == '') {
                          ToastUtil.showToast('???????????????');
                          return;
                        }
                        if (explainController.text == '') {
                          ToastUtil.showToast('?????????????????????');
                          return;
                        }
                        saveConfig();
                      },
                    ),
                  ]),
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
