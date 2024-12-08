import 'dart:async'; // Import Timer untuk pembaruan otomatis
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kolamleleiot/custom/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:kolamleleiot/componen/collors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:kolamleleiot/custom/AlertDialog.dart';
import 'package:kolamleleiot/custom/ikan_lele.dart';
import 'package:kolamleleiot/custom/popup.dart';
import 'package:kolamleleiot/grafik/usia_ikan.dart';
import 'package:kolamleleiot/main.dart';

class InformasiScreen extends StatefulWidget {
  @override
  _InformasiScreenState createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  final TextEditingController _fishQuantityController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Timer? _timer;
  int _fishAge = 0;
  int? _fishQuantity; // Variabel untuk menyimpan persentase
  final int targetAge = 90;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _startAgeTimer();
    _listenToFishStartDate();
    fetchFishQuantity();
  }

  void _startAgeTimer() {
    _timer = Timer.periodic(Duration(days: 1), (_) {
      setState(() {
        _fishAge++;
      });
      _updateFishAgeInDatabase(); // Update usia ikan setiap hari
    });
  }

  // Dengarkan perubahan pada tanggalMulai di Firebase
  void _listenToFishStartDate() {
    _subscription = _database
        .child('informasiLele/tanggalMulai')
        .onValue
        .listen((event) async {
      if (event.snapshot.exists) {
        // Parse tanggalMulai dan hitung usia ikan
        DateTime startDate = DateTime.parse(event.snapshot.value as String);
        _fishAge = DateTime.now().difference(startDate).inDays;

        // Simpan usia ikan ke Firebase
        await _updateFishAgeInDatabase();

        // Perbarui UI
        setState(() {});
      }
    });
  }

  Future<void> _updateFishAgeInDatabase() async {
    await _database.child('informasiLele/usiaIkan').set(_fishAge);
  }

  int getPercentage() {
    if (_fishAge >= targetAge) {
      return 100; // Jika usia ikan sudah mencapai target
    }
    return ((_fishAge / targetAge) * 100)
        .round(); // Membulatkan persentase ke angka terdekat
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

        // Clear the text field after successful operation
        _fishQuantityController.clear();

        // Show success dialog
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

        // Show notification with sound
        _showNotificationWithSound(
          'Berhasil Mengatur Jumlah Bibit!',
          'Anda berhasil mengatur jumlah bibit lele.',
        );

        // Add data to Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        await firestore.collection('notifications').add({
          'detailText': "Berhasil mengatur jumlah bibit lele.",
          'tanggal':
              FieldValue.serverTimestamp(), // Use timestamp from Firestore
          'tipeNotifikasi': "panen",
        });
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

  Future<void> PanenLele() async {
    try {
      // Remove data
      await _database.child('data/jumlahIkan').set(0);
      await _database.child('informasiLele/tanggalMulai').set(null);
      await _database.child('informasiLele/usiaIkan').set(0);

      // Reset feeding amounts to 0
      await _database.child('makanPagi/beratMakan').set(0);
      await _database.child('makanSore/beratMakan').set(0);
      await _database.child('makanMalam/beratMakan').set(0);
      _listenToFishStartDate();
      // Show success dialog for harvesting
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatusPopup(
            message: "Data berhasil dihapus, lele telah dipanen!",
            isSuccess: true,
          );
        },
      );

      // Show notification with sound for harvesting
      _showNotificationWithSound(
        'Memanen Lele',
        'Anda telah berhasil memanen lele.',
      );

      // Add data to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('notifications').add({
        'detailText': "Memanen lele telah selesai.",
        'tanggal': FieldValue.serverTimestamp(), // Use timestamp from Firestore
        'tipeNotifikasi': "panen",
      });
    } catch (e) {
      print("Error updating data: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatusPopup(
            message: "Terjadi kesalahan saat menghapus data!",
            isSuccess: false,
          );
        },
      );
    }
  }

  Future<void> _showNotificationWithSound(String title, String body) async {
    try {
      // Menghasilkan ID unik untuk setiap notifikasi dalam rentang valid
      final notificationId = DateTime.now().millisecondsSinceEpoch % (2 ^ 31);

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'custom_sound_channel', // ID channel
        'Notifikasi Suara Khusus', // Nama channel
        channelDescription: 'Notifikasi dengan suara khusus',
        sound: RawResourceAndroidNotificationSound(
            'rezalele'), // Nama file suara tanpa ekstensi
        importance: Importance.high,
        priority: Priority.high,
        playSound: true, // Pastikan suara diputar
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        notificationId, // Gunakan ID unik untuk setiap notifikasi
        title, // Judul notifikasi
        body, // Isi notifikasi
        platformChannelSpecifics,
      );

      // Jika notifikasi berhasil diputar
      print("Notifikasi berhasil diputar dengan suara '$title'.");
    } catch (e) {
      // Menangani kesalahan jika ada masalah dalam memutar suara
      print("Gagal memutar suara notifikasi: $e");
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
    _subscription.cancel();
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
      body: SingleChildScrollView(
        child: Padding(
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
                  padding: EdgeInsets.all(28.0),
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
                              fontSize: 30.0,
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
                            "${getPercentage()}% dari target tercapai", // Menampilkan persentase tanpa desimal // Menampilkan persentase
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircularProgressText(
                            onHarvest: () {
                              PanenLele();
                              // Memanggil PanenLele() ketika tombol Panen ditekan
                              print('Memanen lele...');
                              // Anda dapat menambahkan kode untuk memanggil fungsi PanenLele
                            },
                          ) // Path untuk usia ikan
                          // SizedBox(
                          //     height:
                          //         10), // Menambahkan jarak vertikal antar widget
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     bool? result =
                          //         await CancellationDialog.show(context);
                          //     if (result == true) {
                          //       PanenLele();
                          //       print("User confirmed cancellation");
                          //     } else {
                          //       print("User canceled the dialog");
                          //     }
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.blue,
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 15, vertical: 5),
                          //   ),
                          //   child: Text(
                          //     "PANEN",
                          //     style: TextStyle(
                          //         fontSize: 16.0, color: Colors.white),
                          //   ),
                          // ),
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
                color: ColorConstants.primaryColor,
                child: Padding(
                  padding: EdgeInsets.all(28.0),
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
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  '$_fishQuantity Bibit Lele', // Display dynamic quantity
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
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
                  bool? result = await CancellationDialog.show(
                    context,
                    message:
                        "Apakah kamu yakin ingin mengatur jumlah bibit lele?", // Custom message
                  );
                  if (result == true) {
                    updateFishQuantity(); // Fungsi untuk mengatur jumlah bibit
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
                  "ATUR",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
