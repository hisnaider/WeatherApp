import 'package:flutter/material.dart';
import 'package:weather_app/screen/introduction.dart';
import 'package:weather_app/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 15,
            letterSpacing: 0.65,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: const Color.fromRGBO(0, 133, 255, 1)),
        useMaterial3: true,
      ),
      home: const IntroductionScreen(),
    );
  }
}
