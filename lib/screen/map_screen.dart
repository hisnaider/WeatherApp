import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/components/map_weather_toggle.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/screen/weather_screen.dart';
import 'package:weather_app/services/geocoding_api.dart';

/// The main widget representing the map screen.
///
/// This widget displays an interactive map for users to interact with it by
/// dragging and pinch zooming. It includes features such as a text field to
/// search for a city, a floating button to obtain the current location, and a
/// map for navigating to a specific city.
///
/// If the [coordinates] parameter is not null, the WeatherScreen will display
/// the weather forecast for that location.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<double>? coordinates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWeatherToogle(
        weatherChild: SizedBox.shrink(),
        showBackground: coordinates != null,
        mapChild: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                  zoom: 13,
                  maxZoom: 13,
                  minZoom: 8,
                  center: const LatLng(-32.0353776, -52.10758020000003),
                  interactiveFlags: coordinates == null
                      ? InteractiveFlag.drag | InteractiveFlag.pinchZoom
                      : InteractiveFlag.none),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.weatherapp.app',
                )
              ],
            ),
            Visibility(
              visible: coordinates == null,
              child: const _SearchCity(),
            )
          ],
        ),
      ),
    );
  }
}

/// This widget represents a city search feature.
///
/// It includes a text input field for users to search for cities, and a list
/// of suggested cities with their respective states and countries.
///
/// The user can enter a city name in the search field, and the widget will display
/// a list of suggested cities, using [_CityWidget], based on the input.
class _SearchCity extends StatefulWidget {
  const _SearchCity({super.key});

  @override
  State<_SearchCity> createState() => __SearchCityState();
}

class __SearchCityState extends State<_SearchCity> {
  /// List of searched cities
  List<dynamic> _cities = [];

  /// Function to search cities by name
  void searchCityByName(String city) async {
    if (city.trim() != "") {
      var findedCities = await GeocodingAPI().getCity(city);
      if (findedCities["data"] != null) {
        setState(() {
          _cities = findedCities["data"];
        });
      }
    } else {
      setState(() {
        _cities = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 40, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: TextField(
                autocorrect: true,
                style: const TextStyle(
                    fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.75)),
                onSubmitted: searchCityByName,
                decoration: kTextFieldDecoration.copyWith(
                  prefixIcon: const Icon(Icons.search),
                  //suffixIcon: const Icon(Icons.close),
                ),
              ),
            ),
            Visibility(
              visible: _cities.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    for (int i = 0; i < _cities.length; i++) ...[
                      _CityWidget(
                          city: _cities[i]["name"],
                          uf: _cities[i]["state"],
                          country: _cities[i]["country"],
                          coordinates: [_cities[i]["lat"], _cities[i]["lon"]]),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 55),
            child: Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.primary,
              size: 70,
            ),
          ),
        ),
      ],
    );
  }
}

/// This widget represents a city suggested by the user's search.
///
/// It provides a GestureDetector to navigate the user to the weather screen.
///
/// [city]: The name of the city.
/// [uf]: The state of the city.
/// [country]: The country of the city.
/// [coordinates]: The coordinates of the city
class _CityWidget extends StatelessWidget {
  final String city;
  final String uf;
  final String country;
  final List<double> coordinates;
  const _CityWidget(
      {super.key,
      required this.city,
      required this.uf,
      required this.country,
      required this.coordinates});

  @override
  Widget build(BuildContext context) {
    print([coordinates[0], coordinates[1]]);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "$uf, $country",
                style: Theme.of(context).textTheme.labelMedium,
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeatherScreen()),
              );
            },
            child: Text(
              "Ver clima",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
