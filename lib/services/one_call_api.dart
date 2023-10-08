import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:weather_app/config.dart';

/// This class contains a function that utilizes the OpenWeather One Call API.
///
/// The [baseUrl] and [apiKey] are defined in the `config.dart` file.
///
/// [getWeather]: Retrieves weather data for a specific location.
class OneCallAPI {
  /// Get weather data for a specific location.
  ///
  /// This function takes latitude [lat] and longitude [lon] as parameters.
  ///
  /// It makes a request to the endpoint `api.openweathermap.org/data/3.0/onecall`
  /// with the provided [lat] and [lon], excluding 'minutely' and 'alerts' data.
  /// The response includes information such as `lat`, `lon`, `timezone`,
  /// `timezone_offset`, `current`, `hourly` and `daily`.
  ///
  /// If an unexpected error occurs, an unknown error code and a descriptive
  /// message are returned.
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    try {
      Uri uri = Uri.https(baseUrl, "/data/3.0/onecall", {
        "lat": lat.toString(),
        "lon": lon.toString(),
        "exclude": "minutely,alerts",
        "appid": apiKey,
        "units": "metric",
        "lang": "pt_br",
      });
      var response = await http.get(uri);
      var result = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        result["daily"].removeAt(0);
        result["hourly"] = result["hourly"].sublist(1, 25);
        return {...result as Map<String, dynamic>};
      }
      return {
        "error": {"code": result["cod"], "message": result["message"]}
      };
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return {
        "error": {"code": "unknown", "message": "Algo deu errado\n$e"}
      };
    }
  }
}
