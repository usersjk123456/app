import 'package:client/api/api.dart';
import 'package:client/common/color.dart';
import 'package:client/service/goods_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/comment_item.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';

class AllComment extends StatefulWidget {
  final String goodsId;
  AllComment({
    this.goodsId,
  });

  @override
  AllCommentState createState() => AllCommentState();
}

class AllCommentState extends State<AllComment> with TickerProviderStateMixin {
  FocusNode contentFocus = FocusNode();
  EasyRefreshController _controller = EasyRefreshController();
  bool isLoading = false;
  List commentList = [];
  int page = 1;
  String count = '0';

  @override
  void initState() {
    getComment();
    super.initState();
  }

  void getComment() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.goodsId);
    map.putIfAbsent("page", () => page);
    map.putIfAbsent("limit", () => 10);
    GoodsServer().getServer(map, Api.GET_COMMENT, (success) async {
      if (mounted) {
        setState(() {
          count = success['count'];
          if (page == 1) {
            commentList = success['list'];
          } else {
            if (success['list'].length == 0) {
              // // ToastUtil.showToast('已加载全部数据');
            } else {
              for (var i = 0; i < success['list'].length; i++) {
                commentList.insert(commentList.length, success['list'][i]);
              }
            }
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

    Widget titleBox = Container(
      alignment: Alignment.centerLeft,
      child: Container(
        width: ScreenUtil.instance.setWidth(240.0),
        height: ScreenUtil.instance.setWidth(45.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xffeee4e5),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(15),
          top: ScreenUtil().setWidth(15),
          left: ScreenUtil().setWidth(15),
        ),
        child: Text(
          '全部评价($count)',
          style: TextStyle(
            fontSize: ScreenUtil.instance.setWidth(26.0),
            color: Colors.black,
          ),
        ),
      ),
    );

    Widget buildList() {
      List<Widget> arr = <Widget>[];
      Widget content;

      for (var i = 0; i < commentList.length; i++) {
        var item = commentList[i];
        arr.add(Comment(
          item: item,
          isImg: true,
        ));
      }

      content = Column(
        children: arr,
      );
      return content;
    }

    Widget contentWidget() {
      return Container(
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
          child: SingleChildScrollView(child: buildList()),
          onRefresh: () async {
            page = 1;
            getComment();
            _controller.finishRefresh();
          },
          onLoad: () async {
            if(page * 10>commentList.length){
              return;
            }
            page++;
            getComment();
            _controller.finishRefresh();
          },
        ),
      );
    }

    return MaterialApp(
      title: "全部评价",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: new Text(
            '全部评价',
            style: new TextStyle(
              color: PublicColor.headerTextColor,
            ),
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
        body: Column(
          children: <Widget>[
            titleBox,
            Expanded(flex: 1, child: contentWidget())
          ],
        ),
      ),
    );
  }
}
