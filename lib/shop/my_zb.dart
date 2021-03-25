// import 'package:client/config/Navigator_util.dart';
// import 'package:client/service/live_service.dart';
// import 'package:client/widgets/dialog.dart';
// import 'package:flutter/material.dart';
// import '../common/color.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../utils/toast_util.dart';
// import '../widgets/loading.dart';
// import "package:flutter_easyrefresh/easy_refresh.dart";
// import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
// import 'package:flutter_easyrefresh/bezier_circle_header.dart';
// import 'package:client/widgets/cached_image.dart';
// import 'package:client/widgets/no_data.dart';

// class MyZbPage extends StatefulWidget {
//   @override
//   MyZbPageState createState() => MyZbPageState();
// }

// class MyZbPageState extends State<MyZbPage> {
//   bool isLoading = false;
//   String jwt = '';
//   List goodsList = [];
//   int type = 1; // 分类
//   EasyRefreshController _controller = EasyRefreshController();
//   @override
//   void initState() {
//     super.initState();
//     getMyLive();
//   }

//   // 我的直播列表
//   void getMyLive() {
//     setState(() {
//       isLoading = true;
//     });
//     Map<String, dynamic> map = Map();
//     LiveServer().myLive(map, (success) async {
//       setState(() {
//         isLoading = false;
//         goodsList = success['list'];
//       });
//       _controller.finishRefresh();
//     }, (onFail) async {
//       setState(() {
//         isLoading = false;
//       });
//       ToastUtil.showToast(onFail);
//     });
//   }

//   // 删除直播
//   void deleLive(item) {
//     Map<String, dynamic> map = Map();
//     map.putIfAbsent("id", () => item['id']);

//     LiveServer().deleLive(map, (success) async {
//       ToastUtil.showToast('删除成功');
//       getMyLive();
//     }, (onFail) async {
//       ToastUtil.showToast(onFail);
//     });
//   }

//   // 关闭直播
//   void closeLive(lives) {
//     Map<String, dynamic> map = Map();
//     map.putIfAbsent("room_id", () => lives['id']);
//     LiveServer().closeLive(map, (success) async {
//       ToastUtil.showToast('关闭成功');
//       getMyLive();
//     }, (onFail) async {
//       ToastUtil.showToast(onFail);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
//     // 关闭直播按钮
//     Widget closeBtn(item) {
//       return Container(
//         child: InkWell(
//           onTap: () {
//             showDialog(
//               context: context,
//               barrierDismissible: true,
//               builder: (BuildContext context) {
//                 return MyDialog(
//                     width: ScreenUtil.instance.setWidth(600.0),
//                     height: ScreenUtil.instance.setWidth(300.0),
//                     queding: () {
//                       closeLive(item);
//                       Navigator.of(context).pop();
//                     },
//                     quxiao: () {
//                       Navigator.of(context).pop();
//                     },
//                     title: '温馨提示',
//                     message: '确定关闭该直播？');
//               },
//             );
//           },
//           child: Text(
//             "关闭直播",
//             style: TextStyle(
//               fontSize: ScreenUtil().setSp(24),
//               color: Color(0xffb6b6b6),
//             ),
//           ),
//         ),
//       );
//     }

//     // 删除直播按钮
//     Widget deleteBtn(item) {
//       return Container(
//         width: ScreenUtil().setWidth(100),
//         child: InkWell(
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 0,
//                 child: Image.asset(
//                   "assets/shop/scan.png",
//                   width: ScreenUtil().setWidth(30),
//                   height: ScreenUtil().setSp(32),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   child: Text(
//                     '删除',
//                     style: TextStyle(
//                       color: Color(0xffb6b6b6),
//                       fontSize: ScreenUtil().setSp(28),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           onTap: () {
//             print('删除');
//             showDialog(
//               context: context,
//               barrierDismissible: true,
//               builder: (BuildContext context) {
//                 return MyDialog(
//                     width: ScreenUtil.instance.setWidth(600.0),
//                     height: ScreenUtil.instance.setWidth(300.0),
//                     queding: () {
//                       deleLive(item);
//                       Navigator.of(context).pop();
//                     },
//                     quxiao: () {
//                       Navigator.of(context).pop();
//                     },
//                     title: '温馨提示',
//                     message: '确定删除该直播？');
//               },
//             );
//           },
//         ),
//       );
//     }

