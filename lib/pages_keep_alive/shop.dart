import 'package:client/common/Global.dart';
import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import 'package:flutter/services.dart';
import '../widgets/cached_image.dart';
import '../service/store_service.dart';
import '../widgets/tool_menu.dart';

class ShopPage extends StatefulWidget {
  final Function stateUser;
  ShopPage({this.stateUser});
  @override
  ShopPageState createState() => ShopPageState();
}

class ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  //保持页面状态
  bool get wantKeepAlive => true;
  DateTime lastPopTime;
  bool isLoading = false, isStore = false;
  String jwt = '',
      uid = '',
      nickname = '',
      balance = '',
      jifen = '',
      headimgurl = '',
      todayYg = '',
      cumulativeYg = '',
      cumulativeYj = '',
      vip = '',
      id = '';
  int fans = 0;
  int status = 0;
  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getInfo();
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();

    StoreServer().getHome(map, (success) {
      if (mounted) {
        setState(() {
          headimgurl = success['user']['headimgurl'];
          nickname = success['user']['nickname'];
          balance = success['user']['balance'];
          jifen = success['user']['jifen'].toString();
          fans = success['user']['fans'];
          id = success['user']['id'].toString();
          todayYg = success['today'].toString();
          cumulativeYg = success['lei'].toString();
          cumulativeYj = success['yong'].toString();
          status = int.parse(success['status'].toString());
          vip = (success['user']['vip'] + 1).toString();
          isStore =
              success['user']['is_store'].toString() == "0" ? false : true;
        });
      }
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget bgArea = new Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      height:  Global.isShow
            ? ScreenUtil().setWidth(520):ScreenUtil().setWidth(395),
      child: Stack(children: <Widget>[
        //bg图片
        Positioned(
          top: 0,
          child: Image.asset(
            "assets/shop/bg_wode.png",
            height: ScreenUtil().setWidth(395),
            width: ScreenUtil().setWidth(750),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 40,
          right: 0,
          child: Container(
            height: ScreenUtil().setWidth(70),
            width: ScreenUtil().setWidth(200),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color(0xffA7CD60),
                Color(0xff10C798),
              ]),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            // child: InkWell(
            //     child: Container(
            //       alignment: Alignment.center,
            //       child: Text(
            //         !isStore
            //             ? (status == -1
            //                 ? '成为供应商'
            //                 : status == 0
            //                     ? '审核中'
            //                     : status == 1 ? '缴纳保证金' : '审核失败')
            //             : '切换到供货商',
            //         style: TextStyle(
            //           fontSize: ScreenUtil().setSp(28),
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //     onTap: () {
            //       if (!isStore) {
            //         if (status == 0) {
            //           NavigatorUtils.goAuthenticationWaitingPage(context);
            //         } else if (status == 1) {
            //           NavigatorUtils.toAuthenticationPayPage(context);
            //         } else {
            //           NavigatorUtils.goApplicationPage(context);
            //         }
            //       } else {
            //         widget.stateUser(1);
            //       }
            //     }),
            child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    !isStore
                        ? (status == -1
                            ? '成为供应商'
                            : status == 0
                                ? '审核中'
                                : status == 1 ? '缴纳保证金' : '审核失败')
                        : '切换到供货商',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: PublicColor.whiteColor,
                    ),
                  ),
                ),
                onTap: () {
                  if (!isStore) {
                    if (status == 0) {
                      NavigatorUtils.goAuthenticationWaitingPage(context)
                          .then((data) {
                        getInfo();
                      });
                    } else if (status == 1) {
                      NavigatorUtils.toAuthenticationPayPage(context)
                          .then((data) {
                        getInfo();
                      });
                    } else {
                      NavigatorUtils.goApplicationPage(context).then((data) {
                        getInfo();
                      });
                    }
                  } else {
                    widget.stateUser(1);
                  }
                }),
          ),
        ),
        Positioned(
            top: 60,
            left: 20,
            child: new Row(
              children: <Widget>[
                new InkWell(
                  child: Container(
                    child: headimgurl == ""
                        ? Container()
                        : CachedImageView(
                            ScreenUtil.instance.setWidth(127.0),
                            ScreenUtil.instance.setWidth(127.0),
                            headimgurl,
                            null,
                            BorderRadius.all(Radius.circular(50.0))),
                  ),
                  onTap: () {
                    if (isStore) {
                      NavigatorUtils.goShopInforPage(context);
                    }
                  },
                ),
                new Container(
                  padding: EdgeInsets.only(left: 20),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Container(
                        //   width: ScreenUtil().setWidth(560),
                        //   child: Text(
                        //     nickname,
                        //     style: TextStyle(
                        //         fontSize: ScreenUtil().setSp(30),
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.w600),
                        //   ),
                        // ),
                        Container(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: ScreenUtil().setWidth(450),
                                  ),
                                  child: Text(
                                    "${nickname}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: PublicColor.btnColor,
                                      fontSize: ScreenUtil().setSp(32),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(10)),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(16),
                                      ScreenUtil().setWidth(3),
                                      ScreenUtil().setWidth(16),
                                      ScreenUtil().setWidth(3)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                    border: Border.all(
                                      width: ScreenUtil().setWidth(1),
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  child: Text(
                                    '等级${vip}',
                                    style: TextStyle(
                                      color: PublicColor.btnColor,
                                      fontSize: ScreenUtil().setSp(22),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          width: ScreenUtil().setWidth(560),
                          child: Text(
                            'ID:${id} ',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(560),
                          height: ScreenUtil().setWidth(60),
                          child: new Row(children: <Widget>[
                            Expanded(
                                flex: 3,
                                child: RichText(
                                    text: TextSpan(
                                        text: '邀请码',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil.instance
                                                .setWidth(28)),
                                        children: <TextSpan>[
                                      TextSpan(
                                          text: id,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(28))),
                                    ]))),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(75),
                                  height: ScreenUtil().setWidth(40),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text('复制',
                                      style: TextStyle(
                                          color: Colors.white,
                                          height: 1.3,
                                          fontSize: ScreenUtil.instance
                                              .setWidth(24))),
                                ),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: id));
                                  ToastUtil.showToast('复制成功');
                                },
                              ),
                            ),
                            isStore
                                ? Expanded(
                                    flex: 4,
                                    child: InkWell(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 20),
                                        child: Text(
                                          '店铺管理>',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(30)),
                                        ),
                                      ),
                                      onTap: () {
                                        NavigatorUtils.toShopManagePage(
                                            context);
                                      },
                                    ),
                                  )
                                : Expanded(
                                    flex: 4,
                                    child: Text(''),
                                  )
                          ]),
                        ),
                      ]),
                )
              ],
            )),

        Global.isShow
            ? Positioned(
                bottom: 0,
                left: 15,
                child: Container(
                  height: ScreenUtil().setWidth(260),
                  width: ScreenUtil().setWidth(700),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: new Column(children: <Widget>[
                    Container(
                      height: ScreenUtil().setWidth(120),
                      width: ScreenUtil().setWidth(700),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: PublicColor.lineColor)),
                      ),
                      child: Row(children: <Widget>[
                        InkWell(
                          onTap: () {
                            NavigatorUtils.goCurrentBalancePage(context);
                          },
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(30),
                                    10,
                                    ScreenUtil().setWidth(20),
                                    0),
                                child: Text(
                                  '余额(元)',
                                  style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                              ),
                              new Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '$balance',
                                  style: TextStyle(
                                      color: Color(0xffA2BD52),
                                      fontSize: ScreenUtil().setSp(28),
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     NavigatorUtils.goCurrentJJPage(context);
                        //   },
                        //   child: new Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       new Container(
                        //         alignment: Alignment.center,
                        //         padding: EdgeInsets.fromLTRB(
                        //             ScreenUtil().setWidth(30),
                        //             10,
                        //             ScreenUtil().setWidth(20),
                        //             0),
                        //         child: Text(
                        //           '奖金(元)',
                        //           style: TextStyle(
                        //             color: Color(0xff888888),
                        //             fontSize: ScreenUtil().setSp(28),
                        //           ),
                        //         ),
                        //       ),
                        //       new Container(
                        //         // padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30),
                        //         //     5, ScreenUtil().setWidth(0), 0),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           '$jifen',
                        //           style: TextStyle(
                        //               color: Color(0xffA2BD52),
                        //               fontSize: ScreenUtil().setSp(28),
                        //               fontWeight: FontWeight.w600),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ]),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        child: new Row(children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: new Column(children: <Widget>[
                                Container(
                                    child: Text(
                                  '今日预估',
                                  style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                )),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      todayYg,
                                      style: TextStyle(
                                          color: Color(0xff4f4f4f),
                                          fontSize: ScreenUtil().setSp(28),
                                          fontWeight: FontWeight.w600),
                                    ))
                              ])),
                          Expanded(
                              flex: 1,
                              child: new Column(children: <Widget>[
                                Container(
                                    child: Text(
                                  '累计预估',
                                  style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                )),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      cumulativeYg,
                                      style: TextStyle(
                                          color: Color(0xff4f4f4f),
                                          fontSize: ScreenUtil().setSp(28),
                                          fontWeight: FontWeight.w600),
                                    ))
                              ])),
                          Expanded(
                              flex: 1,
                              child: new Column(children: <Widget>[
                                Container(
                                    child: Text(
                                  '累计佣金',
                                  style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                )),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      cumulativeYj,
                                      style: TextStyle(
                                          color: Color(0xff4f4f4f),
                                          fontSize: ScreenUtil().setSp(28),
                                          fontWeight: FontWeight.w600),
                                    ))
                              ]))
                        ]))
                  ]),
                ),
              )
            : Container(),
        Global.isShow
            ? Positioned(
                top: 145,
                right: 0,
                child: InkWell(
                  child: Container(
                    child: Image.asset(
                      "assets/shop/zbqy.png",
                      height: ScreenUtil().setWidth(60),
                      width: ScreenUtil().setWidth(188),
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    NavigatorUtils.toAnchorQyPage(context);
                  },
                ),
              )
            : Container(),
      ], textDirection: TextDirection.rtl),
    );

    Widget btnArea = new Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(14)),
      alignment: Alignment.center,
      child: Container(
        width: ScreenUtil().setWidth(710),
        height: ScreenUtil().setWidth(150),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: ScreenUtil.getInstance().setWidth(143.0),
                width: ScreenUtil.getInstance().setWidth(217.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xffFF7DAF),
                    Color(0xffFF748D),
                  ]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  child: new Column(children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          '粉丝数',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          '$fans',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ))
                  ]),
                  onTap: () {
                    NavigatorUtils.goFansNumsPage(context);
                  },
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  height: ScreenUtil.getInstance().setWidth(143.0),
                  width: ScreenUtil.getInstance().setWidth(215.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xffFC686F),
                      Color(0xffFF934C),
                    ]),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    child: new Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Image.asset(
                          "assets/shop/zb.png",
                          height: ScreenUtil().setWidth(43),
                          width: ScreenUtil().setWidth(40),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '开通直播',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ))
                    ]),
                    onTap: () {
                      NavigatorUtils.goOpeningZbPage(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CreateZhiboPage()));
                    },
                  ),
                ),
              ),
              Container(
                height: ScreenUtil.getInstance().setWidth(143.0),
                width: ScreenUtil.getInstance().setWidth(217.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xff28CFB3),
                    Color(0xffD0EC7F),
                  ]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  child: new Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Image.asset(
                        "assets/shop/fs.png",
                        height: ScreenUtil().setWidth(45),
                        width: ScreenUtil().setWidth(45),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          '邀请粉丝',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ))
                  ]),
                  onTap: () {
                    NavigatorUtils.goInvitationFsPage(context);
                  },
                ),
              )
            ]),
      ),
    );

    //数据管理
    Widget shujuGL = new Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(14)),
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8, left: 15),
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(80),
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: PublicColor.lineColor)),
              ),
              child: Text(
                '数据管理',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: new Wrap(
                spacing: ScreenUtil().setWidth(30), // 主轴(水平)方向间距
                runSpacing: ScreenUtil().setWidth(4), // 纵轴（垂直）方向间距
                children: <Widget>[
                  Global.isShow
                      ? ToolMenu(
                          img: 'assets/shop/tgdd.png',
                          name: '推广订单',
                          tapFun: () {
                            NavigatorUtils.toExtensionPage(context);
                          },
                        )
                      : Container(),
                  ToolMenu(
                    img: 'assets/shop/ljfw.png',
                    name: '累计访问',
                    tapFun: () {
                      NavigatorUtils.toCumulativeFwPage(context);
                    },
                  ),
                  ToolMenu(
                    img: 'assets/shop/scgl.png',
                    name: '素材管理',
                    tapFun: () {
                      NavigatorUtils.toMaterialGlPage(context);
                    },
                  ),
                  ToolMenu(
                    img: 'assets/shop/myxy.png',
                    name: '橙子学院',
                    tapFun: () {
                      NavigatorUtils.toMuyuCollegePage(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    //钻石专享
    Widget zuanshiZX = new Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
        width: ScreenUtil().setWidth(700),
        // height: ScreenUtil().setWidth(280),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15),
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(80),
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: PublicColor.lineColor)),
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      '钻石专享',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                        child: Container(
                          padding: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          child: Text(
                            '全部 >',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xff888888),
                            ),
                          ),
                        ),
                        onTap: () {
                          NavigatorUtils.toDiamondsZxPage(context);
                        }),
                  )
                ],
              ),
            ),
            Container(
              child: Wrap(
                spacing: ScreenUtil().setWidth(30), // 主轴(水平)方向间距
                runSpacing: ScreenUtil().setWidth(4), // 纵轴（垂直）方向间距
                children: <Widget>[
                  ToolMenu(
                    img: 'assets/shop/zsjx.png',
                    name: '钻石精选',
                    tapFun: () {
                      NavigatorUtils.toDiamondsJxPage(context, "3");
                    },
                  ),
                  ToolMenu(
                    img: 'assets/shop/mzbm.png',
                    name: '每周必BUY',
                    tapFun: () {
                      NavigatorUtils.toDiamondsJxPage(context, "4");
                    },
                  ),
                  ToolMenu(
                    img: 'assets/shop/sqgl.png',
                    name: '省钱攻略',
                    tapFun: () {
                      ToastUtil.showToast('暂无开放');
                    },
                  ),
                  ToolMenu(
                    img: 'assets/shop/djzq.png',
                    name: '低价专区',
                    tapFun: () {
                      NavigatorUtils.toDiamondsJxPage(context, "5");
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    //我的直播
    Widget myZhiBo = new Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
      alignment: Alignment.center,
      child: Container(
        width: ScreenUtil().setWidth(700),
        padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: new Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 8, left: 15),
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(80),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: PublicColor.lineColor)),
            ),
            child: Text(
              '我的直播',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: Colors.black,
              ),
            ),
          ),
          Container(
            child: Wrap(
              spacing: ScreenUtil().setWidth(30), // 主轴(水平)方向间距
              runSpacing: ScreenUtil().setWidth(4), // 纵轴（垂直）方向间距
              children: <Widget>[
                ToolMenu(
                  img: 'assets/shop/cjzb.png',
                  name: '创建直播',
                  tapFun: () {
                    NavigatorUtils.toCreateZhiboPage(context);
                  },
                ),
                ToolMenu(
                  img: 'assets/shop/wdyg.png',
                  name: '我的预告',
                  tapFun: () {
                    NavigatorUtils.toMyYgPage(context);
                  },
                ),
                ToolMenu(
                  img: 'assets/shop/wdzb.png',
                  name: '我的直播',
                  tapFun: () {
                    NavigatorUtils.toMyZbPage(context);
                  },
                ),
                Container(
                  //占位
                  width: ScreenUtil().setWidth(140),
                ),
              ],
            ),
          )
        ]),
      ),
    );

    return WillPopScope(
      child: Scaffold(
        backgroundColor: PublicColor.bodyColor,
        body: Container(
          child: new ListView(
            padding: EdgeInsets.only(top: 0),
            children: <Widget>[
              bgArea,
              Global.isShow ? btnArea : Container(),
              shujuGL,
              zuanshiZX,
              myZhiBo,
              new SizedBox(height: ScreenUtil().setWidth(30))
            ],
          ),
        ),
      ),
      onWillPop: () async {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          ToastUtil.showToast('再按一次退出');
          return false;
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    );
  }
}
