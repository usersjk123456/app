import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/dialog.dart';
import '../service/video_service.dart';
import '../utils/toast_util.dart';

class RecordVideoPage extends StatefulWidget {
  @override
  RecordVideoPageState createState() => RecordVideoPageState();
}

class RecordVideoPageState extends State<RecordVideoPage> {
  List list = [];
  bool isLoading = false;
  @override
  void initState() {
    getTypeList();
    super.initState();
  }

  void getTypeList() async {
    Map<String, dynamic> map = Map();
    VideoServer().myVideoList(map, (success) {
      setState(() {
        list = success['list'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  void delVideo(item) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => item['id']);
    VideoServer().delMyVideo(map, (success) {
      ToastUtil.showToast('删除成功');
      getTypeList();
      setState(() {
        isLoading = false;
      });
    }, (onFail) {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget buildGoods() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (list.length == 0) {
        arr.add(Container(
          height: ScreenUtil().setWidth(700),
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ));
      } else {
        for (var item in list) {
          arr.add(
            InkWell(
              onTap: () {
                NavigatorUtils.goMyVideoDetail(context, item['type'], item);
              },
              child: Container(
                height: ScreenUtil().setWidth(246),
                width: ScreenUtil().setWidth(750),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            item["img"],
                            height: ScreenUtil().setWidth(197),
                            width: ScreenUtil().setWidth(202),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: ScreenUtil().setWidth(100),
                          top: ScreenUtil().setWidth(68),
                          child: Image.asset(
                            "assets/zhibo/play.png",
                            width: ScreenUtil().setWidth(70),
                            height: ScreenUtil().setWidth(70),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        item["name"],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(40),
                        top: ScreenUtil().setWidth(30),
                      ),
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            item['state'].toString() == '0'
                                ? '审核中'
                                : item['state'] == '1' ? '已通过' : '已拒绝',
                            style: TextStyle(
                                color: item['state'] == '2'
                                    ? PublicColor.grewNoticeColor
                                    : Colors.red,
                                fontSize: ScreenUtil().setSp(28)),
                          ),
                          InkWell(
                            child: new Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/shop/scan.png",
                                  width: ScreenUtil().setWidth(30),
                                  height: ScreenUtil().setSp(32),
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  '删除',
                                  style: TextStyle(
                                    color: Color(0xffb6b6b6),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return MyDialog(
                                      width:
                                          ScreenUtil.instance.setWidth(600.0),
                                      height:
                                          ScreenUtil.instance.setWidth(300.0),
                                      queding: () {
                                        delVideo(item);
                                        Navigator.of(context).pop();
                                      },
                                      quxiao: () {
                                        Navigator.of(context).pop();
                                      },
                                      title: '温馨提示',
                                      message: '确定删除该视频？');
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        }
      }
      content = new Container(
        child: new Column(children: arr),
      );
      return content;
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: new Text(
              '我的短视频',
              style: new TextStyle(color: PublicColor.headerTextColor),
            ),
            flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: PublicColor.linearHeader,
                  ),
                ),

            centerTitle: true,
            leading: new IconButton(
              icon: Icon(
                Icons.navigate_before,
                color: PublicColor.headerTextColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [buildGoods()],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
