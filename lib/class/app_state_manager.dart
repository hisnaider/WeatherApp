import 'package:flutter/material.dart';
import 'package:weather_app/services/geocoding_api.dart';
import 'package:weather_app/services/geolocator_api.dart';
import 'package:weather_app/services/one_call_api.dart';

class AppStateManager extends ChangeNotifier {
  late List<double> _coordinates;
  bool _cityHasBeenSelected = false;
  Map<String, dynamic>? _data;

  AppStateManager({required List<double> coord}) {
    _coordinates = coord;
  }

  List<double> get coordinates {
    return _coordinates;
  }

  bool get cityHasBeenSelected {
    return _cityHasBeenSelected;
  }

  Map<String, dynamic>? get data {
    return _data;
  }

  void getUserPosition() async {
    Map<String, dynamic> position = await GeolocatorAPI().getPosition();
    _coordinates = [position["data"].latitude, position["data"].longitude];
    notifyListeners();
  }

  Future<void> selectLocation(List<double> coords, int time) async {
    if (!_cityHasBeenSelected) {
      _coordinates = coords;
      _cityHasBeenSelected = true;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: time));
      _data = {};
      notifyListeners();
    }
  }

  void setWeather(Map<String, dynamic> weatherData) {
    try {
      _data = weatherData;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
