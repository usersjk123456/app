import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PublicColor {
  static const Color bodyColor = Color(0xfff5f5f5);
  static const Color textColor = Color.fromRGBO(69, 69, 69, 1.0); //#333333
  static const Color grewNoticeColor = Color(0xff999999); //#999
  static const Color themeColor = Color(0xffFBE241); //#主题色
  static const Color redColor = Color(0xfffe483b); //#加入购物车
  static const Color headerTextColor = Color.fromRGBO(69, 69, 69, 1.0); //头部文字颜色
  static const Color headerColor = Color(0xffFBE241); //#头部背景色
  static const Color whiteColor = Color(0xffffffff); //#白色
  static const Color lineColor = Color(0xfff4f4f4); //#边框颜色
  static const Color btnColor = Color.fromRGBO(255, 255, 255, 1.0); //#按钮字体色
  static const Color searchColor = Color.fromRGBO(78, 78, 78, 0.69); // #4E4E4E
  static const Color inputHintColor = Color(0xff545454); //#454545
  static const Color borderColor = Color(0xfff4f4f4);
  static const Color yellowColor = Color(0xfff88718); //#F88718
  static const Color goodsNum = Color(0xffa0A0A0);

  // 按钮背景颜色
  static const LinearGradient linearBtn = LinearGradient(
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(0.6, 0.0),
    colors: <Color>[const Color(0xffEE9249), const Color(0xffFC5740)],
  );
  // 按钮文字颜色
  static const Color btnTextColor = Color(0xff333333);

  // 头部渐变色(从左到右)
  static const LinearGradient linearHeader = LinearGradient(
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(0.6, 0.0),
    colors: <Color>[const Color(0xffffffff), const Color(0xffffffff)],
  );

  // 渐变色(从左到右)
  static const LinearGradient linear = LinearGradient(
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(0.6, 0.0),
    colors: <Color>[const Color(0xffFBE449), const Color(0xffFFD303)],
  );

  // 渐变色(从上到下)
  static const LinearGradient linear1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[const Color(0xffFBE449), const Color(0xffFFD303)],
  );
}

class Style {
  static width(double width) => ScreenUtil().setWidth(width);

  static height(double height) => ScreenUtil().setHeight(height);

  static font(double size) => ScreenUtil().setSp(size);

  static textStyle(
          {Color color,
          double size = 28,
          FontWeight fontWeight = FontWeight.normal}) =>
      TextStyle(
          color: color ?? PublicColor.textColor,
          fontSize: font(size),
          fontWeight: fontWeight);

  static padding(
          {double left = 0,
          double right = 0,
          double top = 0,
          double bottom = 0}) =>
      EdgeInsets.only(
          left: width(left),
          right: width(right),
          top: width(top),
          bottom: width(bottom));
  static margin(
          {double left = 0,
          double right = 0,
          double top = 0,
          double bottom = 0}) =>
      EdgeInsets.only(
          left: width(left),
          right: width(right),
          top: width(top),
          bottom: width(bottom));

  static paddingAll(double size) => EdgeInsets.all(width(size));

  static Border borderStyle({
    Color color,
    double size = 1,
    direction = "bottom",
  }) =>
      Border(
        top: direction == "top"
            ? BorderSide(
                width: size,
                color: color != null ? color : PublicColor.borderColor,
              )
            : BorderSide(),
        right: direction == "right"
            ? BorderSide(
                width: size,
                color: color != null ? color : PublicColor.borderColor,
              )
            : BorderSide(),
        bottom: direction == "bottom"
            ? BorderSide(
                width: size,
                color: color != null ? color : PublicColor.borderColor,
              )
            : BorderSide(),
        left: direction == "left"
            ? BorderSide(
                width: size,
                color: color != null ? color : PublicColor.borderColor,
              )
            : BorderSide(),
      );

  static RoundedRectangleBorder roundedNone({double size = 0.0}) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width(size)),
      );

  static boxShadow() {
    return [
      BoxShadow(
          color: Color.fromRGBO(108, 108, 108, 0.46),
          offset: Offset(0.0, 2), //阴影xy轴偏移量
          blurRadius: 15.0, //阴影模糊程度
          spreadRadius: 1.0 //阴影扩散程度
          )
    ];
  }
}

class Data {
  static ints(i) {
    if (i is int) {
      return i;
    } else {
      return int.parse(i);
    }
  }

  static string(i) {
    if (i is String) {
      return i;
    } else {
      return i.toString();
    }
  }
}
