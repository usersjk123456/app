import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../widgets/loading.dart';
import '../service/live_service.dart';
import '../utils/toast_util.dart';
import '../config/fluro_convert_util.dart';

class MyChooseGoodsPage extends StatefulWidget {
  final String obj;
  MyChooseGoodsPage({this.obj});
  @override
  _MyChooseGoodsPageState createState() => _MyChooseGoodsPageState();
}

class _MyChooseGoodsPageState extends State<MyChooseGoodsPage> {
  bool isLoading = false;
  var liveType = '', goodsId = '', goodsImg = '';
  int tabIndex = 0;
  TabController tabController;
  Map addMap = {};
  List lists = [];

  int currentId = 0;
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    addMap = FluroConvertUtils.string2map(widget.obj);
    getUserGoods();
  }

  // 获取带货商品
  void getUserGoods() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => 2);
    LiveServer().getUserGoods(map, (success) async {
      var list = success['list'];
      for (var i = 0; i < list.length; i++) {
        list[i]['isSelect'] = false;
        
        if (addMap.length != 0) {
          if (addMap.containsKey(list[i]['id'].toString())) {
            list[i]['isSelect'] = true;
          }
        }
      }
      setState(() {
        isLoading = false;
        lists = list;
      });
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
    Widget bottomBtn = new Container(
      // width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(100),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            offset: new Offset(0.0, 0.1),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: new Row(children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              '最多可选50件商品',
              style: TextStyle(
                color: Color(0xff787878),
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: InkWell(
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(244),
              height: ScreenUtil().setWidth(100),
              decoration: BoxDecoration(
                color: PublicColor.themeColor,
              ),
              child: Text(
                '确认',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context, addMap);
            },
          ),
        )
      ]),
    );

    Widget contentWidget() {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
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
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: lists.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.59,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return _getGridViewItem(context, lists[index]);
                  }),
              onRefresh: () async {
                _controller.finishRefresh();
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.white,
              height: ScreenUtil().setWidth(100),
              width: ScreenUtil().setWidth(750),
              child: Column(children: <Widget>[bottomBtn]),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '选择商品',
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
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget _getGridViewItem(BuildContext context, productEntity) {
    return Container(
      alignment: Alignment.topLeft,
      child: new InkWell(
        child: Container(
          margin: EdgeInsets.only(top: 5, left: 5),
          width: ScreenUtil().setWidth(230),
          height: ScreenUtil().setWidth(388),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular((8.0)),
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
          ),
          child: new Column(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(230),
                height: ScreenUtil().setWidth(240),
                child: Image.network(
                  productEntity['thumb'],
                  height: ScreenUtil().setWidth(240),
                  width: ScreenUtil().setWidth(230),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(
                  ScreenUtil().setWidth(10),
                ),
                child: Text(
                  productEntity['name'].toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: ScreenUtil().setSp(28), height: 1.2),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10),
                ),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        '￥' + productEntity['now_price'].toString(),
                        style: TextStyle(
                          color: Color(0xffe42239),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      height: ScreenUtil().setWidth(44),
                      width: productEntity['isSelect']
                          ? ScreenUtil().setWidth(80)
                          : ScreenUtil().setWidth(44),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: productEntity['isSelect']
                            ? Color(0xff8f8f8f)
                            : Color(0xffe42239),
                        shape: BoxShape.rectangle, //可以设置角度，BoxShape.circle直接圆形
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (!addMap.containsKey(productEntity['id'].toString())) {
                            addMap[productEntity['id'].toString()] = productEntity;
                          } else {
                            addMap.remove(productEntity['id'].toString());
                          }
                          setState(() {
                            productEntity['isSelect'] =
                                !productEntity['isSelect'];
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            productEntity['isSelect'] ? '已选' : '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: productEntity['isSelect']
                                  ? ScreenUtil().setSp(26)
                                  : ScreenUtil().setSp(35),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
