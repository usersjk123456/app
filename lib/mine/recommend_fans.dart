// import '../widgets/btn_big.dart';
// import '../shop/share_django.dart';
// import 'package:flutter/material.dart';
// import '../common/color.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../service/user_service.dart';
// import '../utils/toast_util.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_html/flutter_html.dart';

// class RecommendFansPage extends StatefulWidget {
//   @override
//   RecommendFansPageState createState() => RecommendFansPageState();
// }

// class RecommendFansPageState extends State<RecommendFansPage> {
//   @override
//   String fsnum = "";
//   String contant = "";
//   String jwt = '', fans = '';
//   @override
//   void initState() {
//     super.initState();
//     getLocal();
//   }

//   void getLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       jwt = prefs.getString('jwt');
//     });
//     if (jwt != null) {
//       getInfo();
//       getAgree();
//     }
//   }
//   void getInfo() async {
//     Map<String, dynamic> map = Map();
//     UserServer().getUserInfo(map, (success) async {
//       if (mounted) {
//         setState(() {

//           fans = success['fans'].toString();

//         });
//       }
//     }, (onFail) async {
//       ToastUtil.showToast(onFail);
//     });
//   }
//   // void getInfo() async {
//   //   Map<String, dynamic> map = Map();
//   //   map.putIfAbsent("jwt", () => jwt);
//   //   UserServer().cwts(map, (success) async {
//   //     if (mounted) {
//   //       print('$success');
//   //       setState(() {
//   //         contant = success['activity'];
//   //         fsnum = success['user']['fans'].toString();
//   //       });
//   //     }
//   //   }, (onFail) async {
//   //     ToastUtil.showToast(onFail);
//   //   });
//   // }
//   // 获取个人资料
//   void getAgree() async {

//     Map<String, dynamic> map = Map();
//     UserServer().getAbout(map, (success) async {
//       setState(() {
//         contant = success['res']['about'];
//       });
//     }, (onFail) async {

//       ToastUtil.showToast(onFail);
//     });
//   }

//   Widget build(BuildContext context) {
//     Widget playBox = Container(
//       padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
//       child: Html(data: contant),
//     );
//     ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

//     Widget btnArea = new Container(
//       width: ScreenUtil().setWidth(754),
//       margin: EdgeInsets.only(
//         top: ScreenUtil().setWidth(54)
//       ),
//       alignment: Alignment.center,
//       // child: BigButton(
//       //   name: '立即邀请',

//       //   tapFun: () {
//       //     showModalBottomSheet(
//       //       context: context,
//       //       builder: (BuildContext context) {
//       //         return ShareDjango(type: "invite");
//       //       },
//       //     );
//       //   },
//       //   width: ScreenUtil().setWidth(343),
//       // ),
//       child: InkWell(
//         onTap: (){
//           showModalBottomSheet(
//             context: context,
//             builder: (BuildContext context) {
//               return ShareDjango(type: "invite");
//             },
//           );
//         },
//         child: Image.asset(
//           'assets/shop/ic_yaoqing_anniu.png',
//           width: ScreenUtil().setWidth(506),
//         ),
//       ),
//     );

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           centerTitle: true,
//           title: new Text(
//             '成为推手',
//             style: new TextStyle(color: PublicColor.headerTextColor),
//           ),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: PublicColor.linearHeader,
//             ),
//           ),
//           leading: new IconButton(
//             icon: Icon(
//               Icons.navigate_before,
//               color: PublicColor.headerTextColor,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         body: new Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/shop/tuishou_bg.png"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Stack(
//             children: <Widget>[
//               // Text('当前粉丝数量:1864'),
//               Positioned(
//                 child: btnArea,
//                 bottom: ScreenUtil().setWidth(450),
//               ),
//               Positioned(
//                 // child: Text("???????"),
//                 child: Container(
//                   width: ScreenUtil().setWidth(750),
//                   alignment: Alignment.topCenter,
//                   child: Text('当前粉丝数量：${fans}',
//                       style: TextStyle(
//                           color: PublicColor.whiteColor,
//                           fontSize: ScreenUtil().setSp(38))),
//                 ),
//                 bottom: ScreenUtil().setWidth(550),
//               ),
//               Positioned(
//                 left: ScreenUtil().setWidth(48),
//                 // child: Text("???????"),
//                 child: Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage("assets/shop/tjbg.png"),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     width: ScreenUtil().setWidth(656),
//                     // height: ScreenUtil().setWidth(400),
//                     alignment: Alignment.topCenter,
//                     child: Column(
//                       children: <Widget>[
//                         // Container(
//                         //     padding: EdgeInsets.only(
//                         //       top: ScreenUtil.instance.setWidth(73.0),
//                         //     ),
//                         //     child: Image.asset(
//                         //       'assets/shop/tstitle.png',
//                         //       width: ScreenUtil.instance.setWidth(139.0),
//                         //       // height: ScreenUtil.instance.setWidth(34.0),
//                         //     )),
//                         Container(
//                             width: ScreenUtil.instance.setWidth(521.0),
//                             height: ScreenUtil.instance.setWidth(200.0),
//                             margin: EdgeInsets.only(
//                               top: ScreenUtil.instance.setWidth(100.0),
//                             ),
//                             child: ListView(
//                               children: <Widget>[playBox],
//                             ))
//                       ],
//                     )),
//                 bottom: ScreenUtil().setWidth(50),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:client/utils/string_util.dart';

