import 'package:client/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../common/upload_to_oss.dart';
import '../widgets/choose_type.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../my_store/up_img_build.dart';
import '../service/store_service.dart';
import '../config/Navigator_util.dart';

FocusNode _commentFocus = FocusNode();

class TianjiashangpinPage extends StatefulWidget {
  final oid;
  TianjiashangpinPage({this.oid});
  @override
  TianjiashangpinPageState createState() => TianjiashangpinPageState();
}

class TianjiashangpinPageState extends State<TianjiashangpinPage> {
  bool isLoading = false;
  String jwt = '';
  bool _value = false;
  bool _xgvalue = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _marketPriceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _xgnumController = TextEditingController();
  TextEditingController _commissionController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  List typeList = [];
  //商品分类
  Map shopType = {
    "id": 0,
    "name": "",
  };
  Map formate = {}; // 规格
  Map freight = {}; // 运费
  Map freeShipping = {}; // 满包邮
  Map shippingHourse = {}; // 发货仓
  String mainImg = ''; // 主图
  Map shopDesc = {"content": "", "desc": "", "detail_img": []}; //商品详情
  List imgList = []; //
  @override
  void initState() {
    super.initState();
    getShopTypeList();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    // _titleController.dispose();
    _priceController.clear();
    // _priceController.dispose();
    _marketPriceController.clear();
    // _marketPriceController.dispose();
    _stockController.clear();
    // _stockController.dispose();
    _xgnumController.clear();
    // _xgnumController.dispose();
  }

