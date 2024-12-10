// import 'package:flutter/material.dart';
// import 'package:kolamleleiot/componen/collors.dart';
// import 'package:kolamleleiot/view/beranda.dart';
// import 'package:kolamleleiot/view/informasi.dart';
// import 'package:kolamleleiot/view/monitoring.dart';
// // import 'package:kolamleleiot/view/profil.dart';
// // import 'package:kolamleleiot/componen/collors.dart';

// class BottomNavigation extends StatefulWidget {
//   @override
//   _BottomNavigationState createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = [
//       HomeScreen(),
//       MonitoringScreen(),
//       InformasiScreen(),
//       // ProfilScreen(),
//     ];

//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 0
//                 ? _buildSelectedIcon(Icons.home)
//                 : Icon(Icons.home, size: 24),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 1
//                 ? _buildSelectedIcon(Icons.monitor)
//                 : Icon(Icons.monitor, size: 24),
//             label: 'Monitoring',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 2
//                 ? _buildSelectedIcon(Icons.info)
//                 : Icon(Icons.info, size: 24),
//             label: 'Informasi',
//           ),
//           // BottomNavigationBarItem(
//           //   icon: _selectedIndex == 3
//           //       ? _buildSelectedIcon(Icons.person)
//           //       : Icon(Icons.person, size: 24),
//           //   label: 'Profil',
//           // ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.black,
//         showUnselectedLabels: true,
//         type: BottomNavigationBarType.fixed,
//         selectedLabelStyle:
//             TextStyle(color: Colors.black), // Warna teks tetap hitam
//         unselectedLabelStyle: TextStyle(color: Colors.black),
//       ),
//     );
//   }

//   Widget _buildSelectedIcon(IconData icon) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: ColorConstants.primaryColor,
//         borderRadius: BorderRadius.circular(12), // Sudut melengkung
//       ),
//       child: Icon(icon, color: Colors.white, size: 24),
//     );
//   }
// }