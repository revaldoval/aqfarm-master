import 'package:flutter/material.dart';
import 'package:kolamleleiot/view/set-nama.dart';
// import 'beranda.dart';
// import 'custom/bottom_navigation.dart';
import 'view/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash Screen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Panggil SplashScreen sebagai halaman pertama
      routes: {
        '/home': (context) => SetNamaScreen(), // Halaman setelah splash
      },
    );
  }
}
