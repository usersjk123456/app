import 'package:client/api/api.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import 'package:client/service/user_service.dart';
import '../utils/toast_util.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading.dart';

class FoodYz extends StatefulWidget {
  final String babyId;

  FoodYz({this.babyId});
  @override
  FoodYzState createState() => FoodYzState();
}

class FoodYzState extends State<FoodYz> {
  String aboutContent;
  bool isLoading = false;
  List datalist = [];
  String imgUrl = '';
  String title = '';
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => widget.babyId);
    Service().getData(map, Api.FOODSP_LIST_URL, (success) async {
      print("wc");
      print(success['type']['img']);
      setState(() {
        imgUrl = success['type']['img'];
        title = success['type']['name'];
        for (var i = 0; i < success['list']['data'].length; i++) {
          datalist.add(success['list']['data'][i]);
        }
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget headerTop = Container(
        height: ScreenUtil().setWidth(364),
        width: ScreenUtil().setWidth(750),
        child: Image.network(
          '${imgUrl}',
          fit: BoxFit.fill,
        ));
    Widget listWidget(item, key) {
      return InkWell(
        child: Container(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(22),
            bottom: ScreenUtil().setWidth(22),
          ),
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(33),
            left: ScreenUtil().setWidth(39),
            right: ScreenUtil().setWidth(39),
          ),
          decoration: BoxDecoration(
            color: PublicColor.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 10.0), //阴影xy轴偏移量
                  blurRadius: 10.0, //阴影模糊程度
                  spreadRadius: 1.0 //阴影扩散程度
                  )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(11),
                            left: ScreenUtil().setWidth(34),
                            right: ScreenUtil().setWidth(19),
                          ),
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(37),
                          height: ScreenUtil().setWidth(37),
                          decoration: BoxDecoration(
                              color: Color(0xffFABB8A),
                              borderRadius: BorderRadius.circular(50)),
                          child: new Text(
                            '${key + 1}',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                              color: PublicColor.textColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(11),
                          ),
                          child: new Text(
                            '${item['title']}',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(32.0),
                              color: PublicColor.textColor,
                            ),
                          ))
                    ],
                  ),
                  Container(
                      width: ScreenUtil().setWidth(419),
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(33),
                        left: ScreenUtil().setWidth(30),
                      ),
                      child: new Text(
                        '${item['text']}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(26.0),
                          color: Color(0xfff666666),
                        ),
                      ))
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  right: ScreenUtil().setWidth(21),
                ),
                child: CachedImageView(
                  ScreenUtil.instance.setWidth(160.0),
                  ScreenUtil.instance.setWidth(121.0),
                  '${item['img']}',
                  null,
                  BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          NavigatorUtils.goFoodyuanzedetails(context, item['id']);
          // goShopList(list['id'].toString(), list['name']);
        },
      );
    }

    ;
    Widget listContainer() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (datalist.length != 0) {
        for (var i = 0; i < datalist.length; i++) {
          arr.add(listWidget(datalist[i], i));
        }
      }

      content = new Column(
        children: arr,
      );
      return content;
    }

    Widget dataContainer = Container(
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(22),
      ),
      // height: ScreenUtil().setWidth(364),
      child: listContainer(),
    );

    return MaterialApp(
      title: "辅食添加基本原则",
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
          //辅食分享
          // actions: <Widget>[
          //   MaterialButton(
          //       child: Icon(
          //         Icons.share,
          //         size: 25.0,
          //         color: Colors.black,
          //       ),
          //       onPressed: () {
          //         print('分享');
          //       }),
          // ],
        ),
        body: isLoading
            ? LoadingDialog()
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[headerTop, dataContainer],
                  ),
                ),
              ),
      ),
    );
  }
}
