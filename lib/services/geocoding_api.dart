// ignore_for_file: avoid_print

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
  /// This function takes an [http.Response] object as a parameter, which
  /// contains a `body` (String) and a `statusCode` (int). Depending on the
  /// value of `statusCode`, it either returns the data as a Map or an error
  /// code and message.
  ///
  /// If the `statusCode` is equal to 200, the data is returned as a List.
  /// If the `statusCode` is different, a error is thrown
  List<dynamic> decodeResponse(http.Response response) {
    var result = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      return result as List<dynamic>;
    }
    throw {"code": result["cod"], "message": errorMessage(result)};
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
      var response = await http.get(uri);
      return decodeResponse(response);
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
      var response = await http.get(uri);
      return decodeResponse(response)[0];
    } catch (e) {
      rethrow;
    }
  }
}
