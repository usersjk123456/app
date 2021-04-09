import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/common/color.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Pinglun extends StatefulWidget {
  final item;
  final type;
  final clickZan;
  final like;
  final is_like;
  final clickDel;
  Pinglun(
      {this.item,
      this.type,
      this.clickZan,
      this.like,
      this.clickDel,
      this.is_like});
  @override
  _PinglunState createState() => _PinglunState();
}

class _PinglunState extends State<Pinglun> {
  List item = [];
  int uid = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      item = widget.item;
    });
    getId();
    print(widget.item);
    print('1111');
  }

  void getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getInt('uid');
    });
  }

  List<Widget> boxs() => List.generate(widget.item.length, (index) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          // margin: EdgeInsets.only(
          //   bottom: ScreenUtil().setWidth(20),
          // ),
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(24),
            left: ScreenUtil().setWidth(50),
          ),
          child: InkWell(
            onTap: () {
              // print(widget.item[index]['user']);
              // print(widget.item[index]['user']['headimgurl']);
            },
            //设置圆角
            child: Column(
              children: <Widget>[
                Row(children: [
                  Container(
                    child: CachedImageView(
                      ScreenUtil.instance.setWidth(55.0),
                      ScreenUtil.instance.setWidth(55.0),
                      widget.item[index]['user']['headimgurl'],
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
                  widget.type == 1
                      ? Expanded(
                          flex: 2,
                          child: Container(
                            child: Text(
                              '${widget.item[index]['user']['nickname']}',
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: ScreenUtil().setSp(30),
                              ),
                            ),
                          ))
                      : Container(),
                  widget.type == 1
                      ? Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(30)),
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${widget.item[index]['create_at']}',
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: ScreenUtil().setSp(30),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  widget.type == 2
                      ? Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${widget.item[index]['user']['nickname']}',
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: ScreenUtil().setSp(30),
                                  ),
                                ),
                                Container(
                                  // margin: EdgeInsets.only(
                                  //     top: ScreenUtil().setWidth(10)),
                                  child: Text(
                                    '${widget.item[index]['create_at']}',
                                    style: TextStyle(
                                      color: Color(0xff999999),
                                      fontSize: ScreenUtil().setSp(24),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                      : Container(),
                ]),
                widget.type == 1
                    ? Container(
                        height: ScreenUtil().setWidth(60),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.item[index]['desc']}',
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: ScreenUtil().setSp(32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      width: ScreenUtil().setWidth(600),
                      child: Text(
                        '${widget.item[index]['text']}',

                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(25),
                ),
                widget.type == 1
                    ?
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          initialIndex: index,
                          attahcments: widget.item,
                        )
                    ));
                  },
                  child:
                Container(
                        alignment: Alignment.centerLeft,
                        child: CachedImageView(
                          ScreenUtil.instance.setWidth(240.0),
                          ScreenUtil.instance.setWidth(240.0),
                          widget.item[index]['img'],
                          null,
                          BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),)
                    : Container(),
                SizedBox(
                  height: ScreenUtil().setWidth(24),
                ),
                Container(
                  // width: ScreenUtil().setWidth(651),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                  height: ScreenUtil().setWidth(1),
                  color: Color(0xffE5E5E5),
                ),
                widget.type == 1
                    ? Container(
                        height: ScreenUtil().setWidth(83),
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(37)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      widget.clickZan();
                                    },
                                    child: Image.asset(
                                      '${widget.is_like == 0 ? 'assets/index/ic_dianzan.png' : 'assets/index/dz.png'}',
                                      width: ScreenUtil().setWidth(32),
                                      height: ScreenUtil().setWidth(32),
                                    )),
                                Text(
                                  '${widget.like}',
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(77),
                            ),
                            widget.item[index]['user']['id'] == uid
                                ? Row(
                                    children: <Widget>[
                                      InkWell(
                                          onTap: () {
                                            widget.clickDel(
                                                widget.item[index]['id']);
                                          },
                                          child: Image.asset(
                                            'assets/index/scan.png',
                                            width: ScreenUtil().setWidth(32),
                                            height: ScreenUtil().setWidth(32),
                                          )),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(10),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.type == 2
            ? Container(
                alignment: Alignment.centerLeft,
                height: ScreenUtil().setWidth(99),
                width: ScreenUtil().setWidth(750),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                ),
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(36),
                ),
                color: PublicColor.whiteColor,
                child: Text(
                  '评价',
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(),
        Container(
          child: Column(children: boxs()),
        )
      ], //要显示的子控件集合
    );
  }
}


class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    this.scrollDirection = Axis.horizontal,
    this.attahcments,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;
  final List attahcments;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.attahcments.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "${currentIndex + 1}/${widget.attahcments.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: CachedNetworkImageProvider(
        widget.attahcments[index]['img'],
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: index),
    );
  }
}