import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kolamleleiot/Notifikasi_push.dart';
import 'package:kolamleleiot/custom/bottom_navigation.dart';
import 'package:kolamleleiot/view/splashscreen.dart';

// Inisialisasi notifikasi lokal
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Fungsi untuk menangani pesan FCM saat aplikasi di background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Pesan diterima di background: ${message.notification?.title}');
}

// Fungsi untuk menampilkan notifikasi lokal
void _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'Your channel description',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformDetails,
    payload: 'item x',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Konfigurasi notifikasi lokal
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Konfigurasi Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Mendengarkan pesan yang diterima di foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Pesan diterima di foreground: ${message.notification?.title}');
    if (message.notification != null) {
      // Menampilkan notifikasi lokal saat pesan diterima
      _showNotification(message);
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kolam Lele',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      routes: {'/home': (context) => BottomNavigation()},
    );
  }
}
