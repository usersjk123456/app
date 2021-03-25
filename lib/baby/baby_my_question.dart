import 'package:client/api/api.dart';
import 'package:client/service/service.dart';
import 'package:client/widgets/pinglun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';

class BabyMyQuestion extends StatefulWidget {
  final oid;
  BabyMyQuestion({this.oid});
  @override
  BabyMyQuestionState createState() => BabyMyQuestionState();
}

class BabyMyQuestionState extends State<BabyMyQuestion> {
  final commitcontroller = TextEditingController();
  FocusNode _commitFocus = FocusNode();
  String aboutContent;
  bool isLoading = false;
  int is_like = 0;
  int like = 0;
  int answerId = 0;
  int uid =0;
  List questionlist = [
    // {
    //   'headimgurl':
    //       'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
    //   'old_price': "1234",
    //   'now_price': '最近多吃些营养丰富的蛋白质类食物，或者去医院找医生看下吧',
    //   'title': '执象科技',
    //   'desc': '八周，孕酮是不是特别低呀？',
    //   'old': '2020-10-15 15:30:10',
    //   'money': '0'
    // }
  ];
  List datalist = [
    // {
    //   'thumb':
    //       'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
    //   'old_price': "1234",
    //   'now_price': '最近多吃些营养丰富的蛋白质类食物，或者去医院找医生看下吧',
    //   'title': '执象科技',
    //   'desc': '八周，孕酮是不是特别低呀？',
    //   'old': '2020-10-15 15:30:10',
    //   'money': '0'
    // },
    // {
    //   'thumb':
    //       'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
    //   'old_price': "1234",
    //   'now_price': '三年半的那篇文搭配聂卫平你的wind为你',
    //   'title': '执象科技',
    //   'desc': '八周，孕酮是不是特别低呀？',
    //   'old': '2020-12-13 15:30:10',
    //   'money': '0'
    // },
    // {
    //   'thumb':
    //       'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
    //   'old_price': "1234",
    //   'now_price': '最近多吃些营养丰富的蛋白质类食物，或者去医院找医生看下吧',
    //   'title': '执象科技',
    //   'desc': '八周，孕酮是不是特别低呀？',
    //   'old': '2020-11-11 15:30:10',
    //   'money': '0'
    // },
    // {
    //   'thumb':
    //       'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604554013901&di=17e5a19421bf23aaae75a838468288a4&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171114%2F0fc43e9ad58f4a5cb41a018925b0e475.jpeg',
    //   'old_price': "1234",
    //   'now_price': '最近多吃些营养丰富的蛋白质类食物，或者去医院找医生看下吧',
    //   'title': '执象科技',
    //   'desc': '八周，孕酮是不是特别低呀？',
    //   'old': '2020-10-15 15:30:10',
    //   'money': '0'
    // },
  ];
  @override
  void initState() {
    super.initState();
    
    getList();
  }



  void getList() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("qid", () => widget.oid);

    Service().getData(map, Api.GET_ANSWERLIST_URL, (success) async {
      // print(alldata);
      setState(() {
        questionlist = [];
        datalist = success['list'];
        // answerId = success['list']['answer']['id'];
        is_like = success['problem']['is_like'];
        like = success['problem']['like'];
        questionlist.add(success['problem']);
      });
      print(datalist);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void clickZan() {
    print(widget.oid);
    Map<String, dynamic> map = Map();
    map.putIfAbsent("qid", () => widget.oid);
    // map.putIfAbsent("text", () => commitcontroller.text);
    if (is_like == 0) {
      map.putIfAbsent("is_like", () => 1);
    } else {
      map.putIfAbsent("is_like", () => 2);
    }
    map.putIfAbsent("is_like", () => 1);
    Service().getData(map, Api.ANSWER_URL, (success) async {
      if (is_like == 0) {
        ToastUtil.showToast('点赞成功');
      } else {
        ToastUtil.showToast('已取消点赞');
      }

      getList();
      // print(alldata);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void sendCommit() {
    String commentContent = commitcontroller.text;
    if (commentContent.length > 200) {
      ToastUtil.showToast("最多只能输入200个字");
      return;
    }
    print(widget.oid);
    Map<String, dynamic> map = Map();
    map.putIfAbsent("qid", () => widget.oid);
    map.putIfAbsent("text", () => commitcontroller.text);
    map.putIfAbsent("is_comment", () => 1);
    Service().getData(map, Api.ANSWER_URL, (success) async {
      ToastUtil.showToast('评论成功');
      setState(() {
        commitcontroller.text = '';
      });

      _commitFocus.unfocus();
      getList();
      // print(alldata);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void clickDel(id) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("qid", () => widget.oid);
    map.putIfAbsent("id", () => id);
    Service().getData(map, Api.DEL_QUESTION_URL, (success) async {
      ToastUtil.showToast('删除成功');
      Navigator.pop(context);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget questionView = Container(
      child: questionlist.length > 0
          ? Pinglun(
              item: questionlist,
              type: 1,
              clickZan: clickZan,
              like: like,
              is_like: is_like,
              clickDel: clickDel)
          : Container(),
    );
    Widget pinglunView = Container(
      child: datalist.length > 0
          ? Pinglun(
              item: datalist,
              type: 2,
              clickZan: null,
              like: null,
              is_like: null,
              clickDel: null)
          : Container(),
    );
    Widget iptView = Container(
        color: PublicColor.whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              decoration: new BoxDecoration(
                //背景
                color: Color(0xfffEEEEEE),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(30)),
                //设置四周边框
              ),
              // height: ScreenUtil().setWidth(65),
              width: ScreenUtil().setWidth(594),
              child: TextField(
                controller: commitcontroller,
                focusNode: _commitFocus,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    hintText: '说点什么吧', border: InputBorder.none),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setWidth(65),
              decoration: new BoxDecoration(
                //背景
                color: PublicColor.themeColor,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(30)),
                //设置四周边框
              ),
              child: InkWell(
                child: Text(
                  '发送',
                  style: TextStyle(
                    fontSize: 18,
                    color: PublicColor.whiteColor,
                  ),
                ),
                onTap: () {
                  sendCommit();
                },
              ),
            )
          ],
        ));
    return MaterialApp(
      title: "问答",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: new Text(
            '问答',
            style: new TextStyle(color: PublicColor.textColor),
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
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 8,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            questionView,
                            pinglunView,
                          ],
                        ),
                      )),
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    color: PublicColor.whiteColor,
                    child: iptView,
                  ))
                ],
              )
                // child: SingleChildScrollView(
                //   child: Column(
                //     children: <Widget>[questionView, pinglunView, iptView],
                //   ),
                // ),
                ),
      ),
    );
  }
}
