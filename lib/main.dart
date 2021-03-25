import 'package:client/common/color.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import './config/application.dart';
import './config/routes.dart';
import 'package:amap_location/amap_location.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import './utils/toast_util.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 注册 fluro routes
  FluroRouter router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;
  //设置ios的key
  /*=============*/
  AMapLocationClient.setApiKey("97ce61f3c02118d73ef1bb4b883492cd");
  /*============*/
  //设置ios的key
  /*=============*/
  runApp(MyApp());
//   SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
// SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AMapLocation loc;
  @override
  void initState() {
    AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
    super.initState();
    _initFluwx();
    _checkPersmission();
  }

  _initFluwx() async {
    await registerWxApi(
        appId: "wx085b0ae36cbcac1d",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://chengzibaobao.com/link/");
    // await fluwx.isWeChatInstalled();
  }

  void _checkPersmission() async {
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
    await LocationPermissions().requestPermissions();
    AMapLocation loc = await AMapLocationClient.getLocation(true);
    setState(() {
      loc = loc;
    });
    final prefs = await SharedPreferences.getInstance();
    // 存值
    await prefs.setString('loc', loc.city);
    print(
        "定位成功: \n时间${loc.timestamp}\n经纬度:${loc.latitude} ${loc.longitude}\n 地址:${loc.formattedAddress} 城市:${loc.city} 省:${loc.province}");
  }

  @override
  void dispose() {
    //注意这里关闭
    AMapLocationClient.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      theme: mDefaultTheme,
      navigatorKey: Routes.navigatorKey,
      onGenerateRoute: Application.router.generator,
    );
  }
}

//自定义主题
final ThemeData mDefaultTheme = ThemeData(primaryColor: PublicColor.textColor);
