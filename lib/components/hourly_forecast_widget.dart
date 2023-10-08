import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/utils.dart';

class HourlyForecastWidget extends StatelessWidget {
  /// This widget represents the forecast weather for a specific hour;
  ///
  /// Parameters:
  /// [weatherId]: Id that identifies the weather;
  /// [temperature]: Temperature in the specified hour;
  /// [date]: The specified date.
  const HourlyForecastWidget(
      {super.key,
      required this.weatherId,
      required this.temperature,
      required this.date});

  final int weatherId;
  final double temperature;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    String hour = date.hour.toString().padLeft(2, "0");
    String minute = date.minute.toString().padLeft(2, "0");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SvgPicture.asset(weatherIcon(weatherId, date.hour)),
          Text(
            "$hour:$minute",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(255, 255, 255, 0.5)),
          ),
          Text(
            "${temperature.toInt()}º",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(letterSpacing: 0.5, color: Colors.white),
          )
        ],
      ),
    );
  }
}
