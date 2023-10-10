import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/class/app_state_manager.dart';
import 'package:weather_app/components/daily_forecast_widget.dart';
import 'package:weather_app/components/hourly_forecast_widget.dart';
import 'package:weather_app/components/map_screen_background.dart';
import 'package:weather_app/components/weather_detail.dart';
import 'package:weather_app/utils.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _showHourlyForecast = true;

  void _setShowHourlyForecast(double weekForecastWidgetHeight) {
    if (weekForecastWidgetHeight < 450 && _showHourlyForecast) {
      setState(() {
        _showHourlyForecast = false;
      });
    } else if (weekForecastWidgetHeight >= 450 && !_showHourlyForecast) {
      setState(() {
        _showHourlyForecast = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppStateManager, Map<String, dynamic>?>(
      selector: (context, myState) => myState.weatherData,
      shouldRebuild: (previous, next) => previous != next,
      builder: (context, value, child) {
        if (value == null) {
          Provider.of<AppStateManager>(context, listen: false).setWeather();
        }
        Map<String, dynamic>? currentWeather = value?["current"] ?? {};
        return MapScreenBackground(
            loading: value == null,
            child: value != null
                ? Column(
                    children: [
                      _CityName(
                        date: currentWeather!["dt"],
                      ),
                      _TemperatureWidget(
                        description: currentWeather["weather"][0]
                            ["description"],
                        weatherId: currentWeather["weather"][0]["id"],
                        temperature: currentWeather["temp"].toDouble(),
                      ),
                      _HourlyWidgetList(
                          hourlyWeatherForecast: value["hourly"],
                          showHourlyForecast: _showHourlyForecast),
                      _WeatherDetails(
                        currentWeather: currentWeather,
                        dailyWeather: value["daily"],
                        screenHeight: MediaQuery.of(context).size.height,
                        setShowHourlyForecast: _setShowHourlyForecast,
                      )
                    ],
                  )
                : const SizedBox.shrink());
      },
    );
  }
}

class _CityName extends StatelessWidget {
  /// This widget represents the location and forecast date information
  ///
  /// It takes [date] as parameter;
  ///
  /// parameters:
  /// [date]: Date of the last time that weather forecast has been registered.
  const _CityName({required this.date});
  final int date;

  /// This function format the [date] into a redeable date.
  ///
  /// It takes [date] as as parameter and performs the following steps:
  /// 1. Get current date and transform [date] into a DateTime;
  /// 2. Calls the function `getTemporalDescription` from `utils.dart` to get
  ///    how many days had passed since the last weather forecast date;
  /// 3. Get just the hour and minutes of [date];
  /// 4. Returns the date in the format "tanto tempo atras, 'dia' de 'mês' de
  ///    'ano', 'hora':'minuto'"
  String formatForecastTime(int date) {
    DateTime currentDate = DateTime.now();
    DateTime forecastDate = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    String daysPassed =
        getTemporalDescription(currentDate.difference(forecastDate).inDays);
    String hour = forecastDate.hour.toString().padLeft(2, "0");
    String minute = forecastDate.minute.toString().padLeft(2, "0");
    return "$daysPassed, ${forecastDate.day} de ${months[forecastDate.month]} de ${forecastDate.year}, $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? city =
        Provider.of<AppStateManager>(context, listen: false).locationName;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 45, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .deselectCity();
            },
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 18, color: Colors.white),
                Expanded(
                  child: Text(
                    "${city?["name"]} - ${city?["state"]}, ${city?["country"]}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatForecastTime(date),
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

///
///
///
///
///
///

class _TemperatureWidget extends StatelessWidget {
  /// This widget represents the centered temperature
  ///
  /// It takes [weatherId], [description] and [temperature] as parameters
  ///
  /// parameters:
  /// [weatherId]: Id that identifies the weather;
  /// [description]: A short description of the weather;
  /// [temperature]: Current temperature.
  const _TemperatureWidget(
      {required this.weatherId,
      required this.description,
      required this.temperature});
  final int weatherId;
  final String description;
  final double temperature;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(weatherIcon(weatherId, DateTime.now().hour)),
              Text(
                description[0].toUpperCase() + description.substring(1),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              )
            ],
          ),
          Text(
            "${temperature.toInt()}º",
            style: const TextStyle(
                color: Colors.white,
                fontFamily: "Poppins",
                fontSize: 100,
                fontWeight: FontWeight.w300,
                height: 0.95),
          )
        ],
      ),
    );
  }
}

