import 'package:client/config/Navigator_util.dart';
import 'package:client/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/search_card.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../common/color.dart';
import '../service/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/user_service.dart';

class FoodSearch extends StatefulWidget {
  @override
  FoodSearchState createState() => FoodSearchState();
}

class FoodSearchState extends State<FoodSearch>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  bool issearch = false, isLive = false, isStore = false;
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  EasyRefreshController _controller = EasyRefreshController();
  final FocusNode _focus = new FocusNode();

  List historyFoodList = [];
  String historyFoodString = '';
  String sateId = '';
  String jwt = '';
  List lishisousuo = [];
  List foodCdlist = [];
  int _page = 0;
  int _limit = 10;

  @override
  void initState() {
    super.initState();
    _controller.finishRefresh();
    getHistory();
  }

  void getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString('jwt');
    });
    if (jwt != null) {
      getInfo();
    }

    if (prefs.getString('historyfood') != null) {
      historyFoodString = prefs.getString('historyfood');
      setState(() {
        historyFoodList = prefs.getString('historyfood').split(',');
      });
    }
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          isLive = success['is_live'].toString() == "0" ? false : true;
          isStore = success['is_store'].toString() == "0" ? false : true;
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void keySearch(keywords) async {
    getHistory();
    Map<String, dynamic> map = Map();
    map.putIfAbsent("food", () => keywords);
    HomeServer().searchfood(map, (success) async {
      print(success['list']['data']);
      print('~~~~~~~~~');
      setState(() {
        foodCdlist = success['list']['data'];
        if (foodCdlist.length == 0) {
          ToastUtil.showToast('暂无数据');
        }
      });
      bool isCz = false;
      if (historyFoodList.length != 0) {
        for (var i = historyFoodList.length - 1; i >= 0; i--) {
          if (historyFoodList[i] == keywords) {
            isCz = true;
            return;
          }
        }
      }
      print('isCA---->>>$isCz');
      if (!isCz) {
        if (historyFoodString == '') {
          historyFoodString += keywords;
        } else {
          historyFoodString += ',' + keywords;
        }
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('historyfood', historyFoodString);
      }
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focus.hasFocus) {
      if (_keywordTextEditingController.text != '') {
        setState(() {
          issearch = true;
        });
      } else {
        setState(() {
          issearch = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    _focus.addListener(_onFocusChange);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          child: SearchCardWidget(
            elevation: 0,
            onTap: () {},
            textEditingController: _keywordTextEditingController,
            focusNode: _focus,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: PublicColor.linearHeader,
          ),
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
                padding: const EdgeInsets.only(right: 14.0),
                alignment: Alignment.center,
                child: Text(
                  '搜索',
                  style: new TextStyle(color: PublicColor.textColor),
                )),
            onTap: () {
              if (_keywordTextEditingController.text == '') {
                ToastUtil.showToast('请输入搜索商品');
                return;
              } else {
                keySearch(_keywordTextEditingController.text);
              }

              setState(() {
                issearch = true;
              });
            },
          ),
          InkWell(
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 14.0),
                child: Text(
                  '取消',
                  style: new TextStyle(color: PublicColor.textColor),
                )),
            onTap: () {
              print('取消');
              Navigator.pop(context);
            },
          )
          // MaterialButton(
          //     child: Text('取消'),
          //     onPressed: () {
          //       print('取消');
          //       Navigator.pop(context);
          //     }),
        ],
      ),
      body: issearch ? searchPage2() : searchPage1(),
    );
  }

  Widget searchPage1() {
    return Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Container(
            width: ScreenUtil.instance.setWidth(750),
            height: ScreenUtil.instance.setWidth(85),
            padding: EdgeInsets.only(
                left: ScreenUtil.instance.setWidth(25),
                right: ScreenUtil.instance.setWidth(25)),
            child: new Row(children: [
              Expanded(
                flex: 1,
                child: new Row(
                  children: <Widget>[
                    new Image.asset('assets/index/lsjl.png',
                        width: ScreenUtil.instance.setWidth(35)),
                    Text(
                      ' 搜索历史',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil.instance.setWidth(30.0),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('history');
                    setState(() {
                      historyFoodList.clear();
                    });
                  },
                  child: Container(
                    child: new Image.asset('assets/index/scan.png',
                        width: ScreenUtil.instance.setWidth(35)),
                    alignment: Alignment.centerRight,
                  ),
                ),
              )
            ]),
          ),
          Wrap(
            spacing: 5,
            runSpacing: ScreenUtil.instance.setWidth(10.0),
            children: searchHistory(historyFoodList),
          ),
        ],
      ),
      isloading ? LoadingDialog() : Container(),
    ]);
  }

  List<Widget> listBoxs(list) => List.generate(list.length, (index) {
        return InkWell(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(15)),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: new Border.all(color: Color(0xfffececec), width: 0.5),
            ),
            child: Text(
              list[index]['keywords'],
              style: TextStyle(
                color: Colors.black45,
                fontSize: ScreenUtil.instance.setWidth(28),
              ),
            ),
          ),
          onTap: () {
            keySearch(list[index]['keywords']);
            _keywordTextEditingController.text = list[index]['keywords'];
            setState(() {
              issearch = true;
            });
          },
        );
      });

  List<Widget> searchHistory(list) => List.generate(list.length, (index) {
        return InkWell(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(15)),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: new Border.all(color: Color(0xfffececec), width: 0.5),
            ),
            child: Text(
              list[index],
              style: TextStyle(
                color: Colors.black45,
                fontSize: ScreenUtil.instance.setWidth(28),
              ),
            ),
          ),
          onTap: () {
            keySearch(list[index]);
            _keywordTextEditingController.text = list[index];
            setState(() {
              issearch = true;
            });
          },
        );
      });

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
              NavigatorUtils.goFoodDetails(context, foodCdlist[i]['id']);
              // .then((res) => getFoodList());
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
                                image: NetworkImage("${foodCdlist[i]['img']}"),
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
                  ),
                  child: Container(
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

  Widget searchPage2() {
    return EasyRefresh(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[foodCdlist.length > 0 ? foodView() : NoData()],
        ),
      ),
      // onRefresh: () async {

      //   _controller.finishRefresh();
      // },
      // onLoad: () async {
      //   _controller.finishRefresh();
      // },
    );
  }
}
