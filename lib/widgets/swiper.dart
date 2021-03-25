import 'package:client/config/Navigator_util.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/string.dart';

class SwiperView extends StatelessWidget {
  final List bannerData;
  final int size;
  final double viewHeight;
  final String type;
  SwiperView(this.bannerData, this.size, this.viewHeight, this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: viewHeight,
      width: double.infinity,
      child: bannerData == null || bannerData.length == 0
          ? Container(
              height: ScreenUtil.instance.setWidth(750.0),
              color: Colors.grey,
              alignment: Alignment.center,
              child: Text(Strings.NO_DATA_TEXT),
            )
          : Swiper(
              onTap: (index) {},
              itemCount: bannerData.length,
              scrollDirection: Axis.horizontal,
              //滚动方向，设置为Axis.vertical如果需要垂直滚动
              loop: true,
              //无限轮播模式开关
              autoplay: true,
              itemBuilder: (BuildContext buildContext, int index) {
                return InkWell(
                  onTap: () {
                    print(bannerData[index]);
                    if (bannerData[index]['goods_id'].toString() != '0' &&
                        type != 'xq') {
                      NavigatorUtils.toXiangQing(
                          context, bannerData[index]['goods_id']);
                    }
                  },
                  child: Container(
                    width: ScreenUtil.instance.setWidth(750.0),
                    height:ScreenUtil.instance.setWidth(750.0),
                    child: Image.network(
                      bannerData[index]['img'],
                      fit: BoxFit.fitWidth,
                    ),
                  ),

                  //  CachedImageView(double.infinity, double.infinity,
                  //     bannerData[index]['img'], null, BorderRadius.circular(0)),
                );
              },
              duration: 300,
              pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                      size: 8.0,
                      color: Colors.white,
                      activeColor: Color(0xffA53FA4))),
            ),
    );
  }
}