//     Widget listArea() {
//       List<Widget> arr = <Widget>[];
//       Widget content;
//       if (goodsList.length == 0) {
//         arr.add(Container(
//           height: ScreenUtil().setWidth(700),
//           alignment: Alignment.center,
//           margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
//           child: Image.asset(
//             'assets/mine/zwsj.png',
//             width: ScreenUtil().setWidth(400),
//           ),
//         ));
//       } else {
//         for (var item in goodsList) {
//           arr.add(
//             Container(
//               child: Stack(
//                 children: <Widget>[
//                   InkWell(
//                     child: Container(
//                       height: ScreenUtil().setWidth(246),
//                       width: ScreenUtil().setWidth(750),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border(
//                             bottom: BorderSide(color: PublicColor.lineColor)),
//                       ),
//                       child: Row(children: <Widget>[
//                         Expanded(
//                           flex: 0,
//                           child: Stack(
//                             children: <Widget>[
//                               Positioned(
//                                 child: Container(
//                                   padding: EdgeInsets.only(left: 20),
//                                   child: Image.network(
//                                     item['img'],
//                                     height: ScreenUtil().setWidth(197),
//                                     width: ScreenUtil().setWidth(202),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 left: 20,
//                                 child: Container(
//                                   width: ScreenUtil().setWidth(100),
//                                   height: ScreenUtil().setWidth(40),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     color: PublicColor.themeColor,
//                                     borderRadius: BorderRadius.circular(
//                                       ScreenUtil().setWidth(40),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     item['is_open'] == "0"
//                                         ? "预告"
//                                         : item['is_open'] == "1"
//                                             ? "直播中"
//                                             : "已结束",
//                                     style: TextStyle(
//                                         fontSize: ScreenUtil().setSp(24),
//                                         color: PublicColor.btnTextColor),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 3,
//                           child: Row(
//                             children: <Widget>[
//                               Expanded(
//                                 flex: 2,
//                                 child: Container(
//                                   alignment: Alignment.topLeft,
//                                   padding: EdgeInsets.only(
//                                     top: ScreenUtil().setWidth(20),
//                                     left: ScreenUtil().setWidth(20),
//                                   ),
//                                   child: Text(
//                                     item['desc'],
//                                     style: TextStyle(
//                                       fontSize: ScreenUtil().setSp(28),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(
//                                   padding: EdgeInsets.only(
//                                     top: ScreenUtil().setWidth(20),
//                                     bottom: ScreenUtil().setWidth(20),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       item['is_open'] == "2"
//                                           ? Container(
//                                               child: Text(
//                                                 item["is_huifang"] == "2"
//                                                     ? "查看回放"
//                                                     : "回放生成中",
//                                                 style: TextStyle(
//                                                   fontSize:
//                                                       ScreenUtil().setSp(24),
//                                                   color: Color(0xffb6b6b6),
//                                                 ),
//                                               ),
//                                             )
//                                           : item['is_open'] == "1"
//                                               ? closeBtn(item)
//                                               : Container(),
//                                       deleteBtn(item)
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ]),
//                     ),
//                     onTap: () {
//                       NavigatorUtils.goReplayDetails(context, item['id']);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }
//       content = Column(
//         children: arr,
//       );
//       return content;
//     }

//     Widget contentWidget() {
//       return isLoading
//           ? LoadingDialog()
//           : Container(
//               child: EasyRefresh(
//                 controller: _controller,
//                 header: BezierCircleHeader(
//                   backgroundColor: PublicColor.themeColor,
//                 ),
//                 footer: BezierBounceFooter(
//                   backgroundColor: PublicColor.themeColor,
//                 ),
//                 enableControlFinishRefresh: true,
//                 enableControlFinishLoad: false,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: <Widget>[
//                       listArea(),
//                     ],
//                   ),
//                 ),
//                 onRefresh: () async {
//                   getMyLive();
//                   _controller.finishRefresh();
//                 },
//               ),
//             );
//     }


