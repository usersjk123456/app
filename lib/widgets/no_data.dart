import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoData extends StatelessWidget {
  final deHeight; //减去的距离
  final imgWidth; //图片大小
  NoData({this.deHeight, this.imgWidth});

  @override
  Widget build(BuildContext context) {
    int height = deHeight == null ? 100 : deHeight;  //100为默认头部高度
    return Container(
      height: MediaQuery.of(context).size.height - height,
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      child: Image.asset(
        'assets/mine/zwsj.png',
        width: imgWidth == null
            ? ScreenUtil().setWidth(300)
            : ScreenUtil().setWidth(imgWidth),
      ),
    );
  }
}
