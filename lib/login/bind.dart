import 'package:client/config/Navigator_util.dart';
import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';

class BindDialog extends Dialog {
  final String uid;
  BindDialog({this.uid});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Bind(uid: uid),
    );
  }
}

class Bind extends StatefulWidget {
  final String uid;
  Bind({this.uid});
  @override
  _BindState createState() => _BindState();
}

class _BindState extends State<Bind> {
  // OpenLive({@required this.krPrice, @required this.expendStore});
  TextEditingController idController = TextEditingController();
  var btnActive = false;
  var inviteId = '';
  bool isLoading = false;
  String orderId = "";
  @override
  void initState() {
    super.initState();
  }

  void confirmId() {
    if (idController.text == '') {
      ToastUtil.showToast('请输入上级ID');
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("shangji", () => idController.text);
    map.putIfAbsent("uid", () => widget.uid);

    UserServer().bindshangji(map, (success) async {
      ToastUtil.showToast('绑定成功');
      setState(() {
        isLoading = false;
      });
      final prefs = await SharedPreferences.getInstance();
      // 存值
      await prefs.setString('jwt', success['jwt']);
      await prefs.setInt('uid', success['user']['id']);

      await Future.delayed(Duration(seconds: 1), () {
        NavigatorUtils.goHomePage(context);
      });
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
        new Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          child: new Center(
            //保证控件居中效果
            child: new Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
              ),
              width: ScreenUtil().setWidth(600),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setWidth(30),
                  ),
                  color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: PublicColor.textColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '上级ID',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(34),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(
                            right: ScreenUtil().setWidth(40),
                          ),
                          child: TextField(
                            controller: idController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "请输入上级ID",
                            ),
                            onChanged: (value) {
                              // setState(() {
                              //   widget.template['limit'] = value;
                              // });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: ScreenUtil().setWidth(80),
                    width: ScreenUtil().setWidth(300),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(60),
                      bottom: ScreenUtil().setWidth(70),
                    ),
                    decoration: BoxDecoration(
                        color: PublicColor.themeColor,
                        borderRadius: new BorderRadius.circular((8.0))),
                    child: new FlatButton(
                      disabledColor: PublicColor.themeColor,
                      onPressed: () {
                        print('确认');
                        confirmId();
                      },
                      child: new Text(
                        '确认',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
