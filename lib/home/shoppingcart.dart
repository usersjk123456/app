import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/checkbox.dart';
import '../widgets/cached_image.dart';
import '../widgets/dialog.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../common/color.dart';
import '../service/goods_service.dart';

class ShoppingCart extends StatefulWidget {
  @override
  ShoppingCartState createState() => ShoppingCartState();
}

class ShoppingCartState extends State<ShoppingCart>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  bool isbianji = true;
  String jwt = '';
  List cars = [];
  List buy = [];
  List listview = [];
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
    cars = [];
    Map<String, dynamic> map = Map();
    // map.putIfAbsent("phone", () => _phoneController.text);

    GoodsServer().getCartList(map, (success) async {
      var list = success['list'];
      for (var i = 0; i < list.length; i++) {
        for (var j = 0; j < list[i]['list'].length; j++) {
          list[i]['list'][j]['check'] = false;
        }
      }
      setState(() {
        listview = list;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  //修改购物车数量
  void changeNumCar(type, id, nums, item) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("cart_id", () => id);
    map.putIfAbsent("num", () => nums);

    GoodsServer().changeCartNum(map, (success) async {
      if (type == "1") {
        setState(() {
          item['num'] = item['num'] - 1;
          _getallamount();
        });
      } else {
        setState(() {
          item['num'] = item['num'] + 1;
          if (item['num'] > 99) {
            item['num'] = '99+';
          }
          _getallamount();
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void delCart() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("cart_id", () => cars);

    GoodsServer().delCart(map, (success) async {
      setState(() {
        isloading = false;
      });
      getList();
      for (var i = 0; i < listview.length; i++) {
        for (var j = 0; j < listview[i]['list'].length; j++) {
          listview[i]['list'][j]['check'] = false;
        }
      }
    }, (onFail) async {
      setState(() {
        isloading = false;
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
    return Scaffold(
        appBar: new AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            '购物车',
            style: TextStyle(
              color: PublicColor.headerTextColor,
              fontSize: ScreenUtil.instance.setWidth(30.0),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: PublicColor.linearHeader,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: PublicColor.headerTextColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            listview.length != 0
                ? MaterialButton(
                    child: Text(
                      isbianji ? '编辑' : '完成',
                      style: TextStyle(
                        color: Color(0xff493900),
                        fontSize: ScreenUtil.instance.setWidth(30.0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isbianji = !isbianji;
                      });
                    })
                : Container(),
          ],
        ),
        body: contentWidget());
  }

  _checkCart(bool isCheck, int listindex, int index) {
    setState(() {
      listview[listindex]['list'][index]['check'] = isCheck;
    });
  }

  //删除
  _getItemId() async {
    cars = [];
    int index = 0;
    int leng = 0;
    for (var i = 0; i < listview.length; i++) {
      for (var j = 0; j < listview[i]['list'].length; j++) {
        leng++;
        if (listview[i]['list'][j]['check']) {
          var id = listview[i]['list'][j]['cart_id'];
          cars.add(id);
        } else {
          index++;
        }
      }
    }
    if (index == leng) {
      ToastUtil.showToast('请选择商品');
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyDialog(
              width: ScreenUtil.instance.setWidth(600.0),
              height: ScreenUtil.instance.setWidth(300.0),
              queding: () async {
                Navigator.of(context).pop();
                delCart();
              },
              quxiao: () {
                Navigator.of(context).pop();
              },
              title: '温馨提示',
              message: '确定删除该商品吗？');
        });
  }

//结算
  _getjiesuan() async {
    List list = listview;
    int k = 0;
    int n = 0;
    for (var i = 0; i < list.length; i++) {
      for (var j = 0; j < list[i]['list'].length; j++) {
        n++;
        if (list[i]['list'][j]['check'] == false) {
          k++;
        }
      }
    }
    if (n == k) {
      ToastUtil.showToast('请选择商品');
    } else {
      for (var i = 0; i < list.length; i++) {
        list[i]['list'].removeWhere((item) => item['check'] == false);
      }
      list.removeWhere((item) => item['list'].length == 0);
      Map obj = {"list": list};
      NavigatorUtils.toTijiaoDingdan(context, obj);
    }
  }

  _getallamount() {
    double amount = 0;
    for (var i = 0; i < listview.length; i++) {
      for (var j = 0; j < listview[i]['list'].length; j++) {
        if (listview[i]['list'][j]['check']) {
          int shuliang = listview[i]['list'][j]['num'];
          double price = double.parse(listview[i]['list'][j]['now_price']);
          amount += price * shuliang;
        }
      }
    }
    return amount;
  }

  bool _checkedAllbyindex(int index) {
    var list = listview[index]['list'];
    for (var i = 0; i < list.length; i++) {
      if (list[i]['check'] == null || !list[i]['check']) {
        return false;
      }
    }
    return true;
  }

  bool _checkedAll() {
    for (var i = 0; i < listview.length; i++) {
      var list = listview[i]['list'];
      for (var j = 0; j < list.length; j++) {
        if (list[j]['check'] == null || !list[j]['check']) {
          return false;
        }
      }
    }
    return true;
  }

  _checkedAllitem(bool isCheck) {
    for (var i = 0; i < listview.length; i++) {
      var list = listview[i]['list'];
      for (var j = 0; j < list.length; j++) {
        listview[i]['list'][j]['check'] = isCheck;
      }
    }
  }

  _checkedAllitembyindex(bool isCheck, int index) {
    var list = listview[index]['list'];
    for (var j = 0; j < list.length; j++) {
      listview[index]['list'][j]['check'] = isCheck;
    }
  }

  List<Widget> listBoxs(listView, check, listindex) =>
      List.generate(listView.length, (index) {
        return Container(
          width: ScreenUtil.instance.setWidth(700),
          height: ScreenUtil.instance.setWidth(260),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: Border(
              top: BorderSide(color: Color(0xfffececec), width: 1),
            ),
          ),
          child: new Row(
            children: <Widget>[
              RoundCheckBox(
                value: check[index]['check'],
                onChanged: (bool) {
                  _checkCart(bool, listindex, index);
                },
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    String oid = (listView[index]['id']).toString();
                    String shipId = (listView[index]['ship_id']).toString();
                    String roomId = (listView[index]['room_id']).toString();
                    NavigatorUtils.toXiangQing(context, oid, shipId, roomId);
                  },
                  child: CachedImageView(
                      ScreenUtil.instance.setWidth(204.0),
                      ScreenUtil.instance.setWidth(204.0),
                      listView[index]['thumb'],
                      null,
                      BorderRadius.all(Radius.circular(0))),
                ),
              ),
              new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
              Container(
                width: ScreenUtil.instance.setWidth(380.0),
                padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(16),
                ),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listView[index]['name'].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Color(0xfff333333),
                          fontSize: ScreenUtil.instance.setWidth(28.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      listView[index].containsKey('attr_name')
                          ? Text(
                              listView[index]['attr_name'],
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil.instance.setWidth(25.0),
                              ),
                            )
                          : Container(),
                      SizedBox(height: ScreenUtil.instance.setWidth(5.0)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: ScreenUtil.instance.setWidth(210.0),
                              height: ScreenUtil.instance.setWidth(75.0),
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: '￥' +
                                        listView[index]['now_price']
                                            .toString() +
                                        ' ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize:
                                            ScreenUtil.instance.setWidth(27.0)),
                                    children: [
                                      TextSpan(
                                          text: '￥' +
                                              listView[index]['old_price']
                                                  .toString(),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Color(0xfffcccccc),
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(27.0))),
                                    ]),
                              ),
                            ),
                            Container(
                              width: ScreenUtil.instance.setWidth(150.0),
                              height: ScreenUtil.instance.setWidth(50.0),
                              alignment: Alignment.bottomRight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                border: new Border.all(
                                    color: Color(0xfffcccccc), width: 0.5),
                              ),
                              child: Row(children: [
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: new ShapeDecoration(
                                        shape: Border(
                                          right: BorderSide(
                                              color: Color(0xfffececec),
                                              width: 1),
                                        ), // 边色与边宽度
                                      ),
                                      child: Text('-'),
                                    ),
                                    onTap: () {
                                      if (listView[index]['num'] <= 1) {
                                        return;
                                      }
                                      changeNumCar(
                                        "1",
                                        listView[index]['cart_id'],
                                        listView[index]['num'] - 1,
                                        listView[index],
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          listView[index]['num'].toString()),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: new ShapeDecoration(
                                        shape: Border(
                                          left: BorderSide(
                                              color: Color(0xfffececec),
                                              width: 1),
                                        ), // 边色与��宽度
                                      ),
                                      child: Text('+'),
                                    ),
                                    onTap: () {
                                      changeNumCar(
                                        "2",
                                        listView[index]['cart_id'],
                                        listView[index]['num'] + 1,
                                        listView[index],
                                      );
                                    },
                                  ),
                                ),
                              ]),
                            )
                          ])
                    ]),
              )
            ],
          ),
        );
      });

  Widget gouwuitem(BuildContext context, item, index) {
    return Container(
      child: new Column(children: [
        new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: new Border.all(color: Color(0xfffececec), width: 0.5),
          ),
          child: Column(children: [
            Container(
              height: ScreenUtil.getInstance().setWidth(80.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                RoundCheckBox(
                    value: _checkedAllbyindex(index),
                    onChanged: (bool) {
                      setState(() {
                        _checkedAllitembyindex(bool, index);
                      });
                    }),
                Image.asset(
                  'assets/index/dp2.png',
                  width: ScreenUtil.instance.setWidth(32.0),
                ),
                SizedBox(width: ScreenUtil.instance.setWidth(8.0)),
                Text(
                  item['title'] != null ? item['title'] : '',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: ScreenUtil.instance.setWidth(28.0),
                      fontWeight: FontWeight.bold),
                )
              ]),
            ),
            Column(
              children: listBoxs(item['list'], listview[index]['list'], index),
            )
          ]),
        ),
      ]),
    );
  }

  Widget contentWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        listview.length != 0
            ? Container(
                width: ScreenUtil.getInstance().setWidth(700.0),
                margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(110)),
                child: ListView.builder(
                    itemCount: listview.length,
                    itemBuilder: (BuildContext context, int index) {
                      return gouwuitem(context, listview[index], index);
                    }))
            : ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(277.5),
                      left: ScreenUtil().setWidth(177.5),
                      right: ScreenUtil().setWidth(177.5),
                    ),
                    child: Image.asset(
                      "assets/index/gwcno.png",
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
        listview.length != 0
            ? Container(
                height: ScreenUtil.instance.setWidth(100.0),
                decoration: ShapeDecoration(
                  shape: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: <Widget>[
                        RoundCheckBox(
                          value: _checkedAll(),
                          onChanged: (bool) {
                            setState(() {
                              _checkedAllitem(bool);
                            });
                          },
                        ),
                        Container(
                          width: ScreenUtil.getInstance().setWidth(200.0),
                          child: RichText(
                            text: TextSpan(
                              text: isbianji ? '合计' : '',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: ScreenUtil.instance.setWidth(30.0)),
                              children: [
                                TextSpan(
                                  text: isbianji
                                      ? "￥${_getallamount().toStringAsFixed(2)}"
                                      : '',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(30.0),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        isbianji ? _getjiesuan() : _getItemId();
                      },
                      child: Container(
                        width: ScreenUtil.instance.setWidth(245.0),
                        decoration: BoxDecoration(
                          gradient: PublicColor.linearBtn,
                        ),
                        alignment: Alignment.center,
                        height: ScreenUtil.instance.setWidth(100.0),
                        child: Text(
                          isbianji ? '结算' : '删除',
                          style: TextStyle(
                            color: PublicColor.btnTextColor,
                            fontSize: ScreenUtil.instance.setWidth(30.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(),
        isloading ? LoadingDialog() : Container()
      ],
    );
  }
}
