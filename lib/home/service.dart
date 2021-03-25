import 'dart:async';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import '../widgets/loading.dart';
import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: WebViewExample()));

class WebViewExample extends StatefulWidget {
  final String token;
  WebViewExample({this.token});
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;
  String name = '', headimgurl = '', uid = '', url = '';

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getUserInfo(map, (success) async {
      if (mounted) {
        setState(() {
          headimgurl = success['headimgurl'];
          name = success['nickname'];
          uid = success['id'].toString();
          url =
              'http://kefu.fir.show/yk_chat?token=${widget.token}&yk_uid=$uid&yk_avatar=https://images.yijiewangluo.cn/4511592386322_.pic_hd.jpg&yk_name=$name';
        });
      }
      print(url);
      print('url====$url');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget webview = Container(
      child: url != ''
          ? WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            )
          : LoadingDialog(),
    );

    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: Text(
          '客服',
          style: TextStyle(
            color: PublicColor.headerTextColor,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: PublicColor.linearHeader,
          ),
        ),
        centerTitle: true,
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
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return webview;
      }),
    );
  }
}
