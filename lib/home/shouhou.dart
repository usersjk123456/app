import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/loading.dart';
import '../widgets/cached_image.dart';
import '../common/upload_to_oss.dart';
import '../common/color.dart';
import '../config/fluro_convert_util.dart';
import '../utils/toast_util.dart';
import '../service/user_service.dart';

class ShouHouPage extends StatefulWidget {
  final String objs;
  ShouHouPage({this.objs});

  @override
  ShouHouPageState createState() => ShouHouPageState();
}

class ShouHouPageState extends State<ShouHouPage> {
  bool isLoading = false;
  int groupValue = 1;
  String img = "";
  String reason = '';
  Map lists = {
    "id": "",
    "img": "",
    "goods_name": "",
    "num": "",
    "now_price": "",
    "freight": "",
    "totalMoney": "",
  };
  TextEditingController _descController = TextEditingController();
  @override
  void initState() {
    lists = FluroConvertUtils.string2map(widget.objs);
    print('~~~~~~~~~~~~~~');
    print(lists);
    print('~~~~~~~~~~~~~~');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeLoading({type = 2, sent = 0, total = 0}) {
    if (type == 1) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void apply() {
    if (reason == "") {
      ToastUtil.showToast('请选择退款原因');
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => lists['id']);
    map.putIfAbsent("type", () => this.groupValue);
    map.putIfAbsent("num", () => lists['num']);
    map.putIfAbsent("reason", () => reason);
    map.putIfAbsent("money", () => lists['allMoney']);
    map.putIfAbsent("explain", () => _descController.text);
    map.putIfAbsent("img", () => img);
    UserServer().applyAfter(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('已提交申请');
      Navigator.pop(context, "1");
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: new AppBar(
            elevation: 0,
            title: Text(
              '申请售后',
              style: TextStyle(
                color: PublicColor.headerTextColor,
                fontSize: ScreenUtil.instance.setWidth(30.0),
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
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: PublicColor.linearHeader,
              ),
            ),
          ),
          resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }

  Widget contentWidget() {
    return Container(
      width: ScreenUtil.instance.setWidth(750.0),
      height: ScreenUtil.instance.setWidth(1200.0),
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(25), left: ScreenUtil().setWidth(25)),
      child: Column(children: [
        new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
        Container(
            height: ScreenUtil.instance.setWidth(207.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: new Border.all(color: Color(0xfffececec), width: 1),
            ),
            child: Row(children: <Widget>[
              new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
              CachedImageView(
                  ScreenUtil.instance.setWidth(168.0),
                  ScreenUtil.instance.setWidth(168.0),
                  lists['img'],
                  null,
                  BorderRadius.all(Radius.circular(10))),
              new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
              Container(
                width: ScreenUtil.instance.setWidth(470.0),
                height: ScreenUtil.instance.setWidth(185.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text(lists['goods_name'],
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26.0))),
                      new SizedBox(height: ScreenUtil.instance.setWidth(5.0)),
                      new Row(children: [
                        Container(
                          width: ScreenUtil.instance.setWidth(470.0),
                          height: ScreenUtil.instance.setWidth(80.0),
                          alignment: Alignment.bottomLeft,
                          child: Row(children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text('￥${lists['now_price']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ScreenUtil.instance
                                              .setWidth(26.0))),
                                )),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: Text('x${lists['num']}',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: ScreenUtil.instance
                                              .setWidth(26.0))),
                                ))
                          ]),
                        ),
                      ])
                    ]),
              ),
            ])),
        new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
        Container(
          height: ScreenUtil.instance.setWidth(740.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: new Border.all(color: Color(0xfffececec), width: 1),
          ),
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(25),
                  left: ScreenUtil().setWidth(25)),
              height: ScreenUtil.instance.setWidth(100.0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border(
                  bottom: BorderSide(color: Color(0xfffececec), width: 1),
                ),
              ),
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: Text('退款类型',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.instance.setWidth(26.0)))),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Radio(
                            value: 1,
                            groupValue: this.groupValue,
                            activeColor: PublicColor.themeColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (v) {
                              setState(() {
                                this.groupValue = v;
                              });
                            }),
                        Text('退货退款',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil.instance.setWidth(26.0))),
                        Radio(
                            value: 2,
                            groupValue: this.groupValue,
                            activeColor: PublicColor.themeColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (v) {
                              setState(() {
                                this.groupValue = v;
                              });
                            }),
                        Text('仅退款',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil.instance.setWidth(26.0)))
                      ],
                    )),
              ]),
            ),
            Container(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(25),
                  left: ScreenUtil().setWidth(25)),
              height: ScreenUtil.instance.setWidth(100.0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border(
                  bottom: BorderSide(color: Color(0xfffececec), width: 1),
                ),
              ),
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: Text('退款数量',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.instance.setWidth(26.0)))),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('1',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil.instance.setWidth(26.0))),
                      ],
                    )),
              ]),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                height: ScreenUtil.instance.setWidth(100.0),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: Border(
                    bottom: BorderSide(color: Color(0xfffececec), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '退款原因',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil.instance.setWidth(26.0),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            reason == "" ? '请选择' : reason,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                print('退款原因');
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FenleiWidget(onChanged: (type) {
                        setState(() {
                          reason = type;
                        });
                      });
                    });
              },
            ),
            Container(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(25),
                  left: ScreenUtil().setWidth(25)),
              height: ScreenUtil.instance.setWidth(100.0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border(
                  bottom: BorderSide(color: Color(0xfffececec), width: 1),
                ),
              ),
              child: Row(children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('退款金额',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil.instance.setWidth(26.0))),
                        Text("最多退款${lists['allMoney']}，包含运费${lists['freight']}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil.instance.setWidth(23.0))),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        //  + lists['allMoney']
                        Text("￥${lists['amount']}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil.instance.setWidth(26.0))),
                      ],
                    )),
              ]),
            ),
            Container(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(25),
                  left: ScreenUtil().setWidth(25)),
              height: ScreenUtil.instance.setWidth(100.0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border(
                  bottom: BorderSide(color: Color(0xfffececec), width: 1),
                ),
              ),
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: Text('退款说明',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.instance.setWidth(26.0)))),
                Expanded(
                  flex: 2,
                  child: new TextField(
                    style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(26.0),
                        color: Colors.black),
                    textAlign: TextAlign.end,
                    controller: _descController,
                    decoration: new InputDecoration(
                        hintText: '选填', border: InputBorder.none),
                  ),
                ),
              ]),
            ),
            new SizedBox(height: ScreenUtil.instance.setWidth(30.0)),
            Container(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(25),
                  left: ScreenUtil().setWidth(25)),
              height: ScreenUtil.instance.setWidth(190.0),
              child: Row(children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: Text('上传凭证',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26.0)))),
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                    child: new Container(
                      alignment: Alignment.topLeft,
                      child: img == ""
                          ? Image.asset(
                              'assets/dianpu/sctp.png',
                              width: ScreenUtil.instance.setWidth(190.0),
                            )
                          : Image.network(
                              img,
                              width: ScreenUtil.instance.setWidth(190.0),
                            ),
                    ),
                    onTap: () async {
                      print('上传图片');
                      Map obj = await openGallery("image", changeLoading);
                      if (obj == null) {
                        changeLoading(type: 2, sent: 0, total: 0);
                        return;
                      }
                      if (obj['errcode'] == 0) {
                        img = obj['url'];
                      } else {
                        ToastUtil.showToast(obj['msg']);
                      }
                    },
                  ),
                ),
              ]),
            )
          ]),
        ),
        new SizedBox(height: ScreenUtil.instance.setWidth(20.0)),
        InkWell(
          child: Container(
            width: ScreenUtil.instance.setWidth(640.0),
            height: ScreenUtil.instance.setWidth(90.0),
            color: PublicColor.themeColor,
            alignment: Alignment.center,
            child: Text('提交',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil.instance.setWidth(28.0))),
          ),
          onTap: () {
            print('提交');
            apply();
          },
        )
      ]),
    );
  }
}

