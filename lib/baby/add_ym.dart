import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/dialog.dart';
import '../service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class AddYmPage extends StatefulWidget {
  @override
  AddYmPageState createState() => AddYmPageState();
}

class AddYmPageState extends State<AddYmPage> {
  bool isLoading = false;
  String jwt = '', id = '', addressId = "";
  List addressList = [], wdlist = [];
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  final FocusNode _focus = new FocusNode();
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();

    getLocal();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    getList();
  }

  void _onFocusChange() {}

  void getList() async {
    _page++;
    if (_page == 1) {
      wdlist = [];
    }

    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bid", () => id = prefs.getString('id'));
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);

    UserServer().getYmList(map, (success) async {
      setState(() {
        if (_page == 1) {
          //赋值
          wdlist = success['del'];
        } else {
          if (success['del'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['del'].length; i++) {
              wdlist.insert(wdlist.length, success['del'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  void deleteAddrss() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => addressId);
    UserServer().delAddress(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('删除成功');
      getList();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget deleDjango(context) {
    return MyDialog(
      width: ScreenUtil.instance.setWidth(600.0),
      height: ScreenUtil.instance.setWidth(300.0),
      queding: () {
        deleteAddrss();
        Navigator.of(context).pop();
      },
      quxiao: () {
        Navigator.of(context).pop();
      },
      title: '温馨提示',
      message: '确定删除该地址吗？',
    );
  }

  Widget getSlides() {
    List<Widget> arr = <Widget>[];
    Widget content;
    for (var item in wdlist) {
      arr.add(Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(29)),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xffE5E5E5),
            ),
          ),
        ),
        child: InkWell(
          child: Container(
            height: ScreenUtil().setWidth(102),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item['title'],
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
                Icon(
                  Icons.navigate_next,
                  color: Color(0xffC0C0C0),
                ),
              ],
            ),
          ),
          onTap: () {
            String oid = item['id'].toString();
            String title = item['title'].toString();
            String desc = item['desc'].toString();
            _page = 0;
            wdlist = [];
            NavigatorUtils.goYmInfo(context, oid, title, desc)
                .then((res) => getLocal());
          },
        ),
      ));
    }

    content = new ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: arr,
    );
    return content;
  }

  // Widget  = Container(
  //   width: ScreenUtil().setWidth(700),
  //   height: ScreenUtil().setWidth(102),
  //   decoration: BoxDecoration(
  //       color: Color(0xffffffff),
  //    )),
  // );

  @override
  Widget build(BuildContext context) {
    _focus.addListener(_onFocusChange);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: new Text(
                  '添加疫苗',
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
              body: Container(
                  width: ScreenUtil().setWidth(700),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(25),
                    right: ScreenUtil().setWidth(25),
                    top: ScreenUtil().setWidth(20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 5.0), //阴影xy轴偏移量
                          blurRadius: 7.0, //阴影模糊程度
                          spreadRadius: 1.0 //阴影扩散程度
                          ),
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // padding: EdgeInsets.all(ScreenUtil().setWidth(1)),
                  child: getSlides())),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
