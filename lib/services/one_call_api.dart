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
      print(result);
      if (response.statusCode == 200) {
        result["daily"].removeAt(0);
        result["hourly"] = result["hourly"].sublist(1, 25);
        return {...result as Map<String, dynamic>};
      }
      throw {"code": response.statusCode, "message": response};
    } catch (e) {
      // ignore: avoid_print
      var error = e as Map<String, dynamic>;
      return {
        "error": {"code": e["code"], "message": _errorMessage(error)}
      };
    }
  }

  /// Get error messages based on error codes.
  ///
  /// This function takes an [error] map and returns an error message based on
  /// the error code. It handles various error cases, such as missing parameters,
  /// invalid API keys, missing city information, rate limiting, and unexpected
  /// errors.
  ///
  /// Parameters:
  /// [error]: A map containing error code and message.
  ///
  /// Returns:
  /// A user-friendly error message.
  String _errorMessage(Map<String, dynamic> error) {
    switch (error["code"]) {
      case 400:
        return "Há um problema com os parâmetros fornecidos para buscar o clima. Verifique se todos os campos estão preenchidos corretamente e tente novamente.";
      case 401:
        return "Há algo de errado com a chave da API, ela pode ter sido desativada ou alterada. Entre em contato com o suporte, e-mail 'weather.app@suport.com'.";
      case 404:
        return "Verifique se o nome da cidade está correto e tente novamente. Se a cidade não estiver disponível, entre em contato com o suporte, e-mail 'weather.app@suport.com'.";
      case 429:
        return "Muitas solicitações estão sendo feitas. Por favor, aguarde um momento e tente novamente mais tarde.";
      default:
        return "Ocorreu um erro inesperado. Detalhes:\n${error["message"]}.";
    }
  }
}
