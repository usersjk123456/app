import 'package:client/common/color.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import '../widgets/cached_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductView extends StatelessWidget {
  final List productList;
  ProductView(this.productList);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil.instance.setWidth(25.0),
          right: ScreenUtil.instance.setWidth(25.0)),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: productList.length,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.56,
              crossAxisSpacing: 0,
              mainAxisSpacing: 3),
          itemBuilder: (BuildContext context, int index) {
            return _getGridViewItem(context, productList[index]);
          }),
    );
  }

  Widget _getGridViewItem(BuildContext context, productEntity) {
    return Container(
      child: InkWell(
        onTap: () async {
          NavigatorUtils.toBaMaiXiangQing(context, productEntity['id'], "1");
        },
        child: Card(
          elevation: 5.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))), //设置圆角
          child: Column(
            children: [
              Container(
                child: CachedImageView(
                  ScreenUtil.instance.setWidth(340.0),
                  ScreenUtil.instance.setWidth(330.0),
                  productEntity['thumb'],
                  null,
                  BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                padding: EdgeInsets.only(),
              ),
              Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                // padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(20),
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20)),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(10),
                              right: ScreenUtil().setWidth(10),
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xffFD5392),
                                Color(0xffF86F64),
                              ]),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "拼团",
                              style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(26.0),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '            ${productEntity['name']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(30.0),
                              fontWeight: FontWeight.w700,
                              color: Color(0xfff000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil.instance.setWidth(15.0),
                          ScreenUtil.instance.setWidth(5.0),
                          ScreenUtil.instance.setWidth(15.0),
                          0),
                      child: Text(
                        "原价: ¥${productEntity['old_price']}",
                        style: TextStyle(
                          color: PublicColor.grewNoticeColor,
                          fontSize: ScreenUtil.instance.setWidth(26.0),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: ScreenUtil().setWidth(30),
                    //   child: LinearProgressIndicator(
                    //     backgroundColor: Colors.grey[200],
                    //     valueColor:
                    //         AlwaysStoppedAnimation(PublicColor.themeColor),
                    //     value: productEntity['tuannum'] /
                    //         productEntity['totalnum'],
                    //   ),
                    // ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil.instance.setWidth(15.0),
                          ScreenUtil.instance.setWidth(5.0),
                          ScreenUtil.instance.setWidth(15.0),
                          ScreenUtil.instance.setWidth(5.0)),
                      child: Text(
                        "拼团价: ¥${productEntity['now_price']}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: ScreenUtil.instance.setWidth(28.0),
                        ),
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   padding: EdgeInsets.fromLTRB(
                    //       ScreenUtil.instance.setWidth(15.0),
                    //       ScreenUtil.instance.setWidth(5.0),
                    //       ScreenUtil.instance.setWidth(15.0),
                    //       ScreenUtil.instance.setWidth(5.0)),
                    //   child: Text(
                    //     "补贴金额: ¥${productEntity['bamaicompensate']}",
                    //     style: TextStyle(
                    //       color: PublicColor.grewNoticeColor,
                    //       fontSize: ScreenUtil.instance.setWidth(28.0),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Container(
                      height: ScreenUtil().setWidth(80),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: PublicColor.btnlinear,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "参团",
                        style: TextStyle(
                          color: PublicColor.btnColor,
                          fontSize: ScreenUtil.instance.setWidth(28.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
