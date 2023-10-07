import 'package:geolocator/geolocator.dart';

/// This class contains functions that utilize the Geolocator API.
///
/// [getPosition]: Get user's position;
class GeolocatorAPI {
  /// Use Geolocator to retrieve the user's position.
  ///
  /// This function checks if the location service is enabled, verifies the
  /// permissions to access the location, and then returns the user's location.
  ///
  /// If any issues occur during the process, an error will be returned.
  Future<Map<String, dynamic>> getPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Location-services-disabled.';
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location-permission-denied';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Location-services-denied-forever.';
      }
      Position position = await Geolocator.getCurrentPosition();
      return {"data": position};
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return {"error": e};
    }
  }
}
