import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kolamleleiot/view/splashscreen.dart';
import 'package:kolamleleiot/custom/bottom_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Meminta izin untuk notifikasi (terutama untuk iOS)
  NotificationSettings settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Pengguna memberikan izin notifikasi');
  } else {
    print('Pengguna menolak izin notifikasi');
  }

  // Mendapatkan token perangkat FCM
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Mendaftarkan perangkat ke topik untuk menerima notifikasi
  await FirebaseMessaging.instance.subscribeToTopic("amoniakAlert");

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Penanganan notifikasi di latar depan
    if (message.notification != null) {
      print('Notifikasi di latar depan diterima: ${message.notification?.title}');
      // Tampilkan notifikasi atau update UI sesuai kebutuhan
    }
  });

  runApp(MyApp());
}

// Penanganan pesan di background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Notifikasi background diterima: ${message.notification?.title}');
  // Kamu bisa menambahkan logika untuk menangani pesan di background di sini
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kolam Lele',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => BottomNavigation(),
      },
    );
  }
}
