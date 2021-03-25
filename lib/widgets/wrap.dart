import 'package:flutter/material.dart';
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 获取设备的宽度
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      backgroundColor: Color(0xfff1f1f1),
      body: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.black12,
            child: Center(child: Text("顶部")),
          ),
          Container(
            height: 300,
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: Wrap(
              children: _createGridViewItem(width),
            ),
          )
        ],
      ),
    );
  }

  _createGridViewItem(width) {
    List<Widget> list = [];
    for (var i = 0; i < 18; i++) {
      // 你想分几列，就除以几， 高度可以进行自定义
      list.add(Container(
        width: width / 4,
        height: 50,
        color: Colors.primaries[i],
      ));
    }
    return list;
  }
}
