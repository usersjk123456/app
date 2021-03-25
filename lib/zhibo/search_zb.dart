import 'package:client/config/Navigator_util.dart';
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
import 'package:client/service/live_service.dart';
import '../widgets/zhibo_product.dart';

class SearchZb extends StatefulWidget {
  @override
  SearchZbState createState() => SearchZbState();
}

class SearchZbState extends State<SearchZb>
    with SingleTickerProviderStateMixin {
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

    if (prefs.getString('history_zb') != null) {
      historyString = prefs.getString('history_zb');
      setState(() {
        historyList = prefs.getString('history_zb').split(',');
      });
    }
  }

  void keySearch(keywords) async {
    getHistory();
    Map<String, dynamic> map = Map();
    map.putIfAbsent("keywords", () => keywords);
    map.putIfAbsent("page", () => 1);
    map.putIfAbsent("limit", () => 100);
    HomeServer().searchLive(map, (success) async {
      setState(() {
        listView = success['list'];
        print('listView====$listView');
        if (listView.length == 0) {
          ToastUtil.showToast('暂无数据');
        }
      });
      bool isCz = false;
      if (historyList.length != 0) {
        for (var i = 0; i < historyList.length; i++) {
          if (historyList[i] == keywords) {
            isCz = true;
            return;
          }
        }
      }
      if (!isCz) {
        if (historyString == '') {
          historyString += keywords;
        } else {
          historyString += ',' + keywords;
        }
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('history_zb', historyString);
      }
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  // 获得推流地址
  getliveurl(productEntity) async {
    if (productEntity['is_open'].toString() == "1") {
      Map<String, dynamic> map = Map();
      map.putIfAbsent("room_id", () => productEntity['id']);
      LiveServer().inRoom(map, (success) async {
        Map obj = {'url': success['res']['rtmp_url']};
        NavigatorUtils.goLookZhibo(
            context, productEntity['id'].toString(), success);
      }, (onFail) async {
        ToastUtil.showToast(onFail);
      });
    } else {
      NavigatorUtils.goLiveOverPage(context, productEntity['id']);
    }
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
            hintText: "请输入搜索的直播间",
          ),
        ),
        backgroundColor: PublicColor.themeColor,
        actions: <Widget>[
          InkWell(
            child: Container(
                padding: const EdgeInsets.only(right: 14.0),
                alignment: Alignment.center,
                child: Text(
                  '搜索',
                  style: TextStyle(
                    color: PublicColor.btnTextColor,
                  ),
                )),
            onTap: () {
              if (_keywordTextEditingController.text == '') {
                ToastUtil.showToast('请输入搜索内容');
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
                    color: PublicColor.btnTextColor,
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
                            fontSize: ScreenUtil.instance.setWidth(30.0)),
                      ),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('history_zb');
                    setState(() {
                      historyList.clear();
                      historyList = [];
                      historyString = "";
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
      child: ProductView(listView, getliveurl),
      // onRefresh: () async {

      //   _controller.finishRefresh();
      // },
      // onLoad: () async {
      //   _controller.finishRefresh();
      // },
    );
  }
}
