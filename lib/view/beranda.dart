import 'package:flutter/material.dart';
import 'package:kolamleleiot/view/notifikasi.dart';
import '../grafik/kadar_amonia.dart';
import 'package:intl/intl.dart';
import '../custom/icon_notifikasi.dart';
import 'package:kolamleleiot/componen/collors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  // final Function(int) onTapNotification;
  // HomeScreen({required this.onTapNotification});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String suhu = "Loading...";
  String currentAmoniaLevel = "Loading...";
  String amoniaLevelText = "Loading...";

  bool _switchValuePagi = false;
  bool _switchValueSore = false;
  bool _switchValueMalam = false;

  double _beratPakanPagi = 1.0; // Nilai default 1kg
  double _beratPakanSore = 1.0; // Nilai default 1kg
  double _beratPakanMalam = 1.0; // Nilai default 1kg

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
  }

  void _getSuhu() {
    _database.child('suhu').onValue.listen((event) {
      final String newSuhu = event.snapshot.value.toString();
      setState(() {
        suhu = newSuhu;
      });
    });
  }

  void _getAmoniak() {
    _database.child('amoniak').onValue.listen((DatabaseEvent event) {
      final String newAmoniak = event.snapshot.value.toString();
      setState(() {
        currentAmoniaLevel = newAmoniak;
        double amoniaValue = double.tryParse(currentAmoniaLevel) ?? 0.0;
        amoniaLevelText = (amoniaValue * 1).toStringAsFixed(0) + '%';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil waktu saat ini
    String currentTime = DateFormat('HH:mm').format(DateTime.now());

    // // Menentukan nilai kadar amonia saat ini (ganti dengan nilai yang sesuai)
    // String currentAmoniaLevel = amoniak; // Contoh kadar amonia
    // String amoniaLevelText =
    //     currentAmoniaLevel.toString() + '%'; // Menghitung persen

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
            Text(
              "Johan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ColorConstants.blackColor,
              ),
            ),
          ],
        ),
        // backgroundColor: ColorConstants.PutihBiruColor,
        backgroundColor: ColorConstants.BiruColor,
        // backgroundColor: Color(0xFF62CDFA),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(
        //         right: 20), // Menambahkan jarak 20 dari kanan
        //     child: GestureDetector(
        //       onTap: () {
        //         widget.onTapNotification(2); // Ganti ke indeks notifikasi
        //       },
        //       child: CustomNotificationIcon(
        //         hasNotification:
        //             // false, // Ganti dengan true atau false sesuai kondisi notifikasi
        //             true,
        //       ),
        //     ),
        //   )
        // ],
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
                    true, // Ganti dengan true atau false sesuai kondisi notifikasi
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
                  // Header
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 20, top: 44, right: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             getGreeting(),
                  //             style: TextStyle(
                  //               fontSize: 14,
                  //               fontWeight: FontWeight.w500,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //           Text(
                  //             "Nama Pengguna",
                  //             style: TextStyle(
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.w600,
                  //               color: Colors.black,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           widget.onTapNotification(
                  //               2); // Ganti ke indeks notifikasi
                  //         },
                  //         child: Image.asset(
                  //           'assets/notifikasi icon.png', // Pastikan nama file benar
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Kadar Amonia
                  // SizedBox(height: 20),
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
                                    Text(
                                      currentTime,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.greyColor,
                                      ),
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
                                          "Saat Ini",
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
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        "Suhu Air : " + suhu,
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
                                "Suhu Air : " + suhu,
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

                  // pemberian pakan pagi
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width -
                            60, // Lebar menyesuaikan dengan lebar layar
                        margin: EdgeInsets.symmetric(
                            horizontal: 30), // Margin kiri dan kanan
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(15), // Padding untuk teks
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Menyelaraskan teks dan gambar secara vertikal
                                  children: [
                                    Text(
                                      "Pagi",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Jarak kecil antara teks dan gambar
                                    Image.asset(
                                      'assets/ic-pagi.png', // Path menuju gambar
                                      width: 24, // Lebar gambar
                                      height: 24, // Tinggi gambar
                                    ),
                                    Spacer(), // Menggunakan Spacer agar Switch berada di paling kanan
                                    // Teks status ON/OFF
                                    Text(
                                      _switchValuePagi
                                          ? "ON"
                                          : "OFF", // Menampilkan ON atau OFF berdasarkan status switch
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _switchValuePagi
                                            ? Colors.green
                                            : Colors
                                                .red, // Warna teks sesuai status
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Jarak antara teks dan switch
                                    Switch(
                                      value: _switchValuePagi,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValuePagi = value;
                                        });
                                      },
                                      activeColor: Colors
                                          .green, // Warna ketika switch dalam keadaan on
                                      inactiveThumbColor: Colors
                                          .red, // Warna ketika switch dalam keadaan off
                                      inactiveTrackColor: Colors
                                          .grey[300], // Warna track ketika off
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Center(
                                      // Menggunakan Center untuk menempatkan teks di tengah
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize:
                                                14, // Ukuran font default untuk seluruh teks
                                            color: Colors
                                                .black, // Warna default untuk seluruh teks
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Berat pakan yang diberikan ", // Teks berat pakan
                                              style: TextStyle(
                                                fontSize:
                                                    14, // Ukuran font untuk berat pakan
                                                color: Colors
                                                    .black, // Warna hitam untuk berat pakan
                                              ),
                                            ),
                                            TextSpan(
                                              text: "(kg)", // Teks kg
                                              style: TextStyle(
                                                fontSize:
                                                    12, // Ukuran font untuk kg
                                                color: Colors
                                                    .grey, // Warna abu untuk kg
                                                fontWeight: FontWeight
                                                    .w600, // Tebal untuk kg
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            20), // Jarak antara teks dan slider
                                    // Slider untuk memilih berat pakan
                                    Slider(
                                      value: _beratPakanPagi,
                                      min: 1,
                                      max: 5,
                                      divisions:
                                          4, // Membagi slider menjadi 4 step (1, 2, 3, 4, 5)
                                      label:
                                          "${_beratPakanPagi.toStringAsFixed(1)} kg", // Label di atas slider
                                      onChanged: (double value) {
                                        setState(() {
                                          _beratPakanPagi = value;
                                        });
                                      },
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.grey[300],
                                    ),
                                    Text(
                                      "Berat pakan: ${_beratPakanPagi.toStringAsFixed(1)} kg",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // pemberian pakan sore
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width -
                            60, // Lebar menyesuaikan dengan lebar layar
                        margin: EdgeInsets.symmetric(
                            horizontal: 30), // Margin kiri dan kanan
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(15), // Padding untuk teks
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Menyelaraskan teks dan gambar secara vertikal
                                  children: [
                                    Text(
                                      "Sore",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Jarak kecil antara teks dan gambar
                                    Image.asset(
                                      'assets/ic-sore.png', // Path menuju gambar
                                      width: 24, // Lebar gambar
                                      height: 24, // Tinggi gambar
                                    ),
                                    Spacer(), // Menggunakan Spacer agar Switch berada di paling kanan
                                    // Teks status ON/OFF
                                    Text(
                                      _switchValueSore
                                          ? "ON"
                                          : "OFF", // Menampilkan ON atau OFF berdasarkan status switch
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _switchValueSore
                                            ? Colors.green
                                            : Colors
                                                .red, // Warna teks sesuai status
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Jarak antara teks dan switch
                                    Switch(
                                      value: _switchValueSore,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueSore = value;
                                        });
                                      },
                                      activeColor: Colors
                                          .green, // Warna ketika switch dalam keadaan on
                                      inactiveThumbColor: Colors
                                          .red, // Warna ketika switch dalam keadaan off
                                      inactiveTrackColor: Colors
                                          .grey[300], // Warna track ketika off
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Center(
                                      // Menggunakan Center untuk menempatkan teks di tengah
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize:
                                                14, // Ukuran font default untuk seluruh teks
                                            color: Colors
                                                .black, // Warna default untuk seluruh teks
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Berat pakan yang diberikan ", // Teks berat pakan
                                              style: TextStyle(
                                                fontSize:
                                                    14, // Ukuran font untuk berat pakan
                                                color: Colors
                                                    .black, // Warna hitam untuk berat pakan
                                              ),
                                            ),
                                            TextSpan(
                                              text: "(kg)", // Teks kg
                                              style: TextStyle(
                                                fontSize:
                                                    12, // Ukuran font untuk kg
                                                color: Colors
                                                    .grey, // Warna abu untuk kg
                                                fontWeight: FontWeight
                                                    .w600, // Tebal untuk kg
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            20), // Jarak antara teks dan slider
                                    // Slider untuk memilih berat pakan
                                    Slider(
                                      value: _beratPakanSore,
                                      min: 1,
                                      max: 5,
                                      divisions:
                                          4, // Membagi slider menjadi 4 step (1, 2, 3, 4, 5)
                                      label:
                                          "${_beratPakanSore.toStringAsFixed(1)} kg", // Label di atas slider
                                      onChanged: (double value) {
                                        setState(() {
                                          _beratPakanSore = value;
                                        });
                                      },
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.grey[300],
                                    ),
                                    Text(
                                      "Berat pakan: ${_beratPakanSore.toStringAsFixed(1)} kg",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // pemberian pakan malam
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width -
                            60, // Lebar menyesuaikan dengan lebar layar
                        margin: EdgeInsets.symmetric(
                            horizontal: 30), // Margin kiri dan kanan
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(15), // Padding untuk teks
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Menyelaraskan teks dan gambar secara vertikal
                                  children: [
                                    Text(
                                      "Malam",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Jarak kecil antara teks dan gambar
                                    Image.asset(
                                      'assets/ic-malam.png', // Path menuju gambar
                                      width: 24, // Lebar gambar
                                      height: 24, // Tinggi gambar
                                    ),
                                    Spacer(), // Menggunakan Spacer agar Switch berada di paling kanan
                                    // Teks status ON/OFF
                                    Text(
                                      _switchValueMalam
                                          ? "ON"
                                          : "OFF", // Menampilkan ON atau OFF berdasarkan status switch
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _switchValueMalam
                                            ? Colors.green
                                            : Colors
                                                .red, // Warna teks sesuai status
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Jarak antara teks dan switch
                                    Switch(
                                      value: _switchValueMalam,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _switchValueMalam = value;
                                        });
                                      },
                                      activeColor: Colors
                                          .green, // Warna ketika switch dalam keadaan on
                                      inactiveThumbColor: Colors
                                          .red, // Warna ketika switch dalam keadaan off
                                      inactiveTrackColor: Colors
                                          .grey[300], // Warna track ketika off
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Center(
                                      // Menggunakan Center untuk menempatkan teks di tengah
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize:
                                                14, // Ukuran font default untuk seluruh teks
                                            color: Colors
                                                .black, // Warna default untuk seluruh teks
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Berat pakan yang diberikan ", // Teks berat pakan
                                              style: TextStyle(
                                                fontSize:
                                                    14, // Ukuran font untuk berat pakan
                                                color: Colors
                                                    .black, // Warna hitam untuk berat pakan
                                              ),
                                            ),
                                            TextSpan(
                                              text: "(kg)", // Teks kg
                                              style: TextStyle(
                                                fontSize:
                                                    12, // Ukuran font untuk kg
                                                color: Colors
                                                    .grey, // Warna abu untuk kg
                                                fontWeight: FontWeight
                                                    .w600, // Tebal untuk kg
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            10), // Jarak antara teks dan slider
                                    // Slider untuk memilih berat pakan
                                    Slider(
                                      value: _beratPakanMalam,
                                      min: 1,
                                      max: 5,
                                      divisions:
                                          4, // Membagi slider menjadi 4 step (1, 2, 3, 4, 5)
                                      label:
                                          "${_beratPakanMalam.toStringAsFixed(1)} kg", // Label di atas slider
                                      onChanged: (double value) {
                                        setState(() {
                                          _beratPakanMalam = value;
                                        });
                                      },
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.grey[300],
                                    ),
                                    Text(
                                      "Berat pakan: ${_beratPakanMalam.toStringAsFixed(1)} kg",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
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
