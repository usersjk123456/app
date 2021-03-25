import 'dart:async';

import 'package:client/api/api.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:client/widgets/search_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';

class FoodClass extends StatefulWidget {
  @override
  FoodClassState createState() => FoodClassState();
}

class FoodClassState extends State<FoodClass> {
  EasyRefreshController _controller = EasyRefreshController();
  String aboutContent;
  bool isLoading = false;
  String searchval = "";
  List foodTipsList = [];
  List flList = [];
  List foodCdlist = [], lists = [];
  int _page = 0;
  int _limit = 10;
  Map babyInf = {'headimgurl': ''};
  String babyText = '';
  String babyid = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  @override
  void initState() {
    super.initState();

    getbabyList();
    getFsxzs();
    getFssp();
    getFoodList();
  }

  void getbabyList() async {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, dynamic> map = Map();
    UserServer().getbabyList(map, (success) async {
      setState(() {
        // isLoading = false;
        lists = success['list'];
      });
      if (success['list'].length > 0) {
        getBabyInf();
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getBabyInf() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    babyid = prefs.getString('id');
    print('?????????????');
    print(prefs.getString('id'));
    //获取宝宝信息
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    Service().getData(map, Api.GET_BABY_URL, (success) async {
      setState(() {
        babyInf = success['data'];
      });

      getSm(babyInf['id']);
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  getSm(id) {
    //获取辅食说明
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id);
    Service().getData(map, Api.BABY_FS_URL, (success) async {
      setState(() {
        babyText = success['text'];
      });
      print(babyInf);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getFsxzs() {
    //获取辅食小知识
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 5);
    Service().getData(map, Api.FENLEI_LIST_URL, (success) async {
      setState(() {
        for (var i = 0; i < success['list'].length; i++) {
          foodTipsList.add(success['list'][i]);
        }
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getFssp() {
    //获取辅食食谱分类
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 3);
    map.putIfAbsent("limit", () => 3);
    map.putIfAbsent("page", () => 1);
    Service().getData(map, Api.FOODSP_URL, (success) async {
      setState(() {
        for (var i = 0; i < success['list'].length; i++) {
          flList.add(success['list'][i]);
        }
      });
      await setState(() {
        Map<String, dynamic> allsp = {
          'img':
              'https://yzhlimgserver.oss-cn-beijing.aliyuncs.com/2020-10-10/muyu_ae5a607b4d7d9ff001942b01cb1875b0.png',
          'name': '全部食谱'
        };
        flList.add(allsp);
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getFoodList() {
    _page++;
    if (_page == 1) {
      setState(() {
        foodCdlist = [];
      });
    }
    //获取辅食菜单列表
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 1);
    map.putIfAbsent("limit", () => _limit);
    map.putIfAbsent("page", () => _page);
    Service().getData(map, Api.FOODCD_List_URL, (success) async {
      print(success);
      if (success['list']['data'].length <= 0) {
        // setState(() {
        //   isloading = false;
        // });
        // ToastUtil.showToast('已加载全部数据');
      } else {
        setState(() {
          for (var i = 0; i < success['list']['data'].length; i++) {
            foodCdlist.add(success['list']['data'][i]);
          }
        });
      }
      _controller.finishRefresh();
    }, (onFail) async {
      ToastUtil.showToast(onFail);
      _controller.finishRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget ipt() {
      return Container(
        color: PublicColor.whiteColor,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(49), right: ScreenUtil().setWidth(49)),
        child: SearchCardWidget(
          elevation: 0,
          hintText: '输入食材,给你菜谱',
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            NavigatorUtils.goFoodsearch(context);
          },
          textEditingController: searchController,
          focusNode: searchFocus,
        ),
      );
    }

    Widget topHead() {
      return Container(
        color: PublicColor.whiteColor,
        padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(41), bottom: ScreenUtil().setWidth(30)),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(49)),
              child: CachedImageView(
                ScreenUtil.instance.setWidth(155.0),
                ScreenUtil.instance.setWidth(155.0),
                babyInf['headimgurl'],
                null,
                BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(28)),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hi~${babyInf['nickname']}已经${babyInf['is_birth'] == 2 ? '出生' : '怀孕'}${babyInf['week']}周${babyInf['day']}天",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setWidth(28)),
                    alignment: Alignment.centerLeft,
                    child: Text('${babyText}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.left),
                  )
                ],
              ),
            )),
          ],
        ),
      );
    }

    Widget title(text) {
      return Container(
        child: Row(
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(35),
              width: ScreenUtil().setWidth(8),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(28)),
              decoration: BoxDecoration(
                color: PublicColor.foodColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(23)),
              child: Text('${text}'),
            )
          ],
        ),
      );
    }

    Widget _getGridViewItem(BuildContext context, item) {
      return InkWell(
        child: Container(
          // color: Color(0xffffffff),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(24)),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xff000000).withOpacity(0.1),
                blurRadius: 5.0,
              ),
            ],
            image: DecorationImage(
              image: AssetImage('assets/index/foodbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            '${item['name']}',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
        ),
        onTap: () {
          NavigatorUtils.goFoodyuanze(context, item['id'].toString());
          // print(productEntity);
          // String oid = (productEntity['id']).toString();
          // NavigatorUtils.toXiangQing(context, oid, '0', '0');
        },
      );
    }

    Widget littleTips() {
      return Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(19),
          ),
          color: PublicColor.whiteColor,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(45),
                ),
                child: title("辅食小知识"),
              ),
              Container(
                child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(30),
                        bottom: ScreenUtil().setWidth(48),
                        top: ScreenUtil().setWidth(41)),
                    itemCount: foodTipsList.length,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //横轴元素个数
                        crossAxisCount: 2,
                        //纵轴间距
                        mainAxisSpacing: ScreenUtil().setWidth(21),

                        //横轴间距
                        crossAxisSpacing: ScreenUtil().setWidth(27),
                        //子组件宽高长度比例
                        childAspectRatio: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return _getGridViewItem(context, foodTipsList[index]);
                    }),
              )
            ],
          ));
    }

    Widget flWidget(list) {
      return Expanded(
        flex: 1,
        child: new InkWell(
          child: Column(
            children: <Widget>[
              Container(
                child: ClipOval(
                  child: Image.network(
                    list['img'],
                    width: ScreenUtil.instance.setWidth(110.0),
                    height: ScreenUtil.instance.setWidth(110.0),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(10),
              ),
              Container(
                child: new Text(
                  list['name'],
                  style: TextStyle(
                    fontSize: ScreenUtil.instance.setWidth(26.0),
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          onTap: () {
            if (list['name'] == '全部食谱') {
              NavigatorUtils.goFoodAll(context);
            } else {
              NavigatorUtils.goFoodList(context, list['id'].toString())
                  .then((res) {
                setState(() {
                  _page = 0;
                });
                getFoodList();
              });
            }

            // goShopList(list['id'].toString(), list['name']);
          },
        ),
      );
    }

    Widget categoryList() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (flList.length != 0) {
        for (var item in flList) {
          arr.add(flWidget(item));
        }
      }

      content = new Row(
        children: arr,
      );
      return content;
    }

    //分类
    Widget fenlei() {
      return Container(
        padding: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(41),
        ),
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(18),
        ),
        color: PublicColor.whiteColor,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(45),
                  bottom: ScreenUtil().setWidth(41)),
              child: title("食谱分类"),
            ),
            categoryList()
          ],
        ),
      );
    }

    //标签
    bqView() {
      List<Widget> list = [];
      for (var i = 0; i < 2; i++) {
        list.add(
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfffFCE1CD)),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(6),
                bottom: ScreenUtil().setWidth(6),
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16)),
            child: Text(
              '补铁',
              style: TextStyle(
                fontSize: ScreenUtil.instance.setWidth(24.0),
                color: PublicColor.foodColor,
              ),
            ),
          ),
        );
      }
      return list;
    }

    Widget bqContainer = Container(
      child: Wrap(
        runSpacing: ScreenUtil.instance.setWidth(10.0),
        spacing: ScreenUtil.instance.setWidth(26),
        children: bqView(),
      ),
    );

    _createGridViewItem() {
      List<Widget> list = [];
      for (var i = 0; i < foodCdlist.length; i++) {
        // 你想分几列，就除以几， 高度可以进行自定义
        list.add(Container(
            decoration: BoxDecoration(
                color: PublicColor.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                      blurRadius: 15.0, //阴影模糊程度
                      spreadRadius: 1.0 //阴影扩散程度
                      )
                ]),
            width: ScreenUtil.instance.setWidth(334.0),
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(20),
            ),
            // height: ScreenUtil.instance.setWidth(443.0),
            child: InkWell(
              onTap: () {
                NavigatorUtils.goFoodDetails(context, foodCdlist[i]['id'])
                    .then((res) {
                  setState(() {
                    _page = 0;
                  });
                  getFoodList();
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: ScreenUtil.instance.setWidth(257.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil.instance.setWidth(334.0),
                          height: ScreenUtil.instance.setWidth(220.0),
                          decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage("${foodCdlist[i]['img']}"),
                                  fit: BoxFit.fitWidth),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ))),
                        ),
                        Positioned(
                            top: ScreenUtil.instance.setWidth(203.0),
                            left: ScreenUtil.instance.setWidth(24.0),
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(6),
                                  bottom: ScreenUtil().setWidth(6),
                                  left: ScreenUtil().setWidth(16),
                                  right: ScreenUtil().setWidth(16)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: PublicColor.foodColor),
                              child: Text(
                                '${foodCdlist[i]['age']}',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(24.0),
                                  color: PublicColor.whiteColor,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(24),
                    ),
                    child: Text(
                      '${foodCdlist[i]['name']}',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(28.0),
                        color: PublicColor.textColor,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(10),
                        left: ScreenUtil().setWidth(24)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setWidth(16)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xfffFCE1CD)),
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(6),
                              bottom: ScreenUtil().setWidth(6),
                              left: ScreenUtil().setWidth(16),
                              right: ScreenUtil().setWidth(16)),
                          child: Text(
                            '${foodCdlist[i]['nutrients']}',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(24.0),
                              color: PublicColor.foodColor,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xfffFCE1CD)),
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(6),
                              bottom: ScreenUtil().setWidth(6),
                              left: ScreenUtil().setWidth(16),
                              right: ScreenUtil().setWidth(16)),
                          child: Text(
                            '${foodCdlist[i]['food']}',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(24.0),
                              color: PublicColor.foodColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(29),
                        left: ScreenUtil().setWidth(24)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(6)),
                                child: Image.asset(
                                  'assets/foods/xin.png',
                                  width: ScreenUtil.instance.setWidth(28.0),
                                ),
                              ),
                              Container(
                                child: Text('${foodCdlist[i]['like']}'),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(6)),
                                child: Image.asset(
                                  'assets/foods/yanjing.png',
                                  width: ScreenUtil.instance.setWidth(28.0),
                                ),
                              ),
                              Container(
                                child: Text('${foodCdlist[i]['visits']}'),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
      }
      return list;
    }

    Widget foodView() {
      return Container(
          color: PublicColor.whiteColor,
          // height: ScreenUtil.instance.setWidth(520.0),
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(22),
          ),
          // width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(45),
                    bottom: ScreenUtil().setWidth(41)),
                child: title("为了你的宝贝下厨吧"),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: Wrap(
                  runSpacing: ScreenUtil.instance.setWidth(40.0),
                  spacing: ScreenUtil.instance.setWidth(20),
                  children: _createGridViewItem(),
                ),
              )
            ],
          ));
    }

    return MaterialApp(
      title: "辅食日记",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '辅食日记',
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
        body: isLoading
            ? LoadingDialog()
            : Container(
                color: Color(0xfff7f7f7),
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
                        ipt(),
                        babyid == null || lists.length <= 0
                            ? Container()
                            : topHead(),
                        littleTips(),
                        fenlei(),
                        foodView()
                      ],
                    ),
                  ),
                  onRefresh: () async {
                    // _controller.finishRefresh();
                    _page = 0;
                    getFoodList();
                  },
                  onLoad: () async {
                    getFoodList();
                    _controller.finishRefresh();
                  },
                )),
      ),
    );
  }
}
