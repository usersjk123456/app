import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RankWidget extends StatefulWidget {
  final List sendList;
  RankWidget({this.sendList});
  @override
  RankWidgetState createState() => RankWidgetState();
}

class RankWidgetState extends State<RankWidget> {
  @override
  void initState() {
    print('sendList======${widget.sendList}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget rankItem(item, index) {
      return InkWell(
        onTap: () {
          NavigatorUtils.goInformationLivePage(context, item['id'], '1');
        },
        child: Container(
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setWidth(140),
          padding: EdgeInsets.only(left: 20, right: 20),
          child: new Row(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Container(child: Text((index + 1).toString())),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: ClipOval(
                    child: Image.network(
                      item['headimgurl'],
                      height: ScreenUtil().setWidth(90),
                      width: ScreenUtil().setWidth(90),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    item['nickname'],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item['coin_num'].toString(),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (widget.sendList.length > 0) {
        var i = 0;
        for (var item in widget.sendList) {
          arr.add(rankItem(item, i));
          i++;
        }
      }

      content = ListView(
        children: arr,
      );
      return content;
    }

    return new Container(
      child: new Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setWidth(94),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffdddddd),
                ),
              ),
            ),
            child: Text(
              '本场榜单',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w600,
                color: Color(0xff454545),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setWidth(70),
            padding: EdgeInsets.only(left: 20, right: 20),
            // decoration: BoxDecoration(color: Color(0xfffbfbfb)),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    'TOP100',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xff8f8f8f)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '金币',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xff8f8f8f),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: ScreenUtil().setWidth(530),
              padding: EdgeInsets.only(bottom: 10),
              child: buildList())
        ],
      ),
    );
  }
}
