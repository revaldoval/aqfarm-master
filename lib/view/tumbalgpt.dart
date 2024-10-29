// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class FishDropdown extends StatefulWidget {
//   @override
//   _FishDropdownState createState() => _FishDropdownState();
// }

// class _FishDropdownState extends State<FishDropdown> {
//   String? selectedBibit;
//   final List<String> jumlahBibit = ["10", "20", "30", "40"];

//   // Reference to the Realtime Database
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();

//   // Function to update value in Firebase Realtime Database
//   Future<void> updateFishQuantity(String? newQuantity) async {
//     if (newQuantity != null) {
//       await _database.child('fishData/jumlahBibit').set(newQuantity);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 10.0),
//           padding: EdgeInsets.symmetric(horizontal: 15.0),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black54),
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: DropdownButton<String>(
//             value: selectedBibit,
//             hint: Text("Jumlah bibit ikan"),
//             isExpanded: true,
//             underline: SizedBox(),
//             items: jumlahBibit.map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (newValue) {
//               setState(() {
//                 selectedBibit = newValue;
//               });
//             },
//           ),
//         ),
//         SizedBox(height: 20), // Spacing between dropdown and button
//         ElevatedButton(
//           onPressed: () {
//             updateFishQuantity(selectedBibit); // Save to Firebase when button is pressed
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: ColorConstants.primaryColor, // Button color
//             padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//           ),
//           child: Text(
//             "SETTING",
//             style: TextStyle(fontSize: 16.0, color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }
// }
