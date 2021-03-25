import 'package:client/api/api.dart';
import 'package:client/common/color.dart';
import 'package:client/service/service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';

class Questionlist extends StatefulWidget {
  final item;
  final type;
  final userlist;
  final getQuestion;
  Questionlist({this.item, this.type, this.userlist, this.getQuestion});
  @override
  QuestionlistState createState() => QuestionlistState();
}

class QuestionlistState extends State<Questionlist> {
  List item = [];
  // @override
  // void initState() {
  //   super.initState();
  //   item = widget.item;
  //   print(item.length);
  //   print(widget.type);
  // }

  void clickZan(id, is_like, idx) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("qid", () => id);
    // map.putIfAbsent("text", () => commitcontroller.text);
    if (is_like == 0) {
      map.putIfAbsent("is_like", () => 1);
    } else {
      map.putIfAbsent("is_like", () => 2);
    }
    map.putIfAbsent("is_like", () => 1);
    Service().getData(map, Api.ANSWER_URL, (success) async {
      if (success['list']['is_like'] == 1) {
        ToastUtil.showToast('点赞成功');
      } else {
        ToastUtil.showToast('已取消点赞');
      }
      setState(() {
        widget.item[idx]['is_like'] = success['list']['is_like'];
        widget.item[idx]['like'] = success['list']['like'];
        // htlist = [];
      });
      print(success['list']['like']);
      print(success['list']['is_like']);
      print('aaaaaaaaaaaaaaaaaaaaaa');
      // widget.getQuestion();
      // print(alldata);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void clickDel(id, idx) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("qid", () => id);
    map.putIfAbsent("id", () => widget.userlist['id']);
    Service().getData(map, Api.DEL_QUESTION_URL, (success) async {
      ToastUtil.showToast('删除成功');
      setState(() {
        widget.item.removeAt(idx);
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getlist() {
    widget.getQuestion();
  }

  List<Widget> boxs() => List.generate(widget.item.length, (index) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          margin: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(20),
          ),
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(24),
            left: ScreenUtil().setWidth(50),
          ),
          child: InkWell(
            onTap: () {
              var that = this;
              String oid = (widget.item[index]['id']).toString();
              NavigatorUtils.goBabyMyQuestion(context, oid)
                  .then((res) => widget.getQuestion());
              // NavigatorUtils.gobabyXiangqing(context);
            },
            //设置圆角
            child: Column(
              children: <Widget>[
                Row(children: [
                  Container(
                    child: CachedImageView(
                      ScreenUtil.instance.setWidth(55.0),
                      ScreenUtil.instance.setWidth(55.0),
                      widget.userlist['headimgurl'],
                      null,
                      BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(29),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        child: Text(
                          '${widget.userlist['nickname']}',
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: ScreenUtil().setSp(30),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${widget.item[index]['create_date']}',
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ),
                    ),
                  )
                ]),
                Container(
                  margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
                  height: ScreenUtil().setWidth(60),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.item[index]['desc']}',
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: ScreenUtil().setSp(32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      width: ScreenUtil().setWidth(600),
                      child: Text(
                        '${widget.item[index]['text']}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ],
                ),
                widget.item[index]['img'].length > 0
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: CachedImageView(
                          ScreenUtil.instance.setWidth(240.0),
                          ScreenUtil.instance.setWidth(240.0),
                          widget.item[index]['img'],
                          null,
                          BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      )
                    : Container(),
                widget.type == '1'
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'assets/index/ic_shouye_da.png',
                            width: ScreenUtil().setWidth(33),
                            height: ScreenUtil().setWidth(33),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: ScreenUtil().setWidth(600),
                            child: Text(
                              "${widget.item[index]['comment']}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: ScreenUtil().setWidth(25),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(24),
                ),
                Container(
                  // width: ScreenUtil().setWidth(651),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                  height: ScreenUtil().setWidth(1),
                  color: Color(0xffE5E5E5),
                ),
                widget.type == '1'
                    ? Container(
                        height: ScreenUtil().setWidth(83),
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(37)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      clickZan(widget.item[index]['id'],
                                          widget.item[index]['is_like'], index);
                                    },
                                    child: Image.asset(
                                      '${widget.item[index]['is_like'] == 0 ? 'assets/index/ic_dianzan.png' : 'assets/index/dz.png'}',
                                      width: ScreenUtil().setWidth(32),
                                      height: ScreenUtil().setWidth(32),
                                    )),
                                Text(
                                  '${widget.item[index]['like']}',
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(77),
                            ),
                            Row(
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      clickDel(widget.item[index]['id'], index);
                                    },
                                    child: Image.asset(
                                      'assets/index/scan.png',
                                      width: ScreenUtil().setWidth(32),
                                      height: ScreenUtil().setWidth(32),
                                    )),
                                SizedBox(
                                  width: ScreenUtil().setWidth(10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: ScreenUtil().setWidth(83),
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(37)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                '删除',
                                style: TextStyle(color: PublicColor.fontColor),
                              ),
                              onTap: () {
                                clickDel(widget.item[index]['id'], index);
                              },
                            ),
                            Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {},
                                        child: Image.asset(
                                          'assets/index/ly.png',
                                          width: ScreenUtil().setWidth(32),
                                          height: ScreenUtil().setWidth(32),
                                        )),
                                    Text(
                                      '${widget.item[index]['comment']}',
                                      style: TextStyle(
                                        color: Color(0xff666666),
                                        fontSize: ScreenUtil().setSp(28),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(77),
                                ),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          clickZan(
                                              widget.item[index]['id'],
                                              widget.item[index]['is_like'],
                                              index);
                                        },
                                        child: Image.asset(
                                          '${widget.item[index]['is_like'] == 0 ? 'assets/index/ic_dianzan.png' : 'assets/index/dz.png'}',
                                          width: ScreenUtil().setWidth(32),
                                          height: ScreenUtil().setWidth(32),
                                        )),
                                    Text(
                                      '${widget.item[index]['like']}',
                                      style: TextStyle(
                                        color: Color(0xff666666),
                                        fontSize: ScreenUtil().setSp(28),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
              ],
            ),
          ),
        );
      });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: boxs(), //要显示的子控件集合
    );
  }
}
