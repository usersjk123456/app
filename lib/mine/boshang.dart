import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../api/api.dart';
import '../utils/serivice.dart';

class Boshang extends StatefulWidget {
  final String type;
  final String nums;
  Boshang({this.type, this.nums});
  @override
  BoshangState createState() => BoshangState();
}

class BoshangState extends State<Boshang> {
  bool isLoading = false;
  List consumptionList = [];
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    _page++;
    if (_page == 1) {
      consumptionList = [];
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => widget.type);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);
    Service().sget(Api.TEAM_LIST_URL, map, (success) async {
      setState(() {
        isLoading = false;
        if (_page == 1) {
          //赋值
          consumptionList = success['data'];
        } else {
          if (success['data'].length == 0) {
            // ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['data'].length; i++) {
              consumptionList.insert(
                  consumptionList.length, success['data'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  // 列表项
  Container listItem(String headimg, String nickname, String id, String phone) {
    return new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 20, right: 20),
      height: ScreenUtil().setWidth(131),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xffD6D6D6)),
      ),
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "$headimg",
                      fit: BoxFit.fill,
                      width: ScreenUtil().setWidth(70),
                      height: ScreenUtil().setWidth(70),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(150),
                    child: Text(
                      "$nickname",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontSize: ScreenUtil().setSp(26),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "ID: $id",
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(24),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "电话: $phone",
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
      alignment: Alignment.center,
      child: new Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          height: ScreenUtil().setWidth(111),
          width: ScreenUtil().setWidth(750),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xffd6d6d6))),
          ),
          child: new Row(
            children: <Widget>[
              Container(
                child: Text(
                  widget.type == "1"
                      ? '播商成员数量'
                      : widget.type == "2" ? "播商服务商数量" : "粉丝成员数量",
                  style: TextStyle(
                    color: Color(0xff5e5e5e),
                    fontSize: ScreenUtil().setSp(28),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  ' (${widget.nums})',
                  style: TextStyle(
                    color: Color(0xffe92f2f),
                    fontSize: ScreenUtil().setSp(28),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (consumptionList.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Text(
            '没有更多了',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold),
          ),
        ));
      } else {
        for (var item in consumptionList) {
          arr.add(listItem(
            item['headimgurl'].toString(),
            item['nickname'].toString(),
            item['id'].toString(),
            item['phone'].toString(),
          ));
        }
      }
      content = ListView(
        children: arr,
      );
      return content;
    }

    Widget withdrawList = Container(
      child: EasyRefresh(
        controller: _controller,
        header: BezierCircleHeader(
          backgroundColor: PublicColor.themeColor,
        ),
        footer: BezierBounceFooter(
          backgroundColor: PublicColor.themeColor,
        ),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: false,
        onRefresh: () async {
          _page = 0;
          getList();
        },
        onLoad: () async {
          if (_page * 10 > consumptionList.length) {
            return;
          }
          getList();
        },
        child: listArea(),
      ),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              widget.type == "1"
                  ? '播商成员'
                  : widget.type == "2"
                      ? "播商服务商"
                      : widget.type == "3" ? "粉丝成员" : "VIP成员",
              style: new TextStyle(
                color: PublicColor.headerTextColor,
              ),
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
            alignment: Alignment.center,
            child: new Column(
              children: [topArea, Expanded(flex: 1, child: withdrawList)],
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
