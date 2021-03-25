import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login/login.dart';
import './tabbar.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool isLoading = true;
  String jwt = '';
  bool isLogin = true;
  @override
  void initState() {
    super.initState();
    getLocal();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString('jwt');
    if (jwt != null) {
      setState(() {
        isLogin = false;
        isLoading = false;
      });
    } else {
      setState(() {
        isLogin = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLogin
                  ? LoginPage()
                  : Tabbar(
                      index: '0',
                    ),
    );
  }
}