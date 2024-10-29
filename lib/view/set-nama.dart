import 'package:flutter/material.dart';
import 'package:kolamleleiot/custom/bottom_navigation.dart';
import 'package:kolamleleiot/componen/collors.dart';

class SetNamaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Tambahkan SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100), // Jarak dari atas layar
              Center(
                child: Image.asset(
                  'assets/setnama.png',
                  width: 150, // Sesuaikan ukuran jika diperlukan
                  height: 150,
                ),
              ),
              SizedBox(
                  height: 50), // Jarak antara gambar dan teks "MASUKKAN NAMA"
              Text(
                "MASUKKAN NAMA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  height: 20), // Jarak antara "MASUKKAN NAMA" dan instruksi
              Text(
                "Silakan masukkan nama anda!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 50), // Jarak antara instruksi dan form nama
              TextField(
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30), // Spacer diganti untuk jaga jarak
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavigation()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ColorConstants.primaryColor, // Warna tombol
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
