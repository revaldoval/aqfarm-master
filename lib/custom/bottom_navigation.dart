import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:kolamleleiot/view/beranda.dart';
import 'package:kolamleleiot/view/informasi.dart';
import 'package:kolamleleiot/view/monitoring.dart';
import 'package:kolamleleiot/tidak%20terpakai/profil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  final DatabaseReference _ammoniaRef =
      FirebaseDatabase.instance.ref('data/amoniak');

  @override
  void initState() {
    super.initState();
    monitorAmmonia();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void monitorAmmonia() {
    _ammoniaRef.onValue.listen((DatabaseEvent event) {
      final value = event.snapshot.value;
      if (value != null) {
        final ammoniaLevel = int.tryParse(value.toString()) ?? 0;
        print("Kadar amoniak: $ammoniaLevel");
        if (ammoniaLevel > 100) {
          sendNotification(ammoniaLevel);
        }
      }
    });
  }

  Future<void> sendNotification(int ammoniaLevel) async {
    const String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/aq-farm/messages:send';
    final String serviceAccountKey = await DefaultAssetBundle.of(context)
        .loadString('assets/service_account_key.json');
    final Map<String, dynamic> serviceAccount = jsonDecode(serviceAccountKey);
    final String accessToken = await getAccessToken(serviceAccount);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = {
      "message": {
        "topic": "amoniakAlert",
        "notification": {
          "title": "Peringatan Kadar Amoniak!",
          "body":
              "Kadar amoniak sudah mencapai $ammoniaLevel. Segera lakukan tindakan.",
        },
        "data": {
          "amoniak": ammoniaLevel.toString(),
        },
      },
    };

    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Notifikasi berhasil dikirim!");
      } else {
        print("Gagal mengirim notifikasi: ${response.body}");
      }
    } catch (e) {
      print("Error saat mengirim notifikasi: $e");
    }
  }

  Future<String> getAccessToken(Map<String, dynamic> serviceAccount) async {
    final url = "https://oauth2.googleapis.com/token";
    final response = await http.post(
      Uri.parse(url),
      body: {
        "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "assertion": createJwt(serviceAccount),
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['access_token'];
    } else {
      throw Exception('Gagal mendapatkan token akses');
    }
  }

  String createJwt(Map<String, dynamic> serviceAccount) {
    final now = DateTime.now();
    final expiration = now.add(Duration(hours: 1));

    final jwt = JWT(
      {
        'iss': serviceAccount['client_email'],
        'scope': 'https://www.googleapis.com/auth/firebase.messaging',
        'aud': serviceAccount['token_uri'],
        'iat': now.millisecondsSinceEpoch ~/ 1000,
        'exp': expiration.millisecondsSinceEpoch ~/ 1000,
      },
    );

    final privateKey = serviceAccount['private_key'] as String;
    return jwt.sign(
      RSAPrivateKey(privateKey),
      algorithm: JWTAlgorithm.RS256,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(),
      MonitoringScreen(),
      InformasiScreen(),
      ProfilScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF62CDFA), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor, size: 24),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info, size: 24),
              label: 'Informasi',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
