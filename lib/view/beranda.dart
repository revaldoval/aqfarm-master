import 'package:flutter/material.dart';
import 'package:kolamleleiot/view/notifikasi.dart';
import '../grafik/kadar_amonia.dart';
import 'package:intl/intl.dart';
import '../custom/icon_notifikasi.dart';
import 'package:kolamleleiot/componen/collors.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../custom/feedcardwidget.dart';

class HomeScreen extends StatefulWidget {
  // final Function(int) onTapNotification;
  // HomeScreen({required this.onTapNotification});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late String currentTime;
  String suhu = "Loading...";
  String currentAmoniaLevel = "Loading...";
  String amoniaLevelText = "Loading...";

  double pagiFeedWeight = 0.0; // default 0.5
  double soreFeedWeight = 0.0; // default 0.5
  double malamFeedWeight = 0.0; // default 0.5

  // bool _malamSwitchValue = false;
  // double _malamWeight = 0.0;
  // bool _switchValueMalam = false;
  // double _beratPakanMalam = 1.0;

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
  void initState() {
    super.initState();
    _getSuhu();
    _getAmoniak();
    _getFeedWeight();
    _updateTime();
  }

  void _getSuhu() {
    _database.child('data/suhuAir').onValue.listen((event) {
      final String newSuhu = event.snapshot.value.toString();
      setState(() {
        suhu = newSuhu;
      });
    });
  }

  void _getAmoniak() {
    _database.child('data/amoniak').onValue.listen((DatabaseEvent event) {
      final String newAmoniak = event.snapshot.value.toString();
      setState(() {
        currentAmoniaLevel = newAmoniak;
        double amoniaValue = double.tryParse(currentAmoniaLevel) ?? 0.0;
        amoniaLevelText = (amoniaValue * 1).toStringAsFixed(0) + '%';
      });
    });
  }

  void _getFeedWeight() {
    // Ambil data berat pakan berdasarkan waktu dari Firebase
    _database
        .child('makanPagi/beratMakan')
        .onValue
        .listen((DatabaseEvent event) {
      final String makanPagi = event.snapshot.value.toString();
      double makanPagiWeight = double.tryParse(makanPagi) ?? 0.0; // default 0.5

      setState(() {
        pagiFeedWeight = makanPagiWeight;
      });
    });

    _database
        .child('makanSore/beratMakan')
        .onValue
        .listen((DatabaseEvent event) {
      final String makanSore = event.snapshot.value.toString();
      double makanSoreWeight = double.tryParse(makanSore) ?? 0.0; // default 0.5

      setState(() {
        soreFeedWeight = makanSoreWeight;
      });
    });

    _database
        .child('makanMalam/beratMakan')
        .onValue
        .listen((DatabaseEvent event) {
      final String makanMalam = event.snapshot.value.toString();
      double makanMalamWeight =
          double.tryParse(makanMalam) ?? 0.0; // default 0.5

      setState(() {
        malamFeedWeight = makanMalamWeight;
      });
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    // Format waktu ke dalam format 12 jam dengan AM/PM
    currentTime = DateFormat('hh:mm a').format(now); // Format 'a' untuk AM/PM
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil waktu saat ini
    // String currentTime = DateFormat('HH:mm').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorConstants.blackColor,
              ),
            ),
            // Text(
            //   "Johan",
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.w600,
            //     color: ColorConstants.blackColor,
            //   ),
            // ),
          ],
        ),
        // backgroundColor: ColorConstants.PutihBiruColor,
        backgroundColor: ColorConstants.BiruColor,

        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 20), // Menambahkan jarak 20 dari kanan
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NotifikasiScreen(), // Mengarahkan ke NotifikasiScreen
                  ),
                );
              },
              child: CustomNotificationIcon(
                hasNotification:
                    false, // Ganti dengan true atau false sesuai kondisi notifikasi
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: ColorConstants.gradientBackgroundColors,
            colors: ColorConstants.gradientBackgroundColorsBlue,
            // colors: [Color(0xFF62CDFA), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kadar Amonia",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.blackColor,
                        ),
                      ),
                    ),
                  ),
                  // Grafik kadar amonia dan Card Kadar Amonia
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Grafik kadar amonia
                      Container(
                        padding: const EdgeInsets.only(left: 40),
                        child: AmoniaChart(),
                      ),
                      SizedBox(width: 30),
                      // Card Kadar Amonia
                      Container(
                        width: 200,
                        child: Column(
                          children: [
                            Card(
                              color: ColorConstants.whiteColor,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.only(right: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentTime,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ColorConstants.greyColor,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Jarak antara teks dan garis
                                        Container(
                                          width: 44,
                                          height: 4,
                                          color: Color(
                                              0xFF5DCCFC), // Warna #5DCCFC
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Kadar Amonia",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "saat Ini",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          amoniaLevelText,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Card Kadar Amonia Info
                            Container(
                              width: 250,
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              "Pengurasan kolam akan dilakukan secara otomatis ketika kadar amonia mencapai ",
                                        ),
                                        TextSpan(
                                          text: "0,05 ppm",
                                          style: TextStyle(
                                            color: ColorConstants.redColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Suhu Air
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                        "Suhu Air",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Card Suhu Air
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(left: 30, right: 30, top: 5),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: ColorConstants.blackColor,
                                ),
                              ),
                              Text(
                                "Suhu Air " + suhu + "°C",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/gelombang.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          // left: 90,
                          right: 30,
                          child: Image.asset(
                            'assets/waterdrop.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          // left: 300,
                          right: 10,
                          child: Image.asset(
                            'assets/suhu air.png',
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                  ),
                  // Kartu Hari & Tanggal
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: Card(
                      color: Color(0xFF62CDFA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hari & Tanggal",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              DateFormat('EEEE, dd MMMM yyyy')
                                  .format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FeedCardWidget(
                    feedTime: "Pagi",
                    feedWeight: pagiFeedWeight,
                    initialSwitchValue: false,
                  ),
                  SizedBox(height: 5),
                  FeedCardWidget(
                    feedTime:
                        "Sore", // Waktu makan (Morning, Afternoon, Evening, etc.)
                    feedWeight: soreFeedWeight, // Berat pakan dalam kg
                    initialSwitchValue: false, // Status switch (ON atau OFF)
                  ),
                  SizedBox(height: 5),
                  FeedCardWidget(
                    feedTime:
                        "Malam", // Waktu makan (Morning, Afternoon, Evening, etc.)
                    feedWeight: malamFeedWeight, // Berat pakan dalam kg
                    initialSwitchValue: false, // Status switch (ON atau OFF)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
