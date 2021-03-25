import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';
import '../common/color.dart';

class ChangeNums extends StatefulWidget {
  final id;
  final couponNum;
  final Function getList;
  ChangeNums({
    Key key,
    this.id,
    this.couponNum,
    this.getList,
  }) : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => _ChangeNumsState();
}

class _ChangeNumsState extends State<ChangeNums> {
  int nums = 0;
  @override
  void initState() {
    super.initState();
  }

  void addNum() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.id);
    map.putIfAbsent("num", () => nums);

    StoreServer().addCouponNum(map, (success) async {
      Navigator.pop(context);
      widget.getList();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext content) {
    Widget title = new Container(
      // alignment: Alignment.centerLeft,
      height: ScreenUtil().setWidth(75),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
              child: new Text('增加张数',
                  style:
                      TextStyle(fontSize: ScreenUtil.instance.setWidth(30.0)))),
          new Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
              child: InkWell(
                child: Image.asset(
                  'assets/index/gb.png',
                  width: ScreenUtil.instance.setWidth(40.0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ))
        ],
      ),
    );

    return new Container(
      height: ScreenUtil().setWidth(390),
      child: Column(
        children: <Widget>[
          title,
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: ScreenUtil().setWidth(30)),
                        Text(
                          '优惠券名称',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(35),
                              color: PublicColor.textColor),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(30)),
                        Text('当前张数：${widget.couponNum}'),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(200),
                  child: Container(
                    width: ScreenUtil.instance.setWidth(150.0),
                    height: ScreenUtil.instance.setWidth(50.0),
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border:
                          new Border.all(color: Color(0xfffcccccc), width: 0.5),
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
                            if (nums <= 0) {
                              return;
                            }
                            setState(() {
                              nums--;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('$nums'),
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
                              ), // 边色与��宽度
                            ),
                            child: Text('+'),
                          ),
                          onTap: () {
                            setState(() {
                              nums++;
                            });
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(30))
              ],
            ),
          ),
          InkWell(
            onTap: () {
              addNum();
            },
            child: Container(
              alignment: Alignment.center,
              color: PublicColor.bodyColor,
              width: ScreenUtil().setWidth(750),
              height: ScreenUtil().setWidth(90),
              child: Text('完成'),
            ),
          ),
        ],
      ),
    );
  }
}
