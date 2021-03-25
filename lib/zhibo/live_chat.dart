import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//聊天
class ChatWidget extends StatefulWidget {
  final ctx;
  final list;
  final index;
  ChatWidget({this.ctx, this.list, this.index});
  @override
  ChatWidgetState createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 600)..init(context);

    // 聊天
    Widget liaotianitem(BuildContext context, item, index) {
      return Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(10),
          top: ScreenUtil().setWidth(10),
        ),
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(10),
        ),
        width: ScreenUtil().setWidth(200),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10),
        ),
        child: new Column(children: [
          new Row(
            children: <Widget>[
              CachedImageView(
                ScreenUtil.instance.setWidth(55.0),
                ScreenUtil.instance.setWidth(55.0),
                item['headimgurl'],
                null,
                BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              new SizedBox(
                width: ScreenUtil.instance.setWidth(16.0),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  item['nickname'],
                  style: TextStyle(
                    color: Color(0xffffd406),
                    fontSize: ScreenUtil.instance.setWidth(30.0),
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
          Container(
            width: ScreenUtil.instance.setWidth(580.0),
            child: Text(
              item['msg'],
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.instance.setWidth(30.0),
              ),
            ),
          ),
          new SizedBox(
            height: ScreenUtil.instance.setWidth(10.0),
          ),
        ]),
      );
    }

    return liaotianitem(widget.ctx, widget.list, widget.index);
  }
}
