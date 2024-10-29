import 'package:flutter/material.dart';
import 'package:kolamleleiot/componen/collors.dart';
import 'package:firebase_database/firebase_database.dart';

class InformasiScreen extends StatefulWidget {
  @override
  _InformasiScreenState createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  String? selectedBibit;
  final List<String> jumlahBibit = [
    "50",
    "100",
    "150",
    "200",
    "250",
    "300",
    "350",
    "400",
    "450",
    "500",
    "550",
    "600",
    "650",
    "700",
    "750",
    "800",
    "850",
    "900",
    "950",
    "1000"
  ];

  // Reference to the Realtime Database
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Function to update value in Firebase Realtime Database
  Future<void> updateFishQuantity() async {
    if (selectedBibit != null) {
      try {
        int selectedQuantity = int.parse(selectedBibit!); // Convert to integer
        await _database.child('ikan').set(selectedQuantity); // Send as integer
        print(
            "Data sent successfully: $selectedQuantity"); // Confirmation output
      } catch (e) {
        print("Error sending data: $e"); // Error output
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a fish quantity before saving.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // Align content at the top
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Card(
              margin: EdgeInsets.symmetric(
                  horizontal: 10.0), // Jarak 30 dari kiri dan kanan layar
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Radius sudut
              ),
              color: ColorConstants.primaryColor, // Warna Card
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Menyebar konten secara horizontal
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Mengatur posisi teks ke kiri
                      children: [
                        Text(
                          "35 Hari",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Usia Ikan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        // SizedBox(height: 10),
                        Text(
                          "100% Target tercapai",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    // Child: CircularProgressIndicator berada di kanan
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: 0.4, // 40%
                            strokeWidth: 10,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        Text(
                          "40%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
            // Instructional Text
            Text(
              "Silakan masukkan jumlah bibit ikan yang akan dimasukkan ke dalam kolam untuk memudahkan dalam pemberian pakan.",
              style: TextStyle(
                fontSize: 14.0,
                color: ColorConstants.greyColor,
              ),
              textAlign: TextAlign.center, // Correct placement of textAlign
            ),
            SizedBox(height: 50),
            // Dropdown for selecting jumlah bibit ikan
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: selectedBibit,
                hint: Text("Jumlah bibit ikan"),
                isExpanded: true,
                underline: SizedBox(),
                items: jumlahBibit.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedBibit = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 50),
            // Setting button
            ElevatedButton(
              onPressed: updateFishQuantity, // Call function directly
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Adjust your color here if needed
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                "SETTING",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
