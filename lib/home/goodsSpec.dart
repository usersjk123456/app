import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/Global.dart';
import '../service/goods_service.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../common/color.dart';
import '../widgets/cached_image.dart';

class GuigeWidget extends StatefulWidget {
  final Function(int) onChanged;
  final String jwt;
  final Map goods;
  final bool isLive;
  final String roomId;
  final String shipId;
  final List guige;
  GuigeWidget({
    Key key,
    this.onChanged,
    @required this.jwt,
    @required this.goods,
    this.isLive,
    this.roomId,
    this.shipId,
    this.guige,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<GuigeWidget> {
  int buynum = 1;
  int checkindex = 0;
  String buyType = '0';
  @override
  void initState() {
    print(' widget.isLive------${widget.isLive}');
    print(' widget.roomId------${widget.roomId}');
    super.initState();
    if (widget.isLive) {
      if (widget.roomId == '0') {
        buyType = '1';
      } else {
        buyType = '0';
      }
    } else {
      buyType = '0';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addshoppingcar() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("goods_id", () => widget.goods['id']);
    map.putIfAbsent("num", () => buynum);
    if (widget.guige.length != 0) {
      map.putIfAbsent("sid", () => widget.guige[checkindex]['id']);
    } else {
      map.putIfAbsent("sid", () => '0');
    }
    map.putIfAbsent("buy_type", () => buyType);
    map.putIfAbsent("ship_id", () => widget.shipId);
    map.putIfAbsent("room_id", () => widget.roomId);
    map.putIfAbsent("store_id", () => widget.goods['store_id']);
    map.putIfAbsent("share_id", () => "0");

    GoodsServer().addCart(map, (success) async {
      ToastUtil.showToast('加入购物车成功');
      Navigator.of(context).pop();
      widget.onChanged(-1);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void buy(goods, roomId) async {
    Map obj = {
      "list": [
        {
          "title": goods['store_name'],
          "store_id": goods['store_id'],
          "list": [goods]
        }
      ]
    };
    Navigator.of(context).pop();
    NavigatorUtils.toTijiaoDingdan(context, obj, roomId);
  }

  List<Widget> guigeBoxs(list) => List.generate(list.length, (index) {
        return InkWell(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(20)),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              color: checkindex == index
                  ? PublicColor.themeColor
                  : Color(0xfffeae9e9),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Text(
              list[index]['name'],
              style: TextStyle(
                color: checkindex == index
                    ? PublicColor.btnTextColor
                    : PublicColor.textColor,
                fontSize: ScreenUtil.instance.setWidth(28),
              ),
            ),
          ),
          onTap: () {
            widget.onChanged(index);
            setState(() {
              checkindex = index;
            });
          },
        );
      });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: ScreenUtil.instance.setWidth(780.0),
      child: Column(children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(20), top: ScreenUtil().setWidth(15)),
          child: InkWell(
            child: Image.asset(
              'assets/index/gb.png',
              width: ScreenUtil.instance.setWidth(40.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(550.0),
          child: ListView(children: [
            Container(
              height: ScreenUtil.instance.setWidth(230.0),
              decoration: new ShapeDecoration(
                shape: Border(
                  bottom: BorderSide(color: Color(0xfffececec), width: 1),
                ), // 边色与边宽度
              ),
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(25),
                  left: ScreenUtil().setWidth(25)),
              child: Row(children: [
                CachedImageView(
                  ScreenUtil.instance.setWidth(200.0),
                  ScreenUtil.instance.setWidth(200.0),
                  widget.guige.length != 0
                      ? widget.guige[checkindex]['img']
                      : widget.goods['thumb'],
                  null,
                  BorderRadius.all(Radius.circular(0)),
                ),
                new SizedBox(width: ScreenUtil.instance.setWidth(10.0)),
                Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(25)),
                  child: Column(
                    children: <Widget>[
                      widget.guige.length != 0
                          ? Text(
                              '￥${widget.guige[checkindex]['price']}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil.instance.setWidth(27.0),
                              ),
                            )
                          : Text(
                              '￥${widget.goods['now_price']}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil.instance.setWidth(27.0),
                              ),
                            ),
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      widget.guige.length != 0
                          ? Text('库存 ${widget.guige[checkindex]['stock']}',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: ScreenUtil.instance.setWidth(25.0)))
                          : Text('库存 ${widget.goods['stock']}',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize:
                                      ScreenUtil.instance.setWidth(25.0))),
                    ],
                  ),
                )
              ]),
            ),
            new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
            widget.guige.length != 0
                ? Text(
                    '    ' + '规格',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(26.0),
                    ),
                  )
                : Container(),
            new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
            widget.guige.length != 0
                ? Container(
                    padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(25),
                        left: ScreenUtil().setWidth(25)),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: ScreenUtil.instance.setWidth(10.0),
                      children: guigeBoxs(widget.guige),
                    ),
                  )
                : Container(),
            new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
            Container(
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        '购买数量',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil.instance.setWidth(26.0),
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenUtil.instance.setWidth(170.0),
                      height: ScreenUtil.instance.setWidth(50.0),
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                                      color: Color(0xfffececec), width: 1),
                                ), // 边色与边宽度
                              ),
                              child: Text('-'),
                            ),
                            onTap: () {
                              print('减');
                              if (buynum <= 1) {
                                return;
                              }
                              setState(() {
                                buynum = buynum - 1;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                buynum.toString(),
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(24)),
                              ),
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
                                      color: Color(0xfffececec), width: 1),
                                ), // 边色与边宽度
                              ),
                              child: Text('+'),
                            ),
                            onTap: () {
                              int stock = 0;
                              setState(() {
                                if (widget.guige.length != 0) {
                                  stock = widget.guige[checkindex]['stock'];
                                } else {
                                  stock = widget.goods['stock'];
                                }

                                if (buynum >= stock) {
                                  return;
                                }
                                buynum = buynum + 1;
                              });
                            },
                          ),
                        ),
                      ]),
                    )
                  ],
                ))
          ]),
        ),
        Container(
          child: Row(children: [
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
                  child: InkWell(
                    child: Container(
                      height: ScreenUtil.instance.setWidth(90.0),
                      width: ScreenUtil.instance.setWidth(330.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: new Border.all(
                            color: PublicColor.redColor, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '加入购物车',
                        style: TextStyle(
                          color: PublicColor.redColor,
                          fontSize: ScreenUtil.instance.setWidth(27.0),
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (widget.jwt == null) {
                        ToastUtil.showToast(Global.NO_LOGIN);
                        return;
                      }
                      addshoppingcar();
                    },
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
                  child: InkWell(
                    child: Container(
                      height: ScreenUtil.instance.setWidth(90.0),
                      width: ScreenUtil.instance.setWidth(330.0),
                      decoration: BoxDecoration(
                        gradient: PublicColor.linearBtn,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '立即购买',
                        style: TextStyle(
                          color: PublicColor.whiteColor,
                          fontSize: ScreenUtil.instance.setWidth(27.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (widget.jwt == null) {
                        ToastUtil.showToast(Global.NO_LOGIN);
                        return;
                      }
                      if (widget.guige.length != 0) {
                        widget.goods['sid'] = widget.guige[checkindex]['id'];
                      } else {
                        widget.goods['sid'] = '';
                      }
                      widget.goods['num'] = buynum;
                      widget.goods['buy_type'] = buyType;
                      widget.goods['ship_id'] = widget.shipId;
                      widget.goods['room_id'] = widget.roomId;
                      widget.goods['share_id'] = "0"; //分享id 暂时没有
                      buy(widget.goods, widget.roomId);
                    },
                  ),
                ))
          ]),
        ),
      ]),
    );
  }
}
