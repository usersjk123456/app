import 'package:client/common/color.dart';
import 'package:client/common/upload_to_oss.dart';
import 'package:client/my_store/up_img_build.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentItem extends StatefulWidget {
  final Map item;
  final int index;
  final Function getContent;
  CommentItem({this.item, this.index, this.getContent});

  @override
  CommentItemState createState() => CommentItemState();
}

class CommentItemState extends State<CommentItem> {
  FocusNode contentFocus = FocusNode();
  bool isLoading = false;

  void unFouce() {
    contentFocus.unfocus(); // input失去焦点
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

    Widget goods(item) {
      return Container(
        padding: EdgeInsets.all(
          ScreenUtil().setWidth(20),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: PublicColor.lineColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              item['img'],
              width: ScreenUtil().setWidth(114),
              height: ScreenUtil().setWidth(114),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(22),
            ),
            // Text(
            //   item['goods_name'],
            //   style: TextStyle(
            //     fontSize: ScreenUtil().setWidth(28),
            //     color: PublicColor.textColor,
            //   ),
            // ),
            Expanded(
                child: Container(
              child: Text(
                '${item['goods_name']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setWidth(28),
                  color: PublicColor.textColor,
                ),
              ),
            )),
          ],
        ),
      );
    }

    Widget content = Container(
      height: ScreenUtil().setWidth(200),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(20),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ScreenUtil().setWidth(15),
        ),
      ),
      child: new TextField(
        onChanged: (value) {
          widget.getContent(value, widget.index);
        },
        focusNode: contentFocus,
        keyboardType: TextInputType.text,
        maxLines: 12,
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "宝贝能满足您的期待吗？说说你的使用心得，分享给想买的他们吧",
        ),
      ),
    );

    Widget upImg(item) {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: BuildImg(
                      imgList: item['imgList'],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      child: Container(
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setWidth(150),
                        child: Image.asset(
                          'assets/mine/addimg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () async {
                        if (item['imgList'].length >= 5) {
                          ToastUtil.showToast('最多只能上传5张图片');
                          return;
                        }
                        // childKey.currentState.unFouce();
                        unFouce();
                        Map obj = await openGallery("image", changeLoading);
                        if (obj == null) {
                          changeLoading(type: 2, sent: 0, total: 0);
                          return;
                        }
                        if (obj['errcode'] == 0) {
                          item['imgList']
                              .insert(item['imgList'].length, obj['url']);
                        } else {
                          ToastUtil.showToast(obj['msg']);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(10),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(16)),
      child: Column(
        children: <Widget>[
          goods(widget.item),
          SizedBox(
            height: ScreenUtil().setWidth(14),
          ),
          Container(
            padding: EdgeInsets.all(
              ScreenUtil().setWidth(20),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: PublicColor.lineColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(20),
              ),
            ),
            child: Column(
              children: <Widget>[content, upImg(widget.item)],
            ),
          )
        ],
      ),
    );
  }
}
