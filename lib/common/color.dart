import 'dart:ui';
import 'package:flutter/material.dart';

class PublicColor {
  static const Color bodyColor = Color(0xfff5f5f5);
  static const Color textColor = Color.fromRGBO(69, 69, 69, 1.0); //#333333
  static const Color grewNoticeColor = Color(0xff999999); //#999
  static const Color fontColor = Color(0xff4a4a4a); //#999
  static const Color themeColor = Color(0xffFD8C34); //#主题色
  static const Color redColor = Color(0xffA53FA4); //#加入购物车
  static const Color btnColor = Color(0xffffffff); //#333333
  // static const Color headerTextColor =
  //     Color.fromRGBO(69, 69, 69, 1.0); //#333333
  static const Color headerTextColor = Color(0xff222222); //#白色
  static const Color headerColor = Color(0xffffffff); //#标题色
  static const Color whiteColor = Color(0xffffffff); //#白色
  static const Color lineColor = Color(0xfff4f4f4); //#白色

  //辅食主体色
  static const Color foodColor = Color(0xffFD8C34); //

  // 按钮背景颜色
  static const LinearGradient linearBtn = LinearGradient(
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(0.6, 0.0),
    colors: <Color>[const Color(0xffEE9249), const Color(0xffFC5740)],
  );

  // 按钮背景颜色
  static const LinearGradient lineartop = LinearGradient(
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(0.6, 0.0),
    colors: <Color>[const Color(0xffEE9249), const Color(0xffFC5740)],
  );

  // 按钮文字颜色
  static const Color btnTextColor = Color(0xffffffff);

  static const LinearGradient btnlinear = LinearGradient(
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(0.6, 0.0),
    colors: <Color>[const Color(0xffEE9249), const Color(0xffFC5740)],
  );
  // 头部渐变色(从左到右)
  static const LinearGradient linearHeader = LinearGradient(colors: [
    Color(0xFFffffff),
    Color(0xFFffffff),
  ], begin: Alignment.bottomCenter, end: Alignment.topCenter);

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