///
///
///
///
///
///

class _HourlyWidgetList extends StatelessWidget {
  /// This widget represents the row of hourly forecast weather
  ///
  /// It takes [showHourlyForecast] and [hourlyWeatherForecast] as parameters
  ///
  /// Parameters:
  /// [showHourlyForecast]: determines if this widget should be visible;
  /// [hourlyWeatherForecast]: list of hourly forecast weather;
  const _HourlyWidgetList(
      {required this.showHourlyForecast, required this.hourlyWeatherForecast});
  final bool showHourlyForecast;
  final List<dynamic> hourlyWeatherForecast;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: showHourlyForecast
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 250),
      firstChild: SizedBox(
        height: 113,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: hourlyWeatherForecast.length,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (context, index) {
            var forecast = hourlyWeatherForecast[index];
            return HourlyForecastWidget(
              weatherId: forecast["weather"][0]["id"],
              temperature: forecast["temp"].toDouble(),
              date: DateTime.fromMillisecondsSinceEpoch(forecast["dt"] * 1000),
            );
          },
        ),
      ),
      secondChild: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}

///
///
///
///
///
///

class _WeatherDetails extends StatefulWidget {
  final double screenHeight;
  final Function(double) setShowHourlyForecast;
  final Map<String, dynamic> currentWeather;
  final List<dynamic> dailyWeather;
  const _WeatherDetails(
      {required this.screenHeight,
      required this.setShowHourlyForecast,
      required this.currentWeather,
      required this.dailyWeather});

  @override
  State<_WeatherDetails> createState() => __WeatherDetailsState();
}

class __WeatherDetailsState extends State<_WeatherDetails> {
  bool isOpen = false;
  double containerHeight = 250;

  void changeContainerHeight(double velocity) {
    double currentHeight = containerHeight;
    setState(() {
      containerHeight =
          (isOpen ? currentHeight > 500 : currentHeight > 350) ? 600 : 250;
      isOpen = (isOpen ? currentHeight > 500 : currentHeight > 350);
    });
    widget.setShowHourlyForecast(widget.screenHeight - containerHeight);
  }

  void dragContainer(double y) {
    double currentHeight = containerHeight - y;
    if (containerHeight > 600) {
      currentHeight = 600;
    } else if (containerHeight < 250) {
      currentHeight = 250;
    }
    widget.setShowHourlyForecast(widget.screenHeight - containerHeight);

    setState(() {
      containerHeight = currentHeight;
    });
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
                          weather: TypeOfWeatherDetail.feelsLike,
                          value:
                              widget.currentWeather["feels_like"].toString()),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.wind,
                          value:
                              widget.currentWeather["wind_speed"].toString()),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.cloud,
                          value: widget.currentWeather["clouds"].toString()),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.precipitation,
                          value:
                              widget.currentWeather["rain"]?["1h"].toString() ??
                                  "0"),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.uvi,
                          value: widget.currentWeather["uvi"].toString()),
                      WeatherDetail(
                          weather: TypeOfWeatherDetail.humidity,
                          value: widget.currentWeather["humidity"].toString()),
                    ],
                  ),
                ),
                const Divider(
                  height: 20,
                  color: Colors.grey,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.3,
                ),
                Text(
                  "Previsões pros proximos dias",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                    child: ListView.builder(
                  padding: EdgeInsetsDirectional.only(bottom: 50),
                  itemCount: widget.dailyWeather.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> daily = widget.dailyWeather[index];
                    return DailyForecastWidget(
                      date: DateTime.fromMillisecondsSinceEpoch(
                          daily["dt"] * 1000),
                      maxTemperature: daily["temp"]["max"].toDouble(),
                      minTemperature: daily["temp"]["min"].toDouble(),
                      weatherId: daily["weather"][0]["id"],
                    );
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
