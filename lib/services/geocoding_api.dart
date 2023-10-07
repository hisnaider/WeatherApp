// ignore_for_file: avoid_print

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:weather_app/config.dart';

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
  /// If the `statusCode` is equal to 200, the data is returned as a Map with the
  /// key "data." If the `statusCode` is different, an error object with a code and
  /// message is returned
  Map<String, dynamic> decodeResponse(http.Response response) {
    var result = convert.jsonDecode(response.body);
    print("qqq");
    if (response.statusCode == 200) {
      return {"data": result as List<dynamic>};
    }
    return {
      "error": {"code": result["cod"], "message": result["message"]}
    };
  }

  /// Get a city by geocoding.
  ///
  /// This function takes a [city] name as a parameter.
  ///
  /// By using the endpoint `api.openweathermap.org/geo/1.0/direct` with the
  /// [city] as get request, it will return a list of cities with the fields
  /// `name`, `local_names`, `lat`, `lon`, `country` and `state`
  ///
  /// To return the data with the right format, the function [decodeResponse] is
  /// called and transform the response into a Map.
  ///
  /// If an unexpected error occurs, an unknown code and a message is returned
  Future<Map<String, dynamic>> getCityByName(String city) async {
    try {
      Uri uri = Uri.http(baseUrl, "/geo/1.0/direct", {
        "q": city,
        "limit": "3",
        "appid": apiKey,
      });
      var response = await http.get(uri);
      return decodeResponse(response);
    } catch (e) {
      print(e);
      return {
        "error": {"code": "unknown", "message": "Algo deu errado\n$e"}
      };
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
  /// To return the data with the right format, the function [decodeResponse] is
  /// called and transform the response into a Map.
  ///
  /// If an unexpected error occurs, an unknown code and a message is returned
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
      return decodeResponse(response)["data"][0];
    } catch (e) {
      print(e);
      return {
        "error": {"code": "unknown", "message": "Algo deu errado\n$e"}
      };
    }
  }
}
