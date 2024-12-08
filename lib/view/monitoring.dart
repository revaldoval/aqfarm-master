import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
          "Monitor",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Teks Deskripsi
            Text(
              "Anda dapat memonitor kamera secara real-time",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            // Card untuk Video
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                child: YoutubePlayer(
                  controller: _controller1,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Color(0xFF62CDFA),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Kamera
            // CustomButton(
            //   icon: Icons.camera_alt,
            //   text: "Kamera",
            //   isActive: true,
            // ),
            // const SizedBox(height: 10),
            // // Tombol Lampu
            // CustomButton(
            //   icon: Icons.lightbulb,
            //   text: "Lampu",
            //   isActive: true,
            // ),
          ],
        ),
      ),
    );
  }
}

// Widget CustomButton untuk Kamera dan Lampu
class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isActive;

  const CustomButton({
    required this.icon,
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF0B7FB5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              isActive ? Icons.check_circle : Icons.radio_button_unchecked,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
