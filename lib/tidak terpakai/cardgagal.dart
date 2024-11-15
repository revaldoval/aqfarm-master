                  // SizedBox(height: 5),
                  // // pemberian pakan malam
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Container(
                  //       width: MediaQuery.of(context).size.width -
                  //           60, // Lebar menyesuaikan dengan lebar layar
                  //       margin: EdgeInsets.symmetric(
                  //           horizontal: 30), // Margin kiri dan kanan
                  //       child: Card(
                  //         color: Colors.white,
                  //         elevation: 4,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Padding(
                  //           padding:
                  //               const EdgeInsets.all(15), // Padding untuk teks
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Row(
                  //                 crossAxisAlignment: CrossAxisAlignment
                  //                     .center, // Menyelaraskan teks dan gambar secara vertikal
                  //                 children: [
                  //                   Text(
                  //                     "Malam",
                  //                     style: TextStyle(
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.grey,
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                       width:
                  //                           5), // Jarak kecil antara teks dan gambar
                  //                   Image.asset(
                  //                     'assets/ic-malam.png', // Path menuju gambar
                  //                     width: 24, // Lebar gambar
                  //                     height: 24, // Tinggi gambar
                  //                   ),
                  //                   Spacer(), // Menggunakan Spacer agar Switch berada di paling kanan
                  //                   // Teks status ON/OFF
                  //                   Text(
                  //                     _switchValueMalam
                  //                         ? "ON"
                  //                         : "OFF", // Menampilkan ON atau OFF berdasarkan status switch
                  //                     style: TextStyle(
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: _switchValueMalam
                  //                           ? Colors.green
                  //                           : Colors
                  //                               .red, // Warna teks sesuai status
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                       width:
                  //                           10), // Jarak antara teks dan switch
                  //                   Switch(
                  //                     value: _switchValueMalam,
                  //                     onChanged: (bool value) {
                  //                       setState(() {
                  //                         _switchValueMalam = value;
                  //                       });
                  //                     },
                  //                     activeColor: Colors
                  //                         .green, // Warna ketika switch dalam keadaan on
                  //                     inactiveThumbColor: Colors
                  //                         .red, // Warna ketika switch dalam keadaan off
                  //                     inactiveTrackColor: Colors
                  //                         .grey[300], // Warna track ketika off
                  //                   ),
                  //                 ],
                  //               ),
                  //               Column(
                  //                 children: [
                  //                   Center(
                  //                     // Menggunakan Center untuk menempatkan teks di tengah
                  //                     child: RichText(
                  //                       text: TextSpan(
                  //                         style: TextStyle(
                  //                           fontSize:
                  //                               14, // Ukuran font default untuk seluruh teks
                  //                           color: Colors
                  //                               .black, // Warna default untuk seluruh teks
                  //                         ),
                  //                         children: [
                  //                           TextSpan(
                  //                             text:
                  //                                 "Berat pakan yang diberikan ", // Teks berat pakan
                  //                             style: TextStyle(
                  //                               fontSize:
                  //                                   14, // Ukuran font untuk berat pakan
                  //                               color: Colors
                  //                                   .black, // Warna hitam untuk berat pakan
                  //                             ),
                  //                           ),
                  //                           TextSpan(
                  //                             text: "(kg)", // Teks kg
                  //                             style: TextStyle(
                  //                               fontSize:
                  //                                   12, // Ukuran font untuk kg
                  //                               color: Colors
                  //                                   .grey, // Warna abu untuk kg
                  //                               fontWeight: FontWeight
                  //                                   .w600, // Tebal untuk kg
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                       height:
                  //                           10), // Jarak antara teks dan slider
                  //                   // Slider untuk memilih berat pakan
                  //                   Slider(
                  //                     value: _beratPakanMalam,
                  //                     min: 1,
                  //                     max: 5,
                  //                     divisions:
                  //                         4, // Membagi slider menjadi 4 step (1, 2, 3, 4, 5)
                  //                     label:
                  //                         "${_beratPakanMalam.toStringAsFixed(1)} kg", // Label di atas slider
                  //                     onChanged: (double value) {
                  //                       setState(() {
                  //                         _beratPakanMalam = value;
                  //                       });
                  //                     },
                  //                     activeColor: Colors.green,
                  //                     inactiveColor: Colors.grey[300],
                  //                   ),
                  //                   Text(
                  //                     "Berat pakan: ${_beratPakanMalam.toStringAsFixed(1)} kg",
                  //                     style: TextStyle(
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.w500,
                  //                       color: Colors.black,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(height: 20),
                  //   ],
                  // ),