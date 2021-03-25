import 'package:client/api/api.dart';
import 'package:client/config/fluro_convert_util.dart';
import 'package:client/service/goods_service.dart';
import 'package:client/widgets/send_comment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../utils/toast_util.dart';
import '../common/color.dart';

class Comment extends StatefulWidget {
  final String objs;
  Comment({this.objs});

  @override
  CommentState createState() => CommentState();
}

class CommentState extends State<Comment> {
  List goodsList = [];
  bool isLoading = false;
  TextEditingController contentController = TextEditingController();
  String content = '';
  bool btnActive = false;
  List commentList = [];
  String storeOrderId = '';

  @override
  void initState() {
    Map order = FluroConvertUtils.string2map(widget.objs);
    for (var item in order['goods']) {
      item['imgList'] = [];
      item['content'] = '';
    }
    goodsList = order['goods'];
    storeOrderId = order['store_order_id'];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void sendComment() {
    print('sendlist====================');
    commentList = [];
    for (var item in goodsList) {
      var obj = {};
      obj['imgList'] = item['imgList'];
      obj['content'] = item['content'];
      obj['goods_id'] = item['goods_id'];
      if (obj['content'] == '') {
        ToastUtil.showToast('请输入评价内容');
        return;
      }
      commentList.add(obj);
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("data", () => commentList);
    map.putIfAbsent("store_order_id", () => storeOrderId);
    GoodsServer().sendComment(map, Api.SEND_COMMENT, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('发布成功');
      Navigator.pop(context);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void getContent(val, index) {
    print('val------');
    print(val);
    goodsList[index]['content'] = val;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget buildList() {
      List<Widget> arr = <Widget>[];
      Widget content;

      for (var i = 0; i < goodsList.length; i++) {
        var item = goodsList[i];
        arr.add(CommentItem(item: item, index: i, getContent: getContent));
      }

      content = Column(
        children: arr,
      );
      return content;
    }

    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '发表评价',
          style: TextStyle(
            color: PublicColor.headerTextColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
            color: PublicColor.headerTextColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              sendComment();
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(20),
              ),
              child: Text('发布',
                  style: TextStyle(
                    color: PublicColor.themeColor,
                  )),
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: PublicColor.linearHeader,
          ),
        ),
      ),
      body: isLoading
          ? LoadingDialog()
          : Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(16),
                bottom: ScreenUtil().setWidth(16),
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30),
              ),
              child: ListView(
                children: <Widget>[
                  buildList(),
                ],
              ),
            ),
    );
  }
}
