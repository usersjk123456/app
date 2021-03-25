import 'package:client/api/api.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:client/widgets/xuxian.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';

class Wikilist extends StatefulWidget {
  final bookId;
  Wikilist({this.bookId});
  @override
  WikilistState createState() => WikilistState();
}

class WikilistState extends State<Wikilist> {
  String aboutContent;
  bool isLoading = false;
  List titleList = [];
  String title = '', name = '', all = '', bookimg = '';
  @override
  void initState() {
    super.initState();
    getBookList();
  }

  void getBookList() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.bookId);
    Service().getData(map, Api.BOOK_LIST_URL, (success) async {
      print(success);
      setState(() {
        titleList = success['list']['four_type'];
        title = success['list']['name'];
        bookimg = success['list']['img'];
        all = success['num'].toString();
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topContainer = Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(16),
        left: ScreenUtil().setWidth(34),
        right: ScreenUtil().setWidth(34),
        bottom: ScreenUtil().setWidth(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(21)),
            child: CachedImageView(
              ScreenUtil.instance.setWidth(150.0),
              ScreenUtil.instance.setWidth(150.0),
              bookimg,
              null,
              BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(32)),
                  width: ScreenUtil().setWidth(480),
                  child: Text(
                    '${title}',
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(32.0),
                      color: PublicColor.textColor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(37)),
                  child: Text(
                    '共${all}篇',
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(24.0),
                      color: PublicColor.textColor,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    listView(item) {
      List<Widget> list = [];
      print(item);
      for (var i = 0; i < item.length; i++) {
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
                  child: RichText(
                      text: TextSpan(
                          text: '${i + 1} | ',
                          style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(24.0),
                              color: PublicColor.textColor),
                          children: <TextSpan>[
                        TextSpan(
                            text: '${item[i]['title']}',
                            style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(24.0),
                                color: PublicColor.textColor))
                      ])),
                ),
                item.length == 1 || i == item.length - 1
                    ? Container()
                    : const MySeparator(color: Colors.grey),
              ],
            ),
          ),
          onTap: () {
            NavigatorUtils.goWikidetails(context, item[i]['id']);
          },
        ));
        print(list);
      }
      return list;
    }

    

    titleListView() {
      List<Widget> list = [];
      for (var i = 0; i < titleList.length; i++) {
        list.add(Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(16),
            left: ScreenUtil().setWidth(34),
            right: ScreenUtil().setWidth(34),
            bottom: ScreenUtil().setWidth(20),
          ),
          child: Column(
            children: <Widget>[
              Container(
                  child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 9,
                        child: Container(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(20),
                                bottom: ScreenUtil().setWidth(40)),
                            child: Text(
                              '${titleList[i]['name']}',
                              style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(32.0),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            )
                            )
                            ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            titleList[i]['ischeck']
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: PublicColor.grewNoticeColor,
                          ),
                        )),
                  ],
                ),
                onTap: () {
                  setState(() {
                    titleList[i]['ischeck'] = !titleList[i]['ischeck'];
                  });
                },
              )),
              Offstage(
                offstage: titleList[i]['ischeck'], //这里控制
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xfff5f5f5),
                    ),
                    child:
                        Column(children: listView(titleList[i]['children']))),
              ),
            ],
          ),
        ));
      }
      return list;
    }

    Widget titleListContainer = Container(
      child: Column(
        children: titleListView(),
      ),
    );

    return MaterialApp(
      title: "${title}",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '${title}',
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
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(37)),
              child: InkWell(
                  child: Image.asset(
                    'assets/foods/ic_sousuo.png',
                    width: ScreenUtil.instance.setWidth(38.0),
                  ),
                  onTap: () {
                    NavigatorUtils.goBooksearch(context);
                  }),
            ),
          ],
        ),
        body: isLoading
            ? LoadingDialog()
            : Container(
                color: PublicColor.whiteColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      topContainer,
                      titleList.length > 0 ? titleListContainer : Container()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
