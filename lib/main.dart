import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/classes/app_state_manager.dart';
import 'package:weather_app/screen/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) =>
          AppStateManager(coord: [-32.0334252, -52.0991297]),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            fontFamily: "Poppins",
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            letterSpacing: 0.65,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(0, 0, 0, 0.75),
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(0, 0, 0, 0.25),
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(0, 0, 0, 0.25),
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(0, 0, 0, 0.75),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: const Color.fromRGBO(0, 133, 255, 1)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