//     var notTackList = [
//       {
//         'thumb':
//             'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
//         'old_price': "1234",
//         'now_price': '1111',
//         'title': '执象科技',
//         'desc': '测试用例',
//         'id': 1,
//         'old': '1.5岁-4.5岁',
//         'is_open': '1',
//         'money': '1'
//       },
//       {
//         'thumb':
//             'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
//         'old_price': "1234",
//         'now_price': '1111',
//         'title': '执象科技',
//         'desc': '测试用例测试用例测试用例测试用例测试用例测试用例,测试用例',
//         'id': 1,
//         'old': '1.5岁-4.5岁',
//         'is_open': '1',
//         'money': '2'
//       },
//       {
//         'thumb':
//             'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
//         'old_price': "1234",
//         'now_price': '1111',
//         'title': '执象科技',
//         'desc': '测试用例',
//         'id': 1,
//         'old': '1.5岁-4.5岁',
//         'is_open': '1',
//         'money': '1'
//       },
//       {
//         'thumb':
//             'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
//         'old_price': "1234",
//         'now_price': '1111',
//         'title': '执象科技',
//         'desc': '测试用例测试用例测试用例测试用例测试用例测试用例,测试用例',
//         'id': 1,
//         'old': '1.5岁-4.5岁',
//         'is_open': '1',
//         'money': '2'
//       },
//       {
//         'thumb':
//             'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
//         'old_price': "1234",
//         'now_price': '1111',
//         'title': '执象科技',
//         'desc': '测试用例',
//         'id': 1,
//         'old': '1.5岁-4.5岁',
//         'is_open': '1',
//         'money': '1'
//       },
//       {
//         'thumb':
//             'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
//         'old_price': "1234",
//         'now_price': '1111',
//         'title': '执象科技',
//         'desc': '测试用例测试用例测试用例测试用例测试用例测试用例,测试用例',
//         'id': 1,
//         'old': '1.5岁-4.5岁',
//         'is_open': '1',
//         'money': '2'
//       },
//     ];
    

//     Widget liwu() {
//       List<Widget> arr = <Widget>[];
//       Widget content;
//       if (notTackList.length == 0) {
//         arr.add(NoData(deHeight: 150));
//       } else {
//         for (var item in notTackList) {
//           arr.add(Container(
//             child: Column(
//               children: <Widget>[
//                 CachedImageView(
//                     ScreenUtil.instance.setWidth(92.0),
//                     ScreenUtil.instance.setWidth(84.0),
//                     item['thumb'],
//                     null,
//                     BorderRadius.all(Radius.circular(50))),
//                 SizedBox(
//                   height: ScreenUtil().setWidth(28),
//                 ),
//                 Text(
//                   item['title'],
//                   style: TextStyle(
//                     fontSize: ScreenUtil().setSp(22),
//                     color: Color(0xff333333),
//                   ),
//                 ),
//                   SizedBox(
//                   height: ScreenUtil().setWidth(12),
//                 ),
//                 Text(
//                   item['money'],
//                   style: TextStyle(
//                     fontSize: ScreenUtil().setSp(30),
//                     color: Color(0xffFB1419),
//                   ),
//                 ),
//               ],
//             ),
//           ));
//         }
//         // }

//       }
//       content = new Wrap(
//         children: arr,
//         spacing: ScreenUtil().setWidth(76),
//         runSpacing: ScreenUtil().setWidth(56),
//       );
//       return content;
//     }

//     //店铺
//     Widget notTack = Column(
//       children: <Widget>[
//         Container(
//           height: ScreenUtil().setWidth(230),
//           width: ScreenUtil().setWidth(750),
//           color: Color(0xffffffff),
//           // alignment: Alignment.center,

