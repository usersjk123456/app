import 'package:client/my_store/choose_freezl.dart';
import 'package:client/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/silde_button.dart';
import '../config/Navigator_util.dart';
import '../service/store_service.dart';
import '../widgets/dialog.dart';
import './choose_free.dart';

class FreeShippingPage extends StatefulWidget {
  final String type;
  FreeShippingPage({this.type});
  @override
  _FreeShippingPageState createState() => _FreeShippingPageState();
}

class _FreeShippingPageState extends State<FreeShippingPage> {
  List shopList = [];
  String freightId = "";
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

  void getList() {
    Map<String, dynamic> map = Map();
    StoreServer().getFreeShippingList(map, (success) async {
      setState(() {
        shopList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void delete() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => freightId);
    StoreServer().delFreeShippingList(map, (success) async {
      ToastUtil.showToast('删除成功');
      getList();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  Widget deleDjango(context) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        delete();
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: '确定删除该模板吗？',
    );
  }

  List<SlideButton> list;
  List<SlideButton> getSlides() {
    list = List<SlideButton>();
    for (var i = 0; i < shopList.length; i++) {
      var key = GlobalKey<SlideButtonState>();
      var slide = SlideButton(
        key: key,
        singleButtonWidth: ScreenUtil().setWidth(160),
        onSlideStarted: () {
          list.forEach((slide) {
            if (slide.key != key) {
              slide.key.currentState?.close();
            }
          });
        },
        child: Container(
          height: ScreenUtil().setWidth(120),
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
          ),
          decoration: BoxDecoration(
              color: PublicColor.whiteColor,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffefefef),
                ),
              )),
          child: InkWell(
            onTap: () {
              if (widget.type == "1") {
                Navigator.pop(context, shopList[i]);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    shopList[i]['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '···',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(60),
                        color: PublicColor.grewNoticeColor),
                  ),
                )
              ],
            ),
          ),
        ),
        buttons: <Widget>[
          buildAction(key, "编辑", Colors.amber, () {
            key.currentState.close();
            freightId = shopList[i]['id'];
            print('freightId-->>>$freightId');
            NavigatorUtils.goAddFreeShippingPage(context, "", freightId)
                .then((res) {
              getList();
            });
          }),
          buildAction(key, "删除", Colors.red, () {
            key.currentState.close();
            freightId = shopList[i]['id'];
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
        width: ScreenUtil().setWidth(160),
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
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(10)),
              Column(
                children: getSlides(),
              )
            ],
          ),
        ),
      ),
    );

    //List<SlideButton> list;

    Widget btnArea = new Container(
      width: ScreenUtil().setWidth(750),
      alignment: Alignment.center,
      child: BigButton(
        name: '+新增包邮模板',
        tapFun: () {
          showModalBottomSheet(
              context: context,
              isDismissible: false,
              builder: (BuildContext context) {
                return FreesWidget(getlist:getList);
              });
        },
        top: ScreenUtil().setWidth(10),
      ),
    );

    return Stack(children: <Widget>[
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text(
            '满包邮',
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
        body: shopList.length == 0
            ? Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/dianpu/zwsj.png',
                  width: ScreenUtil().setWidth(330),
                ),
              )
            : ListView(
                children: <Widget>[
                  addressArea,
                ],
              ),
        resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
      ),
      Positioned(bottom: ScreenUtil().setWidth(30), child: btnArea),
    ]);
  }
}
