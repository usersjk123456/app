#### 针对开发环境新加的json序列化的插件，解决对象传输和转换json的问题，执行这个命令可以自动生成`.g.dart文件`

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

> 打包上架时需要flutter开发环境，当前本地开发环境是1.22.2，
基于1.22.xx都可以运行，如果是flutter 2.0版本会导致部分插件无法运行，配置开发环境的地址

> flutter.io // 官网
> 或访问flutter中文网站

环境配置好后执行

> flutter package get // 下载依赖的插件

> flutter package upgrade // 升级依赖的插件

如果需要开发安卓开发环境则配置安卓的环境

# 安卓打包上架操作

* 执行打包命令
  > flutter clean //清空之前的打包结果

  > flutter build apk --release // 打包出来的结果在项目build\app\outputs\flutter-apk目录下

* 应用宝和小米需要再进行签名一次，为了方便将打出来的apk拷贝到和.keystore目录下（这个命令一般不用执行，只有第一次构建的时候需要执行）

  > jarsigner -verbose -keystore open_ad_sdk.keystore -signedjar app-release.apk app-release.apk key0

  然后输入密码 `123456`

  然后将app-release.apk上传上架
