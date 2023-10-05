import 'package:flutter/material.dart';
import 'package:weather_app/services/geolocator_api.dart';

class AppStateManager extends ChangeNotifier {
  late List<double> _coordinates;
  bool _cityHasBeenSelected = false;

  AppStateManager({required List<double> coord}) {
    _coordinates = coord;
  }

  List<double> get coordinates {
    return _coordinates;
  }

  bool get cityHasBeenSelected {
    return _cityHasBeenSelected;
  }

  void getUserPosition() async {
    print("rr");
    Map<String, dynamic> position = await GeolocatorAPI().getPosition();
    _coordinates = [position["data"].latitude, position["data"].longitude];
    print("rreeeeeeeeee");
    notifyListeners();
  }

  void selectLocation(List<double> coords) {
    _coordinates = coords;
    _cityHasBeenSelected = true;
    notifyListeners();
  }

  void teste() {
    _cityHasBeenSelected = !_cityHasBeenSelected;
    notifyListeners();
  }
}
