import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/upload_to_oss.dart';

class BuildImg extends StatefulWidget {
  final List imgList;
  final upImgLoad;
  final unFouce;
  final changeLoading;
  BuildImg({
    this.imgList,
    this.upImgLoad,
    this.unFouce,
    this.changeLoading,
  });
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
        return index != imgList.length - 1
            ? Stack(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(169),
                    height: ScreenUtil().setWidth(169),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    alignment: Alignment.center,
                    child: imgList.length != 0
                        ? Image.network(
                            imgList[index],
                            width: ScreenUtil().setWidth(169),
                            height: ScreenUtil().setWidth(169),
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
                        setState(() {
                          imgList.removeAt(index);
                        });
                      },
                    ),
                  )
                ],
              )
            : Container(
                width: ScreenUtil().setWidth(160),
                height: ScreenUtil().setWidth(160),
                child: InkWell(
                  onTap: () async {
                    widget.unFouce();
                    Map obj = await openGallery("image", widget.changeLoading);
                    if (obj == null) {
                      widget.changeLoading(type: 2, sent: 0, total: 0);
                      return;
                    }
                    if (obj['errcode'] == 0) {
                      widget.upImgLoad(obj['url']);
                    } else {
                      ToastUtil.showToast(obj['msg']);
                    }
                  },
                  child: Image.asset(
                    imgList[index],
                    width: ScreenUtil().setWidth(160),
                    height: ScreenUtil().setWidth(160),
                    fit: BoxFit.cover,
                  ),
                ),
              );
      });
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5, //主轴上子控件的间距
      runSpacing: 0, //交叉轴上子控件之间的间距
      children: boxs(), //要显示的子控件集合
    );
  }
}
