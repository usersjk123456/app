import 'package:client/common/upLoading.dart';
import 'package:client/common/uploadToOss.dart';
import 'package:client/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import '../widgets/choose_type.dart';
import '../service/video_service.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';

class ShortVideoPage extends StatefulWidget {
  @override
  ShortVideoPageState createState() => ShortVideoPageState();
}

class ShortVideoPageState extends State<ShortVideoPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode descFocus = FocusNode();

  Map liveType = {'id': 0, 'name': '未选择'};
  List chooseType = [];
  bool isLoading = false;
  bool isUpSuccess = false;
  String videoUrl = "";
  String img = "";
  bool isUpLoading = false;
  int sents = 0;
  int totals = 100;

  String tjImg = '', tjId = '';
  Map tjGoods = {};
  VideoPlayerController _controller;

  @override
  void initState() {
    getTypeList();
    super.initState();
  }

  void unFouce() {
    print('111111');
    nameFocus.unfocus(); // input失去焦点
    descFocus.unfocus(); // input失去焦点
  }

  void getTypeList() async {
    Map<String, dynamic> map = Map();
    VideoServer().getCreateViodeType(map, (success) {
      setState(() {
        chooseType = success['list'];
      });
      print(chooseType[0]['id'] is int);
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  void changeLoading({type = 2, sent = 0, total = 100}) {
    print('sent-->>>$sent');
    print('total-->>>$total');
    if (type == 1) {
      setState(() {
        isUpLoading = true;
        sents = sent;
        totals = total;
      });
    } else {
      setState(() {
        isUpLoading = false;
        sents = 0;
        totals = 100;
      });
    }
  }

  void create() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("url", () => videoUrl);
    map.putIfAbsent("img", () => img);
    map.putIfAbsent("name", () => nameController.text);
    map.putIfAbsent("desc", () => descController.text);
    map.putIfAbsent("type", () => liveType['id']);
    map.putIfAbsent("goods_id", () => tjId);
    VideoServer().createVideo(map, (success) {
      ToastUtil.showToast('上传成功');
      Navigator.pop(context);
    }, (onFail) {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget uploadVideo = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(344),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: Container(
          alignment: Alignment.center,
          height: ScreenUtil().setWidth(280),
          width: ScreenUtil().setWidth(202),
          child: isUpSuccess
              ? VideoPlayer(_controller)
              : InkWell(
                  child: Image.asset(
                    "assets/shop/scsp.png",
                    height: ScreenUtil().setWidth(280),
                    width: ScreenUtil().setWidth(202),
                    fit: BoxFit.cover,
                  ),
                  onTap: () async {
                    // unFouce();
                    Map obj = await openGallery("mp4", changeLoading);
                    if (obj == null) {
                      changeLoading(type: 2, sent: 0, total: 100);
                      return;
                    }
                    if (obj['errcode'] == 0) {
                      isUpSuccess = true;
                      videoUrl = obj['url'];

                      _controller = VideoPlayerController.network(obj['url'])
                        ..initialize().then((_) {
                          setState(() {
                            _controller.play();
                          });
                        });
                    } else {
                      isUpSuccess = false;
                      ToastUtil.showToast(obj['msg']);
                    }
                  },
                ),
        ),
      ),
    );

    Widget upImg = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(30),
        ),
        padding: EdgeInsets.all(
          ScreenUtil().setWidth(30),
        ),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                '视频封面',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(40),
            ),
            InkWell(
              child: img == ""
                  ? Image.asset(
                      "assets/shop/sctp.png",
                      height: ScreenUtil().setWidth(183),
                      width: ScreenUtil().setWidth(183),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      img,
                      height: ScreenUtil().setWidth(183),
                      width: ScreenUtil().setWidth(183),
                      fit: BoxFit.cover,
                    ),
              onTap: () async {
                print('点击上传');
                Map obj = await openGallery("image", changeLoading);
                print('obj======$obj');
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
          ],
        ),
      ),
    );

    Widget videoName = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(112),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  child: Text(
                    '视频名称',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Colors.black,
                    ),
                  ))),
          Expanded(
            flex: 3,
            child: Container(
              child: new TextField(
                style: TextStyle(
                  fontSize: ScreenUtil().setWidth(28),
                ),
                controller: nameController,
                focusNode: nameFocus,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    hintText: '名子起的棒，视频销量就上榜~~', border: InputBorder.none),
              ),
            ),
          )
        ]),
      ),
    );

    Widget videoDesc = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(112),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  child: Text(
                    '视频描述',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Colors.black,
                    ),
                  ))),
          Expanded(
            flex: 3,
            child: Container(
              child: new TextField(
                style: TextStyle(
                  fontSize: ScreenUtil().setWidth(28),
                ),
                controller: descController,
                focusNode: descFocus,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    hintText: '这里是视频描述', border: InputBorder.none),
              ),
            ),
          )
        ]),
      ),
    );

    Widget videoType = new Container(
      alignment: Alignment.center,
      child: Container(
          margin: EdgeInsets.only(top: 15),
          width: ScreenUtil().setWidth(700),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
          ),
          child: Column(
            children: <Widget>[
              InkWell(
                child: new Container(
                  height: ScreenUtil().setWidth(100),
                  width: ScreenUtil().setWidth(700),
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0,
                      ScreenUtil().setWidth(20), 0),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Color(0xffdddddd))),
                  ),
                  child: new Row(children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        '推荐商品',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: tjImg == ''
                            ? Text(
                                '仅可选择一件商品',
                                style: TextStyle(
                                  color: Color(0xffeb727d),
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              )
                            : ClipOval(
                                child: new Image.network(
                                  tjImg,
                                  width: ScreenUtil().setWidth(64),
                                  height: ScreenUtil().setWidth(64),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: new Icon(
                          Icons.navigate_next,
                          color: Color(0xff8e8e8e),
                        ),
                      ),
                    )
                  ]),
                ),
                onTap: () {
                  print('推荐商品');
                  // unFouce();
                  NavigatorUtils.toChooseGoodsPage(context, 'tuijian', tjGoods)
                      .then((result) {
                    if (result != null) {
                      setState(() {
                        print('tuijian-----------');
                        print(result);
                        tjGoods = result;
                      });
                      result.forEach((key, value) {
                        setState(() {
                          tjImg = value['thumb'];
                          tjId = value['id'].toString();
                        });
                      });
                    }
                  });
                },
              ),
              InkWell(
                onTap: () {
                  unFouce();
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FenleiWidget(
                        typeList: chooseType,
                        selectId: liveType['id'],
                        title: "短视频分类",
                        onChanged: (item) {
                          setState(() {
                            liveType = item;
                          });
                        },
                      );
                    },
                  );
                },
                child: new Container(
                  height: ScreenUtil().setWidth(100),
                  width: ScreenUtil().setWidth(700),
                  child: new Row(children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                        child: Text(
                          '分类',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          liveType['name'],
                          style: TextStyle(
                            color: Color(0xff8e8e8e),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: new Icon(
                          Icons.navigate_next,
                          color: Color(0xff8e8e8e),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ],
          )),
    );

    Widget btnArea = new Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(40),
      ),
      alignment: Alignment.center,
      child: BigButton(
        name: '确认上传',
        tapFun: () {
          print(_controller);
          if (_controller != null) {
            _controller.pause();
          }
          if (!isUpSuccess) {
            ToastUtil.showToast('请上传视频');
            return;
          }
          if (nameController.text == "") {
            ToastUtil.showToast('请输入视频名称');
            return;
          }
          if (descController.text == "") {
            ToastUtil.showToast('请输入视频描述');
            return;
          }
          if (liveType['id'] == 0) {
            ToastUtil.showToast('请选择分类');
            return;
          }
          create();
        },
        top: ScreenUtil().setWidth(40),
      ),

      // Container(
      //   height: ScreenUtil().setWidth(86),
      //   width: ScreenUtil().setWidth(640),
      //   margin: EdgeInsets.only(
      //     top: ScreenUtil().setWidth(70),
      //     bottom: ScreenUtil().setWidth(70),
      //   ),
      //   decoration: BoxDecoration(
      //     color: PublicColor.themeColor,
      //     borderRadius: new BorderRadius.circular(
      //       (8.0),
      //     ),
      //   ),
      //   child: new FlatButton(
      //     disabledColor: PublicColor.themeColor,
      //     onPressed: () {

      //     },
      //     child: new Text(
      //       '确认上传',
      //       style: TextStyle(
      //         color: PublicColor.textColor,
      //         fontSize: ScreenUtil().setSp(28),
      //         fontWeight: FontWeight.w600,
      //       ),
      //     ),
      //   ),
      // ),
    );
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '短视频',
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
              new InkWell(
                onTap: () {
                  NavigatorUtils.toRecordVideoPage(context);
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.slideshow,
                      color: Color(0xfff493900),
                      size: ScreenUtil.instance.setWidth(45.0),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Text(
                        '历史',
                        style: new TextStyle(
                          color: PublicColor.textColor,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                uploadVideo,
                upImg,
                videoName,
                videoDesc,
                videoType,
                btnArea
              ],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container(),
        isUpLoading ? UpLoadingDialog(sent: sents, total: totals) : Container()
      ],
    );
  }
}
