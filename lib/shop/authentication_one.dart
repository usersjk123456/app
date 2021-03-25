import 'package:client/common/regExp.dart';
import 'package:client/utils/toast_util.dart';
import '../widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import '../widgets/city_picker.dart';
import '../common/upload_to_oss.dart';
import '../widgets/loading.dart';

class AuthenticationOnePage extends StatefulWidget {
  @override
  AuthenticationOnePageState createState() => AuthenticationOnePageState();
}

class AuthenticationOnePageState extends State<AuthenticationOnePage> {
  TextEditingController realshopnamecontroller = TextEditingController();
  TextEditingController addrcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  bool isLoading = false;
  Map obj = {};
  String address = '';
  String province = '';
  String city = '';
  String img4 = '';
  String region = '';
  void changeLoading({type = 2, sent = 0, total = 0}) {
    if (type == 1) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget topArea = new Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(453),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          "assets/shop/rzt.png",
        ),
      )),
      child: Stack(
        children: <Widget>[
          //bg图片

          Positioned(
            top: 10,
            left: 10,
            child: Container(
              width: ScreenUtil().setWidth(750),
              height: ScreenUtil().setWidth(112),
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Icon(
                      Icons.navigate_before,
                      color: Color(0xffffffff),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    '供应商认证',
                    style: new TextStyle(
                        color: Color(0xffffffff),
                        fontSize: ScreenUtil().setSp(32)),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(96),
                    height: ScreenUtil().setWidth(46),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 10,
            child: Container(
              child: Image.asset(
                "assets/shop/stdrz1.png",
                height: ScreenUtil().setWidth(190),
                width: ScreenUtil().setWidth(715),
              ),
            ),
          ),
        ],
      ),
    );
    Widget photo = new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        child: Container(
          width: ScreenUtil().setWidth(694),
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(21),
              bottom: ScreenUtil().setWidth(11)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular((8.0)),
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
          ),
          child: img4 == ""
              ? Image.asset(
                  "assets/shop/ic_yingyezhizhao.png",
                  height: ScreenUtil().setWidth(202),
                  width: ScreenUtil().setWidth(313),
                )
              : Image.network(
                  img4,
                  height: ScreenUtil().setWidth(204),
                  width: ScreenUtil().setWidth(318),
            
                ),
        ),
        onTap: () async {
          Map obj = await openGallery("image", changeLoading);
          if (obj == null) {
            changeLoading(type: 2, sent: 0, total: 0);
            return;
          }
          if (obj['errcode'] == 0) {
            img4 = obj['url'];
          } else {
            ToastUtil.showToast(obj['msg']);
          }
        },
      ),
    );

    Widget inforArea = new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(312),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular((8.0)),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '店铺名称',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ))),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: new TextField(
                      controller: realshopnamecontroller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      decoration: new InputDecoration(
                        hintText: '请输入',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xffa1a1a1)),
                      ),
                    ),
                  ))
            ]),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '联系地址',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ))),
              Expanded(
                flex: 3,
                child: InkWell(
                  child: Container(
                    child: Text(
                      address == '' ? '请选择' : address,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Color(0xffa1a1a1)),
                    ),
                  ),
                  onTap: () {
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
              )
            ]),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '详细地址',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ))),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: new TextField(
                      controller: addrcontroller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      decoration: new InputDecoration(
                        hintText: '请输入',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xffa1a1a1)),
                      ),
                    ),
                  ))
            ]),
          )
        ]),
      ),
    );

    Widget telArea = new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(210),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular((8.0)),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '联系电话',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ))),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: new TextField(
                      controller: phonecontroller,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      decoration: new InputDecoration(
                        hintText: '请输入',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xffa1a1a1)),
                      ),
                    ),
                  ))
            ]),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '电子邮箱',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ))),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: new TextField(
                      controller: emailcontroller,
                      // keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      decoration: new InputDecoration(
                        hintText: '请输入',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xffa1a1a1)),
                      ),
                    ),
                  ))
            ]),
          )
        ]),
      ),
    );

    Widget btnArea = BigButton(
      name: '下一步',
      tapFun: () {
        if (realshopnamecontroller.text == '') {
          ToastUtil.showToast('请输入店铺名称');
          return;
        }
        if (address == '') {
          ToastUtil.showToast('请选择店铺地址');
          return;
        }
        if (addrcontroller.text == '') {
          ToastUtil.showToast('请输入店铺详细地址');
          return;
        }
        if (phonecontroller.text == '') {
          ToastUtil.showToast('请输入联系电话');
          return;
        }
        if (!RegExpTest.checkPhone.hasMatch(phonecontroller.text)) {
          ToastUtil.showToast('电话号码格式错误');
          return;
        }
        if (emailcontroller.text == '') {
          ToastUtil.showToast('请输入电子邮箱');
          return;
        }
        if (!RegExpTest.checkEmail.hasMatch(emailcontroller.text)) {
          ToastUtil.showToast('邮箱格式错误');
          return;
        }
        Map obj = {
          "real_store_name": realshopnamecontroller.text,
          "contact_address": address,
          "img4": img4,
          "detail_address": addrcontroller.text,
          "phone": phonecontroller.text,
          "email": emailcontroller.text,
        };
        NavigatorUtils.toAuthenticationTwoPage(context, obj);
      },
      top: ScreenUtil().setWidth(40),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: new Container(
          alignment: Alignment.center,
          child: new ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              topArea,
              photo,
              inforArea,
              telArea,
              btnArea,
              new SizedBox(height: ScreenUtil().setWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}
