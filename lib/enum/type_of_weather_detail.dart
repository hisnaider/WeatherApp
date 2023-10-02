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
