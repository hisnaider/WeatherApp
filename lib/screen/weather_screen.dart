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
  /// The main widget representing the forecast weather screen.
  ///
  /// This widget provides the primary user interface for displaying weather forecast
  /// information. It features a gradient background and overlays weather data over it.
  /// The information displayed includes the current location, the date of the last
  /// weather forecast update, hourly weather forecast details, and more.
  ///
  /// If no weather data is available, a loading screen is displayed to indicate that
  /// data is being fetched.
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _showHourlyForecast = true;

  void _setShowHourlyForecast(double weekForecastWidgetHeight) {
    if (weekForecastWidgetHeight > 450 && _showHourlyForecast) {
      setState(() {
        _showHourlyForecast = false;
      });
    } else if (weekForecastWidgetHeight <= 450 && !_showHourlyForecast) {
      setState(() {
        _showHourlyForecast = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<AppStateManager>(context, listen: false).deselectCity();
        return false;
      },
      child: Selector<AppStateManager, Map<String, dynamic>?>(
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
                          setShowHourlyForecast: _setShowHourlyForecast,
                        )
                      ],
                    )
                  : const SizedBox.shrink());
        },
      ),
    );
  }
}

class _CityName extends StatelessWidget {
  /// Widget for displaying location information and the date of the last weather forecast.
  ///
  /// This widget presents the city name, state, and country in the format "city
  /// name - state, country," as well as the date of the last data collection.
  ///
  /// The [_CityName] widget takes the following parameter:
  /// - [date]: The timestamp of the last weather forecast update.
  ///
  /// It also includes a function, [formatForecastTime], which formats the provided
  /// timestamp into a human-readable date and time format.
  const _CityName({required this.date});
  final int date;

  /// This function format the [date] into a redeable date.
  ///
  /// It takes [date] as as parameter and performs the following steps:
  /// 1. Get current date and transform [date] into a DateTime;
  /// 2. Calls the function `getTemporalDescription` from `utils.dart` to get
  ///    how many days had passed since the last weather forecast date;
  /// 3. Get just the hour and minutes of [date];
  /// 4. Returns the date in a human-readable date and time format
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
  /// Widget for displaying current weather information, including an SVG icon
  /// representing the weather condition, a brief weather description, and the
  /// current temperature.
  ///
  /// This widget takes the following parameters:
  /// - [weatherId]: An identifier for the current weather condition.
  /// - [description]: A short description of the weather condition.
  /// - [temperature]: The current temperature in degrees Celsius.
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
  /// Widget for displaying an hourly forecast of weather conditions.
  ///
  /// This widget presents a scrollable row containing hourly weather forecast widgets.
  ///
  /// It takes the following parameters:
  /// - [showHourlyForecast]: Determines if this widget should be visible.
  /// - [hourlyWeatherForecast]: A list of hourly weather forecast data.
  ///
  /// When [showHourlyForecast] is true, it displays a list of [HourlyForecastWidget]
  /// components, each representing an hourly weather forecast with weather icon,
  /// temperature, and date.
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
  /// Widget for displaying current and next day's weather conditions.
  ///
  /// This widget presents a white container with a rounded top side, containing
  /// both the current weather and the weather for the next days.
  ///
  /// It accepts the following parameters:
  /// - [setShowHourlyForecast]: A function to control the visibility of [_HourlyWidgetList].
  /// - [currentWeather]: Information about the current weather forecast.
  /// - [dailyWeather]: Information about the weather forecast for the next 7 days.
  ///
  /// This widget can have its height changed by dragging up using gesture detector
  /// widget. At a certain height, it can either make [_HourlyWidgetList] visible or
  /// not, and set this widget height to 250 or 600

  const _WeatherDetails(
      {required this.setShowHourlyForecast,
      required this.currentWeather,
      required this.dailyWeather});
  final Function(double) setShowHourlyForecast;
  final Map<String, dynamic> currentWeather;
  final List<dynamic> dailyWeather;

  @override
  State<_WeatherDetails> createState() => __WeatherDetailsState();
}

class __WeatherDetailsState extends State<_WeatherDetails> {
  bool isOnMaxHeight = false;
  double containerHeight = 250;

  /// Function to change the container's height based on specific conditions.
  ///
  /// This function dynamically adjusts the container's height to either 250 or 600 pixels
  /// based on the current height and whether the container has reached its maximum height.
  /// It calls [setShowHourlyForecast] to control the visibility of [_HourlyWidgetList].
  ///
  /// The height is changed to 600 pixels when the container is at the maximum height
  /// and its current height is greater than 350 pixels. Otherwise, it is set to 250 pixels.
  void changeContainerHeight() {
    double currentHeight = containerHeight;
    setState(() {
      containerHeight =
          (isOnMaxHeight ? currentHeight > 500 : currentHeight > 350)
              ? 600
              : 250;
      isOnMaxHeight =
          (isOnMaxHeight ? currentHeight > 500 : currentHeight > 350);
    });
    widget.setShowHourlyForecast(containerHeight);
  }

