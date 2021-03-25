import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';

class UpLoadingDialog extends StatefulWidget {
  final sent;
  final total;
  UpLoadingDialog({this.sent, this.total});
  @override
  _UpLoadingDialogState createState() => _UpLoadingDialogState();
}

class _UpLoadingDialogState extends State<UpLoadingDialog> {
  var value = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black12,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: 120,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(PublicColor.themeColor),
                    strokeWidth: 5,
                    value: widget.sent / widget.total,
                  ),
                ),
                Positioned(
                    left: 26,
                    top: 30,
                    child: Text(
                      "${(widget.sent / widget.total * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(35),
                        fontWeight: FontWeight.w500,
                      ),
                    ))
              ],
            ),
            // Text('value-->>>${widget.sent / widget.total}')
          ),
        ),
      ),
    );
  }
}
