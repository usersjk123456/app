import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/choose_city.dart';

class AddFreeBuildPage extends StatefulWidget {
  final type;
  final mainCity;
  final city;
  final Map templateList;
  final Map template;
  final Function deleTemp;
  final keys;
  AddFreeBuildPage({
    this.type,
    this.mainCity,
    this.city,
    this.templateList,
    this.template,
    this.deleTemp,
    this.keys,
  });
  @override
  _AddFreeBuildPageState createState() => _AddFreeBuildPageState();
}

class _AddFreeBuildPageState extends State<AddFreeBuildPage> {
  TextEditingController inputController = TextEditingController();
  Map template = {};
  String province = '';
  @override
  void initState() {
    if (!widget.mainCity.containsKey(widget.keys)) {
      widget.mainCity[widget.keys] = {};
    }
    if (widget.template.length != 0) {
      inputController.text = widget.template['num'];

      List proarr = widget.template['province'].split('/');
      for (var i = 0; i < proarr.length; i++) {
        for (var j = 0; j < widget.city.length; j++) {
          if (!widget.mainCity[widget.keys].containsKey(j)) {
            widget.mainCity[widget.keys][j] = {};
          }
          if (proarr[i] == widget.city[j]['name']) {
            widget.mainCity[widget.keys][j] = widget.city[j];
          }
        }
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    inputController.clear();
    inputController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    setState(() {
      if (widget.template.containsKey('num')) {
        inputController.text = widget.template['num'];
      } else {
        inputController.text = "";
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  void configCity(citys, keys) {
    if (widget.mainCity.containsKey(keys)) {
      widget.mainCity.remove(keys);
    }
    widget.mainCity[keys] = {};
    for (var i = 0; i < citys.length; i++) {
      if (widget.mainCity[keys].containsKey(i)) {
        widget.mainCity[keys].remove(i);
      }
      widget.mainCity[keys][i] = {};
      if (citys[i]['flag'] && !citys[i]['isSelect']) {
        widget.mainCity[keys][i] = citys[i];
      }
    }
    setState(() {
      widget.template['province'] = "";
      widget.mainCity[keys].forEach((key, item) {
        if (item.length != 0) {
          if (widget.template['province'] == "") {
            widget.template['province'] += item['name'];
          } else {
            widget.template['province'] += '/' + item['name'];
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: PublicColor.whiteColor,
            border: Border(
              bottom: BorderSide(
                color: Color(0xffefefef),
              ),
            ),
          ),
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(30),
          ),
          alignment: Alignment.center,
          height: ScreenUtil().setWidth(120),
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
            // top: ScreenUtil().setWidth(30),
            // bottom: ScreenUtil().setWidth(30),
          ),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text('包邮省份'),
              ),
              Expanded(
                flex: 8,
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(300),
                        child: Text(
                          !widget.template.containsKey('province')
                              ? '未选择'
                              : widget.template['province'],
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: PublicColor.textColor,
                      ),
                    ],
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        builder: (BuildContext context) {
                          return ChooseCityWidget(
                            keys: widget.keys,
                            city: widget.city,
                            mainCity: widget.mainCity,
                            configCity: configCity,
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(750),
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(30),
            bottom: ScreenUtil().setWidth(30),
          ),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey[100],
                    ),
                    height: ScreenUtil().setWidth(100),
                    width: ScreenUtil().setWidth(680),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text('消费满'),
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(15)),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            height: ScreenUtil().setWidth(80),
                            child: TextField(
                              onChanged: (value) {
                                widget.template['num'] = value;
                              },
                              controller: inputController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(15)),
                        Expanded(
                          flex: 4,
                          child: widget.type == "1" ? Text('元包邮') : Text('件包邮'),
                        ),
                      ],
                    ),
                  ),
                  widget.templateList.length > 1
                      ? Container(
                          width: ScreenUtil().setWidth(60),
                          child: InkWell(
                            onTap: () {
                              widget.deleTemp(widget.keys);
                            },
                            child: Image.asset(
                              "assets/shop/del.png",
                              width: ScreenUtil().setWidth(50),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
