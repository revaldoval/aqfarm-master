import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FeedCardWidget extends StatefulWidget {
  final String feedTime;
  final double feedWeight;
  final bool initialSwitchValue;

  const FeedCardWidget({
    Key? key,
    required this.feedTime,
    required this.feedWeight,
    required this.initialSwitchValue,
  }) : super(key: key);

  @override
  _FeedCardWidgetState createState() => _FeedCardWidgetState();
}

class _FeedCardWidgetState extends State<FeedCardWidget> {
  late bool _switchValue;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _switchValue = widget.initialSwitchValue;
  }

  void _updateFirebaseStatus(bool value) {
    // Tentukan path status di Firebase berdasarkan waktu pakan
    String statusPath = 'makan${widget.feedTime}/status';

    // Update status di Firebase
    _database
        .child(statusPath)
        .set(value ? 'ON' : 'OFF'); // Menggunakan tanda kutip tunggal
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/ic-${widget.feedTime.toLowerCase()}.png';

    return Container(
      width: MediaQuery.of(context).size.width - 60,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.feedTime,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 5),
                  Image.asset(
                    imagePath,
                    width: 24,
                    height: 24,
                  ),
                  Spacer(),
                  Text(
                    _switchValue ? 'ON' : 'OFF',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _switchValue ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(width: 10),
                  Switch(
                    value: _switchValue,
                    onChanged: (bool value) {
                      setState(() {
                        _switchValue = value;
                      });
                      _updateFirebaseStatus(
                          value); // Panggil fungsi untuk update Firebase
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Berat pakan yang diberikan "),
                      TextSpan(
                        text: "(kg)",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Slider(
                value: widget.feedWeight,
                min: 0.5,
                max: 50,
                divisions: 99,
                label: "${widget.feedWeight.toStringAsFixed(1)} kg",
                onChanged: null,
              ),
              Center(
                child: Text(
                  "Berat pakan: ${widget.feedWeight.toStringAsFixed(1)} g",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
