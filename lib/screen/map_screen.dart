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

//
//
//
//
//
//
//
//

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

//
//
//
//
//
//
//
//

class _OverlayWidget extends StatelessWidget {
  /// Widget representing the map's overlay widgets and user interaction elements.
  ///
  /// This widget includes a text input field for searching cities and a list of
  /// suggested cities with their respective states and countries [_SearchCity],
  /// a container for the weather and name of the last selected city
  /// [_LastSelectedCity], a centered pin over the map [MapPin], and buttons on
  /// the bottom left side of the screen, one button to get the user's position
  /// using GPS and other to retrieve the position that the centered pin is over
  /// [_BottomButtons].
  const _OverlayWidget();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _SearchCity(),
            _LastSelectedCity(),
          ],
        ),
        MapPin(
          iconColor: Theme.of(context).colorScheme.primary,
        ),
        const _BottomButtons(),
      ],
    );
  }
}

//
//
//
//
//
//
//
//

class _SearchCity extends StatefulWidget {
  /// This widget represents the city searching.
  ///
  /// It includes a text input field for users to search for cities and a list
  /// of suggested cities with their respective states and countries.
  ///
  /// The user can enter a city name in the search field [_buildSearchInput],
  /// and the widget will display  a list of suggested cities, using
  /// [_buildCityWidget], based on the input.
  const _SearchCity();
  @override
  State<_SearchCity> createState() => __SearchCityState();
}

class __SearchCityState extends State<_SearchCity> {
  /// List of searched cities
  List<dynamic> _listOfSearchedCities = [];

  /// Boolean that indicates when the app is searching for cities
  bool _searching = false;

  /// Function to search cities by name
  ///
  /// This function takes city name [city] as parameter
  ///
  /// It calls `getCityByName` function, with [city] as parameter, from
  /// `geocoding_api.dart` to fetch a list of cities, than set it in
  /// [_listOfSearchedCities cities]. When
  void searchCityByName(String city) async {
    setState(() {
      _searching = true;
    });
    var findedCities = await GeocodingAPI().getCityByName(city.trim());
    setState(() {
      _listOfSearchedCities = findedCities;
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchInput(),
        _buildCityWidget(),
      ],
    );
  }

  /// This widget represents a search input field for finding cities.
  ///
  /// It displays a white container with rounded corners and shadow, and contains
  /// a row with a TextField for users to input city names and a AnimatedSwitcher
  /// that uses [_searching] value to indicates when the app is fetching the city.
  /// The TextField is configured with autocorrect enabled and a search icon as
  /// the prefix. When the user submits their input, the [searchCityByName]
  /// function is called to initiate the city search.
  ///
  /// Note: This widget is typically used to search for cities based on user input.
  /// The [searchCityByName] function handles the search and updates the list of
  /// suggested cities for selection.
  Widget _buildSearchInput() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 40, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 5),
              blurRadius: 5,
              spreadRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: true,
              style: const TextStyle(
                  fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.75)),
              clipBehavior: Clip.antiAlias,
              textCapitalization: TextCapitalization.words,
              onSubmitted: searchCityByName,
              decoration: kTextFieldDecoration.copyWith(
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: SizedBox(
              key: ValueKey<bool>(_searching),
              child: _searching
                  ? Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(10),
                      child: const CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),
            ),
          )
        ],
      ),
    );
  }

  /// Widget representing the container of suggested cities.
  ///
  /// It displays a white container with rounded corners and contains a column
  /// to show suggested cities. Each city in the list is tappable, and when
  /// selected, it opens the Weather Screen.
  ///
  /// The list of suggested cities is provided by [_listOfSearchedCities]. When a
  /// city is tapped, it calls the [selectLocation] method in [AppStateManager] to
  /// select the city and display the Weather Screen. Each city entry includes its
  /// name, state, and country (if available) along with a "Ver clima" (View Weather)
  /// label.
  Widget _buildCityWidget() {
    if (_listOfSearchedCities.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        children: [
          for (int i = 0; i < _listOfSearchedCities.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: GestureDetector(
                onTap: () {
                  Provider.of<AppStateManager>(context, listen: false)
                      .selectLocation([
                    _listOfSearchedCities[i]["lat"],
                    _listOfSearchedCities[i]["lon"]
                  ]);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _listOfSearchedCities[i]["name"],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "${_listOfSearchedCities[i]["state"] ?? ""}${_listOfSearchedCities[i]["country"]}",
                          style: Theme.of(context).textTheme.labelMedium,
                        )
                      ],
                    ),
                    Text(
                      "Ver clima",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

//
//
//
//
//
//
//
//

class _LastSelectedCity extends StatelessWidget {
  /// Widget displaying information about the last selected city.
  ///
  /// This widget displays a container with rounded left side and primary color,
  /// and contains a row that shows the weather and the name of the previously
  /// selected city.
  ///
  /// If the user taps on this widget, it selects the city, and the Weather
  /// Screen will be displayed.
  const _LastSelectedCity();
  @override
  Widget build(BuildContext context) {
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

//
//
//
//
//
//
//
//

class _BottomButtons extends StatelessWidget {
  /// This widget represents two buttons located at the bottom right of the screen.
  ///
  /// It displays two buttons widgets with rounded corners, a primary color, a child
  /// widget, and an elevation. The first button is used to retrieve the user's
  /// position, while the second button is used to obtain the coordinates at the
  /// center of the map.
  const _BottomButtons();
  @override
  Widget build(BuildContext context) {
    /// Get the coordinates at the center of the map and update the selected location.
    ///
    /// This function retrieves the latitude and longitude coordinates at the center of
    /// the map and calls the [selectLocation] method in [AppStateManager] to set this
    /// location as the selected one.
    void getCoordinateByCenteredPin() async {
      List<double> coords = [
        _mapController!.mapController.center.latitude,
        _mapController!.mapController.center.longitude
      ];
      await Provider.of<AppStateManager>(context, listen: false)
          .selectLocation([coords[0], coords[1]]);
    }

    return Positioned(
      bottom: 10,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Button to get user's position
          RawMaterialButton(
            onPressed: Provider.of<AppStateManager>(context).setUserPosition,
            elevation: 5,
            constraints: const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
            padding: const EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    );
  }
}
