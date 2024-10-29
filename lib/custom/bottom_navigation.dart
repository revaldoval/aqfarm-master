import 'package:flutter/material.dart';
import 'package:kolamleleiot/view/beranda.dart';
import 'package:kolamleleiot/view/informasi.dart';
import 'package:kolamleleiot/view/monitoring.dart';
import 'package:kolamleleiot/view/profil.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Mengubah tampilan berdasarkan indeks yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(
          // onTapNotification: _onItemTapped, // Panggil _onItemTapped langsung
          ),
      MonitoringScreen(),
      InformasiScreen(),
      ProfilScreen(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF62CDFA),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/ic-home.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 0 ? Colors.black : Colors.grey[600],
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/ic-monitoring.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 1 ? Colors.black : Colors.grey[600],
              ),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/ic-notification.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 2 ? Colors.black : Colors.grey[600],
              ),
              label: 'Informasi',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/ic-profil.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 3 ? Colors.black : Colors.grey[600],
              ),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[600],
        ),
      ),
    );
  }
}
