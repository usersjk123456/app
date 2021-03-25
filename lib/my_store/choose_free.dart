import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import '../common/color.dart';

class FreeWidget extends StatefulWidget {
  FreeWidget({
    Key key,
  }) : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => _FreeWidgetState();
}

class _FreeWidgetState extends State<FreeWidget> {
  int groupValue = 0;
  List typeList = [
    {"id": 1, "name": "满金额包邮"},
    {"id": 2, "name": "满件包邮"}
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext content) {
    Widget title = new Container(
        // alignment: Alignment.centerLeft,
        height: ScreenUtil().setWidth(75),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                  child: new Text('请选择包邮模板',
                      style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(30.0)))),
              new Container(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                  child: InkWell(
                    child: Image.asset(
                      'assets/index/gb.png',
                      width: ScreenUtil.instance.setWidth(40.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ))
            ]));

    Widget listbuild() {
      List<Widget> arr = <Widget>[title];
      Widget content;
      if (typeList.length != 0) {
        for (var item in typeList) {
          arr.add(
            RadioListTile<int>(
              value: item['id'],
              groupValue: groupValue,
              onChanged: (int value) {
                setState(() {
                  groupValue = value;
                });
              },
              title: new Text(
                item['name'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
              dense: true,
              activeColor: PublicColor.themeColor, // 指定选中时勾选框的颜色
              isThreeLine: false, // 是否空出第三行
              selected: false,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          );
        }
      }
      content = ListView(
        children: arr,
      );
      return content;
    }

    return new Container(
      height: ScreenUtil().setWidth(390),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: listbuild(),
          ),
          InkWell(
            onTap: () {
              String type = groupValue.toString();
              Navigator.of(context).pop();
              NavigatorUtils.goAddFreeShippingPage(context, type);
            },
            child: Container(
              alignment: Alignment.center,
              color: PublicColor.bodyColor,
              width: ScreenUtil().setWidth(750),
              height: ScreenUtil().setWidth(90),
              child: Text('完成'),
            ),
          ),
        ],
      ),
    );
  }
}
