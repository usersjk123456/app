import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImageView extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final BoxDecoration miaoshu;
  final BorderRadius radio;

  CachedImageView(
    this.width,
    this.height,
    this.url,
    this.miaoshu,
    this.radio,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        height: this.height,
        alignment: Alignment.center,
        decoration: this.miaoshu,
        child: ClipRRect(
          borderRadius: this.radio,
          child: CachedNetworkImage(
            imageUrl: this.url,
            fit: BoxFit.fill,
            width: this.width,
            height: this.height,
          ),
        ));
  }
}

