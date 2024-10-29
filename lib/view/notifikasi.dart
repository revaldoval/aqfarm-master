import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifikasiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulasi data waktu sekarang
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('hh:mm a, dd MMMM yyyy').format(now);

    // Simulasi tipe notifikasi
    List<String> tipeNotifikasi = [
      'pengurasan',
      'pengisian',
      'pakan',
      'pengurasan',
      'pakan',
      'pengurasan',
      'pengisian',
      'pakan',
      'pengurasan',
      'pakan'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifikasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notifikasi Terbaru",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tipeNotifikasi.length,
                itemBuilder: (context, index) {
                  // Tentukan icon berdasarkan tipe notifikasi
                  String iconPath;
                  String detailText;

                  if (tipeNotifikasi[index] == 'pengurasan') {
                    iconPath = 'assets/ic-pengurasan.png';
                    detailText =
                        "Pengurasan air kolam sedang berlangsung karena kadar amonia telah mencapai batas 0,05 ppm. Proses ini akan selesai dalam beberapa saat.";
                  } else if (tipeNotifikasi[index] == 'pengisian') {
                    iconPath = 'assets/ic-pengisian.png';
                    detailText =
                        "Pengisian air kolam telah dimulai untuk menjaga kualitas air. Mohon pastikan semua sistem berjalan dengan baik selama proses ini.";
                  } else if (tipeNotifikasi[index] == 'pakan') {
                    iconPath = 'assets/ic-pakan.png';
                    detailText =
                        "Waktu pemberian pakan otomatis telah tiba. Pakan sedang disalurkan sesuai jadwal yang telah diatur.";
                  } else {
                    iconPath =
                        'assets/default.png'; // Default jika tipe tidak cocok
                    detailText = "Detail notifikasi tidak tersedia.";
                  }

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.asset(
                        iconPath, // Menampilkan icon berdasarkan tipe
                        width: 40,
                        height: 40,
                      ),
                      // title: Text(
                      //     "Notifikasi ${index + 1} - ${tipeNotifikasi[index]}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailText,
                            style: TextStyle(
                              fontSize: 12, // Ukuran teks lebih kecil
                              color: Colors.black, // Warna teks
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.more_vert), // icon titik 3
                      // trailing: Icon(Icons.arrow_forward_ios), // icon panah
                      onTap: () {
                        // Aksi ketika notifikasi diklik
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
