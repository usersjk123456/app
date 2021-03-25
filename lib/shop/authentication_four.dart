import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/fluro_convert_util.dart';
import '../utils/toast_util.dart';
import '../service/store_service.dart';
import '../widgets/loading.dart';

class AuthenticationFourPage extends StatefulWidget {
  final String objs;
  AuthenticationFourPage({this.objs});
  @override
  AuthenticationFourPageState createState() => AuthenticationFourPageState();
}

class AuthenticationFourPageState extends State<AuthenticationFourPage> {
  Map obj = {};
  String type = '';
  bool isLoading = false;
  var _selectType;
  List typeList = [];
  TextEditingController shopnamecontroller = TextEditingController();
  @override
  void initState() {
    obj = FluroConvertUtils.string2map(widget.objs);
    super.initState();
    getType();
  }

  void getType() {
    Map<String, dynamic> map = Map();
    StoreServer().getStoreType(map, (success) async {
      setState(() {
        typeList = success['res'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void apply() {
    setState(() {
      isLoading = true;
    });
    StoreServer().applyStore(obj, (success) async {
      setState(() {
        isLoading = false;
      });
      NavigatorUtils.goAuthenticationWaitingPage(context);
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
    List<DropdownMenuItem> generateItemList() {
      final List<DropdownMenuItem> arr = List();
      if (typeList.length != 0) {
        for (var item in typeList) {
          arr.add(
              DropdownMenuItem(value: item['id'], child: Text(item['name'])));
        }
      }
      return arr;
    }

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
                "assets/shop/four.png",
                height: ScreenUtil().setWidth(190),
                width: ScreenUtil().setWidth(715),
              ),
            ),
          ),
        ],
      ),
    );
    Widget inforArea = new Container(
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
        child: new Column(children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '店铺名称',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ))),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: new TextField(
                      controller: shopnamecontroller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      decoration: new InputDecoration(
                        hintText: '请输入',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xffa1a1a1)),
                      ),
                    ),
                  ))
            ]),
          ),
          Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(102),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '分类',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ))),
              Expanded(
                flex: 3,
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    items: generateItemList(),
                    hint: new Text('请选择'),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _selectType = value;
                      });
                    },
//              isExpanded: true,
                    value: _selectType,
                    elevation: 24, //设置阴影的高度
                    style: new TextStyle(
                      //设置文本框里面文字的样式
                      color: Color(0xff4a4a4a),
                      fontSize: ScreenUtil().setSp(28),
                    ),
//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                    iconSize: 40.0,
                  ),
                ),
              )
            ]),
          ),
        ]),
      ),
    );

    Widget btnArea = new Container(
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setWidth(86),
        width: ScreenUtil().setWidth(640),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            gradient: PublicColor.linearBtn,
            borderRadius: new BorderRadius.circular((8.0))),
        child: new FlatButton(
          disabledColor: PublicColor.themeColor,
          onPressed: () {
            if (shopnamecontroller.text == '') {
              ToastUtil.showToast('请输入店铺名称');
              return;
            }
            if (_selectType == null) {
              ToastUtil.showToast('请选择店铺分类');
              return;
            }
            obj['store_name'] = shopnamecontroller.text;
            obj['type_id'] = _selectType;
            apply();
          },
          child: new Text(
            '提交申请',
            style: TextStyle(
                color: PublicColor.btnTextColor,
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
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
                  inforArea,
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
