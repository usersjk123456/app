import 'dart:async';
import 'dart:convert';
import 'package:client/common/color.dart';
import 'package:client/model/user.dart';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:alipay_kit/alipay_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../utils/toast_util.dart';
import '../widgets/loading.dart';

class LivePay extends StatefulWidget {
  final Function getInfo;
  final Map item;
  final Function startTimer;

  LivePay({
    this.getInfo,
    this.item,
    this.startTimer,
  });
  @override
  State<LivePay> createState() => LivePayState();
}

class LivePayState extends State<LivePay> {
  int groupValue = 1;
  bool isloading = false;
  String orderId = '';
  String open = "1";
  User _user;
  static const bool _ALIPAY_USE_RSA2 = true;
  static const String _ALIPAY_PRIVATEKEY =
      'MIIEowIBAAKCAQEAjRe8Ck8eCheO3WEH0no9irgGeF23MMUtQqtbZRVkVkdp5id+jh44uk7NwXNC00Y5ALghxn0uOwNk7zBV/ZorCI7BwwDbqjJhM4hKJLzybHIYl7VwZukOAatItkP66ktUBV2xF1U9NakaJsJaXr5D4x5Wgcfzak2EupEbWJCgG1CwuaBMXNcj+JQIyntPhoMbDlSB+Gz+lZN5+8z+VPAswZwOR5h5AAEg2kpOS7F44YBOD8YnigNxsyIfi+Xsk4/P3h+oMpgWbMTfdf4cC0gkrbxgRPnkJgKvp5SiyjWSP50YNQhdoI+/D0cqdTGLt9pjxwtoX5VslARx90Hrw2OggwIDAQABAoIBAGk+yR+PgMLaa9Eq7eDNGlb9iqYCkgGpM2fF1rkCSgQp5Q6vazGrzXj8C3M//RsICMFGmLss6W1PzNy2243+kBckFdjWLQU561O7WEMrRlIqkbmouB2rvqz0DZsX/nUCl7wg9VaIWM5MQ5uh4jNGDfG+0ZyhgCtNg7J/Rzy7NRLp9DVB1aJbeoJAvt67bAEhtBnVzNVZasDPr61IiFw2ky3C1K1HQOEuFrKcwV3MG+7gu2RPRORzu9+D2C59gSIkQuFz6kAKTjqORzx3O3p7khN0vRs3/w/98QkpDHWzg1PJ/HIaHOuFKC5V5oDBMmiDsB2/zuc5jqUMnU/eenbD2dECgYEAwXL21TcCHldlC0FlrgekvPPr7sMmz7jWffLkAbhavaXKOrKpd6fc/ruextxyWLuHOs2ThpoPnxLWvLX0uoOXBTF9sHfLin9wd+iPsrPS3TJwrFFF1fnleTnIDIYwJWGPf3EqrM0EhzEAzBpfbRDdcFLz2rkvyfedO3PnhMoHWRUCgYEAurbk5aFOmj9wkY7akVpu8hgNcWTlKE4EAHBiuxYkmO1OtVg6/8AFbRLpTQryM0R6c3jFWpw5qEafh9C6Y/hAvPy328l6z6oGe+CZAcMA4CK/8ZPNuVv2KZ/slcUAJttSuuWz0ssXZ9FhuyUq2rPmtnha5L2tRgirh1gGp9bmyTcCgYAgKw/ksLsHdJz23C8eW2MHkMBA+e6wSBpS41sK9i8QrksMq70GisFzEpv6kZnqK3T3UEwh6+iBGU7gHpnNkihA0tQFzkXoh/yZ0/BhVQnRgpu9693jESUZnYQooP/Ml4aXOKhSB92i5YEub4xCxLUuAn1Od9D8ktJwmnt7V2UVaQKBgEMC2xnzD8PaWutSyuz5+PGYYlK9NGWHwnXp3/VnWBEusl3xYZNidlAURnkpIY322L/Sq3n+sc7MMftLlWnFsm5hgRc3s4UOb69MB34TX6ARuLPaKS6Ka8m6pO2Hu6s2cfWz9RsFWswe4KWLDFtbz8TTY0PPM338JJu5owHf5gp3AoGBAJ/E1FrNdEItyqsutk6HDxyQJSS+0S3V5R0RE/QjiBi39jN0nYYpxuEJXt+kIm3S17DKCgBKXEkjX8bn4C8fzUCyJ1IJk/ROyowDuKRp9RfNublSrxMBpehx83K3LLGGdmG9BxG0WxErHGYEQlXRQTXrJJb3wFQ2NkZJQWvLabFA'; // ??????/??????

  Alipay _alipay = Alipay();

