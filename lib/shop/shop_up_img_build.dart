import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/dialog.dart';

class BuildImg extends StatefulWidget {
  final List shopList;
  final Function delShop;
  BuildImg({this.shopList, this.delShop});
  @override
  _BuildImgState createState() => _BuildImgState();
}

class _BuildImgState extends State<BuildImg> {
  @override
  void initState() {
    super.initState();
  }

  Widget deleDjango(context, id) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        widget.delShop(id);
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: '确定删除该商品吗？',
    );
  }

  List<Widget> boxs() => List.generate(widget.shopList.length, (index) {
        return Stack(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(210),
              height: ScreenUtil().setWidth(210),
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              alignment: Alignment.center,
              child: widget.shopList.length != 0
                  ? Image.network(
                      widget.shopList[index]['thumb'],
                      width: ScreenUtil().setWidth(204),
                      height: ScreenUtil().setWidth(204),
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                child: Image.asset(
                  "assets/shop/close.png",
                  width: ScreenUtil().setWidth(30),
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return deleDjango(
                            context, widget.shopList[index]['up_id']);
                      });
                },
              ),
            )
          ],
        );
      });
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10, //主轴上子控件的间距
      runSpacing: 0, //交叉轴上子控件之间的间距
      children: boxs(), //要显示的子控件集合
    );
  }
}
