import 'package:flutter/material.dart';
import 'package:kolamleleiot/view/beranda.dart';
import 'package:kolamleleiot/view/informasi.dart';
import 'package:kolamleleiot/view/monitoring.dart';
import 'package:kolamleleiot/tidak%20terpakai/profil.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(),
      // MonitoringScreen(),
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
              icon: Icon(Icons.home, size: 24),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.monitor, size: 24),
            //   label: 'Monitoring',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info, size: 24),
              label: 'Informasi',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person, size: 24),
            //   label: 'Profil',
            // ),
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
