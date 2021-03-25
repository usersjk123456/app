import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:event_bus/event_bus.dart';
import '../widgets/choose_city.dart';

class AddFreightBuildPage extends StatefulWidget {
  final Function deleTemp;
  final Function configCity;
  final List city;
  final Map mainCity;
  final Map template;
  final keys;
  AddFreightBuildPage({
    this.deleTemp,
    this.configCity,
    this.city,
    this.mainCity,
    this.template,
    this.keys,
  });
  @override
  _AddFreightBuildPageState createState() => _AddFreightBuildPageState();
}

class _AddFreightBuildPageState extends State<AddFreightBuildPage> {
  TextEditingController onlyController = TextEditingController();
  TextEditingController thanController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  Map template = {};
  @override
  void initState() {
    if (!widget.mainCity.containsKey(widget.keys)) {
      widget.mainCity[widget.keys] = {};
    }
    print('widget]...${widget.mainCity}');
    if (widget.template.length != 0) {
      onlyController.text = widget.template['only_price'];
      thanController.text = widget.template['than_price'];
      limitController.text = widget.template['limit'];

      List proarr = widget.template['province'].split('/');
      for (var i = 0; i < proarr.length; i++) {
        for (var j = 0; j < widget.city.length; j++) {
          if (!widget.mainCity[widget.keys].containsKey(j)) {
            widget.mainCity[widget.keys][j] = {};
          }
          if (proarr[i] == widget.city[j]['name']) {
            //这里有问题
            widget.mainCity[widget.keys][j] = widget.city[j];
          }
        }
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    onlyController.clear();
    onlyController.dispose();
    thanController.clear();
    thanController.dispose();
    limitController.clear();
    limitController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    setState(() {
      if (widget.template.containsKey('only_price')) {
        onlyController.text = widget.template['only_price'];
      } else {
        onlyController.text = "";
      }
      if (widget.template.containsKey('than_price')) {
        thanController.text = widget.template['than_price'];
      } else {
        thanController.text = "";
      }
      if (widget.template.containsKey('limit')) {
        limitController.text = widget.template['limit'];
      } else {
        limitController.text = "";
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  void configCity(city, keys) {
    widget.configCity(city, keys);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Column(
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(80),
          color: PublicColor.bodyColor,
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text('自定义'),
              ),
              Container(
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        width: ScreenUtil().setWidth(300),
                        child: Text(
                          '删除',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    widget.deleTemp(widget.keys);
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: PublicColor.whiteColor,
            border: Border(
              bottom: BorderSide(
                color: Color(0xffefefef),
              ),
            ),
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
                child: Text('买家付邮省份'),
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
                          widget.template['province'] == null ||
                                  widget.template['province'] == ""
                              ? '未选择'
                              : widget.template['province'],
                          maxLines: 1,
                          textAlign: TextAlign.right,
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
                            city: widget.city,
                            mainCity: widget.mainCity,
                            keys: widget.keys,
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
          height: ScreenUtil().setWidth(120),
          decoration: BoxDecoration(
            color: PublicColor.whiteColor,
            border: Border(
              bottom: BorderSide(
                color: Color(0xffefefef),
              ),
            ),
          ),
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text('单件商品费用'),
              ),
              Expanded(
                flex: 7,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: onlyController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入",
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.template['only_price'] = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    Text('元/件'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(120),
          decoration: BoxDecoration(
            color: PublicColor.whiteColor,
            border: Border(
              bottom: BorderSide(
                color: Color(0xffefefef),
              ),
            ),
          ),
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text('超出单件费用'),
              ),
              Expanded(
                flex: 7,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: thanController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入",
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.template['than_price'] = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    Text('元/件'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(120),
          decoration: BoxDecoration(
            color: PublicColor.whiteColor,
            border: Border(
              bottom: BorderSide(
                color: Color(0xffefefef),
              ),
            ),
          ),
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text('免费条件'),
              ),
              Expanded(
                flex: 7,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: limitController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入",
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.template['limit'] = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    Text('件/免费'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
