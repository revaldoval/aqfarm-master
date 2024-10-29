// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class MonitoringScreen extends StatefulWidget {
//   @override
//   _MonitoringScreenState createState() => _MonitoringScreenState();
// }

// class _MonitoringScreenState extends State<MonitoringScreen> {
//   late YoutubePlayerController _controller1;

//   @override
//   void initState() {
//     super.initState();
//     // URL video dari YouTube
//     final videoId1 = YoutubePlayer.convertUrlToId(
//         "https://youtu.be/N1jiCKMMgeA?feature=shared");

//     // Inisialisasi controller dengan video ID
//     _controller1 = YoutubePlayerController(
//       initialVideoId: videoId1!,
//       flags: YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller1.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Monitor Kamera",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Card untuk video pertama
//               Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Kamera 1 : Amoniak Sensor",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       YoutubePlayer(
//                         controller: _controller1,
//                         showVideoProgressIndicator: true,
//                         progressIndicatorColor: Color(0xFF62CDFA),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Card untuk informasi
//               Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Informasi Sensor Amoniak",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         "Sensor Amoniak digunakan untuk memantau tingkat amonia dalam air. "
//                         "Tingkat amonia yang tinggi dapat berbahaya bagi kehidupan akuatik. "
//                         "Sensor ini memberikan informasi real-time tentang kualitas air.",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         "Tips Pemantauan:",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         "- Pastikan sensor bersih dan berfungsi dengan baik.\n"
//                         "- Lakukan kalibrasi secara berkala.\n"
//                         "- Perhatikan perubahan mendadak pada data amonia.",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:kolamleleiot/componen/collors.dart';

class MonitoringScreen extends StatefulWidget {
  @override
  _MonitoringScreenState createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  late YoutubePlayerController _controller1;

  @override
  void initState() {
    super.initState();
    // URL video dari YouTube
    final videoId1 = YoutubePlayer.convertUrlToId(
        "https://youtu.be/N1jiCKMMgeA?feature=shared");

    // Inisialisasi controller dengan video ID
    _controller1 = YoutubePlayerController(
      initialVideoId: videoId1!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monitor Kamera",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Tambahkan SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card untuk video pertama
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kamera 1 : Amoniak Sensor",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      YoutubePlayer(
                        controller: _controller1,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Color(0xFF62CDFA),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Card untuk informasi
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Informasi Sensor Amoniak",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Sensor Amoniak digunakan untuk memantau tingkat amonia dalam air. "
                        "Tingkat amonia yang tinggi dapat berbahaya bagi kehidupan akuatik. "
                        "Sensor ini memberikan informasi real-time tentang kualitas air.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Tips Pemantauan:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "- Pastikan sensor bersih dan berfungsi dengan baik.\n"
                        "- Lakukan kalibrasi secara berkala.\n"
                        "- Perhatikan perubahan mendadak pada data amonia.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Tindakan yang diinginkan ketika tombol ditekan
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorConstants.primaryColor, // Warna tombol
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Pelajari Lebih Lanjut",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
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
