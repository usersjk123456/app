import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../widgets/loading.dart';

class OpenLiveDialog extends Dialog {
  final Function startTimer;
  OpenLiveDialog({this.startTimer});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: OpenLive(startTimer: startTimer),
    );
  }
}

class OpenLive extends StatefulWidget {
  final Function startTimer;
  OpenLive({this.startTimer});
  // OpenLive({@required this.loadhall, @required this.jwt});
  @override
  _OpenLiveState createState() => _OpenLiveState();
}

class _OpenLiveState extends State<OpenLive> {
  // OpenLive({@required this.krPrice, @required this.expendStore});
  TextEditingController idController = TextEditingController();
  var btnActive = false;
  var inviteId = '';
  bool isLoading = false;
  String orderId = "";
  @override
  void initState() {
    super.initState();
    fluwx.weChatResponseEventHandler.listen((res) {
      if (res is fluwx.WeChatPaymentResponse) {
        if (res.errCode == 0) {
          widget.startTimer(orderId);
        } else {
          ToastUtil.showToast('支付失败,请重试');
        }
      }
    });
  }

  void confirmId() {
    if (idController.text == '') {
      ToastUtil.showToast('请输入邀请人ID');
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("shangji", () => idController.text);
    UserServer().openLive(map, (success) async {
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
      fluwx.payWithWeChat(
        appId: success['res']['appid'],
        partnerId: success['res']['partnerid'],
        prepayId: success['res']['prepayid'],
        packageValue: success['res']['package'],
        nonceStr: success['res']['noncestr'],
        timeStamp: success['res']['timestamp'],
        sign: success['res']['sign'],
      );
      orderId = success['res']['order_id'];
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
                          '邀请人ID',
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
                              hintText: "请输入邀请人ID",
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
                            color: PublicColor.btnColor),
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
