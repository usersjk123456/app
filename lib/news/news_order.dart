import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCell extends StatefulWidget {
  final Map item;
  OrderCell({@required this.item});
  @override
  _OrderCellState createState() => _OrderCellState();
}

class _OrderCellState extends State<OrderCell> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return new InkWell(
      child: new Container(
          height: ScreenUtil().setHeight(170),
          width: ScreenUtil().setWidth(700),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular((8.0)),
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
          ),
          child: Column(children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
              height: ScreenUtil().setHeight(60),
              width: ScreenUtil().setWidth(700),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
              ),
              child: new Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        '那些年的今天(下级昵称)',
                        style: TextStyle(
                          color: Color(0xff5e5e5e),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: new Text(
                        '2020-12-5 12:34:05',
                        style: TextStyle(
                          color: Color(0xffb8b8b8),
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      )),
                )
              ]),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(30), 5, ScreenUtil().setWidth(20), 0),
              height: ScreenUtil().setHeight(100),
              width: ScreenUtil().setWidth(700),
              child: Text(
                '购买卡西欧手表(CASIO)经典三盘六指针商务男表石英表购买卡西欧手表(CASIO)经典三盘六指针商务男表石英表哈哈哈哈',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ])),
      onTap: () {
        print('订单');
      },
    );
  }
}
