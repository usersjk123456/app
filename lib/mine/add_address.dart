import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/city_picker.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/fluro_convert_util.dart';
import '../service/user_service.dart';

class AddAddressPage extends StatefulWidget {
  final String addr;
  AddAddressPage({this.addr});
  @override
  AddAddressPageState createState() => AddAddressPageState();
}

class AddAddressPageState extends State<AddAddressPage> {
  bool _value = false;
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  String jwt = '';
  String id = '';
  String address = '';
  String province = '';
  String city = '';
  String region = '';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Map addr = FluroConvertUtils.string2map(widget.addr);
    print(addr);
    if (addr != null) {
      id = addr['id'];
      namecontroller.text = addr['name'];
      phonecontroller.text = addr['phone'];
      address = addr['province'] + addr['city'] + addr['region'];
      province = addr['province'];
      city = addr['city'];
      region = addr['region'];
      addresscontroller.text = addr['address'];
      _value = addr['is_default'] == "0" ? false : true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addAddress() async {
    if (namecontroller.text == '') {
      ToastUtil.showToast('请输入收货人姓名');
      return;
    }

    if (phonecontroller.text == '') {
      ToastUtil.showToast('请输入手机号');
      return;
    }

    if (addresscontroller.text == '') {
      ToastUtil.showToast('请输入详细地址');
      return;
    }

    if (address == '') {
      ToastUtil.showToast('请选择地区');
      return;
    }

    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    if (id != "") {
      map.putIfAbsent("id", () => id);
    }
    map.putIfAbsent("name", () => namecontroller.text);
    map.putIfAbsent("address", () => addresscontroller.text);
    map.putIfAbsent("phone", () => phonecontroller.text);
    map.putIfAbsent("province", () => province);
    map.putIfAbsent("city", () => city);
    map.putIfAbsent("region", () => region);
    map.putIfAbsent("is_default", () => _value ? '1' : '0');

    UserServer().addAddress(map, id, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('保存成功');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget inputArea = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        height: ScreenUtil().setHeight(470),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(98),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
            ),
            child: Container(
              child: new TextField(
                controller: namecontroller,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    hintText: '请输入收货人姓名', border: InputBorder.none),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(98),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
            ),
            child: Container(
              child: new TextField(
                controller: phonecontroller,
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                    hintText: '请输入手机号码', border: InputBorder.none),
              ),
            ),
          ),
          InkWell(
            child: Container(
                height: ScreenUtil().setHeight(98),
                width: ScreenUtil().setWidth(700),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      '所在地区',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      address == '' ? '请选择' : address,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Color(0xffa0a0a0),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: new Container(
                        alignment: Alignment.centerRight,
                        child: new Icon(
                          Icons.navigate_next,
                          color: Color(0xff999999),
                        ),
                      )),
                ])),
            onTap: () {
              print('请选择地址');
              setState(() {
                address = '';
              });
              CityPicker.showCityPicker(
                context,
                selectProvince: (value) {
                  address = address + value['name'].toString();
                  province = value['name'].toString();
                },
                selectCity: (value) {
                  address = address + value['name'].toString();
                  city = value['name'].toString();
                },
                selectArea: (value) {
                  setState(() {
                    address = address + value['name'].toString();
                    region = value['name'].toString();
                  });
                },
              );
            },
          ),
          Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30), 10, ScreenUtil().setWidth(20), 0),
              child: new Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    '详细地址',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: addresscontroller,
                      maxLines: 2,
                      decoration:
                          InputDecoration.collapsed(hintText: "请输入详细地址"),
                    ),
                  ),
                )
              ]))
        ]),
      ),
    );

    Widget setArea = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        height: ScreenUtil().setHeight(115),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(30), 0),
          child: new Row(children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: Text(
                  '设置默认地址',
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
                        value: _value,
                        onChanged: (newValue) {
                          setState(() {
                            _value = newValue;
                          });
                        },
                        activeTrackColor: PublicColor.themeColor,
                        activeColor: PublicColor.themeColor,
                        inactiveThumbColor: Color(0xffd5d5d5),
                        inactiveTrackColor: Color(0xfff5f5f5),
                      ),
                    ],
                  ),
                ))
          ]),
        ),
      ),
    );

    return MaterialApp(
        title: "新增地址",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '新增地址',
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
            actions: <Widget>[
              InkWell(
                child: Container(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Text(
                      '保存',
                      style: new TextStyle(
                        color: PublicColor.headerTextColor,
                        fontSize: ScreenUtil().setSp(30),
                        height: 2.7,
                      ),
                    )),
                onTap: () {
                  print('保存');
                  addAddress();
                },
              )
            ],
          ),
          body: new Container(
            alignment: Alignment.center,
            child: isLoading
                ? LoadingDialog()
                : new Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      inputArea,
                      setArea,
                      new SizedBox(height: ScreenUtil().setHeight(40)),
                    ],
                  ),
          ),
          resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
        ));
  }
}
