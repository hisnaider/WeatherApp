# ![WeatherApp](https://github.com/hisnaider/WeatherApp/assets/13882534/042a984c-bf91-4a14-a44d-74f4a7702f8b)
![Static Badge](https://img.shields.io/badge/Flutter%20-%203.13.0-%20grey?style=for-the-badge&logo=flutter&logoColor=white&labelColor=%232968D0&color=grey)
![Static Badge](https://img.shields.io/badge/Dart%20-%203.2.0-%20grey?style=for-the-badge&logo=dart&logoColor=%232968D0&labelColor=white&color=grey)
![Static Badge](https://img.shields.io/badge/Status-%20under%20development%20-%20%23f59842?style=for-the-badge&labelColor=grey)



## About the app
<p align="center"><img src="https://github.com/hisnaider/WeatherApp/assets/13882534/db588015-3359-474c-a9a5-0fab149a9e5d" width="500"></P>

The WeatherApp is a simple weather app that provides current weather conditions for any city. All the pertaining information is from OpenWeather API, one of the most popular weather APIs, that ensures users receive the most accurate and up-to-date weather data available. This API provides the temperature, cloud percentage, humidity percentage, UV index, wind speed and many other details.

This app is designed with a clean and friendly interface, making it easier for users to quickly check the weather conditions in their city or any other location around the world. Users can use the GPS to get their location, search for a city name, or even use the map provided by OpenStreetMap.

## 🔨 Functionalities
- `Search city`: 3 ways to search for a city: by name, using the map or by device's GPS;
- `Current forecast weather`: Temperature, feels like temperature, weather conditions, cloud and humidity percentages, UV index, wind speed, precipitation, and hourly weather and temperature forecasts for the next 8 hours;
- `Week forecast weather`: Weather conditions, minimum and maximum temperatures for the next 7 days.

## Roadmap
- [X] Splash screen;
- [X] Introduction screen;
  - [X] Page widget;
  - [X] Four introduction step;
- [X] Comunication with OpenWeather's API
- [X] Map screen;
  - [X] Map and search widgets
  - [X] Search a city by name;
  - [X] Search a city using the map;
  - [X] Get user's location using GPS;
- [ ] Current forecast weather screen;
- [X] Week forecast weather widget;


## How to run the project
1. Install Flutter https://docs.flutter.dev/get-started/install;
2. Clone this repo: `git clone https://github.com/hisnaider/WeatherApp.git`;
4. Go to project's root and run: `flutter pub get`;
5. Get a free OpenWeather's One Call API key https://openweathermap.org/api;
6. Enter yout API key in `config.dart` (apiKey).

# Developer
| [<img loading="lazy" src="https://avatars.githubusercontent.com/u/13882534?v=4" width=115><br><sub>Hisnaider Ribeiro Campello</sub>](https://github.com/hisnaider) |
| :---: |
