import 'package:flutter/material.dart';
import 'package:weather_app/config.dart';

/// This const represents the decoration of the textfield.
///
/// It fills the textfield with a white color, rounds its corners, and adds vertical
/// and horizontal space between the borders of the textfield.
InputDecoration kTextFieldDecoration = InputDecoration(
  hintText: "Procurar cidade",
  hintStyle: const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      fontSize: 15,
      fontWeight: FontWeight.normal),
  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
);

/// This enum represents the types of weather details that can be displayed.
///
/// Each enum value includes:
/// - [title]: A human-readable label for the weather detail.
/// - [icon]: The SVG icon representing the weather detail.
/// - [typeOfValue]: The unit of measurement or type associated with the value
///   ("%", "º", "mm/h", "Km/h").
enum TypeOfWeatherDetail {
  cloud("Nuvens", "svg/weather_details/cloud_percentage.svg", "%"),
  feelsLike("Sensação", "svg/weather_details/feels_like.svg", "º"),
  humidity("Umidade", "svg/weather_details/humidity_percentage.svg", "%"),
  precipitation(
      "Precipitação", "svg/weather_details/precipitation.svg", " mm/h"),
  uvi("Índice UV", "svg/weather_details/uvi_index.svg", ""),
  wind("Vento", "svg/weather_details/wind_speed.svg", " Km/h");

  const TypeOfWeatherDetail(this.title, this.icon, this.typeOfValue);
  final String title;
  final String icon;
  final String typeOfValue;
}

/// This function determines the location of the weather icon SVG.
///
/// It selects the appropriate weather icon SVG based on the provided [weatherId]
/// (representing the weather condition) and the [hour] at which the weather condition occurs.
///
/// Parameters:
/// - [weatherId]: The ID representing the weather condition, which can be in the following ranges:
///   - Thunderstorm (200-299)
///   - Rain (300-499)
///   - Light Rain (500-510)
///   - Snow (511)
///   - More Rain (520-599)
///   - Snow (600-700)
///   - Mist (701-799)
///   - Clear Sky (800)
///   - Few Clouds (801)
///   - Scattered Clouds (802)
///   - Broken Clouds (803-804)
///
/// - [hour]: The hour of the day when the weather condition occurs (0-23).
///
/// The function determines whether it's day or night based on the [hour] and returns the
/// corresponding day or night weather icon SVG.
String weatherIcon(int weatherId, int hour) {
  bool isNight = hour >= 18 || hour < 6;
  switch (weatherId) {
    case >= 200 && < 300:
      return "svg/weather/thunderstorm.svg";
    case >= 300 && < 500:
      return "svg/weather/rain.svg";
    case >= 500 && < 511:
      if (isNight) {
        return "svg/weather/light_rain_night.svg";
      }
      return "svg/weather/light_rain_day.svg";
    case 511:
      return "svg/weather/snow.svg";
    case >= 520 && < 600:
      return "svg/weather/rain.svg";
    case >= 600 && < 701:
      return "svg/weather/snow.svg";
    case >= 701 && < 800:
      return "svg/weather/mist.svg";
    case 800:
      if (isNight) {
        return "svg/weather/clear_sky_night.svg";
      }
      return "svg/weather/clear_sky_day.svg";
    case 801:
      if (isNight) {
        return "svg/weather/few_clouds_night.svg";
      }
      return "svg/weather/few_clouds_day.svg";
    case 802:
      return "svg/weather/scattered_clouds.svg";
    case 803 || 804:
      return "svg/weather/broken_clouds.svg";
    default:
      return "";
  }
}

/// This function determines a temporal description based on the difference in days.
///
/// Parameters:
/// - [days]: The number of days that represent the temporal description. It can fall into the following ranges:
///   - Today (0)
///   - Yesterday (1)
///   - This week (2-7)
///   - Last week (8-14)
///   - A few weeks ago (15-30)
///   - Last month (31-60)
///   - A few months ago (61-365)
///   - Last year (366-730)
///   - A few years ago (more than 730)
///   - Undetermined time (any other value)
///
/// The function selects the appropriate temporal description based on the [days] value.
String getTemporalDescription(int days) {
  switch (days) {
    case 0:
      return "Hoje";
    case 1:
      return "Ontem";
    case > 1 && <= 7:
      return "Essa semana";
    case > 7 && <= 14:
      return "Semana passada";
    case > 14 && <= 30:
      return "Há algumas semanas";
    case > 30 && <= 60:
      return "Mês passado";
    case > 60 && <= 365:
      return "Há alguns meses";
    case > 365 && <= 730:
      return "Ano passado";
    case > 730:
      return "Há alguns anos";
    default:
      return "Tempo indeterminado";
  }
}

/// This constant map provides the names of the months based on their respective
/// numbers.
///
/// It is used to map the month number (1 to 12) to the name of the month.
const Map<int, String> months = {
  1: "Janeiro",
  2: "Fevereiro",
  3: "Março",
  4: "Abril",
  5: "Maio",
  6: "Junho",
  7: "Julho",
  8: "Agosto",
  9: "Setembro",
  10: "Outubro",
  11: "Novembro",
  12: "Dezembro",
};

/// This constant map provides the names of the days of the week based on their
/// respective numbers.
///
/// It is used to map the day of the week number (1 to 7) to the name of the day.
const Map<int, String> weekDay = {
  1: "Segunda-feira",
  2: "Terça-feira",
  3: "Quarta-feira",
  4: "Quinta-feira",
  5: "Sexta-feira",
  6: "Sábado",
  7: "Domingo",
};

/// Get error messages based on error codes.
///
/// This function takes an [error] map and returns an error message based on
/// the error code. It handles various error cases, such as missing parameters,
/// invalid API keys, missing city information, rate limiting, timeout, and unexpected
/// errors, returning a user-friendly error message.
///
/// It accepts the following parameters:
/// - [error]: A map containing error code and message. The error's code can fall into the following ranges:
///   - Parameter error (400)
///   - API key error (401)
///   - Typos or non-existing value in the API (404)
///   - Exceeded request limits (429)
///   - Request timeout (timeout)
///   - An unexpected error (any different code)
///
/// The function selects the appropriate error message based on the code of the
/// error. When it's an unexpected error, the error details will be returned
/// with the message.
String errorMessage(Map<String, dynamic> error) {
  switch (error["cod"]) {
    case 400:
      return "Há um problema com os parâmetros fornecidos para buscar o clima. Verifique se todos os campos estão preenchidos corretamente e tente novamente.";
    case 401:
      return "Há algo de errado com a chave da API, ela pode ter sido desativada ou alterada. Se persistir o erro, entre em contato com o suporte 'weather.app@suport.com'.";
    case 404:
      return "Verifique se o nome da cidade está correto e tente novamente. Se a cidade não estiver disponível, entre em contato com o suport 'weather.app@suport.com'.";
    case 429:
      return "Muitas solicitações estão sendo feitas. Por favor, aguarde um momento e tente novamente mais tarde.";
    case "timeout":
      return "O tempo limite de solicitação de dados de 10 segundos foi excedido. Certifique-se de que sua conexão com a Internet esteja estável e tente novamente mais tarde.";
    default:
      error["message"] = error["message"].replaceAll(apiKey, "APIKEY");
      return "Ocorreu um erro inesperado.\n\n${error["message"]}.";
  }
}
