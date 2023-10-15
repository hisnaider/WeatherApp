import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/utils.dart';

class WeatherDetail extends StatelessWidget {
  /// Widget to displays weather forecast details.
  ///
  /// This widget is designed to present weather details in a structured manner.
  /// It includes an SVG icon, a label, and the corresponding value for the detail.
  ///
  /// It accepts the following parameters:
  /// - [weather]: The type of weather detail, which determines the icon and label.
  /// - [value]: The value of the weather detail.
  ///
  /// The widget dynamically calculates its width based on the device's screen width to
  /// ensure optimal layout.
  const WeatherDetail({super.key, required this.weather, required this.value});
  final TypeOfWeatherDetail weather;
  final String value;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2 - 10;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: width,
      child: Row(
        children: [
          SvgPicture.asset(
            weather.icon,
            height: 30,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: 0.5,
                child: Text(weather.title,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              Text(value + weather.typeOfValue,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          )
        ],
      ),
    );
  }
}
