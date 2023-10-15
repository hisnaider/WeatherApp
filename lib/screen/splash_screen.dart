// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screen/introduction.dart';
import 'package:weather_app/screen/map_screen.dart';

class SplashScreen extends StatefulWidget {
  /// This widget represents the splash screen
  ///
  /// It displays a centered logo on the screen while determines if the next screen
  /// will be [MapScreen] or [IntroductionScreen]
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    hasPassedIntroScreen();
    super.initState();
  }

  /// Checks if the [IntroductionScreen] has been completed.
  ///
  /// This function utilizes shared preferences to check a boolean value that
  /// determines if the [IntroductionScreen] has already been completed. If the value
  /// is `true`, the next screen will be [MapScreen]; otherwise, the next screen will
  /// be [IntroductionScreen]. The transition between screens includes a 1-second delay.
  Future<void> hasPassedIntroScreen() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final bool hasPassedIntroScreen =
        sharedPreferences.getBool("hasPassedIntroScreen") ?? false;
    if (hasPassedIntroScreen) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const IntroductionScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SvgPicture.asset("svg/logo.svg")),
    );
  }
}
