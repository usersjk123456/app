import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';

class BuildImg extends StatefulWidget {
  final item;
  final user;

  final List imgList;
  final double width;
  final double height;
  final backRefash;
  BuildImg(
      {this.imgList,
      this.width,
      this.height,
      this.backRefash,
      this.item,
      this.user});
  @override
  _BuildImgState createState() => _BuildImgState();
}

class _BuildImgState extends State<BuildImg> {
  List imgList = [];
  @override
  void initState() {
    super.initState();
    imgList = widget.imgList;
  }

  List<Widget> boxs() => List.generate(imgList.length, (index) {
        return Stack(
          children: <Widget>[
            Container(
                width: ScreenUtil()
                    .setWidth(widget.width == null ? 100 : widget.width),
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    if (imgList[index] is Map) {
                      NavigatorUtils.goGroupDetailsPage(
                              context, imgList[index]['id'])
                          .then((result) => widget.backRefash());
                    }
                  },
                  child: imgList.length != 0
                      ? Image.network(
                          imgList[index] is Map
                              ? imgList[index]['img']
                              : imgList[index],
                          width: ScreenUtil().setWidth(
                              widget.width == null ? 100 : widget.width),
                          height: ScreenUtil().setWidth(
                              widget.height == null ? 100 : widget.height),
                          fit: BoxFit.cover,
                        )
                      : Container(),
                )),
          ],
        );
      });
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5, //主轴上子控件的间距
      runSpacing: 3, //交叉轴上子控件之间的间距
      children: boxs(), //要显示的子控件集合
    );
  }
}
