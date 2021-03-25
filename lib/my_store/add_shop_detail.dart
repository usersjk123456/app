import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../common/upload_to_oss.dart';
import '../my_store/up_img_build.dart';
import '../config/fluro_convert_util.dart';

class AddShopDetailsPage extends StatefulWidget {
  final String objs;
  AddShopDetailsPage({this.objs});
  @override
  _AddShopDetailsPageState createState() => _AddShopDetailsPageState();
}

class _AddShopDetailsPageState extends State<AddShopDetailsPage> {
  String jwt = '';
  String name = '';
  bool btnActive = false;
  bool isLoading = false;
  List imgList = [];
  Map shopDesc = {
    "content": '',
    "desc": '',
    "detail_img": [],
  };

  FocusNode _contentFocus = FocusNode();
  FocusNode _descFocus = FocusNode();
  TextEditingController contentController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    Map obj = FluroConvertUtils.string2map(widget.objs);
    print('obj-->>$obj');
    if (obj != null) {
      setState(() {
        shopDesc = obj;
        contentController.text = shopDesc['content'];
        descController.text = shopDesc['desc'];
        imgList = obj["detail_img"];
      });
    }
    super.initState();
  }

  void unFouce() {
    _contentFocus.unfocus();
    _descFocus.unfocus();
  }

  void changeLoading({type = 2, sent = 0, total = 0}) {
    if (type == 1) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget shopDetailsCon = Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              '请添加商品属性',
              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(20),
          ),
          new Container(
            height: ScreenUtil().setWidth(200),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(30),
            ),
            decoration: BoxDecoration(
              color: Color(0xfff8f8f8),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
              border: Border.all(color: Color(0xffeeeeee), width: 1),
            ),
            child: new TextField(
              onChanged: (value) {
                setState(() {
                  btnActive = value.length == 0 ? false : true;
                  name = value;
                });
              },
              focusNode: _contentFocus,
              controller: contentController,
              keyboardType: TextInputType.text,
              maxLines: 12,
              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "请输入对产品的属性描述",
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
          )
        ],
      ),
    );
    Widget shopRemarkets = Container(
      height: ScreenUtil().setWidth(100),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
        border: Border.all(color: Color(0xffeeeeee), width: 1),
      ),
      child: Row(
        children: [
          Text(
            '备注',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(30),
          ),
          Expanded(
            flex: 5,
            child: TextField(
              focusNode: _descFocus,
              controller: descController,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入内容",
              ),
            ),
          )
        ],
      ),
    );

    Widget upImg = Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              '添加图片信息',
              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(20),
          ),
          new Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: BuildImg(
                    imgList: imgList,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setWidth(150),
                      child: Image.asset(
                        'assets/shop/up_img.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () async {
                      unFouce();
                      Map obj = await openGallery("image", changeLoading);
                      if (obj == null) {
                        changeLoading(type: 2, sent: 0, total: 0);
                        return;
                      }
                      if (obj['errcode'] == 0) {
                        imgList.insert(imgList.length, obj['url']);
                      } else {
                        ToastUtil.showToast(obj['msg']);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(10),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '请上传正方形图片',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      color: PublicColor.grewNoticeColor,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    Widget bottomBtn = Container(
      margin: EdgeInsets.only(top: 20, bottom: 30),
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setWidth(95),
        width: ScreenUtil().setWidth(640),
        decoration: BoxDecoration(
            color: PublicColor.themeColor,
            borderRadius: new BorderRadius.circular((8.0))),
        child: new FlatButton(
          disabledColor: PublicColor.grewNoticeColor,
          onPressed: () {
            if (contentController.text == '') {
              ToastUtil.showToast('请��入商品详情');
              return;
            }
            if (descController.text == '') {
              ToastUtil.showToast('请输入备注');
              return;
            }
            if (imgList.length == 0) {
              ToastUtil.showToast('请上传图片信息');
              return;
            }
            shopDesc['content'] = contentController.text;
            shopDesc['desc'] = descController.text;
            shopDesc['detail_img'] = imgList;
            Navigator.pop(context, shopDesc);
          },
          child: new Text(
            '完成',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );

    return MaterialApp(
        title: "店铺描述",
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: <Widget>[
            Scaffold(
              resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
              appBar: AppBar(
                elevation: 0,
                title: new Text(
                  '添加商品详情',
                  style: new TextStyle(
                    color: PublicColor.headerTextColor,
                  ),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: PublicColor.linearHeader,
                  ),
                ),
                centerTitle: true,
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
              body: new Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                color: PublicColor.bodyColor,
                child: new ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                      decoration: BoxDecoration(
                        color: PublicColor.whiteColor,
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(15)),
                        border: Border.all(color: Color(0xffe5e5e5), width: 1),
                      ),
                      child: Column(
                        children: <Widget>[
                          shopDetailsCon,
                          SizedBox(height: ScreenUtil().setWidth(30)),
                          shopRemarkets,
                          SizedBox(height: ScreenUtil().setWidth(30)),
                          upImg
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(80)),
                    bottomBtn,
                  ],
                ),
              ),
            ),
            isLoading ? LoadingDialog() : Container()
          ],
        ));
  }
}