  void getShopDetails() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.oid);
    StoreServer().getShopDetails(map, (success) async {
      setState(() {
        _titleController.text = success['goods']['name'];
        mainImg = success['goods']['thumb'];
        _priceController.text = success['goods']['now_price'];
        _marketPriceController.text = success['goods']['old_price'];
        _commissionController.text = success['goods']['commission'];
        _unitController.text = success['goods']['unit'];
        _value = success['goods']['is_attr'] == 1 ? true : false;
        shopType['id'] = success['goods']['category_id'];
        freight['name'] = success['goods']['freight_name'];
        freight['id'] = success['goods']['freight_id'];
        freeShipping['name'] = success['goods']['post_name'];
        freeShipping['id'] = success['goods']['post_id'];
        shippingHourse['house_name'] = success['goods']['house_name'];
        shippingHourse['id'] = success['goods']['house_id'];
        formate['attr'] = success['attr'];
        formate['specs'] = success['specs'];
        for (var i = 0; i < typeList.length; i++) {
          if (shopType['id'] == typeList[i]['id']) {
            shopType['name'] = typeList[i]['name'];
          }
        }
        shopDesc['content'] = success['goods']['content'];
        shopDesc['desc'] = success['goods']['desc'];
        if (_value) {
        } else {
          _stockController.text = success['goods']['stock'].toString();
        }
        _xgvalue = success['goods']['is_limit'] == 1 ? true : false;
        if (_xgvalue) {
          _xgnumController.text = success['goods']['limit'].toString();
        }
        // 细节图
        if (success['banner_img'].length != 0) {
          for (var i = 0; i < success['banner_img'].length; i++) {
            imgList.add(success['banner_img'][i]['img']);
          }
        }

        // 详情图
        if (success['detail_img'].length != 0) {
          for (var i = 0; i < success['detail_img'].length; i++) {
            shopDesc['detail_img'].add(success['detail_img'][i]['img']);
          }
        }
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getShopTypeList() async {
    Map<String, dynamic> map = Map();

    StoreServer().getStorGoodsTypeList(map, (success) async {
      setState(() {
        typeList = success['list'];
      });
      if (widget.oid.toString() != 'null') {
        getShopDetails();
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
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

  void createShop() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    if (widget.oid.toString() != "null") {
      map.putIfAbsent("id", () => widget.oid);
    }
    map.putIfAbsent("name", () => _titleController.text);
    map.putIfAbsent("unit", () => _unitController.text); //单位
    map.putIfAbsent("category_id", () => shopType['id']);
    map.putIfAbsent("stock", () => _stockController.text);
    map.putIfAbsent("is_attr", () => _value ? "1" : "0");
    map.putIfAbsent("now_price", () => _priceController.text);
    map.putIfAbsent("old_price", () => _marketPriceController.text);
    map.putIfAbsent("commission", () => int.parse(_commissionController.text));
    map.putIfAbsent("content", () => shopDesc['content']);
    map.putIfAbsent("desc", () => shopDesc['desc']);
    map.putIfAbsent("freight_id", () => freight['id']);
    map.putIfAbsent("post_id", () => freeShipping['id']);
    map.putIfAbsent("house_id", () => shippingHourse['id']);
    map.putIfAbsent("is_limit", () => _xgvalue ? "1" : "0");
    map.putIfAbsent("limit", () => _xgnumController.text);
    map.putIfAbsent("specs", () => formate['specs']);
    map.putIfAbsent("attr", () => formate['attr']);
    map.putIfAbsent("detail_img", () => shopDesc['detail_img']);
    map.putIfAbsent("thumb", () => mainImg);
    map.putIfAbsent("banner_img", () => imgList);

    StoreServer().createshop(map, widget.oid, (success) async {
      ToastUtil.showToast('上架成功');
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: new Text(
                  '添加商品',
                  style: new TextStyle(
                    color: PublicColor.headerTextColor,
                  ),
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
              body: contentWidget(),
              resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ));
  }

  Widget contentWidget() {
    return Stack(children: <Widget>[
      Container(
        color: Color(0xfff5f5f5),
        padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setWidth(30),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '商品标题',
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                  ),
                  child: TextField(
                    focusNode: _commentFocus,
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: '请输入商品标题',
                      hintStyle: new TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(28.0)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                  ),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: ScreenUtil().setWidth(180),
                          height: ScreenUtil().setWidth(180),
                          child: mainImg == ''
                              ? Image.asset(
                                  'assets/shop/addimg.png',
                                  fit: BoxFit.contain,
                                )
                              : Image.network(
                                  mainImg,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        onTap: () async {
                          Map obj = await openGallery("image", changeLoading);
                          if (obj == null) {
                            changeLoading(type: 2, sent: 0, total: 0);
                            return;
                          }
                          if (obj['errcode'] == 0) {
                            mainImg = obj['url'];
                          } else {
                            ToastUtil.showToast(obj['msg']);
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        child: Container(
                            width: ScreenUtil().setWidth(180),
                            height: ScreenUtil().setWidth(180),
                            child: Image.asset('assets/shop/addimg1.png',
                                fit: BoxFit.cover)),
                        onTap: () async {
                          Map obj = await openGallery("image", changeLoading);
                          if (obj == null) {
                            changeLoading(type: 2, sent: 0, total: 0);
                            return;
                          }
                          if (obj['errcode'] == 0) {
                            imgList.insert(imgList.length, obj['url']);
                          } else {
                            ToastUtil.showToast(obj['msg']);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(30),
                  ),
                  alignment: Alignment.topLeft,
                  child: BuildImg(
                    imgList: imgList,
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(30),
                      top: ScreenUtil().setWidth(30),
                      bottom: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffdddddd),
                        ),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '商品仅在直播间展示,图片格式仅支持.jpeg和.png,请上传750*360px大小的图',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: PublicColor.grewNoticeColor,
                      ),
                    )),
                Container(
                  padding: EdgeInsets.all(
                    ScreenUtil().setWidth(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '商品分类',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                      InkWell(
                        child: Row(
                          children: <Widget>[
                            Text(
                              shopType['name'] == '' ? '请选择' : shopType['name'],
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                color: shopType['name'] == ''
                                    ? PublicColor.grewNoticeColor
                                    : Colors.red,
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
                                    title: "商品分类",
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
                )
              ]),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: PublicColor.whiteColor,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xffdddddd),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '多规格',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                      Switch(
                        value: _value,
                        onChanged: (newValue) {
                          setState(() {
                            _value = newValue;
                          });
                        },
                        activeTrackColor: Color(0xfffed919),
                        activeColor: Color(0xfffed919),
                        inactiveThumbColor: Color(0xfff5f5f5),
                        inactiveTrackColor: Color(0xfff5f5f5),
                      )
                    ],
                  ),
                ),
                _value
                    ? Container(
                        decoration: BoxDecoration(
                          color: PublicColor.whiteColor,
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffdddddd),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(
                          ScreenUtil().setWidth(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '添加规格',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                            InkWell(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    formate.containsKey('attr') &&
                                            formate['attr'].length != 0
                                        ? '已添加'
                                        : '未添加',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      color: formate.containsKey('attr') &&
                                              formate['attr'].length != 0
                                          ? Colors.red
                                          : PublicColor.grewNoticeColor,
                                    ),
                                  ),
                                  new Icon(
                                    Icons.navigate_next,
                                    color: PublicColor.grewNoticeColor,
                                  )
                                ],
                              ),
                              onTap: () {
                                NavigatorUtils.goAddShopFormate(
                                        context, formate)
                                    .then((result) {
                                  if (result != null) {
                                    setState(() {
                                      formate = result;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  decoration: BoxDecoration(
                    color: PublicColor.whiteColor,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xffdddddd),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '价格',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(400),
                        child: TextField(
                          controller: _priceController,
                          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '为自己的商品设置合适的价格',
                            hintStyle: new TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(28.0)),
                            border: InputBorder.none,
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
                        color: Color(0xffdddddd),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '市场价',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(350),
                        child: TextField(
                          controller: _marketPriceController,
                          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '请输入市场价',
                            hintStyle: new TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(28.0)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _value
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          color: PublicColor.whiteColor,
                        ),
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(30),
                          top: ScreenUtil().setWidth(10),
                          bottom: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '库存',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(350),
                              child: TextField(
                                controller: _stockController,
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(28)),
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '设置合适的库存避免超卖',
                                  hintStyle: new TextStyle(
                                      fontSize:
                                          ScreenUtil.instance.setWidth(28.0)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),
            Container(
              decoration: BoxDecoration(
                color: PublicColor.whiteColor,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffdddddd),
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                top: ScreenUtil().setWidth(10),
                bottom: ScreenUtil().setWidth(10),
                right: ScreenUtil().setWidth(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '佣金',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(350),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _commissionController,
                            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '请输入佣金',
                              hintStyle: new TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text('%'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: PublicColor.whiteColor,
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                top: ScreenUtil().setWidth(10),
                bottom: ScreenUtil().setWidth(10),
                right: ScreenUtil().setWidth(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '单位',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(350),
                    child: TextField(
                      controller: _unitController,
                      style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: '请输入单位',
                        hintStyle: new TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(28.0)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),
            Container(
              color: PublicColor.whiteColor,
              padding: EdgeInsets.all(
                ScreenUtil().setWidth(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '商品详情',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(300),
                          alignment: Alignment.centerRight,
                          child: Text(
                            shopDesc['content'] == ''
                                ? '未添加'
                                : shopDesc['content'],
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: shopDesc['content'] == ''
                                  ? PublicColor.grewNoticeColor
                                  : Colors.red,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        new Icon(
                          Icons.navigate_next,
                          color: PublicColor.grewNoticeColor,
                        )
                      ],
                    ),
                    onTap: () {
                      NavigatorUtils.goAddShopDetails(context, shopDesc)
                          .then((result) {
                        if (result != null) {
                          setState(() {
                            shopDesc = result;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: PublicColor.whiteColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffdddddd),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(
                      ScreenUtil().setWidth(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '运费模板',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Text(
                                freight.containsKey('name')
                                    ? freight['name']
                                    : '未添加',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: freight.containsKey('name')
                                      ? Colors.red
                                      : PublicColor.grewNoticeColor,
                                ),
                              ),
                              new Icon(
                                Icons.navigate_next,
                                color: PublicColor.grewNoticeColor,
                              )
                            ],
                          ),
                          onTap: () {
                            NavigatorUtils.goYunfeimobanPage(context, "1")
                                .then((result) {
                              if (result != null) {
                                setState(() {
                                  freight = result;
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: PublicColor.whiteColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffdddddd),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(
                      ScreenUtil().setWidth(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '满包邮',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Text(
                                freeShipping.containsKey('name')
                                    ? freeShipping['name']
                                    : '未添加',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: freeShipping.containsKey('name')
                                      ? Colors.red
                                      : PublicColor.grewNoticeColor,
                                ),
                              ),
                              new Icon(
                                Icons.navigate_next,
                                color: PublicColor.grewNoticeColor,
                              )
                            ],
                          ),
                          onTap: () {
                            NavigatorUtils.goFreeShippingPage(context, "1")
                                .then((result) {
                              if (result != null) {
                                setState(() {
                                  freeShipping = result;
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: PublicColor.whiteColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffdddddd),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(
                      ScreenUtil().setWidth(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '发货仓',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Text(
                                shippingHourse.containsKey('house_name')
                                    ? shippingHourse['house_name']
                                    : '未添加',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color:
                                      shippingHourse.containsKey('house_name')
                                          ? Colors.red
                                          : PublicColor.grewNoticeColor,
                                ),
                              ),
                              new Icon(
                                Icons.navigate_next,
                                color: PublicColor.grewNoticeColor,
                              )
                            ],
                          ),
                          onTap: () {
                            NavigatorUtils.goShippingHoursePage(context, "1")
                                .then((result) {
                              if (result != null) {
                                setState(() {
                                  shippingHourse = result;
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: PublicColor.whiteColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffdddddd),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '限购',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                        Switch(
                          value: _xgvalue,
                          onChanged: (newValue) {
                            setState(() {
                              _xgvalue = newValue;
                            });
                          },
                          activeTrackColor: Color(0xfffed919),
                          activeColor: Color(0xfffed919),
                          inactiveThumbColor: Color(0xfff5f5f5),
                          inactiveTrackColor: Color(0xfff5f5f5),
                        )
                      ],
                    ),
                  ),
                  _xgvalue
                      ? Container(
                          decoration: BoxDecoration(
                            color: PublicColor.whiteColor,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffdddddd),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(30),
                            top: ScreenUtil().setWidth(10),
                            bottom: ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '设置每人限购数量',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(400),
                                child: TextField(
                                  controller: _xgnumController,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28)),
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '请输入，单位：件',
                                    hintStyle: new TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setWidth(28.0)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            BigButton(
              name: '立即上架',
              tapFun: () {
                print('立即上架');
                if (_titleController.text == '') {
                  ToastUtil.showToast('请输入商品标题');
                  return;
                }
                if (mainImg == '') {
                  ToastUtil.showToast('请上传商品主图');
                  return;
                }
                if (shopType['name'] == '') {
                  ToastUtil.showToast('请选择商品分类');
                  return;
                }
                if (_value) {
                  if (!formate.containsKey('attr')) {
                    ToastUtil.showToast('请添加商品规格');
                    return;
                  }
                } else {
                  if (_stockController.text == '') {
                    ToastUtil.showToast('请输入商品库存');
                    return;
                  }
                }
                if (_priceController.text == '') {
                  ToastUtil.showToast('请输入商品价格');
                  return;
                }
                if (_marketPriceController.text == '') {
                  ToastUtil.showToast('请输入市场价');
                  return;
                }
                if (_commissionController.text == '') {
                  ToastUtil.showToast('请输入佣金');
                  return;
                }
                if (_unitController.text == '') {
                  ToastUtil.showToast('请输入单位');
                  return;
                }
                if (shopDesc['content'] == '') {
                  ToastUtil.showToast('请设置商品详情');
                  return;
                }
                if (!freight.containsKey('name')) {
                  ToastUtil.showToast('请设置运费模板');
                  return;
                }
                // if (_marketPriceController.text == '') {
                //   ToastUtil.showToast('请设置满包邮');
                //   return;
                // }
                if (!shippingHourse.containsKey('house_name')) {
                  ToastUtil.showToast('请设置发货仓');
                  return;
                }
                if (_xgvalue) {
                  if (_xgnumController.text == '') {
                    ToastUtil.showToast('请输入限购数量');
                    return;
                  }
                }
                createShop();
              },
              top: ScreenUtil().setWidth(50),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(40),
            ),
          ],
        ),
      )
    ]);
  }
}
