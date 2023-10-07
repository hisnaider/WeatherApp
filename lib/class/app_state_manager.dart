import 'package:flutter/material.dart';
import 'package:weather_app/services/geocoding_api.dart';
import 'package:weather_app/services/geolocator_api.dart';
import 'package:weather_app/services/one_call_api.dart';

/// Global state manager of the application
///
/// Parameters:
/// [_coordinates]: Coordinates of the selected position;
/// [_cityHasBeenSelected]: Boolean that indicates if a city has been
/// selected;
/// [_weatherData]: Weather forecast data;
/// [_locationName]: City name, state and country;
/// [_error]: error message.
///
/// Functions:
/// [setUserPosition]: Set current user position;
/// [selectLocation]: Select a location by coordinates;
/// [setLocationName]: Set city name, state and country;
/// [setWeather]: Set city name, state, country and weather forecast data;
///
class AppStateManager extends ChangeNotifier {
  late List<double> _coordinates;
  bool _cityHasBeenSelected = false;
  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _locationName;
  Map<String, dynamic>? _error;

  /// class constructor
  AppStateManager({required List<double> coord}) {
    _coordinates = coord;
  }

  /// get coordinates from [_coordinates]
  List<double> get coordinates {
    return _coordinates;
  }

  /// get boolean that indicates if a city has been selected, from
  /// [_cityHasBeenSelected]
  bool get cityHasBeenSelected {
    return _cityHasBeenSelected;
  }

  /// get weather forecast data from [_weatherData]
  Map<String, dynamic>? get weatherData {
    return _weatherData;
  }

  /// get city name, state and country from [_locationName]
  Map<String, dynamic>? get locationName {
    return _locationName;
  }

  /// get error from [_error]
  Map<String, dynamic>? get error {
    return _error;
  }

  /// Set current user position.
  ///
  /// It calls `getPosition` function from `geolocator_api.dart` to get user's
  /// current position and set it in [_coordinates].
  void setUserPosition() async {
    Map<String, dynamic> position = await GeolocatorAPI().getPosition();
    _coordinates = [position["data"].latitude, position["data"].longitude];
    notifyListeners();
  }

  /// Select a location by coordinates.
  ///
  /// It takes coordinates [coords] and time [time] as parameters.
  ///
  /// If any location has not been selected, the function set the coordinates
  /// [coords] in [_coordinates] and set [_cityHasBeenSelected] as true. If
  /// a delay is needed, the parameter [time] defines in milliseconds the
  /// duration
  Future<void> selectLocation(List<double> coords, int time) async {
    if (!_cityHasBeenSelected) {
      _coordinates = coords;
      _cityHasBeenSelected = true;
      await Future.delayed(Duration(milliseconds: time));
      notifyListeners();
    }
  }

  /// Set city name, state and country.
  ///
  /// It calls `_getLocationName` function to fetch city name, state and country,
  /// and set it in [_locationName]
  void setLocationName(Map<String, dynamic> data) {
    _locationName = data;
    notifyListeners();
  }

  /// Set city name, state, country and weather forecast data.
  ///
  /// This function performs the following steps:
  ///
  /// It calls `_getLocationName` function to fetch city name, state and country,
  /// and set it in [_locationName], than call `_getWeather` to fetch weather
  /// forecast data and set it in [_weatherData].
  Future<void> setWeather() async {
    _locationName ??= await _getLocationName();
    _weatherData = await _getWeather();
    notifyListeners();
  }

  /// Fetches city name, state and country.
  ///
  /// It gets the city name, state and country using the `getCityByCoordinate`
  /// function from `geocoding_api.dart`.
  ///
  /// If any errors occur during these steps, a error is setted in [_error].
  Future<Map<String, dynamic>?> _getLocationName() async {
    Map<String, dynamic> data = await GeocodingAPI()
        .getCityByCoordinate(_coordinates[0], _coordinates[1]);
    if (data["error"] == null) {
      return data;
    } else {
      _error = data["error"];
      return null;
    }
  }

  /// Fetches weather forecast data.
  ///
  /// It gets the weather forecast using the `getWeather` function from
  /// `one_call_api.dart`.
  ///
  /// If any errors occur during these steps, a error is setted in [_error].
  Future<Map<String, dynamic>?> _getWeather() async {
    Map<String, dynamic> data =
        await OneCallAPI().getWeather(_coordinates[0], _coordinates[1]);
    if (data["error"] == null) {
      return data;
    } else {
      _error = data["error"];
      return null;
    }
  }
}
