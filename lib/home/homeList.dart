import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeListBuilder {
  static Widget categoryBuild(list, goShopList,index) {
    return Expanded(
      flex: 1,
      child: new InkWell(
        child: Column(
          children: <Widget>[
            Container(
              child: ClipOval(
                child: Image.network(
                  list['img'],
                  width: ScreenUtil.instance.setWidth(110.0),
                  height: ScreenUtil.instance.setWidth(110.0),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(10),
            ),
            Container(
              child: new Text(
                list['name'],
                style: TextStyle(
                  fontSize: ScreenUtil.instance.setWidth(26.0),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        onTap: () {

          goShopList(list['id'].toString(), list['name'],index);
        },
      ),
    );
  }
}
