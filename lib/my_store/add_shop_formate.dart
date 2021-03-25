import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../common/regExp.dart';
import '../config/fluro_convert_util.dart';
import './add_shop_formate_build.dart';

class AddShopFormatePage extends StatefulWidget {
  final String objs;
  AddShopFormatePage({this.objs});
  @override
  _AddShopFormatePageState createState() => _AddShopFormatePageState();
}

class _AddShopFormatePageState extends State<AddShopFormatePage> {
  bool isAdd = true;
  bool isLoading = false;
  List formate1 = [];
  List formate2 = [];
  Map formate = {};
  List shopList = [];
  Map obj = {};
  TextEditingController formateController1 = TextEditingController();
  TextEditingController formateController2 = TextEditingController();

  @override
  void initState() {
    obj = FluroConvertUtils.string2map(widget.objs);
    print('obj--->>>$obj');
    if (obj.containsKey('attr')) {
      setState(() {
        if (obj['attr'].length != 0) {
          formate = obj['attr'];
        }
        if (obj["specs"][0].length != 0) {
          formate1 = obj["specs"][0];
          print('formate1--->>>$formate1');
          String name = "";
          for (var i = 0; i < obj["specs"][0].length; i++) {
            if (i == obj["specs"][0].length - 1) {
              name += obj["specs"][0][i];
            } else {
              name += obj["specs"][0][i] + ';';
            }
          }
          formateController1.text = name;
        }
        if (obj["specs"][1].length != 0) {
          formate2 = obj["specs"][1];
          isAdd = false;
          String name = "";
          for (var i = 0; i < obj["specs"][1].length; i++) {
            if (i == obj["specs"][1].length - 1) {
              name += obj["specs"][1][i];
            } else {
              name += obj["specs"][1][i] + ';';
            }
          }
          formateController2.text = name;
        }
      });
    }

    super.initState();
  }

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

