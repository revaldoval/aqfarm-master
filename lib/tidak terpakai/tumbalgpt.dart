import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kolamleleiot/componen/collors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:kolamleleiot/custom/AlertDialog.dart';
import 'package:kolamleleiot/custom/ikan_lele.dart';
import 'package:kolamleleiot/custom/popup.dart';

class InformasiScreen extends StatefulWidget {
  @override
  _InformasiScreenState createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  final TextEditingController _fishQuantityController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  int _fishAgeDays = 0; // Variable to store fish age in days
  DateTime? _fishAgeStartDate; // Store the start date for the fish age calculation
  late Timer _timer; // Timer to refresh the fish age periodically

  @override
  void initState() {
    super.initState();
    // Start the timer to update fish age every 1 second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _fishAgeDays = getFishAgeInDays(); // Update the fish age in days
      });
    });
    _fetchStartDate(); // Fetch start date from Firebase when app starts
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchStartDate() async {
    // Fetch the start date from Firebase
    DataSnapshot snapshot = await _database.child('data/startDate').get();
    if (snapshot.exists) {
      _fishAgeStartDate = DateTime.parse(snapshot.value as String);
      _fishAgeDays = getFishAgeInDays();
    }
  }

  Future<void> updateFishQuantity() async {
    if (_fishQuantityController.text.isNotEmpty &&
        int.parse(_fishQuantityController.text) < 100) {
      try {
        int selectedQuantity = int.parse(_fishQuantityController.text);
        await _database.child('data/jumlahIkan').set(selectedQuantity);
        print("Data sent successfully: $selectedQuantity");

        // Update _fishAgeDays and set the start date in Firebase
        DateTime now = DateTime.now();
        await _database.child('data/startDate').set(now.toIso8601String());
        setState(() {
          _fishAgeStartDate = now;
          _fishAgeDays = 0; // Reset the fish age when setting a new quantity
        });

        // Mapping jumlah ikan ke berat makan untuk setiap waktu makan
        Map<String, int> feedingAmounts = {
          'makanPagi/beratMakan': getFeedingAmount(selectedQuantity),
          'makanSore/beratMakan': getFeedingAmount(selectedQuantity),
          'makanMalam/beratMakan': getFeedingAmount(selectedQuantity),
        };

        // Kirim data berat makan ke path yang terpisah (bukan ke 'data')
        await _database
            .child('makanPagi/beratMakan')
            .set(feedingAmounts['makanPagi/beratMakan']);
        await _database
            .child('makanSore/beratMakan')
            .set(feedingAmounts['makanSore/beratMakan']);
        await _database
            .child('makanMalam/beratMakan')
            .set(feedingAmounts['makanMalam/beratMakan']);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatusPopup(
              message:
                  "Selamat anda telah berhasil mengatur jumlah bibit lele!",
              isSuccess: true,
            );
          },
        );
        print("Feeding amounts sent successfully: $feedingAmounts");
      } catch (e) {
        print("Error sending data: $e");
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatusPopup(
            message: "Gagal mengatur jumlah bibit lele!",
            isSuccess: false,
          );
        },
      );
    }
  }

  // Fungsi untuk menentukan berat makan berdasarkan jumlah ikan
  int getFeedingAmount(int quantity) {
    return (quantity * 0.5).toInt(); // Membulatkan hasil ke integer
  }

  // Fungsi untuk menghitung usia ikan dalam hari berdasarkan waktu mulai
  int getFishAgeInDays() {
    if (_fishAgeStartDate != null) {
      // Menghitung selisih waktu dalam hari dari tanggal mulai hingga hari ini
      return DateTime.now().difference(_fishAgeStartDate!).inDays;
    }
    return _fishAgeDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: ColorConstants.primaryColor,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getFishAgeInDays()} Hari", // Display dynamic days
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Usia Ikan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "100% Target tercapai",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: 0.4,
                            strokeWidth: 10,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        Text(
                          "40%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Bagian lain tetap seperti yang sudah ada...
          ],
        ),
      ),
    );
  }
}
