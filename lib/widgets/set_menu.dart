import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetMenu extends StatelessWidget {
  final String name;
  final Function tapFun;
  final int isLine;
  final String value;
  final bool isNavigator;

  SetMenu({
    this.name,
    this.tapFun,
    this.isLine,
    this.value,
    this.isNavigator,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setWidth(700),
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(30),
          0,
          ScreenUtil().setWidth(20),
          0,
        ),
        decoration: BoxDecoration(
          border: isLine == 1
              ? Border(
                  bottom: BorderSide(
                    color: PublicColor.lineColor,
                  ),
                )
              : Border(),
        ),
        child: new Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: new Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
            isNavigator
                ? Expanded(
                    flex: 1,
                    child: new Container(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.navigate_next,
                        color: Color(0xff999999),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: new Text(
                        '$value',
                        style: TextStyle(
                          color: Color(0xffd3d3d3),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      onTap: () {
        tapFun?.call();
      },
    );
  }
}
