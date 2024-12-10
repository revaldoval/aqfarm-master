import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AmoniaChart extends StatefulWidget {
  @override
  _AmoniaChartState createState() => _AmoniaChartState();
}

class _AmoniaChartState extends State<AmoniaChart> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  double currentAmoniaLevelChart = 0.0;
  String amoniaLevelText = "Loading...";

  @override
  void initState() {
    super.initState();
    _getAmoniakChart();
  }

  void _getAmoniakChart() {
    _database.child('data/amoniak').onValue.listen((DatabaseEvent event) {
      final String newAmoniakChart = event.snapshot.value.toString();
      double amoniaValueChart = double.tryParse(newAmoniakChart) ?? 0.0;

      setState(() {
        currentAmoniaLevelChart = (amoniaValueChart / 100).clamp(0.0, 1.0);
        amoniaLevelText = (amoniaValueChart).toStringAsFixed(0) + '%';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        height: 120,
        child: CustomPaint(
          painter: CircularProgressPainter(
            progress: currentAmoniaLevelChart,
          ),
          child: Center(
            child: Text(
              amoniaLevelText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;

  CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    double lineWidth = 8.0; // Ketebalan lingkaran

    // Lingkaran latar belakang
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    // Lingkaran progres
    Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.lightBlueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    // Gambar lingkaran latar belakang
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width - lineWidth) / 2,
      backgroundPaint,
    );

    // Gambar lingkaran progres
    double progressAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromLTWH(
        lineWidth / 2,
        lineWidth / 2,
        size.width - lineWidth,
        size.height - lineWidth,
      ),
      -pi / 2, // Mulai dari atas
      progressAngle,
      false,
      progressPaint,
    );

    // Gambar slider titik
    double sliderX = size.width / 2 +
        cos(-pi / 2 + progressAngle) * (size.width - lineWidth) / 2;
    double sliderY = size.height / 2 +
        sin(-pi / 2 + progressAngle) * (size.height - lineWidth) / 2;

    Paint sliderPaint = Paint()..color = Colors.blue;

    canvas.drawCircle(Offset(sliderX, sliderY), lineWidth * 1.5, sliderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
