import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import '../utils/toast_util.dart';
import '../widgets/cached_image.dart';
import '../common/upload_to_oss.dart';
import 'package:client/service/user_service.dart';

class PersonalDataPage extends StatefulWidget {
  @override
  PersonalDataPageState createState() => PersonalDataPageState();
}

class PersonalDataPageState extends State<PersonalDataPage> {
  bool isLoading = false;
  String img = '';
  String headimgurl = '', name = '', wxImg = '';

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getInfo();
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  // 获取个人资料
  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      setState(() {
        headimgurl = success['user']['headimgurl'];
        name = success['user']['nickname'];
        wxImg = success['user']['wxqrcode'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 上传图片
  changeLoading({type = 2, sent = 0, total = 0}) {
    print('sent-->>>$sent');
    print('total-->>>$total');
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

  // 修改微信名片
  void setWxImg() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("qrcode", () => wxImg);

    UserServer().setWxImg(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('修改成功');
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  // 修改头像
  void setAvatar() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("headimgurl", () => headimgurl);

    UserServer().setAvatar(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('修改成功');
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

    Widget dataArea = new Container(
      height: ScreenUtil().setWidth(306),
      width: ScreenUtil().setWidth(700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xffe5e5e5), width: 1),
      ),
      child: new Column(children: <Widget>[
        new InkWell(
          child: Container(
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  '昵称',
                  style: TextStyle(
                    color: Color(0xff454545),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: new Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Color(0xffbababa),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            NavigatorUtils.goNicknamePage(context)  .then((res) =>getInfo());
          },
        ),
        new InkWell(
          child: Container(
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  '个人头像',
                  style: TextStyle(
                    color: Color(0xff454545),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: new Container(
                  alignment: Alignment.centerRight,
                  child: headimgurl != ''
                      ? ClipOval(
                          child: Image.network(
                            headimgurl,
                            height: ScreenUtil().setWidth(75),
                            width: ScreenUtil().setWidth(75),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () async {
            Map obj = await openGallery("image", changeLoading);
            if (obj == null) {
              changeLoading(type: 2);
              return;
            }
            if (obj['errcode'] == 0) {
              headimgurl = obj['url'];
              setAvatar();
            } else {
              ToastUtil.showToast(obj['msg']);
            }
          },
        ),
        new InkWell(
          child: Container(
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            child: new Row(children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  '微信名片',
                  style: TextStyle(
                    color: Color(0xff454545),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: new Container(
                  alignment: Alignment.centerRight,
                  child: wxImg == ''
                      ? Text(
                          '上传微信二维码',
                          style: TextStyle(
                            color: Color(0xffbababa),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        )
                      : CachedImageView(
                          ScreenUtil.instance.setWidth(75),
                          ScreenUtil.instance.setWidth(75),
                          wxImg,
                          null,
                          BorderRadius.circular(40)),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () async {
            Map obj = await openGallery("image", changeLoading);
            if (obj == null) {
              changeLoading(type: 2);
              return;
            }
            if (obj['errcode'] == 0) {
              wxImg = obj['url'];
              setWxImg();
            } else {
              ToastUtil.showToast(obj['msg']);
            }
          },
        )
      ]),
    );
    return MaterialApp(
        title: "个人资料",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '个人资料',
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
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new SizedBox(
                  height: ScreenUtil().setWidth(20),
                ),
                dataArea
              ],
            ),
          ),
        ));
  }
}
