import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/upload_to_oss.dart';

class AddShopFormateBuildPage extends StatefulWidget {
  final Map formate;
  final String formateKey;
  final int index;
  final Function changeLoading;
  final Function upImgLoad;
  AddShopFormateBuildPage({
    Key key,
    this.formate,
    this.formateKey,
    this.index,
    this.upImgLoad,
    this.changeLoading,
  }) : super(key: key);
  @override
  _AddShopFormateBuildPageState createState() =>
      _AddShopFormateBuildPageState();
}

class _AddShopFormateBuildPageState extends State<AddShopFormateBuildPage> {
  bool isLoading = false;
  FocusNode _priceFocus = FocusNode();
  FocusNode _stockFocus = FocusNode();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController priceController1 = TextEditingController();
  TextEditingController stockController1 = TextEditingController();

  @override
  void initState() {
    if (widget.formate[widget.formateKey]['price'] != null) {
      priceController.text = widget.formate[widget.formateKey]['price'];
      stockController.text = widget.formate[widget.formateKey]['stock'];
    }
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    setState(() {
      if (widget.formate[widget.formateKey]['price'] != '') {
        priceController.text = widget.formate[widget.formateKey]['price'];
      } else {
        priceController.text = "";
      }
      if (widget.formate[widget.formateKey]['stock'] != '') {
        stockController.text = widget.formate[widget.formateKey]['stock'];
      } else {
        stockController.text = "";
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffe4e4e4), width: 1)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                '${widget.formateKey}',
                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              ),
            ),
            SizedBox(height: ScreenUtil().setWidth(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(250),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xfff8f8f8),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(15)),
                    border: Border.all(color: Color(0xffeeeeee), width: 1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '规格价',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Color(0xffa7a7a7),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          onChanged: (value) {
                            widget.formate[widget.formateKey]['price'] = value;
                          },
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocus,
                          controller:
                              widget.formate[widget.formateKey]['price'] == null
                                  ? priceController1
                                  : priceController,
                          style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "0",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(250),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xfff8f8f8),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(15)),
                    border: Border.all(color: Color(0xffeeeeee), width: 1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '库存',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Color(0xffa7a7a7),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          onChanged: (value) {
                            widget.formate[widget.formateKey]['stock'] =
                                value.toString();
                          },
                          keyboardType: TextInputType.number,
                          focusNode: _stockFocus,
                          controller:
                              widget.formate[widget.formateKey]['stock'] == null
                                  ? stockController1
                                  : stockController,
                          style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "0",
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                '上传此规格图片信息',
                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(10),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: InkWell(
                child: Container(
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setWidth(150),
                  child: widget.formate[widget.formateKey]['img'] == null
                      ? Image.asset(
                          'assets/shop/up_img.png',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.formate[widget.formateKey]['img'],
                          fit: BoxFit.cover,
                        ),
                ),
                onTap: () async {
                  _priceFocus.unfocus(); // 失去焦点
                  _stockFocus.unfocus(); // 失去焦点
                  Map obj = await openGallery("image", widget.changeLoading);
                  if (obj == null) {
                    widget.changeLoading(type: 2, sent: 0, total: 0);
                    return;
                  }
                  widget.upImgLoad(obj, widget.formateKey);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
