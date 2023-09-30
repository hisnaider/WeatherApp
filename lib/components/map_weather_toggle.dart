import 'package:flutter/material.dart';
import 'package:weather_app/screen/weather_screen.dart';

class MapWeatherToogle extends StatefulWidget {
  final Widget mapChild;
  final Widget weatherChild;
  const MapWeatherToogle(
      {super.key, required this.mapChild, required this.weatherChild});

  @override
  State<MapWeatherToogle> createState() => _MapWeatherToogleState();
}

class _MapWeatherToogleState extends State<MapWeatherToogle> {
  bool _showBackground = true;
  bool _fetchingData = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.mapChild,
        Visibility(
          visible: _showBackground,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0, 0.75),
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.40),
                  Theme.of(context).colorScheme.primary,
                ],
              ),
            ),
            child: _fetchingData
                ? Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 5,
                      ),
                    ),
                  )
                : WeatherScreen(),
          ),
        )
      ],
    );
  }
}
