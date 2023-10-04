import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/components/map_pin.dart';
import 'package:weather_app/components/map_weather_toggle.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/screen/weather_screen.dart';
import 'package:weather_app/services/geocoding_api.dart';
import 'package:weather_app/services/geolocator_api.dart';

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
  bool _hasBeenInitialized = false;
  late List<double> _coordinates;

  void _init() async {
    Map<String, dynamic> position = await GeolocatorAPI().getPosition();
    print(position);
    if (position["data"] != null) {
      _coordinates = [position["data"].latitude, position["data"].longitude];
    } else {
      _coordinates = [-32.0334252, -52.0991297];
    }
    setState(() {
      _hasBeenInitialized = true;
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasBeenInitialized) {
      return const Scaffold(
        body: Center(
          child: SizedBox(
            height: 150,
            width: 150,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Scaffold(
      body: MapWeatherToogle(
        weatherChild: const SizedBox.shrink(),
        showBackground: false,
        mapChild: Stack(
          children: [
            _MapWidget(coordinates: _coordinates),
            Visibility(
              visible: true,
              child: const _SearchCity(),
            )
          ],
        ),
      ),
    );
  }
}

class _MapWidget extends StatefulWidget {
  final List<double> coordinates;
  final bool cityHasBeenSelected;
  const _MapWidget(
      {super.key, required this.coordinates, this.cityHasBeenSelected = false});

  @override
  State<_MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<_MapWidget> {
  final MapController _mapController = MapController();
  late List<double> _mapCenter;

  @override
  void initState() {
    _mapCenter = widget.coordinates;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          zoom: 13,
          maxZoom: 13,
          minZoom: 8,
          center: LatLng(_mapCenter[0], _mapCenter[1]),
          interactiveFlags: !widget.cityHasBeenSelected
              ? InteractiveFlag.drag | InteractiveFlag.pinchZoom
              : InteractiveFlag.none),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.weatherapp.app',
        )
      ],
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
      var findedCities = await GeocodingAPI().getCityByName(city);
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
        const MapPin()
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
              print(coordinates);
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
