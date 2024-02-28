import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          LottieBuilder.asset('lib/assets/splash.json'),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Divider(
              
          //     color: Colors.deepPurpleAccent,
          //   ),
          // ),
          Text(
            'OpenWeatherAPI.org',
            style: TextStyle(color: Colors.blueAccent),
          )
        ],
      )),
    );
  }
}
