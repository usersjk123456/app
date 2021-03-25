import 'package:client/bottom_input/input_dialog.dart';
import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/cached_image.dart';
import '../utils/toast_util.dart';
import '../service/video_service.dart';

class XiaoxiWidget extends StatefulWidget {
  final videoId;
  final messageNum;
  XiaoxiWidget({this.videoId, this.messageNum});
  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<XiaoxiWidget> {
  TextEditingController _textEditingController = new TextEditingController();
  ScrollController _controller = ScrollController();
  List listview = [];
  bool isOpen = true;
  int _page = 1;
  int count = 0;
  @override
  void initState() {
    super.initState();
    getList();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        //滚动到最后请求更多
        _page += 1;
        getList();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.videoId);
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 10);
    VideoServer().commentList(map, (success) async {
      setState(() {
        count = success['count'];
        if (_page == 1) {
          listview = success['list'];
        } else {
          if (success['list'].length != 0) {
            for (var i = 0; i < success['list'].length; i++) {
              listview.insert(listview.length, success['list'][i]);
            }
          }
        }
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void sendMessage(value) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.videoId);
    map.putIfAbsent("comment", () => value);
    VideoServer().sendComment(map, (success) async {
      if (listview.length > 3) {
        _controller.animateTo(0,
            duration: new Duration(milliseconds: 200), curve: Curves.ease);
      }
      _page = 0;
      listview = [];
      getList();
      _textEditingController.text = "";
      widget.messageNum();
      isOpen = true;
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  Widget pinglunitem(BuildContext context, item, index) {
    return Container(
      child: new Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CachedImageView(
            ScreenUtil.instance.setWidth(80.0),
            ScreenUtil.instance.setWidth(80.0),
            item['user']['headimgurl'],
            null,
            BorderRadius.all(Radius.circular(50))),
        new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item['user']['nickname'],
              style: TextStyle(
                  color: Color(0xffff16c65),
                  fontSize: ScreenUtil.instance.setWidth(28.0))),
          new SizedBox(height: ScreenUtil.instance.setWidth(16.0)),
          Container(
            width: ScreenUtil.instance.setWidth(580.0),
            child: Text(item['comment'], softWrap: true),
          ),
          new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
          Text(item['create_at'],
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: ScreenUtil.instance.setWidth(28.0))),
          new SizedBox(height: ScreenUtil.instance.setWidth(40.0)),
        ])
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: ScreenUtil.instance.setWidth(675.0),
      child: Column(children: [
        Container(
          height: ScreenUtil.instance.setWidth(80.0),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                flex: 9,
                child: Container(
                  child: Text(
                    '$count 条评论',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(28.0),
                    ),
                  ),
                  alignment: Alignment.center,
                )),
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Image.asset(
                        'assets/index/gb.png',
                        width: ScreenUtil.instance.setWidth(40.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )))
          ]),
        ),
        listview.length == 0
            ? Container(
                height: ScreenUtil.instance.setWidth(440.0),
              )
            : Container(
                height: ScreenUtil.instance.setWidth(440.0),
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                child: ListView.builder(
                    itemCount: listview.length,
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return pinglunitem(context, listview[index], index);
                    }),
              ),
        Container(
          height: ScreenUtil.instance.setWidth(150.0),
          width: ScreenUtil().setWidth(750),
          padding: EdgeInsets.all(
            ScreenUtil().setWidth(30),
          ),
          decoration: new ShapeDecoration(
            shape: Border(
              top: BorderSide(color: Color(0xfffcbc9c9), width: 1),
            ), // 边色与边宽度
            color: Colors.white,
          ),
          child: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              InputDialog.show(context).then((value) {
                if (value.toString() != "null") {
                  if (isOpen) {
                    isOpen = false;
                    sendMessage(value);
                  }
                }
              });
            },
            child: Container(
              alignment: Alignment.centerLeft,
              height: ScreenUtil.instance.setWidth(100.0),
              width: ScreenUtil.instance.setWidth(565.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Color(0xffff5f5f5),
                border: new Border.all(color: Color(0xfffcbc9c9), width: 1),
              ),
              padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(15),
                left: ScreenUtil().setWidth(15),
              ),
              child: Text(
                '请填写您要说的内容',
                style: TextStyle(
                  color: PublicColor.grewNoticeColor,
                  fontSize: ScreenUtil().setWidth(30),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
