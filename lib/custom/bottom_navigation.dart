import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kolamleleiot/componen/collors.dart';
import 'package:kolamleleiot/main.dart';
import 'package:kolamleleiot/view/beranda.dart';
import 'package:kolamleleiot/view/informasi.dart';
import 'package:kolamleleiot/view/monitoring.dart';
import 'package:kolamleleiot/tidak%20terpakai/profil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  final DatabaseReference _pumpStatusRef =
      FirebaseDatabase.instance.ref('pompa/status');
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    checkPumpStatusAndAddNotification();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
    // monitorAmmonia();
    scheduleFeedingNotifications();
    startPeriodicCheck();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// Fungsi untuk menambah notifikasi ke Firestore
  Future<void> addNotification(String title, String body) async {
    try {
      final timestamp = Timestamp.now(); // Mendapatkan timestamp saat ini
      final firestore = FirebaseFirestore.instance;

      // Menambahkan notifikasi baru ke Firestore tanpa idNotif
      await firestore.collection('notifications').add({
        'tipeNotifikasi': title, // Pastikan ini adalah string
        'detailText': body, // Pastikan ini adalah string
        'tanggal': timestamp, // Tanggal dalam bentuk Timestamp
      });

      print("Notifikasi berhasil ditambahkan ke Firestore.");
    } catch (e) {
      print("Error menambahkan notifikasi: $e");
    }
  }

// Fungsi untuk memeriksa status pompa dan menambah notifikasi jika diperlukan
  Future<void> checkPumpStatusAndAddNotification() async {
    // Ambil status pompa dari Firebase
    final pumpStatusEvent = await _pumpStatusRef.once();
    final pumpStatus = pumpStatusEvent.snapshot.value;

    // Jika status pompa adalah 'pengurasan', tampilkan notifikasi
    if (pumpStatus == 'pengurasan') {
      // Tampilkan notifikasi kadar amoniak
      _showAmmoniaNotification(); // Parameter 0 karena kadar amoniak tidak dicek

      // Tambahkan notifikasi dengan detail
      addNotification(
        'pengurasan',
        'Pengurasan air kolam sedang berlangsung karena kadar amonia telah mencapai batas. Proses ini akan selesai dalam beberapa saat.',
      );
    } else {
      // Tidak ada tindakan jika status bukan 'pengurasan'
      print(
          "Status pompa bukan 'pengurasan'. Tidak ada notifikasi yang ditambahkan.");
    }
  }

// Fungsi untuk menjalankan pemeriksaan status pompa setiap 10 menit
  void startPeriodicCheck() {
    // Menjadwalkan pemeriksaan status pompa setiap 10 menit (600 detik)
    Timer.periodic(Duration(minutes: 5), (Timer t) async {
      // Panggil fungsi untuk memeriksa status pompa dan menambah notifikasi jika perlu
      await checkPumpStatusAndAddNotification();
    });
  }

  /// Inisialisasi notifikasi
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/app_icon'); // Ganti dengan nama ikon aplikasi Anda

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Fungsi untuk memainkan notifikasi dengan suara khusus
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

  /// Menampilkan notifikasi kadar amoniak
  /// Menampilkan notifikasi kadar amoniak
  void _showAmmoniaNotification() {
    _showNotificationWithSound(
      'Peringatan Kadar Amoniak!',
      'Kadar amoniak telah mencapai ambang batas. Kolam akan dikuras secara otomatis.',
    );
  }

  /// Menjadwalkan notifikasi pemberian pakan otomatis
  void scheduleFeedingNotifications() {
    final now = DateTime.now();
    final scheduleTimes = [
      TimeOfDay(hour: 08, minute: 0),
      TimeOfDay(hour: 16, minute: 0),
      TimeOfDay(hour: 21, minute: 0),
    ];

    for (var time in scheduleTimes) {
      final scheduleDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduleDateTime.isAfter(now)) {
        _scheduleFeedingNotification(scheduleDateTime);
      }
    }
  }

  /// Menampilkan notifikasi pemberian pakan
  void _scheduleFeedingNotification(DateTime scheduleDateTime) {
    final secondsUntilScheduled =
        scheduleDateTime.difference(DateTime.now()).inSeconds;

    Future.delayed(Duration(seconds: secondsUntilScheduled), () {
      _showNotificationWithSound(
        'Pemberian Pakan Otomatis',
        'Waktu pemberian pakan otomatis telah tiba. Pakan sedang disalurkan sesuai jadwal yang telah diatur.',
      );
      addNotification('pakan',
          'Waktu pemberian pakan otomatis telah tiba. Pakan sedang disalurkan sesuai jadwal yang telah diatur.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(),
      MonitoringScreen(),
      InformasiScreen(),
      // ProfilScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? _buildSelectedIcon(Icons.home)
                : Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? _buildSelectedIcon(Icons.monitor)
                : Icon(Icons.monitor, size: 24),
            label: 'Monitoring',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? _buildSelectedIcon(Icons.info)
                : Icon(Icons.info, size: 24),
            label: 'Informasi',
          ),
          // BottomNavigationBarItem(
          //   icon: _selectedIndex == 3
          //       ? _buildSelectedIcon(Icons.person)
          //       : Icon(Icons.person, size: 24),
          //   label: 'Profil',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            TextStyle(color: Colors.black), // Warna teks tetap hitam
        unselectedLabelStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildSelectedIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorConstants.primaryColor,
        borderRadius: BorderRadius.circular(12), // Sudut melengkung
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
