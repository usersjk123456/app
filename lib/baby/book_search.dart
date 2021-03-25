import 'package:client/api/api.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/no_data.dart';
import 'package:client/widgets/xuxian.dart';
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

class BookSearch extends StatefulWidget {
  @override
  BookSearchState createState() => BookSearchState();
}

class BookSearchState extends State<BookSearch>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  bool issearch = false, isLive = false, isStore = false;
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  EasyRefreshController _controller = EasyRefreshController();
  final FocusNode _focus = new FocusNode();

  List historyBookList = [];
  String historyBookString = '';
  String sateId = '';
  String jwt = '';
  List lishisousuo = [];
  List bookCdlist = [];
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

    if (prefs.getString('historybood') != null) {
      historyBookString = prefs.getString('historybood');
      setState(() {
        historyBookList = prefs.getString('historybood').split(',');
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
    map.putIfAbsent("title", () => keywords);
    HomeServer().searchbook(map, (success) async {
      print(success['list']['data']);
      print('~~~~~~~~~');
      setState(() {
        bookCdlist = success['list']['data'];
        if (bookCdlist.length == 0) {
          ToastUtil.showToast('暂无数据');
        }
      });
      bool isCz = false;
      if (historyBookList.length != 0) {
        for (var i = historyBookList.length - 1; i >= 0; i--) {
          if (historyBookList[i] == keywords) {
            isCz = true;
            return;
          }
        }
      }
      print('isCA---->>>$isCz');
      if (!isCz) {
        if (historyBookString == '') {
          historyBookString += keywords;
        } else {
          historyBookString += ',' + keywords;
        }
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('historybood', historyBookString);
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
            hintText: "请输入带娃难题进行搜索",
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
                ToastUtil.showToast('请输入带娃难题进行搜索');
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
                      historyBookList.clear();
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
            children: searchHistory(historyBookList),
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
    listView() {
      List<Widget> list = [];
      for (var i = 0; i < bookCdlist.length; i++) {
        list.add(InkWell(
          child: Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20)),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setWidth(120),
                    child: Text('${bookCdlist[i]['title']}',
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(24.0),
                            color: PublicColor.textColor))
                    // RichText(
                    //     text: TextSpan(
                    //         text: '${i + 1} | ',
                    //         style: TextStyle(
                    //             fontSize: ScreenUtil.instance.setWidth(24.0),
                    //             color: PublicColor.textColor),
                    //         children: <TextSpan>[
                    //       TextSpan(
                    //           text: '${bookCdlist[i]['title']}',
                    //           style: TextStyle(
                    //               fontSize: ScreenUtil.instance.setWidth(24.0),
                    //               color: PublicColor.textColor))
                    //     ])),
                    ),
                bookCdlist.length == 1 || i == bookCdlist.length - 1
                    ? Container()
                    : const MySeparator(color: Colors.grey),
              ],
            ),
          ),
          onTap: () {
            NavigatorUtils.goWikidetails(context, bookCdlist[i]['id']);
          },
        ));
        print(list);
      }
      return list;
    }

    Widget booklist = Container(child: Column(children: listView()));
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
          children: <Widget>[bookCdlist.length > 0 ? booklist : NoData()],
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
