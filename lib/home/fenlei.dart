import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/search_card.dart';
import '../widgets/cached_image.dart';
import '../widgets/loading.dart';
import '../utils/toast_util.dart';
import '../config/Navigator_util.dart';
import '../service/home_service.dart';
import '../common/color.dart';

class FenLei extends StatefulWidget {
  @override
  FenLeiState createState() => FenLeiState();
}

class FenLeiState extends State<FenLei> {
  bool isloading = false;
  final FocusNode _focus = new FocusNode();
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  int _selectIndex = 0;
  List tabTitles = [];
  List listView = [];
  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getList() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    HomeServer().getFenleiList(map, (success) async {
      setState(() {
        tabTitles = success['list'];
        if (success['list'].length != 0) {
          listApi(success['list'][0]['id']);
        }
      });
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void listApi(itemId) async {
    listView = [];
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => itemId);
    HomeServer().getFenleiList(map, (success) async {
      setState(() {
        isloading = false;
        listView = success['children'];
      });
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        leading: new IconButton(
          icon: Icon(
            Icons.navigate_before,
            color: PublicColor.headerTextColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SearchCardWidget(
          elevation: 0,
          focusNode: _focus,
          textEditingController: _keywordTextEditingController,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            NavigatorUtils.goSearchPage(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: PublicColor.linearHeader,
          ),
        ),
      ),
      body: isloading
          ? LoadingDialog()
          : Container(
              child: Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: Container(
                      color: Color(0xffff5f5f5),
                      child: ListView.builder(
                          itemCount: tabTitles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _getFirstLevelView(tabTitles[index], index);
                          }),
                    ),
                  ),
                  new Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      child: new Column(children: [
                        Container(
                          width: double.infinity,
                          height: ScreenUtil.instance.setWidth(100),
                          decoration: new ShapeDecoration(
                            shape: Border(
                              bottom: BorderSide(
                                  color: Color(0xfffececec), width: 1),
                            ), // 边色与边宽度
                          ),
                          child: new Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil.instance.setWidth(35),
                                        ScreenUtil.instance.setWidth(20),
                                        0,
                                        0),
                                    child: Text(
                                      tabTitles[_selectIndex]['name'],
                                      style: TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setWidth(28),
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    if (listView.length != 0) {
                                      var oid = tabTitles[_selectIndex]['id'];
                                      NavigatorUtils.toMoreList(context, oid);
                                    }
                                  },
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenUtil.instance.setWidth(35),
                                          ScreenUtil.instance.setWidth(20),
                                          ScreenUtil.instance.setWidth(35),
                                          0),
                                      child: Text(
                                        '查看更多>',
                                        style: TextStyle(
                                          fontSize:
                                              ScreenUtil.instance.setWidth(28),
                                          color: Colors.black45,
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        listView.length > 0
                            ? Container(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil.instance.setWidth(35.0),
                                    right: ScreenUtil.instance.setWidth(35.0)),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: listView.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 0.75,
                                            crossAxisSpacing: 3,
                                            mainAxisSpacing: 3),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _getGridViewItem(
                                          context, listView[index]);
                                    }),
                              )
                            : Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(250)),
                                child: Image.asset(
                                  'assets/mine/zwsj.png',
                                  width: ScreenUtil().setWidth(400),
                                ),
                              ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _getGridViewItem(BuildContext context, productEntity) {
    return Container(
      child: InkWell(
        onTap: () {
          String oid = productEntity['id'].toString();
          String name = productEntity['name'].toString();
          NavigatorUtils.toShopListPage(context, oid, name, "2");
        },
        child: Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ), //设置圆角
          child: Stack(
            children: [
              Container(
                child: CachedImageView(
                  double.infinity,
                  ScreenUtil.instance.setWidth(157.0),
                  productEntity['img'],
                  null,
                  BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil.instance.setWidth(15),
                    ScreenUtil.instance.setWidth(15),
                    ScreenUtil.instance.setWidth(15),
                    ScreenUtil.instance.setWidth(12)),
                child: Text(
                  productEntity['name'],
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil.instance.setWidth(25.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemClick(int index, String id) {
    setState(() {
      _selectIndex = index;
    });
    listApi(id);
  }

  Widget _getFirstLevelView(item, int index) {
    return GestureDetector(
      onTap: () => _itemClick(index, item['id']),
      child: Container(
        width: double.infinity,
        height: ScreenUtil.instance.setWidth(100),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil.instance.setWidth(100),
              alignment: Alignment.center,
              decoration: new ShapeDecoration(
                shape: Border(
                  left: BorderSide(
                      color: index == _selectIndex
                          ? PublicColor.themeColor
                          : Color(0xffff5f5f5),
                      width: 2),
                  bottom: BorderSide(color: Color(0xfffececec), width: 1),
                ), // 边色与边宽度
                color:
                    index == _selectIndex ? Colors.white : Color(0xffff5f5f5),
              ),
              child: Text(item['name'],
                  style: index == _selectIndex
                      ? TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(26),
                          color: PublicColor.themeColor,
                          fontWeight: FontWeight.w700)
                      : TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(26),
                          color: Colors.black54)),
            ),
          ],
        ),
      ),
    );
  }
}
