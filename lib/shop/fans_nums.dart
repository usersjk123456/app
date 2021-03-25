import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/store_service.dart';
import '../utils/toast_util.dart';

class FansNumsPage extends StatefulWidget {
  @override
  FansNumsPageState createState() => FansNumsPageState();
}

class FansNumsPageState extends State<FansNumsPage> {
  List shopList = [];
  @override
  void initState() {
    super.initState();
    getList(1);
  }

  void getList(type) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    StoreServer().getFansList(map, (success) {
      setState(() {
        shopList = success['data'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    //全部
    Widget allBuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (shopList.length == 0) {
        content = Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(200),
            bottom: ScreenUtil().setWidth(200),
          ),
          child: Image.asset(
            'assets/mine/zwsj.png',
            width: ScreenUtil().setWidth(400),
          ),
        );
      } else {
        for (var item in shopList) {
          arr.add(InkWell(
            child: new Container(
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(164),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Container(
                        padding: EdgeInsets.only(left: 17, right: 20),
                        child: ClipOval(
                          child: Image.network(
                            item['headimgurl'],
                            height: ScreenUtil().setWidth(120),
                            width: ScreenUtil().setWidth(120),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        child: new Column(children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 20),
                          child: RichText(
                              text: TextSpan(
                                  text: '手机号码:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          ScreenUtil.instance.setWidth(28)),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: '${item['phone']}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            ScreenUtil.instance.setWidth(28))),
                              ]))),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text('邀约ID: ${item['id']}',
                              style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: ScreenUtil.instance.setWidth(28))))
                    ])),
                  ),
                  Expanded(
                    flex: 2,
                    child: Stack(children: <Widget>[
                      Positioned(
                        top: 27,
                        right: -5,
                        child: Image.asset(
                          item['is_live'] < 1
                              ? "assets/shop/muvip.png"
                              : "assets/shop/muzb.png",
                          height: ScreenUtil().setWidth(77),
                          width: ScreenUtil().setWidth(166),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: ScreenUtil().setWidth(66),
                        right: ScreenUtil().setWidth(16),
                        child: Text(
                          item['is_live'] < 1 ? 'VIP' : '主播',
                          style: TextStyle(
                            color: item['is_live'] < 1
                                ? Color(0xff493900)
                                : Colors.white,
                            fontSize: ScreenUtil().setSp(26),
                          ),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            ),
            onTap: () {
              print('vip');
            },
          ));
        }
        content = Column(
          children: arr,
        );
      }

      return content;
    }

    Widget all = new Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: ScreenUtil().setWidth(700),
          // height: ScreenUtil().setWidth(344),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
          ),
          child: allBuild(),
        ),
      ),
    );
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '粉丝数',
              style: TextStyle(color: PublicColor.headerTextColor),
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Material(
                color: Colors.white,
                child: TabBar(
                    indicatorWeight: 4.0,
                    // indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: PublicColor.themeColor,
                    unselectedLabelColor: Color(0xff5e5e5e),
                    labelColor: PublicColor.themeColor,
                    onTap: (value) {
                      getList(value + 1);
                    },
                    tabs: <Widget>[
                      new Tab(
                        child: Text(
                          '全部',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      new Tab(
                        child: Text(
                          '主播',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      new Tab(
                        child: Text(
                          'VIP',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),
              ),
            )),
        body: all,
      ),
    );
  }
}
