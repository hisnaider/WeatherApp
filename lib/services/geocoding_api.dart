import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:weather_app/config.dart';
import 'package:weather_app/utils.dart';

/// This class contains functions that utilize the Geocoding API.
///
/// The [baseUrl] and [apiKey] are defined in the `config.dart` file.
///
/// [decodeResponse]: Tranform a response into a Map;
/// [getCityByName]: Retrieves cities by name;
/// [getCityByCoordinate]: Retrieves a city by coordinate.
class GeocodingAPI {
  /// Transform a HTTP response into a structured Map.
  ///
  /// This function takes an [Uri] object as a parameter, which
  /// contains the URI to make a GET request. It returns a structured response,
  /// which includes a `body` (String) and a `statusCode` (int). Depending on the
  /// value of `statusCode`.
  ///
  /// If the `statusCode` is equal to 200, indicating a successful response, the data is parsed and returned as a List.
  ///
  /// If the `statusCode` is different from 200, an error is thrown, providing the error code and a descriptive error message.
  Future<List<dynamic>> decodeResponse(Uri uri) async {
    try {
      var response = await http.get(uri).timeout(const Duration(seconds: 10));
      var result = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return result as List<dynamic>;
      }
      throw {"code": result["cod"], "message": errorMessage(result)};
    } catch (e) {
      if (e is TimeoutException) {
        throw {
          "code": "timeout",
          "message": errorMessage({"cod": "timeout"})
        };
      }
      throw {
        "code": "unknown",
        "message": errorMessage({"cod": "unknown", "message": e.toString()})
      };
    }
  }

  /// Get a city by geocoding.
  ///
  /// This function takes a [city] name as a parameter.
  ///
  /// By using the endpoint `api.openweathermap.org/geo/1.0/direct` with the
  /// [city] as get request, it will return a list of cities with the fields
  /// `name`, `local_names`, `lat`, `lon`, `country` and `state`. When [city] is
  /// a empty string, it will return a empty list
  ///
  /// If an unexpected error occurs in [decodeResponse] function, a error is
  /// rethrown.
  Future<List<dynamic>> getCityByName(String city) async {
    try {
      if (city.isEmpty) return [];
      Uri uri = Uri.http(baseUrl, "/geo/1.0/direct", {
        "q": city,
        "limit": "3",
        "appid": apiKey,
      });
      return await decodeResponse(uri);
    } catch (e) {
      rethrow;
    }
  }

  /// Get a city by reverse geocoding.
  ///
  /// This function takes a [lat] and a [lon] as parameters.
  ///
  /// By using the endpoint `api.openweathermap.org/geo/1.0/reverse` with [lat]
  /// and [lon] as get request, it will return a list of cities with the fields
  /// `name`, `local_names`, `lat`, `lon` and `country`
  ///
  /// If an unexpected error occurs in [decodeResponse] function, a error is
  /// rethrown.
  Future<Map<String, dynamic>> getCityByCoordinate(
      double lat, double lon) async {
    try {
      Uri uri = Uri.http(baseUrl, "/geo/1.0/reverse", {
        "lat": lat.toString(),
        "lon": lon.toString(),
        "limit": "3",
        "appid": apiKey,
      });
      List<dynamic> result = await decodeResponse(uri);
      return result[0];
    } catch (e) {
      rethrow;
    }
  }
}
