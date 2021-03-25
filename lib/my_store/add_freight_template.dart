import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../service/store_service.dart';
import '../widgets/loading.dart';
import '../widgets/choose_city.dart';
import './add_freight_template_build.dart';
import '../common/Global.dart';

class AddFreightPage extends StatefulWidget {
  final String id;
  AddFreightPage({this.id});
  @override
  _AddFreightPageState createState() => _AddFreightPageState();
}

class _AddFreightPageState extends State<AddFreightPage> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  String province = '';
  Map templateList = {};
  int index = 0;
  List city = [];
  Map mainCity = {};
  @override
  void initState() {
    city = Global.city;
    for (var j = 0; j < city.length; j++) {
      if (!mainCity.containsKey('all')) {
        mainCity['all'] = {};
      } else {
        mainCity['all'][j - 1] = {};
      }
    }
    if (widget.id != "null") {
      getDetails();
    }
    super.initState();
  }

  void getDetails() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.id);

    StoreServer().getFreightTempalteDetails(map, (success) async {
      setState(() {
        nameController.text = success['res']['name'];
        province = success['res']['province'];
        List proarr = success['res']['province'].split('/');
        for (var i = 0; i < proarr.length; i++) {
          for (var j = 0; j < city.length; j++) {
            if (proarr[i] == city[j]['name']) {
              mainCity['all'][j] = city[j];
            }
          }
        }
        var child = success['child'];
        for (var i = 0; i < child.length; i++) {
          if (!templateList.containsKey(i)) {
            templateList[i] = {};
          }
          templateList[i]['province'] = child[i]['province'];
          templateList[i]['only_price'] = child[i]['only_price'];
          templateList[i]['than_price'] = child[i]['than_price'];
          templateList[i]['limit'] = child[i]['limit'];
        }
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void configCity(citys, keys) {
    if (mainCity.containsKey(keys)) {
      mainCity.remove(keys);
    }
    mainCity[keys] = {};
    for (var i = 0; i < citys.length; i++) {
      if (mainCity[keys].containsKey(i)) {
        mainCity[keys].remove(i);
      }
      mainCity[keys][i] = {};
      if (citys[i]['flag'] && !citys[i]['isSelect']) {
        mainCity[keys][i] = citys[i];
      }
    }
    if (keys == 'all') {
      setState(() {
        province = '';
        mainCity['all'].forEach((key, item) {
          if (item.length != 0) {
            if (province == '') {
              province += item['name'];
            } else {
              province += '/' + item['name'];
            }
          }
        });
      });
    } else {
      setState(() {
        templateList[keys]['province'] = "";
        mainCity[keys].forEach((key, item) {
          if (item.length != 0) {
            if (templateList[keys]['province'] == "") {
              templateList[keys]['province'] += item['name'];
            } else {
              templateList[keys]['province'] += '/' + item['name'];
            }
          }
        });
      });
    }
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

  void saveConfig(List child) {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    if (widget.id != "null") {
      map.putIfAbsent("id", () => widget.id);
    }
    map.putIfAbsent("name", () => nameController.text);
    map.putIfAbsent("province", () => province);
    map.putIfAbsent("child", () => child);

    StoreServer().addFreightTempalte(map, widget.id, (success) async {
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget contentWidget = new Container(
      color: Colors.grey[100],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: ScreenUtil().setWidth(15)),
          Container(
            height: ScreenUtil().setWidth(120),
            decoration: BoxDecoration(
              color: PublicColor.whiteColor,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffefefef),
                ),
              ),
            ),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30),
            ),
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
          Container(
            decoration: BoxDecoration(
              color: PublicColor.whiteColor,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffefefef),
                ),
              ),
            ),
            alignment: Alignment.center,
            height: ScreenUtil().setWidth(120),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30),
              // top: ScreenUtil().setWidth(30),
              // bottom: ScreenUtil().setWidth(30),
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text('包邮省份'),
                ),
                Expanded(
                  flex: 8,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(300),
                          child: Text(
                            province == '' ? '未选择' : province,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: PublicColor.textColor,
                        ),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          builder: (BuildContext context) {
                            return ChooseCityWidget(
                              keys: "all",
                              city: city,
                              mainCity: mainCity,
                              configCity: configCity,
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: PublicColor.whiteColor,
              // border: Border(
              //   bottom: BorderSide(
              //     color: Color(0xffefefef),
              //   ),
              // ),
            ),
            alignment: Alignment.center,
            height: ScreenUtil().setWidth(120),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
              right: ScreenUtil().setWidth(30),
              // top: ScreenUtil().setWidth(30),
              // bottom: ScreenUtil().setWidth(30),
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text('计费模式'),
                ),
                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        child: Image.asset(
                          "assets/shop/ck.png",
                          width: ScreenUtil().setWidth(30),
                          height: ScreenUtil().setWidth(30),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text('按件计费'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget btn = Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
      child: InkWell(
        child: Text(
          '+ 添加自定义模板',
          style: TextStyle(
              color: PublicColor.themeColor, fontSize: ScreenUtil().setSp(35)),
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

    Widget templatebuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (templateList.length != 0) {
        templateList.forEach((key, value) {
          arr.add(AddFreightBuildPage(
            deleTemp: deleTemp,
            configCity: configCity,
            keys: key,
            template: value,
            city: city,
            mainCity: mainCity,
          ));
        });

        content = Column(children: arr);
      } else {
        content = Container();
      }
      return content;
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  title: new Text(
                    '新增运费模板',
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
                                child[i]['only_price'] == null ||
                                child[i]['than_price'] == null ||
                                child[i]['limit'] == null ||
                                child[i]['province'] == "" ||
                                child[i]['only_price'] == "" ||
                                child[i]['than_price'] == "" ||
                                child[i]['limit'] == "") {
                              ToastUtil.showToast('付费区域不能为空');
                              return;
                            }
                          }
                        }

                        saveConfig(child);
                      },
                    )
                  ]),
              body: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setWidth(20),
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30),
                    ),
                    color: Color(0xffFCDDB6),
                    child: Text(
                      '除包邮以及买家付邮区外，其他地区默认为不配送区域',
                      style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                    ),
                  ),
                  contentWidget,
                  templatebuild(),
                  btn,
                  SizedBox(height: ScreenUtil().setHeight(20))
                ],
              ),
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ));
  }
}
