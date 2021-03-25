import 'package:client/config/Navigator_util.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/checkbox.dart';
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
  bool checkStatus = false;
  bool isLoading = false;
  String orderId = "";
  @override
  void initState() {
    super.initState();
  }

  _checkCart(bool isCheck) {
    setState(() {
      checkStatus = isCheck;
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
                      '【特别说明】',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(34),
                      ),
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text: '1、感谢您选择橙子宝宝，橙子宝宝提供的拼团商品均为质优价实的商品，暂不提供退换货服务',
                        style: TextStyle(
                          color: PublicColor.fontColor,
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text:
                            '2、请提供详细的收货信息（收货人姓名、地址、电话），且保持电话畅通，若因此导致收不到货，请您自行解决相关问题',
                        style: TextStyle(
                          color: PublicColor.fontColor,
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text: '3、请您详细阅读此说明，点击“同意”，视您同意此说明，欢迎您选择所需商品开始参与拼团赚补贴',
                        style: TextStyle(
                          color: PublicColor.fontColor,
                          fontSize: ScreenUtil().setSp(32),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(50),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        RoundCheckBox(
                          value: checkStatus,
                          onChanged: (bool) {
                            _checkCart(bool);
                          },
                        ),
                        Container(
                          child: Text('我已阅读并同意上述条款'),
                        )
                      ],
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
                            await prefs.setString('agree', '1');
                            if (!checkStatus) {
                              ToastUtil.showToast('请先勾选上述条款');
                              return;
                            }
                            Navigator.pop(context);
                            NavigatorUtils.goBamaiList(context);
                          },
                          child: new Text(
                            '同意',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                color: PublicColor.whiteColor),
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
                            Navigator.pop(context);
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
