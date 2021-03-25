import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cached_image.dart';

class Comment extends StatefulWidget {
  final Map item;
  final bool isImg;
  Comment({this.item, this.isImg});

  @override
  CommentState createState() => CommentState();
}

class CommentState extends State<Comment> {
  FocusNode contentFocus = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget imgItem(item) {
      return Container(
        margin:EdgeInsets.only(
          top: ScreenUtil().setWidth(16),
          right: ScreenUtil().setWidth(16),
        ),
        alignment: Alignment.topLeft,
        width: ScreenUtil().setWidth(196),
        height: ScreenUtil().setWidth(146),
        child: Image.network(
          item,
          width: ScreenUtil().setWidth(196),
          fit: BoxFit.fitWidth,
        ),
      );
    }

    Widget buildImgList() {
      List<Widget> arr = <Widget>[];
      Widget content;

      for (var i = 0; i < widget.item['image'].length; i++) {
        var item = widget.item['image'][i];
        arr.add(imgItem(item['img']));
      }

      content = Wrap(
        children: arr,
      );
      return content;
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(30),
        left: ScreenUtil().setWidth(25),
        right: ScreenUtil().setWidth(25),
        top: ScreenUtil().setWidth(25),
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: Border(
          bottom: BorderSide(color: PublicColor.lineColor, width: 1),
        ), // 边色与边宽度
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(56),
                height: ScreenUtil().setWidth(56),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(56),
                ),
                child: CachedImageView(
                  ScreenUtil.instance.setWidth(56.0),
                  ScreenUtil.instance.setWidth(56.0),
                  widget.item['headimgurl'],
                  null,
                  BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(14),
              ),
              Text(
                widget.item['nickname'],
                style: TextStyle(
                  color: PublicColor.grewNoticeColor,
                  fontSize: ScreenUtil().setSp(26),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(20),
            ),
            child: Text(
              widget.item['comment'],
              style: TextStyle(fontSize: ScreenUtil().setSp(28)),
            ),
          ),
          widget.isImg ? buildImgList() : Container()
        ],
      ),
    );
  }
}
