import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../service/home_service.dart';
import '../widgets/cached_image.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
export 'package:extended_image_library/extended_image_library.dart';

class AllPhotoPage extends StatefulWidget {
  @override
  AllPhotoPageState createState() => AllPhotoPageState();
}

class AllPhotoPageState extends State<AllPhotoPage> {
  bool isLoading = false;
  String jwt = '', url = "", addressId = "";
  List addressList = [], listView = [];
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
//  void _handleDragDown(DragDownDetails details) {
//     //print(details);
//     _gestureAnimation.stop();
//     assert(_drag == null);
//     assert(_hold == null);
//     _hold = position.hold(_disposeHold);
//   }

    var now = new DateTime.now();

    var seven = now.millisecondsSinceEpoch - 604800000;

    var day = DateTime.fromMillisecondsSinceEpoch(seven);
    print(day);
    Map<String, dynamic> map = Map();

    HomeServer().yunsearch(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          listView = success['list'];
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

    // Widget result = PageView.custom(
    //   scrollDirection: widget.scrollDirection,
    //   reverse: widget.reverse,
    //   controller: widget.controller,
    //   childrenDelegate: widget.childrenDelegate,
    //   pageSnapping: widget.pageSnapping,
    //   physics: widget.physics,
    //   onPageChanged: widget.onPageChanged,
    //   key: widget.key,
    // );

    // result = RawGestureDetector(
    //   gestures: _gestureRecognizers,
    //   behavior: HitTestBehavior.opaque,
    //   child: result,
    // );

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: new Text(
                '所有照片',
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
                        setState(() {
                          url = listView[index]['imgurl'];
                        });
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
                        // showDialog<Null>(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (BuildContext context) {
                        //     return Material(
                        //    child: Stack(
                        //         children: <Widget>[
                        //           GestureDetector(
                        //             // 手势处理事件
                        //             onTap: () {
                        //               Navigator.of(context).pop(); //退出弹出框
                        //             },
                        //           child:
                        //           Container(
                        //             //弹出框的具体事件
                        //             child: Material(
                        //               color: Color.fromRGBO(0, 0, 0, 0.1),
                        //               child: Center(
                        //                 child: CachedNetworkImage(
                        //                   imageUrl: url,
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           ),
                        //           Positioned(
                        //             left: 20,
                        //             top: 350,
                        //             child: InkWell(
                        //               onTap: () {
                        //                 print('上一张');
                        //                 setState(() {
                        //                   url = listView[index--]['imgurl'];
                        //                 });
                        //               },
                        //               child: Opacity(
                        //                 opacity: 0.6,
                        //                 child: Container(
                        //                   width: ScreenUtil().setWidth(80),
                        //                   height: ScreenUtil().setWidth(80),
                        //                   alignment: Alignment.center,
                        //                   decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.all(
                        //                           Radius.circular(50)),
                        //                       color: Color(0xff9999999)),
                        //                   child: Icon(
                        //                     Icons.navigate_before,
                        //                     color: Colors.black,
                        //                     size: 30,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           Positioned(
                        //             right: 20,
                        //             top: 350,
                        //             child: InkWell(
                        //               onTap: () {
                        //                 print('下一张');

                        //                 url = listView[index ++]['imgurl'];
                        //               },
                        //               child: Opacity(
                        //                 opacity: 0.6,
                        //                 child: Container(
                        //                   width: ScreenUtil().setWidth(80),
                        //                   height: ScreenUtil().setWidth(80),
                        //                   alignment: Alignment.center,
                        //                   decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.all(
                        //                           Radius.circular(50)),
                        //                       color: Color(0xff9999999)),
                        //                   child: Icon(
                        //                     Icons.navigate_next,
                        //                     color: Colors.black,
                        //                     size: 30,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // );
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
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