  StreamSubscription<AlipayResp> _pay;

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      _user = User.fromJson(success["user"]);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
    _pay = _alipay.payResp().listen(_listenPay);
    // ?????? ????????????
    fluwx.weChatResponseEventHandler.listen((res) {
      if (res is fluwx.WeChatPaymentResponse) {
        if (res.errCode == 0) {
          widget.startTimer(orderId);
        } else {
          if (open == "1") {
            open = "2";
            ToastUtil.showToast('????????????,?????????');
          }
        }
      }
    });
  }

  void _listenPay(AlipayResp resp) {
    if (resp.resultStatus.toString() == '9000') {
      widget.startTimer(orderId);
    } else {
      ToastUtil.showToast('????????????');
    }
    print(resp.result);
  }

  // ?????????
  void toRecharge() async {
    Navigator.of(context).pop();
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.item['id']);
    map.putIfAbsent("uid", () => _user.id);
    map.putIfAbsent("pay_state", () => groupValue);
    LiveServer().toRecharge(map, (success) async {
      isloading = false;
      if (groupValue == 1) {
        orderId = success['res']['order_id'];
        fluwx.payWithWeChat(
          appId: success['res']['appid'],
          partnerId: success['res']['partnerid'],
          prepayId: success['res']['prepayid'],
          packageValue: success['res']['package'],
          nonceStr: success['res']['noncestr'],
          timeStamp: success['res']['timestamp'],
          sign: success['res']['sign'],
        );
      } else {
        orderId = success['result']['order_id'].toString();
        callAlipay(success['result']);
      }
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  callAlipay(result) async {
    Map<String, String> orderInfo = <String, String>{
      'app_id': result['pay_ret']['app_id'],
      'biz_content': result['pay_ret']['biz_content'],
      'notify_url': result['pay_ret']['notify_url'],
      'charset': result['pay_ret']['charset'],
      'method': 'alipay.trade.app.pay',
      'timestamp': result['pay_ret']['timestamp'],
      'version': '1.0',
    };
    _alipay.payOrderMap(
      orderInfo: orderInfo,
      signType: _ALIPAY_USE_RSA2 ? Alipay.SIGNTYPE_RSA2 : Alipay.SIGNTYPE_RSA,
      privateKey:
      '-----BEGIN RSA PRIVATE KEY-----\n$_ALIPAY_PRIVATEKEY\n-----END RSA PRIVATE KEY-----',
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Container(
          height: ScreenUtil.instance.setWidth(550.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /*new SizedBox(height: ScreenUtil.instance.setWidth(25.0)),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                    child: Text('?????????????????????',
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(28.0),
                            color: Colors.black,
                        )
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                    child: InkWell(
                      child: Image.asset(
                        'assets/index/gb.png',
                        width: ScreenUtil.instance.setWidth(40.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ]),
              new SizedBox(height: ScreenUtil.instance.setWidth(25.0)),
              new Container(
                height: ScreenUtil.instance.setWidth(2.0),
                color: Color(0xfffececec),
              ),
              new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                child: Text('????????????:${widget.item['rmb']}',
                    style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(28.0),
                        color: Colors.black54)),
              ),
              new SizedBox(height: ScreenUtil.instance.setWidth(35.0)),

               */
              Container(
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                child: Row(children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/index/wxzf.png',
                            width: ScreenUtil.instance.setWidth(75.0),
                          ),
                          new SizedBox(
                              width: ScreenUtil.instance.setWidth(30.0)),
                          Text(
                            '????????????',
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(28.0),
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Radio(
                          value: 1,
                          groupValue: this.groupValue,
                          activeColor: PublicColor.themeColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (v) {
                            print('v=====$v');
                            setState(() {
                              this.groupValue = v;
                            });
                          }),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                child: Row(children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Image.asset(
                          'assets/index/ali.png',
                          width: ScreenUtil.instance.setWidth(75.0),
                        ),
                        new SizedBox(width: ScreenUtil.instance.setWidth(30.0)),
                        Text('???????????????',
                            style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(28.0),
                                color: Colors.black))
                      ]),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Radio(
                          value: 2,
                          groupValue: this.groupValue,
                          activeColor: PublicColor.themeColor,
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          onChanged: (v) {
                            print('v=====$v');
                            setState(() {
                              this.groupValue = v;
                            });
                          }),
                    ),
                  ),
                ]),
              ),

              // SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
              // Container(
              //   padding: EdgeInsets.only(
              //       right: ScreenUtil().setWidth(25),
              //       left: ScreenUtil().setWidth(25)),
              //   child: Row(children: [
              //     Expanded(
              //       flex: 5,
              //       child: Container(
              //         alignment: Alignment.centerLeft,
              //         child: Row(children: [
              //           Image.asset(
              //             'assets/index/ali.png',
              //             width: ScreenUtil.instance.setWidth(75.0),
              //           ),
              //           new SizedBox(width: ScreenUtil.instance.setWidth(30.0)),
              //           Text('???????????????',
              //               style: TextStyle(
              //                   fontSize: ScreenUtil.instance.setWidth(28.0),
              //                   color: Colors.black))
              //         ]),
              //       ),
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Container(
              //         alignment: Alignment.centerRight,
              //         child: Radio(
              //             value: 2,
              //             groupValue: this.groupValue,
              //             activeColor: PublicColor.themeColor,
              //             materialTapTargetSize:
              //                 MaterialTapTargetSize.shrinkWrap,
              //             onChanged: (v) {
              //               print('v=====$v');
              //               setState(() {
              //                 this.groupValue = v;
              //               });
              //             }),
              //       ),
              //     ),
              //   ]),
              // ),
              SizedBox(height: ScreenUtil.instance.setWidth(40.0)),
              Center(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: ScreenUtil.instance.setWidth(95.0),
                    width: ScreenUtil.instance.setWidth(640.0),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: PublicColor.themeColor,
                    ),
                    child: Text(
                      '?????????',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(30.0),
                        color: PublicColor.btnTextColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    toRecharge();
                  },
                ),
              )
            ],
          ),
        ),
        isloading
            ? LoadingDialog()
            : Container(
                height: ScreenUtil().setHeight(0),
              ),
      ],
    );
  }
}
