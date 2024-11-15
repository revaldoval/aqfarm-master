import 'dart:async'; // Import Timer untuk pembaruan otomatis

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
  Timer? _timer;
  int _fishAge = 0;
  int? _fishQuantity;

  @override
  void initState() {
    super.initState();
    _startAgeTimer();
    _getFishAgeFromDatabase();
    fetchFishQuantity();
  }

  void _startAgeTimer() {
    _timer = Timer.periodic(Duration(days: 1), (_) {
      setState(() {
        _fishAge++;
      });
    });
  }

  Future<void> _getFishAgeFromDatabase() async {
    final snapshot = await _database.child('informasiLele/tanggalMulai').get();
    if (snapshot.exists) {
      DateTime startDate = DateTime.parse(snapshot.value as String);
      _fishAge = DateTime.now().difference(startDate).inDays;
      setState(() {});
    }
  }

  Future<void> updateFishQuantity() async {
    if (_fishQuantityController.text.isNotEmpty &&
        int.parse(_fishQuantityController.text) < 101) {
      try {
        int selectedQuantity = int.parse(_fishQuantityController.text);
        await _database.child('data/jumlahIkan').set(selectedQuantity);

        // Save the current date for age calculation
        await _database
            .child('informasiLele/tanggalMulai')
            .set(DateTime.now().toIso8601String());

        // Set the initial feeding amounts
        Map<String, int> feedingAmounts = {
          'makanPagi/beratMakan': getFeedingAmount(selectedQuantity),
          'makanSore/beratMakan': getFeedingAmount(selectedQuantity),
          'makanMalam/beratMakan': getFeedingAmount(selectedQuantity),
        };

        await _database
            .child('makanPagi/beratMakan')
            .set(feedingAmounts['makanPagi/beratMakan']);
        await _database
            .child('makanSore/beratMakan')
            .set(feedingAmounts['makanSore/beratMakan']);
        await _database
            .child('makanMalam/beratMakan')
            .set(feedingAmounts['makanMalam/beratMakan']);

        // Clear the text field after successful operation
        _fishQuantityController.clear();

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

  Future<int?> getFishQuantity() async {
    try {
      // Mendapatkan data dari Firebase menggunakan ref() dan child() yang benar
      final snapshot = await _database.child('data/jumlahIkan').get();

      // Memeriksa apakah data ada dan mengembalikan nilai sebagai integer
      if (snapshot.exists) {
        return snapshot.value is int
            ? snapshot.value as int
            : int.tryParse(snapshot.value.toString());
      } else {
        return null; // Data tidak ada
      }
    } catch (e) {
      print("Error fetching fish quantity: $e");
      return null;
    }
  }

  Future<void> fetchFishQuantity() async {
    try {
      // Mendapatkan reference ke 'data/jumlahIkan' di Firebase
      final ref = FirebaseDatabase.instance.ref().child('data/jumlahIkan');

      // Menambahkan listener untuk mendeteksi perubahan data secara otomatis
      ref.onValue.listen((event) {
        // Mengambil data terbaru dari snapshot
        int? quantity = event.snapshot.value is int
            ? event.snapshot.value as int
            : int.tryParse(event.snapshot.value.toString());

        // Update state dengan jumlah ikan terbaru
        setState(() {
          _fishQuantity = quantity ?? 0;
        });

        // Menampilkan jumlah ikan yang diterima
        print("Jumlah ikan terbaru: $_fishQuantity");
      });
    } catch (e) {
      print("Error fetching fish quantity: $e");
    }
  }

  int getFeedingAmount(int quantity) {
    return (quantity * 0.5).toInt();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                          "$_fishAge Hari", // Display dynamic minutes
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
            SizedBox(height: 10),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fishQuantity == null
                            ? Text(
                                'Loading...', // Teks saat data sedang dimuat
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                '$_fishQuantity Bibit Lele', // Display dynamic quantity
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        Text(
                          "Jumlah Bibit Lele",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/lele.png', // Ganti dengan path gambar Anda
                      width: 100, // Sesuaikan ukuran gambar
                      height: 100, // Sesuaikan ukuran gambar
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Silakan masukkan jumlah bibit ikan yang akan dimasukkan ke dalam kolam untuk memudahkan dalam pemberian pakan.",
              style: TextStyle(
                fontSize: 14.0,
                color: ColorConstants.greyColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _fishQuantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: "Jumlah bibit ikan",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool? result = await CancellationDialog.show(context);
                if (result == true) {
                  updateFishQuantity();
                  print("User confirmed cancellation");
                } else {
                  print("User canceled the dialog");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                "SETTING",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
