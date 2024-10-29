import 'package:flutter/material.dart';
import '../grafik/kadar_amonia.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTapNotification;

  HomeScreen({required this.onTapNotification});

  // Fungsi untuk mendapatkan ucapan berdasarkan waktu
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Selamat Pagi!';
    } else if (hour >= 12 && hour < 15) {
      return 'Selamat Siang!';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore!';
    } else {
      return 'Selamat Malam!';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil waktu saat ini
    String currentTime = DateFormat('HH:mm').format(DateTime.now());

    // Menentukan nilai kadar amonia saat ini (ganti dengan nilai yang sesuai)
    double currentAmoniaLevel = 0.67; // Contoh kadar amonia
    String amoniaLevelText = (currentAmoniaLevel * 100).toStringAsFixed(0) +
        '%'; // Menghitung persen
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)], //ini agak biru putih
          colors: [Color(0xFF62CDFA), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 44,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreeting(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    // color: Color(0xFF90A5B4), //abu abu
                    color: Colors.white, //putih
                  ),
                ),
                // SizedBox(height: 2),
                Text(
                  "Nama Pengguna",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            // left: 300,
            right: 10,
            top: 50,
            child: GestureDetector(
              onTap: () {
                onTapNotification(2); // Ganti ke indeks notifikasi
              },
              child: Container(
                child: Image.asset(
                  'assets/notifikasi icon.png', // Pastikan nama file benar
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 115,
            child: Column(children: [
              Text(
                "Kadar Amonia",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              AmoniaChart(),
            ]),
          ),
          Positioned(
            right: 40,
            // left: 170, // Posisi x untuk Card
            top: 145, // Sesuaikan dengan posisi AmoniaChart
            child: Card(
              color: Colors.white,
              elevation: 4, // Menambahkan sedikit bayangan
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Sudut melengkung
              ),
              child: Container(
                width: 190,
                height: 86,
                padding:
                    EdgeInsets.all(10), // Padding untuk konten di dalam Card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jam
                    Text(
                      currentTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey, // Warna abu-abu
                      ),
                    ),
                    SizedBox(height: 5), // Jarak antara jam dan teks berikutnya
                    // Teks Kadar Amonia
                    Text(
                      "Kadar Amonia",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600, // Semi bold
                        color: Colors.black,
                      ),
                    ),
                    // Teks Saat Ini dan kadar amonia
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Saat Ini",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600, // Semi bold
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          amoniaLevelText, // Menampilkan kadar amonia
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey, // Warna abu-abu
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // card kadar amonia 2 mulai
          Positioned(
            right: 30,
            top: 240,
            child: Card(
              color: Colors.white,
              elevation: 4, // Menambahkan sedikit bayangan
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Sudut melengkung
              ),
              child: Container(
                width: 190,
                padding:
                    EdgeInsets.all(10), // Padding untuk konten di dalam Card
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12, // Ukuran font
                      color: Colors.black, // Warna teks
                    ),
                    children: [
                      TextSpan(
                        text:
                            "Pengurasan kolam akan dilakukan secara otomatis ketika kadar amonia mencapai ",
                      ),
                      TextSpan(
                        text: "0,05 ppm",
                        style: TextStyle(
                          color: Colors.red, // Warna merah
                          fontWeight: FontWeight.w600, // Semi bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // card kadar amonia selesai

          Positioned(
            left: 30,
            top: 350,
            child: Text(
              "Suhu Air",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          //card suhu air mulai
          Positioned(
            top: 380,
            left: 30,
            right: 30,
            child: Card(
              color: Colors.white,
              elevation: 4, // Menambahkan sedikit bayangan
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Sudut melengkung
              ),
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Untuk memastikan teks berada di kiri
                      children: [
                        // Teks Suhu Air dengan padding dan warna abu-abu
                        Padding(
                          padding: EdgeInsets.all(
                              15), // Menambahkan padding hanya untuk teks
                          child: Text(
                            "Suhu Air 30°C",
                            style: TextStyle(
                              fontSize: 16, // Ukuran teks
                              fontWeight: FontWeight.w600, // Teks semi bold
                              color: Colors.grey, // Warna teks abu-abu
                            ),
                            textAlign:
                                TextAlign.left, // Menyelaraskan teks ke kiri
                          ),
                        ),
                        SizedBox(height: 10), // Jarak antara teks dan gambar
                        // Gambar Gelombang tanpa padding
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ), // Membuat lengkungan pada pojok bawah
                          child: Image.asset(
                            'assets/gelombang.png', // Sesuaikan tinggi gambar
                            fit: BoxFit.contain, // Menjaga proporsi gambar
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gambar waterdrop dengan posisi x=100, y=16
                  Positioned(
                    top: 16,
                    left: 100,
                    child: Image.asset(
                      'assets/waterdrop.png', // Sesuaikan ukuran gambar jika perlu
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // card suhu air selesai
        ],
      ),
    ));
  }
}
