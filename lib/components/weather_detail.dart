import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/enum/type_of_weather_detail.dart';

class WeatherDetail extends StatelessWidget {
  final TypeOfWeatherDetail weather;
  final String value;
  const WeatherDetail({super.key, required this.weather, required this.value});

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
