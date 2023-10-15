import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/utils.dart';

class HourlyForecastWidget extends StatelessWidget {
  /// Widget to displays hourly weather forecasts.
  ///
  /// This widget is designed to present weather details for a specific hour, including
  /// an SVG icon representing the weather condition, the time, and the temperature.
  ///
  /// It accepts the following parameters:
  /// - [weatherId]: The ID representing the weather condition for a specific time.
  /// - [temperature]: The temperature for a specific time.
  /// - [date]: The specific date and time of the weather condition.
  ///
  /// The widget extracts the hour and minute from the [date] to display only this
  /// information, and formats the [temperature] to a string with one decimal place.
  ///
  /// This widget is primarily used in [WeatherScreen] to display weather conditions for
  /// the next 24 hours.
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
            "${temperature.toStringAsFixed(1)}º",
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
