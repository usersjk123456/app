import 'package:flutter/material.dart';

class BaseText extends StatelessWidget {

  final Color color;
  final String text;
  final double fontSize;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final TextOverflow textOverflow;

  final FontWeight fontWeight;
  const BaseText(this.text,{
    Key key,
    this.color,
    this.fontSize,
    this.margin,
    this.padding,
    this.textOverflow,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Text(
        text ?? '',
        overflow: textOverflow,
        style: TextStyle(
          color: color ?? Theme.of(context).primaryColor,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
