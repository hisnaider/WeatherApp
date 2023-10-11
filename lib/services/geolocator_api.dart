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
  /// If any issues occur during the process, an error will be throwed.
  Future<Map<String, dynamic>> getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw _errorMessage('Location-services-disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw _errorMessage('Location-permission-denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw _errorMessage('Location-services-denied-forever');
    }
    Position position = await Geolocator.getCurrentPosition();
    return {"lat": position.latitude, "lon": position.longitude};
  }

  /// Get error messages based on error codes.
  ///
  /// This function takes an [code] as a parameter and returns an error message
  /// tailored to specific error codes related to location services and permissions.
  ///
  /// Parameters:
  /// [code]: A string representing the error code.
  ///
  /// Returns:
  /// A map with the error code and an user-friendly error message.
  Map<String, String> _errorMessage(String code) {
    switch (code) {
      case "Location-services-disabled":
        return {
          "code": code,
          "message":
              "O GPS do dispositivo está desativado. Por favor, ative o GPS e tente novamente."
        };
      case "Location-permission-denied":
        return {
          "code": code,
          "message":
              "Você não permitiu o uso do GPS pelo aplicativo. Para obter sua localização, vá para as configurações do aplicativo e conceda permissão para o uso do GPS."
        };
      case "Location-services-denied-forever":
        return {
          "code": code,
          "message":
              "Você negou permanentemente o acesso ao GPS pelo aplicativo. Para obter sua localização, vá para as configurações do aplicativo e conceda permissão para o uso do GPS."
        };
      default:
        return {
          "code": "Desconhecido",
          "message": "Ocorreu um erro inesperado."
        };
    }
  }
}
