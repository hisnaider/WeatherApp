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

String weatherIcon(int code) {
  int hour = DateTime.now().hour;
  switch (code) {
    case >= 200 && < 300:
      return "svg/weather/thunderstorm.svg";
    case >= 300 && < 500:
      return "svg/weather/rain.svg";
    case >= 500 && < 511:
      if (hour < 18 && hour >= 6) {
        return "svg/weather/light_rain_day.svg";
      }
      return "svg/weather/light_rain_night.svg";
    case 511:
      return "svg/weather/snow.svg";
    case >= 520 && < 600:
      return "svg/weather/rain.svg";
    case >= 600 && < 701:
      return "svg/weather/snow.svg";
    case >= 701 && < 800:
      return "svg/weather/mist.svg";
    case 800:
      if (hour < 18 && hour >= 6) {
        return "svg/weather/clear_sky_day.svg";
      }
      return "svg/weather/clear_sky_night.svg";
    case 801:
      if (hour < 18 && hour >= 6) {
        return "svg/weather/few_clouds_day.svg";
      }
      return "svg/weather/few_clouds_night.svg";
    case 802:
      return "svg/weather/scattered_clouds.svg";
    case 803 && 804:
      return "svg/weather/broken_clouds.svg";
    default:
      return "";
  }
}
