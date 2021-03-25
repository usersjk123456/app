import 'dart:io';
import 'package:client/widgets/btn_widget.dart';

import '../widgets/set_menu.dart';
import 'package:flutter/material.dart';
import '../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/Navigator_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/toast_util.dart';
import '../widgets/dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info/package_info.dart';

class SetPage extends StatefulWidget {
  @override
  SetPageState createState() => SetPageState();
}

class SetPageState extends State<SetPage> {
  var _cacheSizeStr = '', version = '';

  String phoneNumber;

  @override
  void initState() {
    super.initState();
    loadCache();
    getVersion();
    final prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      setState(() {
        phoneNumber = value.getString("contactPhone");
      });
    });

  }

  void signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt');
      await prefs.remove('uid');
    } finally {}
  }

  // 获取当前版本
  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
    print('version===$version');
  }

  // 加载缓存
  Future<Null> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
    print('临时目录大小: ' + value.toString());
    setState(() {
      _cacheSizeStr = _renderSize(value); // _cacheSizeStr用来存储大小的值
    });
  }

  // 循环计算文件大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  // 格式化缓存文件大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  // 清除缓存
  void _clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    await loadCache();
    ToastUtil.showToast('清除缓存成功');
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget setArea = new Container(
      width: ScreenUtil().setWidth(700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xffe5e5e5), width: 1),
      ),
      child: new Column(children: <Widget>[
        // 列表
        SetMenu(
          name: '个人资料',
          isLine: 1,
          isNavigator: true,
          tapFun: () {
            NavigatorUtils.goPersonalDataPage(context);
          },
        ),
        SetMenu(
          name: '账户与安全',
          isLine: 1,
          isNavigator: true,
          tapFun: () {
            NavigatorUtils.goAccountSafePage(context);
          },
        ),
        SetMenu(
          name: '清除缓存',
          isLine: 1,
          isNavigator: false,
          value: _cacheSizeStr,
          tapFun: () {
            if (_cacheSizeStr == '' || _cacheSizeStr == '0.00B') {
              ToastUtil.showToast('暂无缓存');
              return;
            }
            _clearCache();
          },
        ),
        SetMenu(
          name: '关于我们',
          isLine: 1,
          isNavigator: true,
          tapFun: () {
            NavigatorUtils.goAboutUs(context);
          },
        ),
        SetMenu(
          name: '用户协议',
          isLine: 1,
          isNavigator: true,
          tapFun: () {
            NavigatorUtils.goAgreement(context, 'yonghu');
          },
        ),
        SetMenu(
          name: '隐私政策',
          isLine: 1,
          isNavigator: true,
          tapFun: () {
            NavigatorUtils.goAgreement(context, 'yinsi');
          },
        ),
        SetMenu(
          name: '当前版本',
          isLine: 0,
          isNavigator: false,
          value: 'V$version',
          tapFun: () {
            return;
          },
        ),
        SetMenu(
          name: '联系我们',
          isLine: 0,
          isNavigator: false,
          value: phoneNumber ?? '',
          tapFun: null,
        ),
      ]),
    );

    Widget btnArea = BigButton(
      name: '退出登录',
      tapFun: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return MyDialog(
                width: ScreenUtil.instance.setWidth(600.0),
                height: ScreenUtil.instance.setWidth(300.0),
                queding: () {
                  signOut();
                  NavigatorUtils.logout(context);
                },
                quxiao: () {
                  Navigator.of(context).pop();
                },
                title: '温馨提示',
                message: '确定要退出登录吗？');
          },
        );
      },
      top: ScreenUtil().setWidth(140),
    );
    return MaterialApp(
        title: "设置",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: new Text(
              '设置',
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
          body: new Container(
            alignment: Alignment.center,
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                setArea,
                btnArea
              ],
            ),
          ),
        ));
  }
}