  /// Function to dynamically change the container's height based on a drag event.
  ///
  /// This function adjusts the container's height by subtracting the value of [y]
  /// from the current height. It ensures that the container's height remains within
  /// a specified range, with a minimum height of 250 and a maximum height of 600 pixels.
  ///
  /// If the resulting height exceeds the maximum limit (600 pixels), it is clamped
  /// to 600 pixels. Similarly, if it falls below the minimum limit (250 pixels), it is
  /// clamped to 250 pixels. The function also calls [setShowHourlyForecast] to control
  /// the visibility of [_HourlyWidgetList].
  void dragContainer(double y) {
    if (y != 0) {
      double currentHeight = containerHeight - y;
      if (containerHeight > 600) {
        currentHeight = 600;
      } else if (containerHeight < 250) {
        currentHeight = 250;
      }
      widget.setShowHourlyForecast(containerHeight);

      setState(() {
        containerHeight = currentHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        changeContainerHeight();
      },
      onVerticalDragUpdate: (details) => dragContainer(details.delta.dy),
      child: AnimatedContainer(
        key: const Key('unique_animatedContainer_key'),
        duration: const Duration(milliseconds: 150),
        curve: Curves.decelerate,
        height: containerHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: buildContent(),
      ),
    );
  }

  /// Widget for displaying the content container.
  ///
  /// This widget is responsible for presenting the current weather forecast using [buildWeatherDetails]
  /// and the daily weather forecast using [buildDailyForecast].
  ///
  /// It includes a header for the current weather, followed by details such as temperature,
  /// wind speed, cloud percentage, and a divider. Additionally, it displays a section for
  /// the weather forecast for the upcoming days.
  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: OverflowBox(
        maxHeight: 650,
        alignment: Alignment.topCenter,
        minHeight: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                height: 5,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(90)),
              ),
            ),
            const SizedBox(height: 10),
            Text("O tempo agora",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            buildWeatherDetails(),
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
            Expanded(child: buildDailyForecast())
          ],
        ),
      ),
    );
  }

  /// Widget for displaying the current forecast of weather conditions.
  ///
  /// This widget arranges the current weather forecast information in a column layout.
  ///
  /// The [buildWeatherDetails] function assembles a [Wrap] of [WeatherDetail] components,
  /// each representing specific weather details such as "feels like" temperature, wind speed,
  /// cloud cover percentage, precipitation (rain in the last hour), UV index, and humidity percentage.
  ///
  /// Each [WeatherDetail] component is populated with data from the [widget.currentWeather] map,
  /// providing a comprehensive overview of the current weather conditions.

  Widget buildWeatherDetails() {
    return Wrap(
      key: const ValueKey("WeatherDetail"),
      runSpacing: 5,
      runAlignment: WrapAlignment.spaceBetween,
      clipBehavior: Clip.hardEdge,
      children: [
        WeatherDetail(
            weather: TypeOfWeatherDetail.feelsLike,
            value: widget.currentWeather["feels_like"].toString()),
        WeatherDetail(
            weather: TypeOfWeatherDetail.wind,
            value: widget.currentWeather["wind_speed"].toString()),
        WeatherDetail(
            weather: TypeOfWeatherDetail.cloud,
            value: widget.currentWeather["clouds"].toString()),
        WeatherDetail(
            weather: TypeOfWeatherDetail.precipitation,
            value: widget.currentWeather["rain"]?["1h"].toString() ?? "0"),
        WeatherDetail(
            weather: TypeOfWeatherDetail.uvi,
            value: widget.currentWeather["uvi"].toString()),
        WeatherDetail(
            weather: TypeOfWeatherDetail.humidity,
            value: widget.currentWeather["humidity"].toString()),
      ],
    );
  }

  /// Widget for displaying a daily forecast of weather conditions.
  ///
  /// This widget presents a scrollable column containing daily weather forecast
  /// information. It is designed to be visible when the user drags [_WeatherDetails]
  /// up.
  ///
  /// The [buildDailyForecast] function creates a [ListView] of [DailyForecastWidget]
  /// components, each representing a day's weather forecast with details such
  /// as date, maximum and minimum temperatures, and weather icon.
  Widget buildDailyForecast() {
    return ListView.builder(
      key: const ValueKey("DailyForecast"),
      padding: const EdgeInsetsDirectional.only(bottom: 50),
      itemCount: widget.dailyWeather.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> daily = widget.dailyWeather[index];
        return DailyForecastWidget(
          date: DateTime.fromMillisecondsSinceEpoch(daily["dt"] * 1000),
          maxTemperature: daily["temp"]["max"].toDouble(),
          minTemperature: daily["temp"]["min"].toDouble(),
          weatherId: daily["weather"][0]["id"],
        );
      },
    );
  }
}