import '../widgets/btn_big.dart';
import '../shop/share_django.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

class RecommendFansPage extends StatefulWidget {
  @override
  RecommendFansPageState createState() => RecommendFansPageState();
}

class RecommendFansPageState extends State<RecommendFansPage> {
  @override
  String fsnum = "";
  String contant = "";
  String jwt = '', fans = '';
  @override
  void initState() {
    super.initState();
    getLocal();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString('jwt');
    });
    if (jwt != null) {
      getInfo();
      getAgree();
    }
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          fans = success["user"]['fans'].toString();
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 获取个人资料
  void getAgree() async {
    Map<String, dynamic> map = Map();
    UserServer().getAbout(map, (success) async {
      setState(() {
        contant = success['res']['about'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  Widget build(BuildContext context) {
    Widget playBox = Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      child: Html(data: contant),
    );
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget btnArea = new Container(
      width: ScreenUtil().setWidth(754),
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(54)),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ShareDjango(type: "invite");
            },
          );
        },
        child: Image.asset(
          'assets/shop/ic_yaoqing_anniu.png',
          width: ScreenUtil().setWidth(506),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '成为推手',
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/shop/ic_yaoqing_bg1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Text('当前粉丝数量:1864'),
              // Positioned(
              //   child: btnArea,
              //   bottom: ScreenUtil().setWidth(450),
              // ),
              // Positioned(
              //   child: Container(
              //     width: ScreenUtil().setWidth(750),
              //     alignment: Alignment.topCenter,
              //     child: Text('当前粉丝数量：${fans}',
              //         style: TextStyle(
              //             color: PublicColor.whiteColor,
              //             fontSize: ScreenUtil().setSp(38))),
              //   ),
              //   bottom: ScreenUtil().setWidth(550),
              // ),
              Positioned(
                bottom: ScreenUtil().setWidth(450),
                left: ScreenUtil().setWidth(40),
                child: Container(
                  width: ScreenUtil().setWidth(668),
                  height: ScreenUtil().setWidth(331),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/shop/ic_yaoqing_bg2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(750),
                        alignment: Alignment.topCenter,
                        child: Text('当前粉丝数量：${StringUtils.isEmpty(fans) ? 0 : fans}',
                            style: TextStyle(
                                color: PublicColor.whiteColor,
                                fontSize: ScreenUtil().setSp(38))),
                      ),
                      btnArea,
                    ],
                  ),
                ),
              ),
              Positioned(
                left: ScreenUtil().setWidth(48),
                child: Container(
                         width: ScreenUtil().setWidth(680),
                  height: ScreenUtil().setWidth(363),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/shop/tjbg.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
            
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        Container(
                            width: ScreenUtil.instance.setWidth(521.0),
                            height: ScreenUtil.instance.setWidth(200.0),
                            margin: EdgeInsets.only(
                              top: ScreenUtil.instance.setWidth(100.0),
                            ),
                            child: ListView(
                              children: <Widget>[playBox],
                            ))
                      ],
                    )),
                bottom: ScreenUtil().setWidth(60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
