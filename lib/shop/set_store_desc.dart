import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/fluro_convert_util.dart';
import '../service/store_service.dart';

class SetStoreDescPage extends StatefulWidget {
  final String desc;
  SetStoreDescPage({this.desc});
  @override
  _SetStoreDescPageState createState() => _SetStoreDescPageState();
}

class _SetStoreDescPageState extends State<SetStoreDescPage> {
  String jwt = '';
  String name = '';
  bool btnActive = false;
  bool isLoading = false;

  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descController.text = FluroConvertUtils.fluroCnParamsDecode(widget.desc);
  }

  void setDesc() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("store_desc", () => descController.text);
    StoreServer().setStorDesc(map, (success) {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('保存成功');
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

    Widget inputArea = new Container(
      height: ScreenUtil().setWidth(500),
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
        controller: descController,
        keyboardType: TextInputType.text,
        maxLines: 12,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "请输入店铺描述",
            //尾部添加清除按钮
            suffixIcon: (btnActive)
                ? IconButton(
                    icon: Icon(Icons.clear),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      // 清空输入框内容
                      descController.clear();
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
        title: "店铺描述",
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: new Text(
                  '店铺描述',
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
                      setDesc();
                    },
                  )
                ],
              ),
              body: new Container(
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
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ));
  }
}
