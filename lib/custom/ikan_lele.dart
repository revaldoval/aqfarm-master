import 'package:flutter/material.dart';

class CatfishPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green;

    // Gambar tubuh ikan lele
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: 100, height: 50),
      paint,
    );

    // Gambar ekor ikan
    final tailPath = Path()
      ..moveTo(size.width / 2 - 50, size.height / 2)
      ..lineTo(size.width / 2 - 80, size.height / 2 - 20)
      ..lineTo(size.width / 2 - 80, size.height / 2 + 20)
      ..close();

    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
