import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kolamleleiot/custom/AlertDialog.dart';
import 'package:kolamleleiot/custom/popup.dart';
import 'package:kolamleleiot/main.dart';

class CircularProgressText extends StatefulWidget {
  final VoidCallback? onHarvest; // Callback untuk memanggil fungsi panen

  const CircularProgressText({Key? key, this.onHarvest}) : super(key: key);

  @override
  _CircularProgressTextState createState() => _CircularProgressTextState();
}

class _CircularProgressTextState extends State<CircularProgressText> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  int usiaIkan = 0;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    // Berlangganan ke perubahan data Firebase
    _subscription = FirebaseDatabase.instance
        .ref('informasiLele/usiaIkan')
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        final newValue = int.tryParse(data.toString()) ?? 0;
        if (newValue != usiaIkan) {
          setState(() {
            usiaIkan = newValue;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // Membatalkan langganan saat widget dihapus
    _subscription.cancel();
    super.dispose();
  }

  // Method untuk menghitung progress berdasarkan usia ikan
  double calculateProgress(int usiaIkan) {
    return (usiaIkan >= 90) ? 1.0 : (usiaIkan / 90.0);
  }

  // Method untuk menghitung persentase usia ikan
  int calculatePercentage(int usiaIkan) {
    double percentage = (usiaIkan >= 90) ? 100.0 : (usiaIkan / 90.0) * 100;
    return percentage.round(); // Mengembalikan nilai integer dengan pembulatan
  }

  @override
  Widget build(BuildContext context) {
    print('Building widget with usiaIkan: $usiaIkan'); // Debug
    final progress = calculateProgress(usiaIkan);
    final percentage =
        calculatePercentage(usiaIkan); // Pastikan ini menghasilkan angka
    final text = "$percentage%";

    // Mengecek apakah persentase telah mencapai 100%
    final isHarvestable =
        percentage >= 100; // Pastikan `percentage` adalah angka (int/double)

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 12, // Menyesuaikan ketebalan
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
                height: 4), // Jarak kecil antara persentase dan teks Panen
            GestureDetector(
              onTap: isHarvestable
                  ? () async {
                      bool? result = await CancellationDialog.show(
                        context,
                        message:
                            "Apakah kamu yakin ingin memanen lele?", // Custom message
                      );
                      if (result == true) {
                        if (widget.onHarvest != null) {
                          widget
                              .onHarvest!(); // Memanggil callback yang diberikan
                        }
                        print("Panen button pressed");
                      } else {
                        print("User canceled the dialog");
                      }
                    }
                  : null,
              child: Text(
                "Panen",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: isHarvestable
                      ? FontWeight.bold // Gaya bold jika sudah 100%
                      : FontWeight.w400, // Gaya normal jika belum 100%
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
