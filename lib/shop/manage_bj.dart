import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../service/store_service.dart';
import './shop_up_img_build.dart';

class ManageBjPage extends StatefulWidget {
  @override
  ManageBjPageState createState() => ManageBjPageState();
}

class ManageBjPageState extends State<ManageBjPage> {
  bool isLoading = false;
  List shopList = [];
  int type = 1;
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    StoreServer().getStoreMassage(map, (success) {
      setState(() {
        isLoading = false;
        shopList = success['list'];
      });
    }, (onFail) {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void delShop(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => id);
    StoreServer().storeDelUpGoods(map, (success) {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('删除成功');
      getList();
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

    return new DefaultTabController(
      length: 2,
      child: Stack(
        children: <Widget>[
          new Scaffold(
            appBar: new AppBar(
                elevation: 0,
                centerTitle: true,
                title: new Text(
                  '商品管理',
                  style: TextStyle(
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
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                        onTap: (value) {
                          type = value + 1;
                          getList();
                        },
                        indicatorWeight: 4.0,
                        indicatorColor: PublicColor.themeColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: PublicColor.themeColor,
                        unselectedLabelColor: PublicColor.textColor,
                        tabs: <Widget>[
                          new Tab(
                            child: Text(
                              '店铺精选',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '品牌专柜',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ]),
                  ),
                )),
            body: new Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
              child: ListView(
                children: <Widget>[
                  BuildImg(
                    shopList: shopList,
                    delShop: delShop,
                  )
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
