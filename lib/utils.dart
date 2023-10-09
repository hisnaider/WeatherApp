import 'package:flutter/material.dart';

InputDecoration kTextFieldDecoration = InputDecoration(
  hintText: "Procurar cidade",
  hintStyle: const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      fontSize: 15,
      fontWeight: FontWeight.normal),
  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
);

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

String weatherIcon(int code, int hour) {
  bool isNight = hour >= 18 || hour < 6;
  switch (code) {
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

String getTemporalDescription(int days) {
  switch (days) {
    case 0:
      return "Hoje";
    case 1:
      return "Ontem";
    case > 1 && < 7:
      return "Essa semana";
    case >= 7 && < 14:
      return "Há mais de uma semana";
    case >= 14 && < 30:
      return "Há algumas semanas";
    case >= 30 && < 60:
      return "Há mais de um mês";
    case >= 60 && < 365:
      return "Há alguns meses";
    case >= 365 && < 730:
      return "Há mais de um ano";
    case >= 730:
      return "Há alguns anos";
    default:
      return "Tempo indeterminado";
  }
}

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

const Map<int, String> weekDay = {
  1: "Segunda-feira",
  2: "Terça-feira",
  3: "Quarta-feira",
  4: "Quinta-feira",
  5: "Sexta-feira",
  6: "Sábado",
  7: "Domingo",
};
