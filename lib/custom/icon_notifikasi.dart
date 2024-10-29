import 'package:flutter/material.dart';
import 'package:kolamleleiot/componen/collors.dart';

class CustomNotificationIcon extends StatelessWidget {
  final bool hasNotification; // Boolean untuk status notifikasi

  // Constructor untuk menerima status notifikasi
  CustomNotificationIcon({required this.hasNotification});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstants.whiteColor,
          ),
          child: Center(
            child: Icon(
              Icons.notifications,
              color: ColorConstants.BiruColor,
              size: 24,
            ),
          ),
        ),
        // Jika hasNotification true, tampilkan titik merah
        if (hasNotification)
          Positioned(
            right: 2, // Posisi titik merah
            top: 2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: ColorConstants.redColor, // Warna titik merah
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
