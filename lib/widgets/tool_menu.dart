import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToolMenu extends StatelessWidget {
  final String img;
  final String name;
  final Function tapFun;
  ToolMenu({this.img, this.name, this.tapFun});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(140),
      child: InkWell(
        child: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(30),
              ),
              child: Image.asset(
                img,
                height: ScreenUtil().setWidth(92),
                width: ScreenUtil().setWidth(92),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(10),
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: Color(0xff888888),
                  fontSize: ScreenUtil().setSp(26),
                ),
              ),
            )
          ],
        ),
        onTap: () {
          tapFun();
        },
      ),
    );
  }
}
