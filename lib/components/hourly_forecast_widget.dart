import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HourlyForecastWidget extends StatelessWidget {
  const HourlyForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SvgPicture.asset("svg/weather/light_rain_day.svg"),
          Text(
            "14:00",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(255, 255, 255, 0.5)),
          ),
          Text(
            "23º",
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
