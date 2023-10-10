// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/class/app_state_manager.dart';
import 'package:weather_app/components/map_pin.dart';
import 'package:weather_app/components/map_screen_background.dart';
import 'package:weather_app/utils.dart';
import 'package:weather_app/screen/weather_screen.dart';
import 'package:weather_app/services/geocoding_api.dart';
import 'package:weather_app/services/one_call_api.dart';

/// This variable controls the map.
AnimatedMapController? _mapController;

class MapScreen extends StatefulWidget {
  /// The main widget representing the map screen.
  ///
  /// This widget displays an interactive map for users to interact with it by
  /// dragging and pinch zooming. It includes features such as a text field to
  /// search for a city, a floating button to obtain the current location, and a
  /// map for navigating to a specific city.
  ///
  /// If a localization has been selected, the WeatherScreen will display
  /// the weather forecast for that location.
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<AppStateManager, bool>(
        selector: (context, myState) => myState.cityHasBeenSelected,
        builder: (context, value, child) {
          return Stack(
            children: [
              _MapWidget(cityHasBeenSelected: value),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: SizedBox(
                  key: ValueKey<bool>(value),
                  child: value ? const WeatherScreen() : const _OverlayWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MapWidget extends StatefulWidget {
  /// The widget that display the map
  ///
  /// This widget displays an interactive map for users to interact with it by
  /// dragging and pinch zooming.
  ///
  /// It uses a Selector to listen any changes on variable coordinates that is in
  /// [AppStateManager]. When there's a change, the map will move to the new
  /// coordinate with a animation
  ///
  /// [cityHasBeenSelected]: A boolean value that indicates if a city has been
  /// selected, if it's true, the map won't be interactive
  const _MapWidget({required this.cityHasBeenSelected});
  final bool cityHasBeenSelected;

  @override
  State<_MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<_MapWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    print("Map Widget");
    return Selector<AppStateManager, List<double>>(
      selector: (context, myState) => myState.coordinates,
      shouldRebuild: (previous, next) => previous != next,
      builder: (context, value, child) {
        LatLng coord = LatLng(value[0], value[1]);
        if (_mapController != null) {
          _mapController!.animateTo(
            dest: coord,
            curve: Curves.easeInOutCirc,
          );
        } else {
          _mapController = AnimatedMapController(
              vsync: this,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOutCirc);
        }

        return FlutterMap(
          mapController: _mapController!.mapController,
          options: MapOptions(
              zoom: 13,
              maxZoom: 13,
              minZoom: 8,
              center: coord,
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
      },
    );
  }
}

class _OverlayWidget extends StatelessWidget {
  /// Widget representing the map's overlay widgets and user interaction elements.
  ///
  /// This widget includes a text input field for searching cities, a list of
  /// suggested cities with their respective states and countries, a display for
  /// the weather and name of the last selected city, a centered pin on the map,
  /// buttons to get the user's position using GPS, and to retrieve the position
  /// that the centered pin is over.
  const _OverlayWidget();

  @override
  Widget build(BuildContext context) {
    /// Get the centered Pin coordinates over the map.
    ///
    /// It takes the centered pin coordinates and set it in the AppStateManager.
    void getCoordinateByCenteredPin() async {
      List<double> coords = [
        _mapController!.mapController.center.latitude,
        _mapController!.mapController.center.longitude
      ];
      await Provider.of<AppStateManager>(context, listen: false)
          .selectLocation([coords[0], coords[1]]);
    }

    print("Overlay Widget");
    return Stack(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// Search city
            _SearchCity(),

            /// Last selected city
            _LastSelectedCity()
          ],
        ),

        /// Pin in the center of the map
        MapPin(
          iconColor: Theme.of(context).colorScheme.primary,
        ),

        /// Buttons
        Positioned(
          bottom: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Button to get user's position
              RawMaterialButton(
                onPressed:
                    Provider.of<AppStateManager>(context).setUserPosition,
                elevation: 5,
                constraints:
                    const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fillColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.gps_fixed_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              /// Button to get centered pin position
              RawMaterialButton(
                onPressed: getCoordinateByCenteredPin,
                padding: const EdgeInsets.all(10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fillColor: Theme.of(context).colorScheme.primary,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Ver clima",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _LastSelectedCity extends StatelessWidget {
  /// Widget displaying information about the last selected city.
  ///
  /// This widget shows the weather and the name of the previously selected city.
  const _LastSelectedCity({super.key});

  @override
  Widget build(BuildContext context) {
    print("Last Selected Widget");
    AppStateManager appState =
        Provider.of<AppStateManager>(context, listen: false);
    String? city = appState.locationName?["name"];
    int? iconId = appState.weatherData?["current"]["weather"][0]["id"];
    int? date = appState.weatherData?["current"]["dt"];
    if (iconId == null) return const SizedBox.shrink();
    return InkWell(
      onTap: () => appState.selectCity(
          [appState.weatherData!["lat"], appState.weatherData!["lon"]]),
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(weatherIcon(iconId, date!), height: 20),
              const SizedBox(width: 5),
              Text(
                city!,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchCity extends StatefulWidget {
  /// This widget represents the city searching.
  ///
  /// It includes a text input field for users to search for cities and a list
  /// of suggested cities with their respective states and countries.
  ///
  /// The user can enter a city name in the search field, and the widget will display
  /// a list of suggested cities, using [_CityWidget], based on the input.
  const _SearchCity({super.key});

  @override
  State<_SearchCity> createState() => __SearchCityState();
}

class __SearchCityState extends State<_SearchCity> {
  /// List of searched cities
  List<dynamic> _listOfSearchedCities = [];

  /// Function to search cities by name
  ///
  /// This function takes city name [city] as parameter
  ///
  /// It calls `getCityByName` function, with [city] as parameter, from
  /// `geocoding_api.dart` to fetch a list of cities, than set it in
  /// [_listOfSearchedCities cities]. If [city] is empty, [_listOfSearchedCities]
  /// will be set as empty.
  void searchCityByName(String city) async {
    if (city.trim() != "") {
      var findedCities = await GeocodingAPI().getCityByName(city);
      if (findedCities["data"] != null) {
        setState(() {
          _listOfSearchedCities = findedCities["data"];
        });
      }
    } else {
      setState(() {
        _listOfSearchedCities = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Search City Widget");
    return Column(
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

        /// Container of suggested cities
        Visibility(
          visible: _listOfSearchedCities.isNotEmpty,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                for (int i = 0; i < _listOfSearchedCities.length; i++) ...[
                  _CityWidget(
                    city: _listOfSearchedCities[i]["name"],
                    uf: _listOfSearchedCities[i]["state"],
                    country: _listOfSearchedCities[i]["country"],
                    coordinates: [
                      _listOfSearchedCities[i]["lat"],
                      _listOfSearchedCities[i]["lon"]
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CityWidget extends StatelessWidget {
  /// This widget represents a city suggested by the user's search.
  ///
  /// It provides a GestureDetector to navigate the user to the weather screen.
  ///
  /// [city]: The name of the city.
  /// [uf]: The state of the city.
  /// [country]: The country of the city.
  /// [coordinates]: The coordinates of the city
  const _CityWidget(
      {required this.city,
      required this.uf,
      required this.country,
      required this.coordinates});
  final String city;
  final String uf;
  final String country;
  final List<double> coordinates;

  @override
  Widget build(BuildContext context) {
    print("City Widget");
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
              Provider.of<AppStateManager>(context, listen: false)
                  .selectLocation(coordinates);
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
