import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/utils.dart';

class DailyForecastWidget extends StatelessWidget {
  final int weatherId;
  final double maxTemperature;
  final double minTemperature;
  final DateTime date;
  const DailyForecastWidget(
      {super.key,
      required this.weatherId,
      required this.maxTemperature,
      required this.minTemperature,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(weatherIcon(weatherId, date.hour)),
          const SizedBox(width: 10),
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Min",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.blue, height: 1.1),
                ),
                Text(
                  "${minTemperature.toStringAsFixed(1)}º",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 20, height: 1.1),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Max",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.red, height: 1.1),
                ),
                Text(
                  "${maxTemperature.toStringAsFixed(1)}º",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 20, height: 1.1),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  weekDay[date.weekday]!,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.2),
                ),
                Text(
                  "${date.day} de Setembro",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(height: 1.2),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
