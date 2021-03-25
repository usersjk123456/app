import 'package:flutter/material.dart';

class ContactUSPage extends StatelessWidget {
  final String phoneNumber;

  const ContactUSPage({
    Key key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("联系我们"),
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 280,
          child: Column(
            children: [
              Image.asset("assets/login/share_logo.png"),
              SizedBox(
                height: 30,
              ),
              Text("联系电话：${phoneNumber ?? ""}"),
            ],
          ),
        ),
      ),
    );
  }
}