//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Text(
//                     '关注数量',
//                     style: TextStyle(
//                       fontSize: ScreenUtil().setSp(34),
//                       color: Color(0xff333333),
//                     ),
//                   ),
//                   Text(
//                     '12152',
//                     style: TextStyle(
//                       fontSize: ScreenUtil().setSp(62),
//                       color: Color(0xffA2BD52),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: ScreenUtil().setWidth(100),
//               ),
//               Container(
//                 height: ScreenUtil().setWidth(117),
//                 width: ScreenUtil().setWidth(1),
//                 color: Color(0xffE5E5E5),
//               ),
//               SizedBox(
//                 width: ScreenUtil().setWidth(100),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Text(
//                     '关注数量',
//                     style: TextStyle(
//                       fontSize: ScreenUtil().setSp(34),
//                       color: Color(0xff333333),
//                     ),
//                   ),
//                   Text(
//                     '12152',
//                     style: TextStyle(
//                       fontSize: ScreenUtil().setSp(62),
//                       color: Color(0xffA2BD52),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: ScreenUtil().setWidth(20),
//         ),
//         Container(
//           width: ScreenUtil().setWidth(750),
//           padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
//           color: Color(0xffffffff),
//           child: Column(
//             children: <Widget>[
//               Container(
//                 height: ScreenUtil().setWidth(100),
//                 alignment: Alignment.center,
//                 child: Text(
//                   '收到礼物',
//                   style: TextStyle(
//                     fontSize: ScreenUtil().setSp(28),
//                     color: PublicColor.themeColor,
//                   ),
//                 ),
//               ),
//               liwu(),
//               // Wrap(
//               //   children: <Widget>[
//               //     for (String item in tags) TagItem(item),
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//       ],
//     );