  void upImgLoad(obj, index) async {
    if (obj['errcode'] == 0) {
      setState(() {
        formate[index]['img'] = obj['url'];
      });
    } else {
      ToastUtil.showToast(obj['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget shopDetailsCon = Container(
      height: ScreenUtil().setWidth(90),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
        border: Border.all(color: Color(0xffeeeeee), width: 1),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: TextField(
              controller: formateController1,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入规格，用英文分号隔开，如红色;绿色",
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isAdd = !isAdd;
              });
            },
            child: Container(
              width: ScreenUtil().setWidth(90),
              height: ScreenUtil().setWidth(90),
              decoration: BoxDecoration(
                color: PublicColor.themeColor,
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
              ),
              child: Center(
                child: Text(
                  isAdd ? '+' : '-',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(70),
                    color: PublicColor.whiteColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

    Widget shopDetailsCon2 = Container(
      height: ScreenUtil().setWidth(90),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
        border: Border.all(color: Color(0xffeeeeee), width: 1),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: TextField(
              controller: formateController2,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入规格，用英文分号隔开，如红色;绿色",
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isAdd = true;
                formate2.clear();
                formateController2.text = "";
              });
            },
            child: Container(
              width: ScreenUtil().setWidth(90),
              height: ScreenUtil().setWidth(90),
              decoration: BoxDecoration(
                color: PublicColor.themeColor,
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
              ),
              child: Center(
                child: Text(
                  '-',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(70),
                    color: PublicColor.whiteColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

    Widget createBtn = Container(
      alignment: Alignment.centerRight,
      child: Container(
        height: ScreenUtil().setWidth(60),
        width: ScreenUtil().setWidth(200),
        decoration: BoxDecoration(
            color: PublicColor.themeColor,
            borderRadius: new BorderRadius.circular((8.0))),
        child: new FlatButton(
          disabledColor: PublicColor.grewNoticeColor,
          onPressed: () {
            if (formateController1.text == '') {
              ToastUtil.showToast('请输入商品规格');
              return;
            }
            if (!RegExpTest.checkformate.hasMatch(formateController1.text)) {
              ToastUtil.showToast('商品规格格式错误');
              return;
            }
            if (formateController2.text != '') {
              if (!RegExpTest.checkformate.hasMatch(formateController2.text)) {
                ToastUtil.showToast('商品规格格式错误');
                return;
              }
            }

            setState(() {
              formate1.clear();
              formate2.clear();
              formate.clear();
              formate1 = formateController1.text.split(';');
              if (formateController2.text != '') {
                formate2 = formateController2.text.split(';');
              } else {
                formate2 = [];
              }
            });
          },
          child: new Text(
            '生成',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    Widget formateBuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (formate1.length == 0) {
        arr.add(Container());
      } else {
        shopList.clear();
        for (var i = 0; i < formate1.length; i++) {
          if (formate2.length == 0) {
            if (formate1[i] != '') {
              shopList.add(formate1[i]);
            }
          } else {
            for (var j = 0; j < formate2.length; j++) {
              if (formate1[i] != '' && formate2[j] != '') {
                shopList.add(formate1[i] + '/' + formate2[j]);
              }
            }
          }
        }
        print("shopList--->>>$shopList");
        for (var i = 0; i < shopList.length; i++) {
          if (!formate.containsKey(shopList[i])) {
            formate[shopList[i]] = {};
          }
          // formate[i]['name'] = shopList[i];
          print('formate----->>>>>$formate');
          arr.add(AddShopFormateBuildPage(
            formate: formate,
            formateKey: shopList[i],
            index: i,
            changeLoading: changeLoading,
            upImgLoad: upImgLoad,
          ));
        }
      }
      content = Column(children: arr);
      return content;
    }

    Widget bottomBtn = Container(
      margin: EdgeInsets.only(top: 20, bottom: 30),
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setWidth(95),
        width: ScreenUtil().setWidth(640),
        decoration: BoxDecoration(
            color: PublicColor.themeColor,
            borderRadius: new BorderRadius.circular((8.0))),
        child: new FlatButton(
          disabledColor: PublicColor.grewNoticeColor,
          onPressed: () {
            if (shopList.length == 0) {
              ToastUtil.showToast('暂未生成规格');
              return;
            } else {
              for (var i = 0; i < shopList.length; i++) {
                if (formate[shopList[i]]['price'] == null ||
                    formate[shopList[i]]['stock'] == null ||
                    formate[shopList[i]]['img'] == null) {
                  ToastUtil.showToast('请填写完整规格');
                  return;
                }
              }
            }
            List forList = [];
            List formate1List = formateController1.text.split(';');
            List formate2List = formateController2.text.split(';');
            if (formate1List.length != 0) {
              formate1List.removeWhere((item) => item == '');
              forList.insert(0, formate1List);
            }
            if (formate2List.length != 0) {
              formate2List.removeWhere((item) => item == '');
              forList.insert(1, formate2List);
            }
            Map obj = {
              "specs": forList,
              "attr": formate,
            };
            Navigator.pop(context, obj);
          },
          child: new Text(
            '完成',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );

    return MaterialApp(
        title: "添加商品规格",
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: <Widget>[
            Scaffold(
              resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
              appBar: AppBar(
                elevation: 0,
                title: new Text(
                  '添加商品规格',
                  style: new TextStyle(
                    color: PublicColor.textColor,
                  ),
                ),
                backgroundColor: PublicColor.themeColor,
                centerTitle: true,
                leading: new IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    color: PublicColor.textColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: new Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                color: PublicColor.bodyColor,
                child: new ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                      decoration: BoxDecoration(
                        color: PublicColor.whiteColor,
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(15)),
                        border: Border.all(color: Color(0xffe5e5e5), width: 1),
                      ),
                      child: Column(
                        children: <Widget>[
                          shopDetailsCon,
                          !isAdd
                              ? SizedBox(height: ScreenUtil().setWidth(10))
                              : Container(),
                          !isAdd ? shopDetailsCon2 : Container(),
                          SizedBox(height: ScreenUtil().setWidth(20)),
                          createBtn,
                          SizedBox(height: ScreenUtil().setWidth(30)),
                          // formateWidget,
                          formateBuild()
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(80)),
                    bottomBtn,
                  ],
                ),
              ),
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ));
  }
}
