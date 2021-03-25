import 'package:client/common/color.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:client/widgets/xuxian.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';

class Readlist extends StatefulWidget {
  final item;
  Readlist({
    this.item,
  });
  @override
  _ReadlistState createState() => _ReadlistState();
}

class _ReadlistState extends State<Readlist> {
  List item = [];
  @override
  void initState() {
    super.initState();
    item = widget.item;
    print(item);
  }

  List<Widget> boxs() => List.generate(item.length, (index) {
        return Container(
          width: ScreenUtil().setWidth(690),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                index == 0
                    ? Container()
                    : const MySeparator(color: Colors.grey),
                Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(25)),
                  child: Text(
                    '${item[index]['subhead']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(32.0),
                      color: PublicColor.textColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(25),
                ),
                Container(
                  child: Text(
                    '${item[index]['text']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(28.0),
                      color: PublicColor.fontColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(25),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    height: ScreenUtil().setWidth(120),
                    color: Color(0xfff5f5f5),
                    child: Row(
                      children: <Widget>[
                        CachedImageView(
                          ScreenUtil.instance.setWidth(80.0),
                          ScreenUtil.instance.setWidth(100.0),
                          item[index]['img'],
                          null,
                          BorderRadius.all(
                            Radius.circular(0),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          child: Text(
                            '${item[index]['title']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // NavigatorUtils.goWikilist(context, item[index]['id']);
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(25),
                ),
              ],
            ),
            onTap: () {
              NavigatorUtils.goWikiTj(context, item[index]['id'].toString());
            },
          ),
        );
      });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: boxs(), //要显示的子控件集合
    );
  }
}
