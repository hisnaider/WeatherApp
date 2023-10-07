import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyForecastWidget extends StatelessWidget {
  const DailyForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("svg/weather/clear_sky_day.svg"),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                "Min",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.blue, height: 1.1),
              ),
              Text(
                "18º",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 20, height: 1.1),
              )
            ],
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                "Max",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.red, height: 1.1),
              ),
              Text(
                "18º",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 20, height: 1.1),
              )
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Quarta feira",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.2),
                ),
                Text(
                  "26 de Setembro",
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
