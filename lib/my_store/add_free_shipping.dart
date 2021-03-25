import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './add_free_shipping_build.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../common/Global.dart';

class AddFreeShippingPage extends StatefulWidget {
  final String type;
  final String oid;
  AddFreeShippingPage({this.type, this.oid});
  @override
  _AddFreeShippingPageState createState() => _AddFreeShippingPageState();
}

class _AddFreeShippingPageState extends State<AddFreeShippingPage> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  String type = '';
  Map templateList = {};
  int index = 1;
  List city = [];
  Map mainCity = {};
  @override
  void initState() {
    city = Global.city;
    super.initState();
    if (widget.oid != "null") {
      getDetails();
    } else {
      setState(() {
        type = widget.type;
        templateList[0] = {};
      });
    }
  }

  void getDetails() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);

    StoreServer().getFreeShippingDetails(map, (success) async {
      setState(() {
        nameController.text = success['res']['name'];
        type = success['res']['type'].toString();
        var child = success['child'];
        for (var i = 0; i < child.length; i++) {
          if (!templateList.containsKey(i)) {
            templateList[i] = {};
          }
          templateList[i]['province'] = child[i]['province'];
          templateList[i]['num'] = child[i]['num'];
        }
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void saveConfig(List child) {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    if (widget.oid != "null") {
      map.putIfAbsent("id", () => widget.oid);
    }
    map.putIfAbsent("type", () => type);
    map.putIfAbsent("name", () => nameController.text);
    map.putIfAbsent("child", () => child);

    StoreServer().addFreeShipping(map, widget.oid, (success) async {
      ToastUtil.showToast('保存成功');
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

  void deleTemp(index) {
    setState(() {
      templateList.remove(index);
      if (mainCity.length != 0) {
        mainCity[index].forEach((keyc, itemc) {
          if (itemc['name'] == city[keyc]['name']) {
            city[keyc]['flag'] = false;
            city[keyc]['isSelect'] = false;
          }
        });
        mainCity.remove(index);
      }
    });
  }

  @override
  void dispose() {
    mainCity.clear();
    for (var i = 0; i < city.length; i++) {
      city[i]['flag'] = false;
      city[i]['isSelect'] = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget btn = Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
      child: InkWell(
        child: Text(
          '+ 新增满包邮模板',
          style: TextStyle(
              color: PublicColor.redColor, fontSize: ScreenUtil().setSp(35)),
        ),
        onTap: () {
          setState(() {
            if (!templateList.containsKey(index)) {
              templateList[index] = {};
            }
            index++;
          });
        },
      ),
    );

    Widget freebuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      print('templateList--->>>>>>$templateList');
      if (templateList.length != 0) {
        templateList.forEach((key, value) {
          arr.add(AddFreeBuildPage(
            type: type,
            templateList: templateList,
            keys: key,
            template: value,
            mainCity: mainCity,
            city: city,
            deleTemp: deleTemp,
          ));
        });
        content = Column(children: arr);
      } else {
        content = Container();
      }
      return content;
    }

    Widget contentWidget = ListView(
      children: <Widget>[
        new Container(
          color: Colors.grey[100],
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setWidth(15)),
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
                      child: Text('模板名称'),
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
                          hintText: "请输入模板名称",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              freebuild(),
              btn,
              SizedBox(height: ScreenUtil().setHeight(20)),
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
                    '新增包邮',
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
                            '保存',
                            style: new TextStyle(
                              color: PublicColor.headerTextColor,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          )),
                      onTap: () {
                        if (nameController.text == '') {
                          ToastUtil.showToast('请输入模板名称');
                          return;
                        }
                        List child = [];
                        if (templateList.length != 0) {
                          templateList.forEach((key, item) {
                            child.add(item);
                          });
                        }
                        print(child);
                        if (child.length != 0) {
                          for (var i = 0; i < child.length; i++) {
                            if (child[i]['province'] == null ||
                                child[i]['num'] == null ||
                                child[i]['province'] == "" ||
                                child[i]['num'] == "") {
                              ToastUtil.showToast('包邮区域不能为空');
                              return;
                            }
                          }
                        }
                        saveConfig(child);
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
