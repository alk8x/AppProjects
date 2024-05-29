import 'package:flutter/material.dart';
import 'package:weatherapp/services/weather_services.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override 
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherServices('66fda9cfbe7aa46e98250795bae287ab');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for specific city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  // need to know which animation to show
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default

    switch (mainCondition.toLowerCase()){ // possible weather conditions from website
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/stormy.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
        return 'assets/snowy.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // initial state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? "loading city..."),

            // animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text('${((_weather?.temperature ?? 0) * 9/5 + 32).round()}°F'),

            // weather condition
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}