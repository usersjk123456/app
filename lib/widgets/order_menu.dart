import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderMenu extends StatelessWidget {
  final String icon;
  final String name;
  final Function navigator;
  OrderMenu({this.icon, this.name, this.navigator});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: ScreenUtil.instance.setWidth(155.0),
        width: ScreenUtil.instance.setWidth(130.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil.instance.setWidth(30.0),
            ),
            Expanded(
              flex: 0,
              child: Image.asset(
                icon,
                height: ScreenUtil().setWidth(50),
                width: ScreenUtil().setWidth(50),
                // fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: ScreenUtil.instance.setWidth(10.0),
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: Color(0xff7b7b7b),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        print('$name');
        navigator();
      },
    );
  }
}
