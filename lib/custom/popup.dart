import 'package:flutter/material.dart';
import 'package:kolamleleiot/componen/collors.dart';
import 'package:kolamleleiot/custom/bottom_navigation.dart';
import 'package:kolamleleiot/tidak%20terpakai/profil.dart';
import 'package:kolamleleiot/view/informasi.dart';

class StatusPopup extends StatefulWidget {
  final String message;
  final bool isSuccess; // Menambahkan parameter untuk menentukan status

  StatusPopup({
    this.message = "Tindakan berhasil dilakukan!",
    this.isSuccess = true, // Default adalah success
  });

  @override
  State<StatusPopup> createState() => _StatusPopupState();
}

class _StatusPopupState extends State<StatusPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isSuccess
                  ? Icons.check_circle
                  : Icons.error, // Mengubah ikon sesuai status
              color: widget.isSuccess
                  ? Colors.green
                  : Colors.red, // Mengubah warna sesuai status
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              widget.isSuccess
                  ? 'Berhasil'
                  : 'Gagal', // Mengubah teks sesuai status
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.isSuccess ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Kosongkan isi setState hanya untuk memicu refresh
                });
                Navigator.pop(
                    context); // Menutup halaman saat ini dan kembali ke halaman sebelumnya
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isSuccess ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(200, 50),
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
