import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/components/daily_forecast_widget.dart';
import 'package:weather_app/components/weather_detail.dart';
import 'package:weather_app/enum/type_of_weather_detail.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double containerHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CityName(name: "Rio Grande", state: "RS"),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("svg/weather/clear_sky_day.svg"),
                  const Text(
                    "Céu limpo",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  )
                ],
              ),
              const Text(
                "23º",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontSize: 100,
                    fontWeight: FontWeight.w300,
                    height: 0.95),
              )
            ],
          ),
        ),
        const _WeatherDetails()
      ],
    );
  }
}

class _CityName extends StatelessWidget {
  final String name;
  final String state;
  final DateTime? date;
  const _CityName(
      {super.key, required this.name, required this.state, this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 18, color: Colors.white),
              Text(
                "$name - $state",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 0.2),
              ),
            ],
          ),
          Text(
            "Hoje, 25 de Setembro de 2023, 12:00",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _WeatherDetails extends StatefulWidget {
  const _WeatherDetails({super.key});

  @override
  State<_WeatherDetails> createState() => __WeatherDetailsState();
}

class __WeatherDetailsState extends State<_WeatherDetails> {
  bool isOpen = false;
  double containerHeight = 250;

  void changeContainerHeight(double velocity) {
    double currentHeight = containerHeight;
    bool currentOpenly = isOpen;
    if (isOpen == false) {
      if (containerHeight > 350) {
        currentHeight = 600;
        currentOpenly = true;
      } else {
        currentHeight = 250;
      }
    } else {
      if (containerHeight < 500) {
        currentHeight = 250;
        currentOpenly = false;
      } else {
        currentHeight = 600;
      }
    }
    setState(() {
      containerHeight = currentHeight;
      isOpen = currentOpenly;
    });
  }

  void dragContainer(double y) {
    double currentHeight = containerHeight - y;
    if (containerHeight > 600)
      currentHeight = 600;
    else if (containerHeight < 250) currentHeight = 250;

    setState(() {
      containerHeight = currentHeight;
    });
  }

  void init() {}

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        changeContainerHeight(details.velocity.pixelsPerSecond.dy);
      },
      onVerticalDragUpdate: (details) => dragContainer(details.delta.dy),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.decelerate,
        height: containerHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: OverflowBox(
            maxHeight: 650,
            alignment: Alignment.topCenter,
            minHeight: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Container(
                      height: 5,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(90)),
                    ),
                  ),
                ),
                Text(
                  "O tempo agora",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    runSpacing: 5,
                    runAlignment: WrapAlignment.spaceBetween,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.feelsLike, value: "20"),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.wind, value: "12"),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.cloud, value: "53"),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.precipitation,
                          value: "1"),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.uvi, value: "0.16"),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.humidity, value: "0")
                    ],
                  ),
                ),
                Divider(
                  height: 20,
                  color: Colors.grey,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.3,
                ),
                Text(
                  "Previsões pra semana",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                    child: ListView.builder(
                  padding: EdgeInsetsDirectional.zero,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return DailyForecastWidget();
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
