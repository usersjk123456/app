import 'package:client/common/regExp.dart';
import 'package:client/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import '../config/fluro_convert_util.dart';
import '../widgets/loading.dart';
import '../utils/toast_util.dart';
import '../common/upload_to_oss.dart';

class AuthenticationTwoPage extends StatefulWidget {
  final String objs;
  AuthenticationTwoPage({this.objs});
  @override
  AuthenticationTwoPageState createState() => AuthenticationTwoPageState();
}

class AuthenticationTwoPageState extends State<AuthenticationTwoPage> {
  bool isLoading = false;
  Map obj = {};
  String img = '';
  String img1 = '';
  String img2 = '';
  TextEditingController namecontroller = TextEditingController();
  TextEditingController idcardcontroller = TextEditingController();
  @override
  void initState() {
    obj = FluroConvertUtils.string2map(widget.objs);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);


        Widget topArea = new Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(453),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          "assets/shop/rzt.png",
        ),
      )),
      child: Stack(
        children: <Widget>[
          //bg图片

          Positioned(
            top: 10,
            left: 10,
            child: Container(
              width: ScreenUtil().setWidth(750),
              height: ScreenUtil().setWidth(112),
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Icon(
                      Icons.navigate_before,
                      color: Color(0xffffffff),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    '供应商认证',
                    style: new TextStyle(
                        color: Color(0xffffffff),
                        fontSize: ScreenUtil().setSp(32)),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(96),
                    height: ScreenUtil().setWidth(46),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 10,
            child: Container(
              child: Image.asset(
                "assets/shop/sfrz2.png",
                height: ScreenUtil().setWidth(190),
                width: ScreenUtil().setWidth(715),
              ),
            ),
          ),
        ],
      ),
    );

    Widget upload = new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(585),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular((8.0)),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 10),
              child: new Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: new Column(
                      children: <Widget>[
                        Container(
                          child: img == ""
                              ? Image.asset(
                                  "assets/shop/scsfzzm.png",
                                  height: ScreenUtil().setWidth(204),
                                  width: ScreenUtil().setWidth(318),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  img,
                                  height: ScreenUtil().setWidth(204),
                                  width: ScreenUtil().setWidth(318),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              '点击上传正面',
                              style: TextStyle(
                                color: Color(0xff888888),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ))
                      ],
                    ),
                    onTap: () async {
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
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: new Column(
                      children: <Widget>[
                        Container(
                          child: img1 == ""
                              ? Image.asset(
                                  "assets/shop/scsfzfm.png",
                                  height: ScreenUtil().setWidth(204),
                                  width: ScreenUtil().setWidth(318),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  img1,
                                  height: ScreenUtil().setWidth(204),
                                  width: ScreenUtil().setWidth(318),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              '点击上传反面',
                              style: TextStyle(
                                color: Color(0xff888888),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ))
                      ],
                    ),
                    onTap: () async {
                      Map obj = await openGallery("image", changeLoading);
                      if (obj == null) {
                        changeLoading(type: 2, sent: 0, total: 0);
                        return;
                      }
                      if (obj['errcode'] == 0) {
                        img1 = obj['url'];
                      } else {
                        ToastUtil.showToast(obj['msg']);
                      }
                    },
                  ),
                )
              ])),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: InkWell(
              child: new Column(children: <Widget>[
                Container(
                  child: img2 == ""
                      ? Image.asset(
                          "assets/shop/scsfsc.png",
                          height: ScreenUtil().setWidth(204),
                          width: ScreenUtil().setWidth(318),
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          img2,
                          height: ScreenUtil().setWidth(204),
                          width: ScreenUtil().setWidth(318),
                          fit: BoxFit.cover,
                        ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      '点击上传营业执照',
                      style: TextStyle(
                        color: Color(0xff888888),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ))
              ]),
              onTap: () async {
                Map obj = await openGallery("image", changeLoading);
                if (obj == null) {
                  changeLoading(type: 2, sent: 0, total: 0);
                  return;
                }
                if (obj['errcode'] == 0) {
                  img2 = obj['url'];
                } else {
                  ToastUtil.showToast(obj['msg']);
                }
              },
            ),
          )
        ]),
      ),
    );

    Widget telArea = new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(210),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular((8.0)),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(102),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffdddddd),
                  ),
                ),
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '姓名',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: new TextField(
                        controller: namecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                        decoration: new InputDecoration(
                          hintText: '请输入',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xffa1a1a1),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(102),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '身份证',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: new TextField(
                        controller: idcardcontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                        decoration: new InputDecoration(
                          hintText: '请输入',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xffa1a1a1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    Widget btnArea = BigButton(
      name: '下一步',
      tapFun: () {
        print('修改');
        if (img == '') {
          ToastUtil.showToast('请上传身份证正面照');
          return;
        }
        if (img1 == '') {
          ToastUtil.showToast('请上传身份证反面照');
          return;
        }
        if (img2 == '') {
          ToastUtil.showToast('请上传营业执照');
          return;
        }
        if (namecontroller.text == '') {
          ToastUtil.showToast('请输入姓名');
          return;
        }
        if (idcardcontroller.text == '') {
          ToastUtil.showToast('请输入身份证号');
          return;
        }
        if (!RegExpTest.checkCard.hasMatch(idcardcontroller.text)) {
          ToastUtil.showToast('身份证号格式错误');
          return;
        }
        obj['name'] = namecontroller.text;
        obj['id_card'] = idcardcontroller.text;
        obj['img1'] = img;
        obj['img2'] = img1;
        obj['img3'] = img2;
        NavigatorUtils.goAuthenticationThreePage(context, obj);
      },
      top: ScreenUtil().setWidth(40),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: <Widget>[
          Scaffold(
       
            body: new Container(
              alignment: Alignment.center,
              child: new ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  topArea,
                  upload,
                  telArea,
                  btnArea,
                  new SizedBox(height: ScreenUtil().setWidth(30)),
                ],
              ),
            ),
          ),
          isLoading ? LoadingDialog() : Container()
        ],
      ),
    );
  }
}
