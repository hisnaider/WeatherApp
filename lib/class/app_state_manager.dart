import 'package:flutter/material.dart';
import 'package:weather_app/components/error_dialog.dart';
import 'package:weather_app/main.dart';
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

  /// Set current user position.
  ///
  /// It calls `getPosition` function from `geolocator_api.dart` to get user's
  /// current position and set it in [_coordinates].
  void setUserPosition() async {
    try {
      Map<String, dynamic> position = await GeolocatorAPI().getPosition();
      _coordinates = [position["lat"], position["lon"]];
      notifyListeners();
    } catch (e) {
      var error = e as Map<String, dynamic>;
      errorDialog(error);
      _cityHasBeenSelected = false;
      notifyListeners();
    }
  }

  /// Select a location by coordinates.
  ///
  /// This function takes coordinates [coords] as parameters and performs the
  /// following steps:
  ///
  /// 1. If no location has been selected previously, it sets the coordinates
  ///    [coords] in [_coordinates].
  /// 2. Sets null values for [_weatherData] and [_locationName].
  /// 3. Sets the value of [_cityHasBeenSelected] to true.
  /// 4. Notifies the listeners to update the UI.
  Future<void> selectLocation(List<double> coords) async {
    if (!_cityHasBeenSelected) {
      _coordinates = coords;
      _weatherData = null;
      _locationName = null;
      _cityHasBeenSelected = true;
      notifyListeners();
    }
  }

  /// Selects city.
  ///
  /// This function sets [_cityHasBeenSelected] to true and notifies listeners.
  void selectCity(List<double> coords) {
    _coordinates = coords;
    _cityHasBeenSelected = true;
    notifyListeners();
  }

  /// Deselects city.
  ///
  /// This function clears the selected city without removing the coordinates.
  /// It sets [_cityHasBeenSelected] to false and notifies listeners.
  void deselectCity() {
    _cityHasBeenSelected = false;
    notifyListeners();
  }

  /// Set city name, state, country and weather forecast data.
  ///
  /// This function performs the following steps:
  ///
  /// It calls `getCityByCoordinate` function from `geocoding_api.dart` to fetch
  /// city name, state and country, and set it in [_locationName], than call
  /// `getWeather` function from `one_call_api.dart` to fetch weather forecast
  /// data and set it in [_weatherData].
  ///
  /// If any errors occur during these steps, a error dialog will be displayed
  /// and the city will deselected.
  Future<void> setWeather() async {
    try {
      _locationName ??= await GeocodingAPI()
          .getCityByCoordinate(_coordinates[0], _coordinates[1]);
      _weatherData =
          await OneCallAPI().getWeather(_coordinates[0], _coordinates[1]);
      notifyListeners();
    } catch (e) {
      var error = e as Map<String, dynamic>;
      errorDialog(error);
      _cityHasBeenSelected = false;
      notifyListeners();
    }
  }
}
