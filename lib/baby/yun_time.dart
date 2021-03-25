import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';

import '../service/home_service.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../widgets/img_list.dart';

class TimePhotoPage extends StatefulWidget {
  @override
  TimePhotoPageState createState() => TimePhotoPageState();
}

class TimePhotoPageState extends State<TimePhotoPage> {
  bool isLoading = false;
  String jwt = '', addressId = "";
  List addressList = [], listView = [], list1 = [];
  EasyRefreshController _controller = EasyRefreshController();
  int _page = 0;
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    // setState(() {
    //   isLoading = true;
    // });
    _page++;
    if (_page == 1) {
      listView = [];
    }

    var now = new DateTime.now();

    var seven = now.millisecondsSinceEpoch - 604800000;

    var day = DateTime.fromMillisecondsSinceEpoch(seven);
    print(day);
    Map<String, dynamic> map = Map();
    map.putIfAbsent("stime", () => day.toString().split(' ')[0]);
    map.putIfAbsent("etime", () => now.toString().split(' ')[0]);
    HomeServer().yunsearch(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          listView = success['list'];
          for (var i = 0; i < listView.length; i++) {
            list1.add(listView[i]['imgurl']);
            print(list1);
          }
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              listView.insert(listView.length, success['list'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  InkWell buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        color: color,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: new Text(
                '最近上传',
                style: new TextStyle(color: PublicColor.headerTextColor),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: PublicColor.linearHeader,
                ),
              ),
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
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 1),
                  itemCount: listView.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return GestureDetector(
                                // 手势处理事件
                                onTap: () {
                                  Navigator.of(context).pop(); //退出弹出框
                                },
                                child: Container(
                                  //弹出框的具体事件
                                  child: Material(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    child: Center(
                                
                                      child: CachedNetworkImage(
                                        imageUrl: listView[index]['imgurl'],
                                        fit: BoxFit.cover,
                                       
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        );
                      },
                      child: CachedImageView(
                          ScreenUtil.instance.setWidth(220.0),
                          ScreenUtil.instance.setWidth(220.0),
                          listView[index]['imgurl'],
                          null,
                          BorderRadius.all(Radius.circular(0))),
                    );
                  }),
            ),
            // body: BuildImg(
            //   imgList: list1,
            //   width: 160.0,
            //   height: 160.0,
            // )
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
