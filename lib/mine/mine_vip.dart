import 'package:client/model/vip_recharge.dart';
import 'package:client/pay_order/vip_pay.dart';
import 'package:client/widgets/base_text.dart';
import 'package:client/widgets/row_tile.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../service/user_service.dart';
import '../service/home_service.dart';
import '../widgets/cached_image.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:client/common/global.dart';

class MineVipPage extends StatefulWidget {
  @override
  MineVipPageState createState() => MineVipPageState();
}

class MineVipPageState extends State<MineVipPage> {
  bool isLoading = false;
  String jwt = '', addressId = "", vip = '', viptime = '', ji = '1';

  VipRecharge _vipRecharge = VipRecharge();
  List allList = [];
  List addressList = [], jingxuanList = [];
  int _page = 0;
  bool isLogin = false;
  Timer _timer;
  String headimgurl = '',
      name = '',
      kfToken = '',
      id = "",
      phone = "",
      shangjilive = "";

  int isLive = 0;

  @override
  void initState() {
    super.initState();
    getvip();
    getInfo();
    getTYK();
  }

  void getvip() async {
    Map<String, dynamic> map = Map();
    UserServer().getvip(map, (success) async {
      setState(() {
        var result = success.map((e) => VipRecharge.fromJson(e)).toList();
        for (int i = 0; i < result.length; i++) {
          result[i].level = (i + 1).toString();
        }
        allList = result;
        allList.elementAt(0).title = "连续包月会员";
        allList.elementAt(0).priceTypeName = "尝鲜价";
        allList.elementAt(1).title = "半年会员";
        allList.elementAt(1).priceTypeName = "优惠价";
        allList.elementAt(2).title = "一年会员";
        allList.elementAt(2).priceTypeName = "惊爆价";
        _vipRecharge = allList.elementAt(0);
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void cancelTimer() {
    _timer?.cancel();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startTimer(orderId) {
    setState(() {
      isLoading = true;
    });
    //设置 1 秒回调一次
    const period = const Duration(seconds: 2);
    _timer = Timer.periodic(period, (timer) {
      getPayStatus(orderId);
      //更新界面
    });
  }

  void getPayStatus(orderId) async {
    print('支付中..');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => orderId);
    map.putIfAbsent("type", () => "1");
    UserServer().getPayStatus(map, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');
      // NavigatorUtils.goMyOrderPage(context, type);
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

// 课程
  void getTYK() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("is_vip", () => ji);
    map.putIfAbsent("limit", () => 2);
    map.putIfAbsent("page", () => _page);
    HomeServer().getclass(map, (success) async {
      setState(() {
        isLoading = false;
      });

      jingxuanList = success['list'];

      // fenleiApi();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  ylmobanView(allList) {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < allList.length; i++) {
      list.add(InkWell(
        onTap: () {
          // allList[i][index];
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return VipFukuanWidget(
                  startTimer: startTimer,
                  vipRecharge: _vipRecharge,
                  // popContent: popContent,
                );
              });
          // payOrder(allList[i]['money']);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffE6AA74),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          width: ScreenUtil().setWidth(209),
          height: ScreenUtil().setWidth(146),
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20),
            bottom: ScreenUtil().setWidth(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                allList[i]['money'].toString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '元',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return list;
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          isLogin = true;
          headimgurl = success['user']['headimgurl'];
          viptime = success['user']['date'].toString();
          vip = success['user']['vip'].toString();
          name = success['user']['nickname'];
          id = success['user']['id'].toString();
          phone = success['user']['phone'].toString();
          shangjilive = success['user']['shangjilive'].toString();
          isLive = success['user']['is_live'];
          kfToken = success['user']['kf_token'];
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      // getList();
    }
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

  Widget getSlides() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (jingxuanList.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in jingxuanList) {
        arr.add(
          Card(
            elevation: 1,
            child: Container(
              height: ScreenUtil().setHeight(226),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(20),
              ),
              padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(24),
                  left: ScreenUtil().setWidth(26),
                  bottom: ScreenUtil().setWidth(24)),
              child: InkWell(
                onTap: () {
                  print(item);
                  String oid = (item['id']).toString();
                  NavigatorUtils.gobabyXiangqing(context, oid, '3');
                },
                //设置圆角
                child: Row(children: [
                  Container(
                    child: CachedImageView(
                      ScreenUtil.instance.setWidth(219.0),
                      ScreenUtil.instance.setWidth(219.0),
                      item['img'],
                      null,
                      BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(29),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(400),
                          child: Text(
                            item['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: ScreenUtil().setSp(32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                            width: ScreenUtil().setWidth(400),
                            child: Text(
                              item['text'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            )),
                        Container(
                          width: ScreenUtil().setWidth(373),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(155),
                                height: ScreenUtil().setWidth(39),
                                decoration: BoxDecoration(
                                  color: Color(0xffFDEAE2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border: Border.all(
                                      color: Color(0xffEE9249), width: 1),
                                ),
                                child: Text(
                                  item['age'],
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(24),
                                    color: Color(0xffF48051),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(136),
                                height: ScreenUtil().setWidth(53),
                                decoration: BoxDecoration(
                                  color: Color(0xffF57C4C),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border: Border.all(
                                      color: Color(0xffF57C4C), width: 1),
                                ),
                                child: InkWell(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '0元领',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(34),
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(11),
                                      ),
                                      Image.asset(
                                        'assets/index/ic_jiantou.png',
                                        width: ScreenUtil().setWidth(13),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print(item);
                                    String oid = (item['id']).toString();
                                    NavigatorUtils.gobabyXiangqing(
                                        context, oid, '3');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      }
    }
    content = new ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 0, left: 10, right: 10),
      children: arr,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("会员充值"),
      ),
      body: _buildBody(context),
    );

    Widget topArea = Container(
      alignment: Alignment.topCenter,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(470),
      child: Stack(children: <Widget>[
        //图片
        /*  Positioned(
          top: 0,
          child: Image.asset(
            "assets/mine/rzt.png",
            height: ScreenUtil().setWidth(356),
            width: ScreenUtil().setWidth(750),
            fit: BoxFit.cover,
          ),
        ),*/
        /*Positioned(
            top: ScreenUtil().setWidth(60),
            left: ScreenUtil().setWidth(30),
            child: Container(
              height: ScreenUtil().setWidth(60),
              width: ScreenUtil().setWidth(40),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                      padding: new EdgeInsets.fromLTRB(2, 2, 2, 12.0),
                      child: Image.asset(
                        "assets/mine/backIcon.png",
                        width: 7,
                      )),
                ),
              ),
            )),*/

        //头像
        Positioned(
          top: ScreenUtil().setWidth(110),
          child: Container(
              child: Row(
            children: <Widget>[
              /*InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0,
                      ScreenUtil().setWidth(45), 0),
                  child: headimgurl == ""
                      ? Container()
                      : CachedImageView(
                          ScreenUtil.instance.setWidth(124.0),
                          ScreenUtil.instance.setWidth(124.0),
                          headimgurl,
                          null,
                          BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                ),
              )*/
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Row(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(250),
                        ),
                        child: Text(
                          "$name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: PublicColor.btnColor,
                            fontSize: ScreenUtil().setSp(32),
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      vip == '0'
                          ? Container()
                          : Container(
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
                                '${vip}等级',
                                style: TextStyle(
                                  color: PublicColor.btnColor,
                                  fontSize: ScreenUtil().setSp(22),
                                ),
                              ),
                            ),
                    ],
                  )),
                  vip == '0'
                      ? Container()
                      : Container(
                          child: Text(
                            // shangjilive != '0'
                            // (邀请人ID：${shangjilive})
                            " ${viptime} 到期",
                            // : 'ID: ${id}',
                            style: TextStyle(
                              color: PublicColor.btnColor,
                              fontSize: ScreenUtil().setSp(26),
                            ),
                          ),
                        ),
                ],
              )
            ],
          )),
        ),
        /*Positioned(
          bottom: 0,
          // left: 0,
          child: Container(
            height: ScreenUtil().setWidth(205),
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(28),
              right: ScreenUtil().setWidth(28),
            ),
            child: Card(
              child: Wrap(
                runSpacing: ScreenUtil.instance.setWidth(0),
                spacing: ScreenUtil.instance.setWidth(25),
                children: ylmobanView(allList),
              ),
            ),
          ),
        ),*/
      ]),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(
            title: Text("会员充值"),
          ),
          body: Container(
            alignment: Alignment.center,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                topArea,
                SizedBox(
                  height: ScreenUtil().setWidth(30),
                ),
                Global.isShow
                    ? Container(
                        color: Color(0xffffffff),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '·',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setWidth(60),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(20),
                            ),
                            Text(
                              'VIP体验课栏',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(36),
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(20),
                            ),
                            Text(
                              '·',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setWidth(60),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        height: ScreenUtil().setWidth(99),
                        width: ScreenUtil().setWidth(750),
                      )
                    : Container(),
                Global.isShow ? getSlides() : Container(),
                SizedBox(
                  height: ScreenUtil().setWidth(30),
                ),
                // listArea
              ],
            ),
          ),
        ),
        isLoading ? LoadingDialog(types: "1") : Container()
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (allList.isEmpty) {
      return Container();
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 15,
              ),
              margin: EdgeInsets.only(
                bottom: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: RowTile(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                leading: CachedImageView(
                  ScreenUtil.instance.setWidth(80.0),
                  ScreenUtil.instance.setWidth(80.0),
                  headimgurl,
                  null,
                  BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
                title: BaseText(
                  "$name",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                //subTitle: Text("${viptime} 到期"),
                hasBottomBorder: false,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    "请选择会员套餐",
                    color: Color(0xFFF0D4A6),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    margin: EdgeInsets.only(
                      bottom: 20,
                    ),
                  ),
                  ...allList.map((e) => _buildMoneyItem(e)).toList()
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: VipFukuanWidget(
                vipRecharge: _vipRecharge,
                startTimer: startTimer,
                // popContent: popContent,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyItem(VipRecharge vipRecharge) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _vipRecharge = vipRecharge;
        });
      },
      child: Card(
        color: vipRecharge == _vipRecharge ? Color(0xffF9EAE7) : Colors.white,
        elevation: 0.5,
        margin: EdgeInsets.only(bottom: 15),
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Row(
            children: [
              BaseText(
                vipRecharge.title,
                fontSize: 18,
              ),
              Container(
                child: BaseText(
                  "${vipRecharge.priceTypeName}!",
                  color: Colors.white,
                  fontSize: 12,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 8,
                ),
                margin: EdgeInsets.only(
                  left: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  gradient: LinearGradient(
                    //渐变位置
                    begin: Alignment.topRight, //右上
                    end: Alignment.bottomLeft, //左下
                    stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                    //渐变颜色[始点颜色, 结束颜色]
                    colors: [
                      Color.fromRGBO(237, 140, 76, 1),
                      Color.fromRGBO(238, 83, 42, 1)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "￥${vipRecharge.money}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough
                        ),
                      ),
                      BaseText(
                        "￥${vipRecharge.discountPrice}",
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