//退款原因弹窗
class FenleiWidget extends StatefulWidget {
  final Function(String) onChanged;
  FenleiWidget({
    Key key,
    @required this.onChanged,
  }) : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => DialogFenleiState();
}

class DialogFenleiState extends State<FenleiWidget> {
  int groupValue = 21;
  Widget build(BuildContext content) {
    return new Container(
      child: new Column(children: <Widget>[
        new Container(
            // alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(75),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                      child: new Text('退款原因',
                          style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(26.0)))),
                  new Container(
                      padding:
                          EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                      child: InkWell(
                        child: Image.asset(
                          'assets/index/gb.png',
                          width: ScreenUtil.instance.setWidth(40.0),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ))
                ])),
        RadioListTile<int>(
            value: 1,
            groupValue: groupValue,
            onChanged: (int value) {
              widget.onChanged("不想买了");
              setState(() {
                groupValue = value;
              });
              Navigator.pop(context);
            },
            title: new Text("不想买了",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ScreenUtil().setSp(28),
                )),
            dense: true,
            activeColor: PublicColor.themeColor, // 指定选中时勾选框的颜色
            isThreeLine: false, // 是否空出第三行
            selected: false,
            controlAffinity: ListTileControlAffinity.trailing),
        Divider(
          color: Colors.grey[300],
          height: 1,
        ),
        RadioListTile<int>(
            value: 2,
            groupValue: groupValue,
            onChanged: (int value) {
              widget.onChanged("与图片不符");
              setState(() {
                groupValue = value;
              });
              Navigator.pop(context);
            },
            title: new Text("与图片不符",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ScreenUtil().setSp(28),
                )),
            dense: false,
            activeColor: PublicColor.themeColor, // 指定选中时勾选框的颜色
            isThreeLine: false, // 是否空出第三行
            selected: false,
            controlAffinity: ListTileControlAffinity.trailing),
        Divider(
          color: Colors.grey[300],
          height: 2,
        ),
        RadioListTile<int>(
            value: 3,
            groupValue: groupValue,
            onChanged: (int value) {
              widget.onChanged("不喜欢");
              setState(() {
                groupValue = value;
              });
              Navigator.pop(context);
            },
            title: new Text("不喜欢",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ScreenUtil().setSp(28),
                )),
            dense: false,
            activeColor: PublicColor.themeColor, // 指定选中时勾选框的颜色
            isThreeLine: false, // 是否空出第三行
            selected: false,
            controlAffinity: ListTileControlAffinity.trailing),
        Divider(
          color: Colors.grey[300],
          height: 1,
        ),
        RadioListTile<int>(
            value: 4,
            groupValue: groupValue,
            onChanged: (int value) {
              widget.onChanged("其他原因");
              setState(() {
                groupValue = value;
              });
              Navigator.pop(context);
            },
            title: new Text("其他原因",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ScreenUtil().setSp(28),
                )),
            dense: false,
            activeColor: PublicColor.themeColor, // 指定选中时勾选框的颜色
            isThreeLine: false, // 是否空出第三行
            selected: false,
            controlAffinity: ListTileControlAffinity.trailing),
        Divider(
          color: Colors.grey[300],
          height: 1,
        ),
      ]),
    );
  }
}
