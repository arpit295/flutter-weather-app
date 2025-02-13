import 'package:flutter/material.dart';
import 'package:practice_clima/city_screen.dart';
import 'package:practice_clima/weather.dart';
import 'location.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int? temperature;
  String? city;
  String? weatherIcon;
  String? weatherMessage;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        city = 'Error City';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var id = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(id);
      city = weatherData['name'];
      weatherMessage = weatherModel.getMessage(temperature!);
    });
  }

  Future<void> getCurrentLocationWeather() async {
    try {
      Location location = Location();
      await location.getCurrentLocation();
      var weatherData = await weatherModel.getWeatherFromCoordinates(
        location.latitude!,
        location.longitude!,
      );
      updateUI(weatherData);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/location_background.jpg'),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await getCurrentLocationWeather();
                    },
                    child: Icon(
                      Icons.near_me,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityScreen(),
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weatherModel.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: 45,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    '$temperature°',
                    style: TextStyle(
                        fontFamily: 'SpartanMB',
                        fontSize: 95,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                  Text(
                    '$weatherIcon',
                    style: TextStyle(fontSize: 100, color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  textAlign: TextAlign.center,
                  '$weatherMessage in $city',
                  style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'SpartanMB',
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
