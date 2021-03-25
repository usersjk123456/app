import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilletContainer extends StatelessWidget {
  final double width;

  final double height;

  final EdgeInsets margin;

  final EdgeInsets padding;

  final Widget child;

  final double circular;

  final Color color;

  final bool hasBoxShadow;

  final BoxBorder border;

  const FilletContainer({
    Key key,
    this.margin,
    this.child,
    this.circular,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.hasBoxShadow = false,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: width,
      height: height,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
      decoration: BoxDecoration(
        border: border,
        color: color ?? Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(circular ?? 10),
        ),
        boxShadow: hasBoxShadow ? [
          BoxShadow(
            color: Colors.grey[100],
            offset: Offset(-5.0, 5.0), //阴影xy轴偏移量
            blurRadius: 1.0, //阴影模糊程度
            spreadRadius: 0.5, //阴影扩散程度
          ),
        ]: [],
      ),
      margin: margin ?? EdgeInsets.all(10),
      child: child,
    );
  }
}
