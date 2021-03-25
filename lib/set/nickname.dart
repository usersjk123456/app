import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/user_service.dart';

class NicknamePage extends StatefulWidget {
  @override
  NicknamePageState createState() => NicknamePageState();
}

class NicknamePageState extends State<NicknamePage> {
  String jwt = '';
  String name = '';
  bool btnActive = false;
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void changeNick() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("nickname", () => name);
    UserServer().setNickname(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('修改成功');
        // await Future.delayed(Duration(seconds: 1), () {
        //   Navigator.of(context).pop();
        // });
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

    Widget inputArea = new Container(
      height: ScreenUtil().setWidth(100),
      width: ScreenUtil().setWidth(700),
      padding: const EdgeInsets.only(left: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xffe5e5e5), width: 1),
      ),
      child: new TextField(
        onChanged: (value) {
          setState(() {
            btnActive = value.length == 0 ? false : true;
            name = value;
          });
        },
        controller: nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "请输入昵称",
            //尾部添加清除按钮
            suffixIcon: (btnActive)
                ? IconButton(
                    icon: Icon(Icons.clear),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      // 清空输入框内容
                      nameController.clear();
                      setState(() {
                        name = '';
                        btnActive = false;
                      });
                    },
                  )
                : null),
      ),
    );

    return MaterialApp(
        title: "昵称",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '昵称',
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
              InkWell(
                child: Container(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Text(
                      '保存',
                      style: new TextStyle(
                        color: PublicColor.textColor,
                        fontSize: ScreenUtil().setSp(28),
                        height: 2.7,
                      ),
                    )),
                onTap: () {
                  print('保存');
                  changeNick();
                },
              )
            ],
          ),
          body: isLoading
              ? LoadingDialog()
              : new Container(
                  alignment: Alignment.center,
                  child: new Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new SizedBox(
                        height: ScreenUtil().setWidth(20),
                      ),
                      inputArea
                    ],
                  ),
                ),
        ));
  }
}
