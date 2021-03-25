import '../widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../service/user_service.dart';
import '../widgets/loading.dart';

class TixianBankPage extends StatefulWidget {
  @override
  TixianBankPageState createState() => TixianBankPageState();
}

class TixianBankPageState extends State<TixianBankPage> {
  bool isLoading = false;
  final namecontroller = TextEditingController();
  final accountcontroller = TextEditingController();
  final mingchengcontroller = TextEditingController();
  final khcontroller = TextEditingController();
  final numscontrlooer = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void toCash() async {
    if (namecontroller.text == '') {
      ToastUtil.showToast('请输入姓名');
      return;
    }
    if (accountcontroller.text == '') {
      ToastUtil.showToast('请输入银行卡账号');
      return;
    }
    if (mingchengcontroller.text == '') {
      ToastUtil.showToast('请输入银行名称');
      return;
    }
    if (khcontroller.text == '') {
      ToastUtil.showToast('请输入开户行名称');
      return;
    }
    if (numscontrlooer.text == '') {
      ToastUtil.showToast('请输入提现数量');
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 2);
    map.putIfAbsent("name", () => namecontroller.text);
    map.putIfAbsent("bank_account", () => accountcontroller.text);
    map.putIfAbsent("bank_name", () => mingchengcontroller.text);
    map.putIfAbsent("open_bank", () => khcontroller.text);
    map.putIfAbsent("amount", () => numscontrlooer.text);
    UserServer().toCash(map, (success) async {
      setState(() {
        isLoading = false;
        namecontroller.text = '';
        accountcontroller.text = '';
        numscontrlooer.text = '';
        mingchengcontroller.text = '';
        khcontroller.text = '';
      });
      ToastUtil.showToast('提现成功');
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

    Widget picArea = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Image.asset(
          "assets/shop/yhk1.png",
          height: ScreenUtil().setWidth(106),
          width: ScreenUtil().setWidth(400),
       
        ),
      ),
    );

    Widget inputArea = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 60),
        height: ScreenUtil().setWidth(560),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setWidth(111),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new TextField(
              controller: namecontroller,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                  hintText: '请输入真实姓名', border: InputBorder.none),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setWidth(111),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new TextField(
              controller: accountcontroller,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  hintText: '请输入银行卡号', border: InputBorder.none),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setWidth(111),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new TextField(
              controller: mingchengcontroller,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                  hintText: '请输入银行名称', border: InputBorder.none),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setWidth(111),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new TextField(
              controller: khcontroller,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                  hintText: '请输入开户行名称', border: InputBorder.none),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setWidth(111),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.only(left: 20),
            child: new TextField(
              controller: numscontrlooer,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  hintText: '请输入提现数量', border: InputBorder.none),
            ),
          ),
        ]),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: new Text(
                  '请输入银行卡号',
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
                child: new ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    picArea,
                    inputArea,
                    BigButton(
                      name: '提现',
                      tapFun: toCash,
                    )
                  ],
                ),
              ),
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ));
  }
}
