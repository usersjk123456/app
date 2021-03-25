import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewBulidPage extends StatefulWidget {
  @override
  NewBulidPageState createState() => NewBulidPageState();
}

class NewBulidPageState extends State<NewBulidPage> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget inputArea = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(306),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          new InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(100),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                        child: Text(
                      '标题',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            hintText: '请输入标题', border: InputBorder.none),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          new InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(100),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                        child: Text(
                      '文本一',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            hintText: '请输入促销内容', border: InputBorder.none),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          new InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(100),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                        child: Text(
                      '文本一',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            hintText: '请输入促销内容', border: InputBorder.none),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );

    Widget bgArea = new Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setWidth(450),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe5e5e5), width: 1),
        ),
        child: new Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 50),
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setWidth(84),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    child: Text(
                  '背景',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                )),
              ),
              Expanded(
                flex: 0,
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10),
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setWidth(45),
                    decoration: BoxDecoration(
                        color: Color(0xfff33232),
                        borderRadius: new BorderRadius.circular((15.0))),
                    child: Text(
                      '背景一',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    print('1');
                    
                  },
                ),
              ),
              Expanded(
                flex: 0,
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10),
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setWidth(45),
                    decoration: BoxDecoration(
                        color: Color(0xffa0a0a0),
                        borderRadius: new BorderRadius.circular((15.0))),
                    child: Text(
                      '背景二',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    print('2');
                   
                  },
                ),
              ),
              Expanded(
                flex: 0,
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setWidth(45),
                    decoration: BoxDecoration(
                        color: Color(0xffa0a0a0),
                        borderRadius: new BorderRadius.circular((15.0))),
                    child: Text(
                      '背景三',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    print('3');
                  
                  },
                ),
              ),
            ]),
          ),
         
        ]),
      ),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: new Text(
              '新建信息卡',
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
            actions: <Widget>[
              InkWell(
                child: Container(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Text(
                      '保存',
                      style: new TextStyle(
                        color: PublicColor.textColor,
                        fontSize: ScreenUtil().setSp(28),
                        height: 2.7,
                      ),
                    )),
                onTap: () {
                  print('保存');
                },
              )
            ],
          ),
          body: new ListView(
            children: <Widget>[
              inputArea,
              bgArea,
            ],
          ),
        ));
  }
}

