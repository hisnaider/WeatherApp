import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:weather_app/config.dart';

class GeocodingAPI {
  Future<Map<String, dynamic>> getCity(String city) async {
    try {
      Uri uri = Uri.http(baseUrl, "/geo/1.0/direct", {
        "q": city,
        "limit": "3",
        "appid": apiKey,
      });
      var response = await http.get(uri);
      var result = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"data": result as List<dynamic>};
      }
      return {
        "error": {"code": result["cod"], "message": result["message"]}
      };
    } catch (e) {
      print(e);
      return {"code": "0", "message": "teste"};
    }
  }
}
