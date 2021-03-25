import 'package:flutter/material.dart';

class TriangleView extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  const TriangleView({
    Key key,
    @required this.width,
    @required this.height,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: CustomPaint(
        painter: TrianglePainter(color:color,),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  Color color;
  TrianglePainter({
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    Path path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
