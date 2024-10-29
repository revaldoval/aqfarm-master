import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Tambahkan aksi untuk ikon pengaturan
              print("Settings clicked");
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil
              CircleAvatar(
                radius: 60, // Ukuran avatar
                backgroundImage: AssetImage(
                    'assets/defaut-profil.png'), // Ganti dengan gambar profil yang sesuai
              ),
              SizedBox(height: 10), // Jarak antara foto dan nama
              // Nama Pengguna
              Text(
                "Nama Pengguna", // Ganti dengan nama pengguna yang sesuai
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20), // Jarak antara nama dan tombol
              // Tombol Edit Profil
              SizedBox(
                width: double.infinity, // Lebar penuh
                height: 50, // Tinggi tetap
                child: ElevatedButton(
                  onPressed: () {
                    // Tambahkan aksi untuk tombol edit profil
                    print("Edit Profil clicked");
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Color(0xFF2A9D8F), // Warna latar belakang tombol
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Edit Profil",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                  height:
                      12), // Jarak antara tombol edit profil dan ubah kata sandi

// Tombol Ubah Kata Sandi
              SizedBox(
                width: double.infinity, // Lebar penuh
                height: 50, // Tinggi tetap
                child: ElevatedButton(
                  onPressed: () {
                    // Tambahkan aksi untuk tombol ubah kata sandi
                    print("Ubah Kata Sandi clicked");
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Color(0xFF62CDFA), // Warna latar belakang tombol
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Ubah Kata Sandi",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              Spacer(), // Mengisi ruang yang tersisa
              // Tombol Keluar
              TextButton(
                onPressed: () {
                  // tombol keluar
                  print("Keluar clicked");
                },
                child: Text(
                  "Keluar",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
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
