import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/cached_image.dart';
import '../widgets/search_card.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../common/color.dart';
import '../service/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/user_service.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> with SingleTickerProviderStateMixin {
  bool isloading = false;
  bool issearch = false, isLive = false, isStore = false;
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  EasyRefreshController _controller = EasyRefreshController();
  final FocusNode _focus = new FocusNode();

  List listView = [];
  List resou = [];
  List historyList = [];
  String historyString = '';
  String sateId = '';
  String jwt = '';
  List lishisousuo = [];

  @override
  void initState() {
    super.initState();
    _controller.finishRefresh();
    resouApi();
    getHistory();
  }

  void resouApi() async {
    Map<String, dynamic> map = Map();
    HomeServer().getKeywords(map, (success) async {
      setState(() {
        resou = success['keywords'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString('jwt');
    });
    if (jwt != null) {
      getInfo();
    }

    if (prefs.getString('history') != null) {
      historyString = prefs.getString('history');
      setState(() {
        historyList = prefs.getString('history').split(',');
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
    map.putIfAbsent("keywords", () => keywords);
    HomeServer().search(map, (success) async {
      setState(() {
        listView = success['goods'];
        if (listView.length == 0) {
          ToastUtil.showToast('暂无数据');
        }
      });
      bool isCz = false;
      if (historyList.length != 0) {
        for (var i = historyList.length - 1; i >= 0; i--) {
          if (historyList[i] == keywords) {
            isCz = true;
            return;
          }
        }
      }
      print('isCA---->>>$isCz');
      if (!isCz) {
        if (historyString == '') {
          historyString += keywords;
        } else {
          historyString += ',' + keywords;
        }
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('history', historyString);
      }
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  // 上架、下家
  void upDown(index, isUp) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => listView[index]['id']);
    map.putIfAbsent("is_up", () => isUp);
    HomeServer().upGoods(map, (success) async {
      if (isUp == "0") {
        ToastUtil.showToast('下架成功');
        setState(() {
          listView[index]['isup'] = 0;
        });
      } else {
        ToastUtil.showToast('上架成功');
        setState(() {
          listView[index]['isup'] = 1;
        });
      }
    }, (onFail) async {
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
                    style: TextStyle(
                    color: Color(0xff222222),
                  ),
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
                  style: TextStyle(
                    color: Color(0xff222222),
                  ),
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
            padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(25)),
            child: new Row(children: [
              new Image.asset('assets/index/rs.png',
                  width: ScreenUtil.instance.setWidth(35)),
              Text(
                ' 热搜',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil.instance.setWidth(30.0)),
              )
            ]),
          ),
          Wrap(
            spacing: 5,
            runSpacing: ScreenUtil.instance.setWidth(10.0),
            children: listBoxs(resou),
          ),
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
                      historyList.clear();
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
            children: searchHistory(historyList),
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
      child: ListView.builder(
          itemCount: listView.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: ScreenUtil.instance.setWidth(750),
              // height: ScreenUtil.instance.setWidth(255),
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil.instance.setWidth(30),
                  ScreenUtil.instance.setWidth(10),
                  ScreenUtil.instance.setWidth(30),
                  10),
              decoration: new ShapeDecoration(
                shape: Border(
                  top: BorderSide(color: Color(0xfffececec), width: 1),
                ), // 边色与边宽度
                color: Colors.white,
              ),
              child: InkWell(
                onTap: () {
                  print(listView[index]['ship_id']);
                  print(listView[index]);
                  String oid = (listView[index]['id']).toString();

                  NavigatorUtils.toXiangQing(context, oid, '0', '0');
                },
                child: new Row(
                  children: <Widget>[
                    CachedImageView(
                        ScreenUtil.instance.setWidth(204.0),
                        ScreenUtil.instance.setWidth(204.0),
                        listView[index]['thumb'],
                        null,
                        BorderRadius.all(Radius.circular(0))),
                    new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                    Container(
                      width: ScreenUtil.instance.setWidth(466.0),
                      // height: ScreenUtil.instance.setWidth(204.0),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new SizedBox(
                                height: ScreenUtil.instance.setWidth(10.0)),
                            Text(listView[index]['name'],
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(25.0))),
                            new SizedBox(
                                height: ScreenUtil.instance.setWidth(5.0)),
                            RichText(
                              text: TextSpan(
                                  text: '￥' +
                                      listView[index]['now_price'].toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(27.0)),
                                  children: [
                                    /*TextSpan(
                                        text: '/赚￥' +
                                            listView[index]['commission']
                                                .toString(),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: ScreenUtil.instance
                                                .setWidth(27.0))),*/
                                  ]),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                       /*     Container(
                              width: ScreenUtil.instance.setWidth(266.0),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                '销量' + listView[index]['buy_count'].toString(),
                                style: TextStyle(
                                  color: Color(0xfff9f9c9c),
                                  fontSize: ScreenUtil.instance.setWidth(24.0),
                                ),
                              ),
                            ),*/
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                /*!isLive && !isStore
                                    ? Container()
                                    : InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: ScreenUtil.instance
                                              .setWidth(150.0),
                                          height: ScreenUtil.instance
                                              .setWidth(60.0),
                                          decoration: BoxDecoration(
                                            border: new Border.all(
                                              color: PublicColor.themeColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          ),
                                          child: Text(
                                            listView[index]['isup'] == 0
                                                ? '上架商品'
                                                : '下架商品',
                                            style: TextStyle(
                                              color: PublicColor.themeColor,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(26),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          if (listView[index]['isup'] == 0) {
                                            sateId = '1';
                                          }

                                          if (listView[index]['isup'] == 1) {
                                            sateId = '0';
                                          }

                                          if (jwt == null) {
                                            ToastUtil.showToast('请先登录');
                                          } else {
                                            if (!isStore && !isLive) {
                                              ToastUtil.showToast('您没有权限上架商品');
                                            } else {
                                              // 可以上架商品
                                              upDown(index, sateId);
                                            }
                                          }
                                        },
                                      ),*/
                                Container(
                                  width: ScreenUtil.instance.setWidth(200.0),
                                  height: ScreenUtil.instance.setWidth(75.0),
                                  alignment: Alignment.bottomRight,
                                  child: MaterialButton(
                                    color: PublicColor.themeColor,
                                    textColor: PublicColor.btnTextColor,
                                    child: new Text('立即抢购',
                                        style: TextStyle(
                                            fontSize: ScreenUtil.instance
                                                .setWidth(22.0))),
                                    height: ScreenUtil.instance.setWidth(55.0),
                                    minWidth:
                                        ScreenUtil.instance.setWidth(120.0),
                                    onPressed: () {
                                      String oid =
                                          (listView[index]['id']).toString();
                                      NavigatorUtils.toXiangQing(
                                          context, oid, '0', '0');
                                    },
                                  ),
                                )
                              ],
                            )
                          ]),
                    )
                  ],
                ),
              ),
            );
          }),
      // onRefresh: () async {

      //   _controller.finishRefresh();
      // },
      // onLoad: () async {
      //   _controller.finishRefresh();
      // },
    );
  }
}
