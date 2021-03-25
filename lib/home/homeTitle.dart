import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/toTime.dart';

class HomeTitlePage extends StatefulWidget {
  final TabController tabController;
  final List tabTitles;
  HomeTitlePage({this.tabController, this.tabTitles});
  @override
  _HomeTitlePageState createState() => _HomeTitlePageState();
}

class _HomeTitlePageState extends State<HomeTitlePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static String getHomeTabName(id, start, end) {
    var nowtime = DateTime.now().millisecondsSinceEpoch;
    start = int.parse(start) * 1000;
    end = int.parse(end) * 1000;
    if (id == '1') {
      return '昨日精选';
    }
    if (nowtime > end) {
      return '已结束';
    }
    if (nowtime < start) {
      return '预热中';
    }
    if (nowtime > start && nowtime < end) {
      return '抢购中';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
        alignment: Alignment.centerLeft,
        child: TabBar(
          controller: widget.tabController,
          indicatorColor: null,
          indicator: const BoxDecoration(),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Color(0xffFE6303),
          unselectedLabelColor: Color(0xfff333333),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          isScrollable: true,
          tabs: widget.tabTitles
              .map((i) => Tab(
                    child: Column(children: [
                      Text(
                          i['id'] == '1'
                              ? '限时特卖'
                              : ToTime.time(i['start_time'], 'HH'),
                          style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(30))),
                      Text(
                          getHomeTabName(
                              i['id'], i['start_time'], i['end_time']),
                          style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(24)))
                    ]),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
