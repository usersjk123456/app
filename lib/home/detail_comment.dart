import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/comment_item.dart';

class CommentWidget extends StatefulWidget {
  final String goodsId;
  final List commentList;
  final String count;
  CommentWidget({
    this.goodsId,
    this.commentList,
    this.count
  });

  @override
  CommentWidgetState createState() => CommentWidgetState();
}

class CommentWidgetState extends State<CommentWidget> {
  FocusNode contentFocus = FocusNode();
  bool isLoading = false;
  
  @override
  void initState() {
    print('list=====${widget.commentList}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget titleBox = Container(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(25),
        right: ScreenUtil().setWidth(25),
      ),
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(10),
        top: ScreenUtil().setWidth(15),
      ),
      height: ScreenUtil.instance.setWidth(80.0),
      width: ScreenUtil.instance.setWidth(750.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Text(
              '宝贝评价(${widget.count})',
              style: TextStyle(
                fontSize: ScreenUtil.instance.setWidth(26.0),
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: InkWell(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  '查看全部 >',
                  style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(26.0),
                      color: Colors.black),
                ),
              ),
              onTap: () {
                NavigatorUtils.goAllComment(context, widget.goodsId.toString());
              },
            ),
          ),
        ],
      ),
    );

    Widget buildList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      print('len======${widget.commentList.length}');
      for (var i = 0; i < widget.commentList.length; i++) {
        var item = widget.commentList[i];
        print(item);
        arr.add(Comment(item: item,isImg:false));
      }

      content = Column(
        children: arr,
      );
      return content;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[titleBox, buildList()],
      ),
    );
  }
}
