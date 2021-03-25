import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';

class NoticeCell extends StatefulWidget {
  final Map item;
  NoticeCell({@required this.item});
  @override
  _NoticeCellState createState() => _NoticeCellState();
}

class _NoticeCellState extends State<NoticeCell> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    itemClick(String id) {
      print(id);
      NavigatorUtils.goNewsDetailPage(context, id);
    }

    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(210),
        width: ScreenUtil().setWidth(700),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular((8.0)),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30),
                2,
                ScreenUtil().setWidth(20),
                0,
              ),
              height: ScreenUtil().setHeight(90),
              width: ScreenUtil().setWidth(700),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffdddddd),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: ScreenUtil().setWidth(350),
                      child: Text(
                        widget.item['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        widget.item['create_at'].toString(),
                        style: TextStyle(
                          color: Color(0xff5e5e5e),
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30),
                15,
                ScreenUtil().setWidth(20),
                0,
              ),
              height: ScreenUtil().setHeight(100),
              width: ScreenUtil().setWidth(700),
              child: Text(
                widget.item['content'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => itemClick(widget.item['id']),
      // onTap: () {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => sDetailPage()));
      // },
    );
  }
}
