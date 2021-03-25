import 'package:client/common/string.dart';
import 'package:client/config/Navigator_util.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import '../widgets/loading.dart';

class AgreementDialog extends Dialog {
  final String uid;
  AgreementDialog({this.uid});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Agreement(uid: uid),
    );
  }
}

class Agreement extends StatefulWidget {
  final String uid;
  Agreement({this.uid});
  @override
  _AgreementState createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
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
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30),
                bottom: ScreenUtil().setWidth(40),
              ),
              width: ScreenUtil().setWidth(600),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(30),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(50),
                      bottom: ScreenUtil().setWidth(50),
                    ),
                    child: Text(
                      '用户协议和隐私政策',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(34),
                      ),
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text:
                            '请务必审慎阅读，充分理解“服务协议”和“隐私政策”各条款。包括但不限于：为了向你提供及时通讯、内容分享等服务。我们需要收集你的设备信息、操作日志等个人信息。你可以在”设置“中查看、变更、删除个人信息并管理你的授权。你可阅读',
                        style: TextStyle(
                          color: PublicColor.grewNoticeColor,
                          fontSize: ScreenUtil().setSp(30),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '《用户协议》',
                            style: TextStyle(
                              color: PublicColor.themeColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                NavigatorUtils.goAgreement(context,'yonghu');
                              },
                          ),
                          TextSpan(text: '和'),
                          TextSpan(
                            text: '《隐私政策》',
                            style: TextStyle(color: PublicColor.themeColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                NavigatorUtils.goAgreement(context,'yinsi');
                              },
                          ),
                          TextSpan(text: '了解详细信息，如你同意，请点击”同意“开始接受我们的服务'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(50),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setWidth(80),
                        width: ScreenUtil().setWidth(240),
                        decoration: BoxDecoration(
                            color: PublicColor.themeColor,
                            borderRadius: new BorderRadius.circular((8.0))),
                        child: new FlatButton(
                          disabledColor: PublicColor.themeColor,
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool(Strings.AGREE_AGREEMENT, true);
                            Navigator.pop(context);
                          },
                          child: new Text(
                            '同意',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setWidth(80),
                        width: ScreenUtil().setWidth(240),
                        decoration: BoxDecoration(
                            color: PublicColor.grewNoticeColor,
                            borderRadius: new BorderRadius.circular((8.0))),
                        child: new FlatButton(
                          onPressed: () {
                            ToastUtil.showToast('您必须同意该用户协议');
                          },
                          child: new Text(
                            '暂不使用',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                      ),
                    ],
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
