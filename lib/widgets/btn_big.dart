import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BigButton extends StatelessWidget {
  final String name;
  final Function tapFun;
  final width;
  final height;
  final top;
  BigButton({this.name, this.tapFun, this.width, this.height, this.top});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: height == null ? ScreenUtil().setWidth(86) : height,
        width: width == null ? ScreenUtil().setWidth(640) : width,
        margin: EdgeInsets.only(
          top: top == null ? ScreenUtil().setWidth(40) : top,
        ),
        decoration: BoxDecoration(
          gradient: PublicColor.linearBtn,
          borderRadius: new BorderRadius.circular(
            (8.0),
          ),
        ),
        child: new FlatButton(
          disabledColor: PublicColor.themeColor,
          onPressed: () {
            tapFun();
          },
          child: new Text(
            name,
            style: TextStyle(
              color: PublicColor.btnTextColor,
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
