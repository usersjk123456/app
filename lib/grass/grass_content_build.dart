import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import '../home/share_django.dart';
import '../utils/toast_util.dart';
import '../service/goods_service.dart';
import '../config/Navigator_util.dart';
import '../widgets/img_list.dart';
import '../widgets/cached_image.dart';

class GrassContentBuild extends StatefulWidget {
  final item;
  final user;
  GrassContentBuild({this.item, this.user});
  @override
  GrassContentBuildState createState() => GrassContentBuildState();
}

class GrassContentBuildState extends State<GrassContentBuild> {
  IjkMediaController controller = IjkMediaController();
  @override
  void initState() {
    super.initState();
    if (widget.item['url_type'].toString() == "2") {
      subscriptPlayFinish();
      if (widget.item.containsKey('img') && widget.item['img'].length != 0) {
        videoPlay(widget.item['img'][0]);
      }
    }
  }

  void videoPlay(url) async {
    controller.setNetworkDataSource(
      url,
      autoPlay: false,
    );
  }

  subscriptPlayFinish() {
    // subscription = controller.playFinishStream.listen((data) {
    //   print('视频播放完毕!!!!!!!!');
    //   controller.play(); //监听视频播放完毕,重新播放
    // });
    controller.ijkStatusStream.listen((data) async {
      await controller.pauseOtherController();
      if (mounted) {
        setState(() {
          if (data == IjkStatus.complete) {
            // 监听播放完毕
            // controller.play();
          } else if (data == IjkStatus.prepared ||
              data == IjkStatus.error ||
              data == IjkStatus.preparing) {
          } else if (data == IjkStatus.playing) {}
        });
      }
    });
  }

  void getGoodsDetails() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.item['goods_id']);

    GoodsServer().getGoodsDetails(map, (success) async {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ShareDjango(
            goods: success['goods'],
            user: widget.user,
            item: widget.item,
            setShareCount: setShareCount,
          );
        },
      );
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void setShareCount(count) {
    setState(() {
      widget.item['share'] = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return InkWell(
      onTap: () {
        NavigatorUtils.toXiangQing(
          context,
          widget.item['goods_id'],
          "1",
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(16)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        color: PublicColor.whiteColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedImageView(
              ScreenUtil.instance.setWidth(100),
              ScreenUtil.instance.setWidth(100),
              widget.item['headimgurl'],
              null,
              BorderRadius.all(
                  Radius.circular(ScreenUtil.instance.setWidth(100))),
            ),
            SizedBox(width: ScreenUtil().setWidth(30)),
            Expanded(
              flex: 1,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.item['name'],
                            style: TextStyle(
                                color: PublicColor.textColor,
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                          Text(
                            widget.item['create_at'],
                            style: TextStyle(
                                color: PublicColor.grewNoticeColor,
                                fontSize: ScreenUtil().setSp(26)),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(10)),
                          Text(
                            widget.item['content'],
                            style: TextStyle(
                                color: PublicColor.textColor,
                                fontSize: ScreenUtil().setSp(28)),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Container(
                            alignment: Alignment.topLeft,
                            child: widget.item['url_type'] == "1"
                                ? BuildImg(
                                    imgList: widget.item['img'],
                                    width: 160.0,
                                    height: 160.0,
                                  )
                                : Container(
                                    width: ScreenUtil().setWidth(400),
                                    height: ScreenUtil().setWidth(400),
                                    child: IjkPlayer(
                                      mediaController: controller,
                                      controllerWidgetBuilder:
                                          (mediaController) {
                                        return DefaultIJKControllerWidget(
                                          controller: controller,
                                          doubleTapPlay: true,
                                          verticalGesture: false,
                                          horizontalGesture: false,
                                          showFullScreenButton: false,
                                        ); // 自定义
                                      },
                                    ),
                                  ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/set/shareIcon.png",
                                  width: ScreenUtil().setWidth(25),
                                  height: ScreenUtil().setWidth(25),
                                ),
                                SizedBox(width: ScreenUtil().setHeight(10)),
                                Text(
                                  "${widget.item['share']}人已分享",
                                  style: TextStyle(
                                      color: PublicColor.grewNoticeColor,
                                      fontSize: ScreenUtil().setSp(26)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          getGoodsDetails();
                        },
                        child: widget.item['commission'] == "0.00"
                            ? Image.asset(
                                "assets/set/icon_fenxiagn.png",
                                width: ScreenUtil().setWidth(36),
                                height: ScreenUtil().setWidth(36),
                              )
                            : Container(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(15),
                                  right: ScreenUtil().setWidth(15),
                                  bottom: ScreenUtil().setWidth(10),
                                  top: ScreenUtil().setWidth(10),
                                ),
                                decoration: BoxDecoration(
                                    color: PublicColor.themeColor,
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(15))),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/set/icon_fenxiang.png",
                                      width: ScreenUtil().setWidth(31),
                                      height: ScreenUtil().setWidth(31),
                                    ),
                                    SizedBox(width: ScreenUtil().setHeight(5)),
                                    Text(
                                      "赚${widget.item['commission']}元",
                                      style: TextStyle(
                                          color: PublicColor.btnTextColor,
                                          fontSize: ScreenUtil().setSp(26)),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
