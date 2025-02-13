import 'dart:convert';
import 'package:http/http.dart';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    Response response = await get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=2aef7ea19f40efdede1d1990358a7a9c&units=metric',
      ),
    );
    if (response.statusCode == 200) {
      String data = response.body;
      var decodeData = jsonDecode(data);
      return decodeData;
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> getWeatherFromCoordinates(
      double latitude, double longitude) async {
    Response response = await get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=2aef7ea19f40efdede1d1990358a7a9c&units=metric'));

    if (response.statusCode == 200) {
      String data = response.body;
      var decodeData = jsonDecode(data);
      return decodeData;
    } else {
      print(response.statusCode);
    }
  }

  String getWeatherIcon(int id) {
    if (id < 300) {
      return '🌩';
    } else if (id < 400) {
      return '🌧';
    } else if (id < 600) {
      return '☔️';
    } else if (id < 700) {
      return '☃️';
    } else if (id < 800) {
      return '🌫';
    } else if (id == 800) {
      return '☀️';
    } else if (id <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
