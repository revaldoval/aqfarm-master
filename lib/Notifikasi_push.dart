// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// class NotifikasiPush extends StatefulWidget {
//   @override
//   NotifikasiPushState createState() => NotifikasiPushState();
// }

// class NotifikasiPushState extends State<NotifikasiPush> {
//   final DatabaseReference _ammoniaRef =
//       FirebaseDatabase.instance.ref('data/amoniak');
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFirebase();
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     _initializeNotifications();
//     monitorAmmonia();
//     scheduleFeedingNotifications();
//     // _initializeNotifications();
//   }

//   // Inisialisasi Firebase
//   Future<void> _initializeFirebase() async {
//     try {
//       await Firebase.initializeApp();
//       print("Firebase berhasil terhubung.");
//       _configureFirebaseMessaging();
//       _initializeFirestore();
//     } catch (e) {
//       print("Gagal terhubung ke Firebase: $e");
//     }
//   }

//   // Inisialisasi Firestore
//   void _initializeFirestore() async {
//     try {
//       await FirebaseFirestore.instance.collection('notifications').get();
//       print("Firebase Firestore berhasil terhubung.");
//     } catch (e) {
//       print("Gagal terhubung ke Firestore: $e");
//     }
//   }

//   // Inisialisasi notifikasi
//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         final String? payload = response.payload;
//         if (payload != null) {
//           print('Payload dari notifikasi: $payload');
//         }
//       },
//     );

//     print("Notifikasi telah diinisialisasi.");
//   }

//   // Konfigurasi Firebase Messaging
//   void _configureFirebaseMessaging() {
//     // Handle notifikasi saat aplikasi di foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Notifikasi diterima di foreground: ${message.notification}');
//       if (message.notification != null) {
//         _handleNotification(message.notification!);
//       }
//     });

//     // Handle notifikasi saat aplikasi di background atau terminated
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   // Fungsi untuk menangani notifikasi FCM
//   Future<void> _handleNotification(RemoteNotification notification) async {
//     final firestore = FirebaseFirestore.instance;
//     final notificationId = DateTime.now().millisecondsSinceEpoch.toString();

//     try {
//       final docSnapshot =
//           await firestore.collection('notifications').doc(notificationId).get();
//       print("Mengecek dokumen dengan ID: $notificationId");

//       if (!docSnapshot.exists) {
//         await firestore.collection('notifications').doc(notificationId).set({
//           'id_notifikasi': notificationId,
//           'title': notification.title,
//           'body': notification.body,
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         print("Notifikasi berhasil ditambahkan ke Firestore: $notificationId");
//       } else {
//         print("Notifikasi dengan ID tersebut sudah ada.");
//       }
//     } catch (e) {
//       print("Gagal menambahkan notifikasi ke Firestore: $e");
//     }
//   }

//   // Fungsi background handler untuk notifikasi FCM
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     print('Handling background notification: ${message.notification}');
//     if (message.notification != null) {
//       final firestore = FirebaseFirestore.instance;
//       final notificationId = DateTime.now().millisecondsSinceEpoch.toString();

//       try {
//         await firestore.collection('notifications').add({
//           'id_notifikasi': notificationId,
//           'title': message.notification?.title,
//           'body': message.notification?.body,
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         print(
//             "Notifikasi berhasil ditambahkan ke Firestore (background): $notificationId");
//       } catch (e) {
//         print("Gagal menambahkan notifikasi ke Firestore (background): $e");
//       }
//     }
//   }

//   // Memantau kadar amoniak
//   void monitorAmmonia() {
//     _ammoniaRef.onValue.listen((DatabaseEvent event) {
//       final value = event.snapshot.value;
//       if (value == null) {
//         print("Data amoniak tidak tersedia.");
//         return;
//       }
//       final ammoniaLevel = int.tryParse(value.toString());
//       if (ammoniaLevel == null) {
//         print("Format data amoniak tidak valid: $value");
//         return;
//       }

//       print(
//           "Kadar amoniak saat ini: $ammoniaLevel"); // Tambahkan log untuk debugging

//       if (ammoniaLevel > 100) {
//         _showAmmoniaNotification(ammoniaLevel);
//         _scheduleWaterFillingNotification();
//       }
//     });
//   }

//   // Fungsi untuk memainkan notifikasi dengan suara khusus
//   Future<void> _showNotificationWithSound(String title, String body) async {
//     try {
//       final notificationId =
//           (title.hashCode ^ DateTime.now().millisecondsSinceEpoch) & 0x7FFFFFFF;

//       final androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'custom_sound_channel',
//         'Notifikasi Suara Khusus',
//         channelDescription: 'Notifikasi dengan suara khusus',
//         sound: RawResourceAndroidNotificationSound('rezalele'),
//         importance: Importance.high,
//         priority: Priority.high,
//         playSound: true,
//       );

//       final platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//       );

//       await flutterLocalNotificationsPlugin.show(
//         notificationId,
//         title,
//         body,
//         platformChannelSpecifics,
//       );

//       print("Notifikasi berhasil diputar dengan suara '$title'.");
//     } catch (e) {
//       print("Gagal memutar suara notifikasi: $e");
//     }
//   }

//   // Menampilkan notifikasi kadar amoniak
//   void _showAmmoniaNotification(int ammoniaLevel) {
//     _showNotificationWithSound(
//       'Kadar Amoniak Telah Mencapai Batas!',
//       'Pengurasan air kolam sedang berlangsung karena kadar amonia telah mencapai batas 0,05 ppm ($ammoniaLevel). Proses ini akan selesai dalam beberapa saat.',
//     );
//   }

//   // Menjadwalkan notifikasi pengisian air setelah 10 detik
//   void _scheduleWaterFillingNotification() {
//     Future.delayed(Duration(seconds: 10), () {
//       _showNotificationWithSound(
//         'Pengisian Air Kolam',
//         'Pengisian air kolam telah dimulai untuk menjaga kualitas air. Mohon pastikan semua sistem berjalan dengan baik selama proses ini.',
//       );
//     });
//   }

//   // Menjadwalkan notifikasi pemberian pakan otomatis
//   void scheduleFeedingNotifications() {
//     final now = DateTime.now();
//     final scheduleTimes = [
//       TimeOfDay(hour: 6, minute: 0),
//       TimeOfDay(hour: 12, minute: 0),
//       TimeOfDay(hour: 18, minute: 0),
//     ];

//     for (var time in scheduleTimes) {
//       var scheduleDateTime = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         time.hour,
//         time.minute,
//       );

//       if (scheduleDateTime.isBefore(now)) {
//         scheduleDateTime = scheduleDateTime.add(Duration(days: 1));
//       }

//       _scheduleFeedingNotification(scheduleDateTime);
//     }
//   }

//   // Menampilkan notifikasi pemberian pakan
//   void _scheduleFeedingNotification(DateTime scheduleDateTime) {
//     final secondsUntilScheduled =
//         scheduleDateTime.difference(DateTime.now()).inSeconds;

//     Future.delayed(Duration(seconds: secondsUntilScheduled), () {
//       _showNotificationWithSound(
//         'Pemberian Pakan Otomatis',
//         'Waktu pemberian pakan otomatis telah tiba. Pakan sedang disalurkan sesuai jadwal yang telah diatur.',
//       );
//     });

//     print("Notifikasi pakan dijadwalkan pada $scheduleDateTime.");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Notifikasi Push"),
//       ),
//       body: Center(
//         child: Text(
//           "Notifikasi push sedang berjalan di background.",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
