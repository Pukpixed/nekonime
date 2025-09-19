import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'second_screen.dart';
import 'package:nekonime/colors.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    // Splash 20 วิแล้วไปหน้า SecondScreen
    Timer(const Duration(seconds: 20), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SecondScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 40, 218, 246),
              AppColors.pastelPink,
            ],
          ),
        ),
        child: Column(
          children: [
            /// ส่วนบน โลโก้
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Image(
                image: AssetImage('assets/icon/nekonime.png'),
                width: 150,
              ),
            ),

            /// ตรงกลาง Loader
            const Expanded(
              child: Center(
                child: SpinKitSpinningLines(
                  color: AppColors.pastelPurple,
                  size: 60,
                ),
              ),
            ),

            /// ข้อความเหนือแบนเนอร์ (ชิดซ้าย)
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Watch Anime with NekoNime",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ส่วนล่าง Banner Slider
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                ),
                items:
                    [
                      'assets/banner/banner1.png',
                      'assets/banner/banner2.png',
                      'assets/banner/banner3.png',
                    ].map((item) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
