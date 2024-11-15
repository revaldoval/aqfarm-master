import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AmoniaChart extends StatefulWidget {
  @override
  _AmoniaChartState createState() => _AmoniaChartState();
}

class _AmoniaChartState extends State<AmoniaChart> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  double currentAmoniaLevelChart = 0.0;
  double currentAmoniaLevel = 0.0;
  String amoniaLevelText = "Loading...";

  @override
  void initState() {
    super.initState();
    _getAmoniak();
    _getAmoniakChart();
  }

  void _getAmoniakChart() {
    _database.child('data/amoniak').onValue.listen((DatabaseEvent event) {
      final String newAmoniakChart = event.snapshot.value.toString();
      double amoniaValueChart = double.tryParse(newAmoniakChart) ?? 0.0;

      setState(() {
        currentAmoniaLevelChart = (amoniaValueChart / 100).clamp(0.0, 1.0);
      });
    });
  }

  void _getAmoniak() {
    _database.child('data/amoniak').onValue.listen((DatabaseEvent event) {
      final String newAmoniak = event.snapshot.value.toString();
      double amoniaValue = double.tryParse(newAmoniak) ?? 0.0;

      setState(() {
        currentAmoniaLevel = amoniaValue;
        amoniaLevelText = (currentAmoniaLevel * 1).toStringAsFixed(0) + '%';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: currentAmoniaLevelChart, // Nilai antara 0.0 hingga 1.0
            strokeWidth: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        Text(
          amoniaLevelText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
