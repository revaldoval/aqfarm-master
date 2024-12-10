import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotifikasiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulasi data waktu sekarang
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('hh:mm a, dd MMMM yyyy').format(now);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // navigatorKey: Bottom.navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Notifikasi",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Ikon tombol kembali
            onPressed: () {
              Navigator.pop(context); // Kembali ke layar sebelumnya
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terbaru",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .orderBy('tanggal',
                          descending: true) // Mengurutkan berdasarkan tanggal
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Tidak ada notifikasi.'));
                    }

                    var notifications = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        var notification = notifications[index];
                        String tipeNotifikasi = notification['tipeNotifikasi'];
                        String detailText = notification['detailText'];
                        String iconPath = '';

                        // Menentukan icon berdasarkan tipe notifikasi
                        if (tipeNotifikasi == 'pengurasan') {
                          iconPath = 'assets/ic-pengurasan.png';
                        } else if (tipeNotifikasi == 'panen') {
                          iconPath = 'assets/ic-pengisian.png';
                        } else if (tipeNotifikasi == 'pakan') {
                          iconPath = 'assets/ic-pakan.png';
                        } else {
                          iconPath =
                              'assets/default.png'; // Default jika tipe tidak cocok
                        }

                        // Format tanggal dari Firestore
                        Timestamp timestamp = notification['tanggal'];
                        DateTime notificationDate = timestamp.toDate();
                        String formattedNotificationDate =
                            DateFormat('hh:mm a, dd MMMM yyyy')
                                .format(notificationDate);

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset(
                              iconPath, // Menampilkan icon berdasarkan tipe
                              width: 40,
                              height: 40,
                            ),
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
                                  formattedNotificationDate,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            // trailing: Icon(Icons.more_vert), // icon titik 3
                            onTap: () {
                              // Aksi ketika notifikasi diklik
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
