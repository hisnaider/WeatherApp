import 'package:flutter/material.dart';
import 'package:weather_app/screen/weather_screen.dart';

class MapWeatherToogle extends StatefulWidget {
  final Widget mapChild;
  final Widget weatherChild;
  final bool showBackground;
  const MapWeatherToogle(
      {super.key,
      required this.mapChild,
      required this.weatherChild,
      required this.showBackground});

  @override
  State<MapWeatherToogle> createState() => _MapWeatherToogleState();
}

class _MapWeatherToogleState extends State<MapWeatherToogle> {
  bool _fetchingData = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.mapChild,
        Visibility(visible: widget.showBackground, child: SizedBox.shrink())
      ],
    );
  }
}
