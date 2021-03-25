import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/silde_button.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../config/Navigator_util.dart';
import '../widgets/dialog.dart';
import '../service/user_service.dart';
import '../widgets/cached_image.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
class BuyClassPage extends StatefulWidget {
  @override
  BuyClassPageState createState() => BuyClassPageState();
}

class BuyClassPageState extends State<BuyClassPage> {
  bool isLoading = false;
  String jwt = '', addressId = "";
  List wdlist = [];
   int _page = 0;
     EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
    }
  }

  void getList() async {
    // setState(() {
    //   isLoading = true;
    // });
        _page++;
    if (_page == 1) {
      wdlist = [];
    }
    Map<String, dynamic> map = Map();
           map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    UserServer().getbuyList(map, (success) async {
  
       setState(() {
        if (_page == 1) {
          //赋值
          wdlist = success['list'];
        } else {
          if (success['list'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              wdlist.insert(wdlist.length, success['list'][i]);
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

  InkWell buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        color: color,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }


  Widget getSlides() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (wdlist.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,

        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in wdlist) {
        arr.add(
          Container(
              height: ScreenUtil().setHeight(226),
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(20),
            ),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(24),
                left: ScreenUtil().setWidth(26),
                bottom: ScreenUtil().setWidth(24)),
            child: InkWell(
              onTap: () {
                print(item);
                String oid = (item['id']).toString();
                NavigatorUtils.gobabyXiangqing(context,oid);
              },
              //设置圆角
              child: Row(children: [
                Container(
                  child: CachedImageView(
                    ScreenUtil.instance.setWidth(219.0),
                    ScreenUtil.instance.setWidth(219.0),
                    item['img'],
                    null,
                    BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(29),
                ),
                Container(
                
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        item['name'],
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil().setSp(32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                          width: ScreenUtil().setWidth(400),
                          child: Text(
                            item['text'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff666666),
                              fontSize: ScreenUtil().setSp(26),
                            ),
                          )),
                       Container(
                      width: ScreenUtil().setWidth(373),
                      child: Text(
                        item['teacher']['name'],
                        style: TextStyle(
                          color: Color(0xffA3C265),
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      )),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      }
    }
    content = new ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: arr,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    var container = new Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                child: SingleChildScrollView(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getSlides(),
                ],
              ),
                ),
            );
    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: new Text(
                '已购课程',
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
            body: container,
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
