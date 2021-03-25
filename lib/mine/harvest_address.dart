import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/dialog.dart';
import '../service/user_service.dart';

class HarvestAddressPage extends StatefulWidget {
  final String type;
  HarvestAddressPage({this.type});
  @override
  HarvestAddressPageState createState() => HarvestAddressPageState();
}

class HarvestAddressPageState extends State<HarvestAddressPage> {
  bool isLoading = false;
  String jwt = '', addressId = "";
  List addressList = [];
  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
    }
  }

  void getList() async {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    UserServer().getAddressList(map, (success) async {
      setState(() {
        // isLoading = false;
        addressList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void deleteAddrss() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => addressId);
    UserServer().delAddress(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('删除成功');
      getList();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget deleDjango(context) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        deleteAddrss();
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: '确定删除该地址吗？',
    );
  }

  List<SlideButton> list;
  List<SlideButton> getSlides() {
    list = List<SlideButton>();
    for (var i = 0; i < addressList.length; i++) {
      var key = GlobalKey<SlideButtonState>();
      var slide = SlideButton(
        key: key,
        singleButtonWidth: 80,
        onSlideStarted: () {
          list.forEach((slide) {
            if (slide.key != key) {
              slide.key.currentState?.close();
            }
          });
        },
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: Text(
              addressList[i]['name'] + '  ' + addressList[i]['phone'],
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(addressList[i]['province'] +
                addressList[i]['city'] +
                addressList[i]['region'] +
                addressList[i]['address']),
            trailing: addressList[i]['is_default'].toString() == "1"
                ? Container(
                    height: ScreenUtil().setHeight(38),
                    width: ScreenUtil().setWidth(75),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: PublicColor.themeColor, width: 1),
                    ),
                    child: Text(
                      '默认',
                      style: TextStyle(
                          color: PublicColor.themeColor,
                          fontSize: ScreenUtil().setSp(24),
                          height: 1.4),
                    ),
                  )
                : Text(''),
            onTap: () {
              if (widget.type == "1") {
                //订单页选择地址
                Navigator.pop(context, addressList[i]);
              }
            },
          ),
        ),
        buttons: <Widget>[
          buildAction(key, "编辑", Colors.amber, () {
            key.currentState.close();
            addressId = addressList[i]['id'].toString();
            // print('add-->>>${addressList[i]}');
            NavigatorUtils.goAddAddressPage(context, addressList[i])
                .then((res) => getList());
          }),
          buildAction(key, "删除", Colors.red, () {
            key.currentState.close();
            addressId = addressList[i]['id'].toString();
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return deleDjango(context);
                });
          }),
        ],
      );
      list.add(slide);
    }
    return list;
  }

  InkWell buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        color: color,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget addressArea = new Container(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: getSlides(),
          ),
        ),
      ),
    );

    Widget btnArea = new Container(
      height: ScreenUtil().setHeight(98),
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
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Text(
              '新增收货地址',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: Color(0xffe61414),
              ),
            ),
            onTap: () {
              NavigatorUtils.goAddAddressPage(context)
                  .then((result) => getList());
            },
          )
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: new Text(
                '收货地址',
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  addressArea,
                  btnArea,
                ],
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
