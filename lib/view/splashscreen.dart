import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart'; // Tambahkan import untuk animasi teks

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatAnimation;
  bool _showText =
      false; // Tambahkan variabel ini untuk mengontrol kapan teks muncul

  @override
  void initState() {
    super.initState();

    // Inisialisasi AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // Animasi pergerakan logo dari bawah ke tengah
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 2), // Mulai dari luar layar di bawah
      end: Offset(0, 0), // Berhenti di tengah
    )
        .chain(CurveTween(
            curve: Curves
                .fastOutSlowIn)) // Ubah curve untuk mempercepat gerakan ke tengah
        .animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 0.5,
              curve: Curves
                  .fastOutSlowIn), // Bagian 0.0 - 0.5 untuk mempercepat ke tengah
        ));

    // Animasi melayang di tengah (perbesar jaraknya)
    _floatAnimation =
        Tween<double>(begin: 0.0, end: -25.0) // Perbesar jarak melayang
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(CurvedAnimation(
              parent: _controller,
              curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
            ));

    _controller.forward();

    // Mengatur reverse animasi agar logo terus melayang
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // Tampilkan teks setelah animasi selesai
    // Timer(Duration(seconds: 3), () {
    //   setState(() {
    //     _showText = true;
    //   });
    // });

    // Timer untuk pindah ke halaman berikutnya setelah animasi
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed(
          '/home'); // Ganti dengan route ke halaman berikutnya
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)],
              colors: [Color(0xFF62CDFA), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 48,
                top: 81,
                child: Image.asset('assets/Logo-splash-screen.png'),
              ),
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Padding(
              //     padding: EdgeInsets.only(top: 81),
              //     child: Image.asset('assets/logo aquafarm.png'),
              //   ),
              // ),
              // Logo animasi melayang di tengah
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset('assets/Logo-splash.png',
                      width: 300, height: 300),
                ),
              ),
              // Animasi teks muncul setelah logo melayang
              // if (_showText)
              //   Positioned(
              //     bottom: 250, // Teks muncul di bagian bawah layar
              //     left: 0,
              //     right: 0,
              //     child: Center(
              //       child: AnimatedTextKit(
              //         animatedTexts: [
              //           TypewriterAnimatedText(
              //             'Selamat datang di aplikasi Kolam Lele',
              //             // textStyle: TextStyle(
              //             //   fontSize: 15.0,
              //             //   fontWeight: FontWeight.bold,
              //             //   color: Colors.black,
              //             // ),
              //             speed: Duration(
              //                 milliseconds: 100), // Kecepatan animasi mengetik
              //           ),
              //         ],
              //         totalRepeatCount: 1, // Hanya sekali mengetik
              //       ),
              //     ),
              //   ),
            ],
          ),
        ));
  }
}
