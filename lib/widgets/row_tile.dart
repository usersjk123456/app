import 'package:flutter/material.dart';

class RowTile extends StatelessWidget {

  final double height;

  final Widget leading;

  final Widget title;

  final Widget trailing;

  final EdgeInsets padding;

  final VoidCallback onTap;

  final EdgeInsets leadingMargin;

  final bool hasBottomBorder;

  final Color color;

  final Widget subTitle;

  const RowTile({
    Key key,
    this.height,
    this.leading,
    this.title,
    this.trailing,
    this.padding,
    this.onTap,
    this.leadingMargin,
    this.hasBottomBorder = true,
    this.color,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: height,
        padding: padding ?? EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: hasBottomBorder ? BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(
              width: 0.5,
              color: color ?? Colors.grey[200],
            ),
          ),
        ) : null,
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: leadingMargin ?? EdgeInsets.only(
                    right: 10,
                  ),
                  child: leading,
                ),
                subTitle != null ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title ?? Container(),
                    subTitle ?? Container(),
                  ],
                ) : title
              ],
            ),
            trailing ?? Container(),
          ],
        ),
      ),
    );
  }
}