//     return Stack(
//       children: <Widget>[
//         new DefaultTabController(
//           length: 2,
//           child: new Scaffold(
//             backgroundColor: Color(0xfff5f5f5),
//             appBar: new AppBar(
//                 title: new Text(
//                   '我的直播',
//                   style: TextStyle(
//                     color: PublicColor.headerTextColor,
//                   ),
//                 ),
//                 centerTitle: true,
//                 flexibleSpace: Container(
//                   decoration: BoxDecoration(
//                     gradient: PublicColor.linearHeader,
//                   ),
//                 ),
//                 leading: new IconButton(
//                   icon: Icon(
//                     Icons.navigate_before,
//                     color: PublicColor.headerTextColor,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 bottom: PreferredSize(
//                   preferredSize: Size.fromHeight(50),
//                   child: Material(
//                     color: Colors.white,
//                     child: TabBar(
//                       indicatorWeight: 4.0,
//                       // indicatorSize: TabBarIndicatorSize.label,
//                       indicatorColor: PublicColor.themeColor,
//                       unselectedLabelColor: Color(0xff5e5e5e),
//                       labelColor: PublicColor.themeColor,
//                       tabs: <Widget>[
//                         new Tab(
//                           child: Text(
//                             '历史直播',
//                             style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(28),
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         new Tab(
//                           child: Text(
//                             '打赏详情',
//                             style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(28),
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ],
//                       onTap: ((index) {
//                         setState(() {
//                           type = index;
//                         });
//                         // getList(index + 1);
//                       }),
//                     ),
//                   ),
//                 )),
//             body:
//                 // isLoading
//                 //     ? LoadingDialog()
//                 //     :
//                 new TabBarView(
//               children: <Widget>[
//                 Column(
//                   children: <Widget>[
//                     SizedBox(
//                       height: ScreenUtil().setWidth(20),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child:contentWidget() ,
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(10),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: <Widget>[
//                     SizedBox(
//                       height: ScreenUtil().setWidth(20),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: notTack,
//                     ),
//                     SizedBox(
//                       height: ScreenUtil().setHeight(10),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:client/config/navigator_util.dart';
import 'package:client/service/live_service.dart';
import 'package:client/widgets/dialog.dart';
import 'package:flutter/material.dart';
import '../common/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';

class MyZbPage extends StatefulWidget {
  @override
  MyZbPageState createState() => MyZbPageState();
}

class MyZbPageState extends State<MyZbPage> {
  bool isLoading = false;
  String jwt = '';
  List goodsList = [];
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();
    getMyLive();
  }

  // 我的直播列表
  void getMyLive() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    LiveServer().myLive(map, (success) async {
      setState(() {
        isLoading = false;
        goodsList = success['list'];
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  // 删除直播
  void deleLive(item) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => item['id']);

    LiveServer().deleLive(map, (success) async {
      ToastUtil.showToast('删除成功');
      getMyLive();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 关闭直播
  void closeLive(lives) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().closeLive(map, (success) async {
      ToastUtil.showToast('关闭成功');
      getMyLive();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // 关闭直播按钮
    Widget closeBtn(item) {
      return Container(
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return MyDialog(
                    width: ScreenUtil.instance.setWidth(600.0),
                    height: ScreenUtil.instance.setWidth(300.0),
                    queding: () {
                      closeLive(item);
                      Navigator.of(context).pop();
                    },
                    quxiao: () {
                      Navigator.of(context).pop();
                    },
                    title: '温馨提示',
                    message: '确定关闭该直播？');
              },
            );
          },
          child: Text(
            "关闭直播",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(24),
              color: Color(0xffb6b6b6),
            ),
          ),
        ),
      );
    }

    // 删除直播按钮
    Widget deleteBtn(item) {
      return Container(
        width: ScreenUtil().setWidth(100),
        child: InkWell(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Image.asset(
                  "assets/shop/scan.png",
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setSp(32),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    '删除',
                    style: TextStyle(
                      color: Color(0xffb6b6b6),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              )
            ],
          ),
          onTap: () {
            print('删除');
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return MyDialog(
                    width: ScreenUtil.instance.setWidth(600.0),
                    height: ScreenUtil.instance.setWidth(300.0),
                    queding: () {
                      deleLive(item);
                      Navigator.of(context).pop();
                    },
                    quxiao: () {
                      Navigator.of(context).pop();
                    },
                    title: '温馨提示',
                    message: '确定删除该直播？');
              },
            );
          },
        ),
      );
    }

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (goodsList.length == 0) {
        arr.add(Container(
          height: ScreenUtil().setWidth(700),
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        ));
      } else {
        for (var item in goodsList) {
          arr.add(
            Container(
              child: Stack(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      height: ScreenUtil().setWidth(246),
                      width: ScreenUtil().setWidth(750),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(color: PublicColor.lineColor)),
                      ),
                      child: Row(children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Image.network(
                                    item['img'],
                                    height: ScreenUtil().setWidth(197),
                                    width: ScreenUtil().setWidth(202),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                child: Container(
                                  width: ScreenUtil().setWidth(100),
                                  height: ScreenUtil().setWidth(40),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: PublicColor.themeColor,
                                    borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(40),
                                    ),
                                  ),
                                  child: Text(
                                    item['is_open'] == "0"
                                        ? "预告"
                                        : item['is_open'] == "1"
                                            ? "直播中"
                                            : "已结束",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(24),
                                        color: PublicColor.btnTextColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(20),
                                    left: ScreenUtil().setWidth(20),
                                  ),
                                  child: Text(
                                    item['desc'],
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
                                    top: ScreenUtil().setWidth(20),
                                    bottom: ScreenUtil().setWidth(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      item['is_open'] == "2"
                                          ? Container(
                                              child: Text(
                                                item["is_huifang"] == "2"
                                                    ? "查看回放"
                                                    : "回放生成中",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(24),
                                                  color: Color(0xffb6b6b6),
                                                ),
                                              ),
                                            )
                                          : item['is_open'] == "1"
                                              ? closeBtn(item)
                                              : Container(),
                                      deleteBtn(item)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    onTap: () {
                      NavigatorUtils.goReplayDetails(context, item['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }
      content = Column(
        children: arr,
      );
      return content;
    }

    Widget contentWidget() {
      return isLoading
          ? LoadingDialog()
          : Container(
              child: EasyRefresh(
                controller: _controller,
                header: BezierCircleHeader(
                  backgroundColor: PublicColor.themeColor,
                ),
                footer: BezierBounceFooter(
                  backgroundColor: PublicColor.themeColor,
                ),
                enableControlFinishRefresh: true,
                enableControlFinishLoad: false,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      listArea(),
                    ],
                  ),
                ),
                onRefresh: () async {
                  getMyLive();
                  _controller.finishRefresh();
                },
              ),
            );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '我的直播',
            style: TextStyle(
              color: PublicColor.headerTextColor,
            ),
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
        body: contentWidget(),
      ),
    );
  }
}
