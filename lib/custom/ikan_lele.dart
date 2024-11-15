import 'package:flutter/material.dart';

class CatfishPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Mengatur warna untuk tubuh ikan
    final bodyPaint = Paint()..color = Colors.blueGrey[900]!;
    final bellyPaint = Paint()..color = Colors.grey[300]!;

    // Gambar tubuh ikan lele (Body)
    final bodyPath = Path()
      ..moveTo(size.width / 2 - 60, size.height / 2)
      ..quadraticBezierTo(size.width / 2 - 90, size.height / 2 - 40,
          size.width / 2 - 40, size.height / 2 - 60) // Top curve
      ..quadraticBezierTo(size.width / 2 + 40, size.height / 2 - 60,
          size.width / 2 + 60, size.height / 2) // Top curve
      ..quadraticBezierTo(size.width / 2 + 90, size.height / 2 + 40,
          size.width / 2 + 40, size.height / 2 + 60) // Bottom curve
      ..quadraticBezierTo(size.width / 2 - 40, size.height / 2 + 60,
          size.width / 2 - 60, size.height / 2) // Bottom curve
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    // Gambar bagian perut ikan lele (Belly)
    final bellyPath = Path()
      ..moveTo(size.width / 2 - 40, size.height / 2)
      ..quadraticBezierTo(size.width / 2 - 20, size.height / 2 - 30,
          size.width / 2 + 20, size.height / 2 - 30)
      ..quadraticBezierTo(size.width / 2 + 40, size.height / 2,
          size.width / 2 + 20, size.height / 2 + 30)
      ..quadraticBezierTo(size.width / 2 - 20, size.height / 2 + 30,
          size.width / 2 - 40, size.height / 2)
      ..close();

    canvas.drawPath(bellyPath, bellyPaint);

    // Gambar ekor ikan (Tail)
    final tailPath = Path()
      ..moveTo(size.width / 2 + 60, size.height / 2) // Mulai dari ujung tubuh
      ..lineTo(size.width / 2 + 100, size.height / 2 - 30) // Ujung atas ekor
      ..lineTo(size.width / 2 + 100, size.height / 2 + 30) // Ujung bawah ekor
      ..close();

    canvas.drawPath(tailPath, bodyPaint);

    // Gambar sirip ikan (Fins)
    final finPathLeft = Path()
      ..moveTo(size.width / 2 - 20, size.height / 2 + 20)
      ..lineTo(size.width / 2 - 60, size.height / 2 + 40)
      ..lineTo(size.width / 2 - 20, size.height / 2 + 50)
      ..close();

    final finPathRight = Path()
      ..moveTo(size.width / 2 + 20, size.height / 2 + 20)
      ..lineTo(size.width / 2 + 60, size.height / 2 + 40)
      ..lineTo(size.width / 2 + 20, size.height / 2 + 50)
      ..close();

    canvas.drawPath(finPathLeft, bodyPaint);
    canvas.drawPath(finPathRight, bodyPaint);

    // Gambar kumis ikan lele (Whiskers)
    final whiskerPaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 2;

    // Left whiskers
    canvas.drawLine(
      Offset(size.width / 2 - 60, size.height / 2 - 10),
      Offset(size.width / 2 - 120, size.height / 2 - 20),
      whiskerPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2 - 60, size.height / 2 - 10),
      Offset(size.width / 2 - 120, size.height / 2 + 10),
      whiskerPaint,
    );

    // Right whiskers
    canvas.drawLine(
      Offset(size.width / 2 + 60, size.height / 2 - 10),
      Offset(size.width / 2 + 120, size.height / 2 - 20),
      whiskerPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2 + 60, size.height / 2 - 10),
      Offset(size.width / 2 + 120, size.height / 2 + 10),
      whiskerPaint,
    );

    // Gambar mata ikan lele (Eyes)
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
        Offset(size.width / 2 - 30, size.height / 2 - 30), 5, eyePaint);
    canvas.drawCircle(
        Offset(size.width / 2 + 30, size.height / 2 - 30), 5, eyePaint);

    // Titik hitam di mata ikan
    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(
        Offset(size.width / 2 - 30, size.height / 2 - 30), 2, pupilPaint);
    canvas.drawCircle(
        Offset(size.width / 2 + 30, size.height / 2 - 30), 2, pupilPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
