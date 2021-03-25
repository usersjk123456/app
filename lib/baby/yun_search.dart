import 'package:client/config/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/cached_image.dart';
import '../widgets/search_card.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../common/color.dart';
import '../service/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/user_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class YunSearch extends StatefulWidget {
  @override
  YunSearchState createState() => YunSearchState();
}

class YunSearchState extends State<YunSearch>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  bool issearch = false, isLive = false, isStore = false;
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  EasyRefreshController _controller = EasyRefreshController();
  final FocusNode _focus = new FocusNode();

  List listView = [];
  List resou = [];
  List historyList = [];
  String historyString = '';
  String sateId = '';
  String jwt = '';
  List lishisousuo = [];
  String hintText = '点击选择搜索日期';
  @override
  void initState() {
    super.initState();
    _controller.finishRefresh();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          isLive = success['is_live'].toString() == "0" ? false : true;
          isStore = success['is_store'].toString() == "0" ? false : true;
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void keySearch(hintText) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("stime", () => hintText);
    map.putIfAbsent("etime", () => hintText);
    HomeServer().yunsearch(map, (success) async {
      setState(() {
        listView = success['list'];
        if (listView.length == 0) {
          ToastUtil.showToast('暂无数据');
        }
      });
      bool isCz = false;
    
      print('isCA---->>>$isCz');
      if (!isCz) {
        if (historyString == '') {
          historyString += hintText;
        } else {
          historyString += ',' + hintText;
        }
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('history', historyString);
      }
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focus.hasFocus) {
      if (_keywordTextEditingController.text != '') {
        setState(() {
          issearch = true;
        });
      } else {
        setState(() {
          issearch = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    _focus.addListener(_onFocusChange);
    return Scaffold(
        appBar: new AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
        
          title: InkWell(
            onTap: () {
              DatePicker.showDatePicker(context,
                  // 是否展示顶部操作按钮
                  showTitleActions: true,
                  // 最小时间
                  minTime: DateTime(2018, 3, 5),
                  // 最大时间
                  maxTime: DateTime(2999, 6, 7),
                  // change事件
                  onChanged: (date) {
                setState(() {
                  hintText = date.toString().split(' ')[0];
                });
              },
                  // 确定事件
                  onConfirm: (date) {
                print('confirm $date');
                setState(() {
                  hintText = date.toString().split(' ')[0];
                });
              },
                  // 当前时间
                  currentTime: DateTime.now(),
                  // 语言
                  locale: LocaleType.zh);
            },
            child: Container(
              width: ScreenUtil().setWidth(600),
              height: ScreenUtil().setWidth(64),
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Color(0xffF5F5F5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: Text(
                hintText,
                style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: ScreenUtil().setSp(26),
                ),
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: PublicColor.linearHeader,
            ),
          ),
          actions: <Widget>[
            InkWell(
              child: Container(
                  padding: const EdgeInsets.only(right: 14.0),
                  alignment: Alignment.center,
                  child: Text(
                    '搜索',
                    style: TextStyle(
                      color: Color(0xff222222),
                    ),
                  )),
              onTap: () {
                if (hintText =='点击选择搜索日期') {
                  ToastUtil.showToast('请选择搜索日期');
                  return;
                } else {
                  keySearch(hintText);
                }

                setState(() {
                  issearch = true;
                });
              },
            ),
            InkWell(
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: Color(0xff222222),
                    ),
                  )),
              onTap: () {
                print('取消');
                Navigator.pop(context);
              },
            )
            // MaterialButton(
            //     child: Text('取消'),
            //     onPressed: () {
            //       print('取消');
            //       Navigator.pop(context);
            //     }),
          ],
        ),
        body: searchPage2());
  }

  Widget searchPage2() {
    return EasyRefresh(
      controller: _controller,
      header: BezierCircleHeader(
        backgroundColor: PublicColor.themeColor,
      ),
      footer: BezierBounceFooter(
        backgroundColor: PublicColor.themeColor,
      ),
      enableControlFinishRefresh: true,
      enableControlFinishLoad: false,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount:3,
             crossAxisSpacing: 3,
             mainAxisSpacing: 3,
             childAspectRatio: 1
           ),
          itemCount: listView.length,
          itemBuilder: (BuildContext context, int index) {
            return  InkWell(
                  onTap: () {
                 
                    String oid = (listView[index]['id']).toString();

                    NavigatorUtils.toXiangQing(context, oid, '0', '0');
                  },
                child: CachedImageView(
                        ScreenUtil.instance.setWidth(220.0),
                        ScreenUtil.instance.setWidth(220.0),
                        listView[index]['imgurl'],
                        null,
                        BorderRadius.all(Radius.circular(0))),
                );
          }),
      // onRefresh: () async {

      //   _controller.finishRefresh();
      // },
      // onLoad: () async {
      //   _controller.finishRefresh();
      // },
    );
  }
}
