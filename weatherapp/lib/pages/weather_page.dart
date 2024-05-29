import 'package:flutter/material.dart';
import 'package:weatherapp/services/weather_services.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/pages/animated_widgets.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override 
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherServices('66fda9cfbe7aa46e98250795bae287ab');
  Weather? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for specific city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
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

  double getWeatherAnimationSize(String? mainCondition) {
    if (mainCondition == null) return 200.0; // default size

    switch (mainCondition.toLowerCase()){ // possible weather conditions from website
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 250.0;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 250.0;
      case 'clear':
        return 200.0;
      case 'snow':
        return 250.0;
      default:
        return 200.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue[500]!,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: _isLoading
              ? Text(
                  "loading city...",
                  style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 32,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // City name with icon
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0), // Add top padding here
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/location-pin.png', // Path to your PNG image
                            width: 24, // Set the width of the image
                            height: 24, // Set the height of the image
                          ),
                          SizedBox(width: 8), // Add some space between the image and the text
                          AnimatedText(
                            text: _weather?.cityName ?? "",
                            style: TextStyle(
                              fontFamily: 'Exo2',
                              fontSize: 32,
                              color: Color.fromARGB(255, 43, 43, 43),
                            ),
                            delay: Duration(milliseconds: 0),
                            shouldAnimate: !_isLoading,
                          ),
                        ],
                      ),
                    ),
            Spacer(flex: 1),
            // Lottie animation below city name
            if (!_isLoading)
              AnimatedLottie(
                assetPath: getWeatherAnimation(_weather?.mainCondition),
                delay: Duration(milliseconds: 300),
                shouldAnimate: !_isLoading,
                size: getWeatherAnimationSize(_weather?.mainCondition),
              ),
            // Spacer(flex: 1),
            // Row containing temperature text on the left and main condition text on the right
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0), // adjust side padding 
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // temperature on the left
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0), // Add padding to the right of temperature
                      child: Baseline(
                        baseline: 80.0, // Adjust this value as needed
                        baselineType: TextBaseline.alphabetic,
                        child: AnimatedText(
                          text: '${((_weather?.temperature ?? 0) * 9 / 5 + 32).round()}°F',
                          style: TextStyle(
                            fontFamily: 'ConcertOne',
                            fontSize: 90,
                          ),
                          delay: Duration(milliseconds: 600),
                          shouldAnimate: !_isLoading,
                        ),
                      ),
                    ),

                    // main condition on the right
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10.0), // Add padding to the left of main condition
                    //   child: Baseline(
                    //     baseline: 40.0, // Adjust this value as needed to align with the temperature text
                    //     baselineType: TextBaseline.alphabetic,
                    //     child: AnimatedText(
                    //       text: _weather?.mainCondition ?? "",
                    //       style: TextStyle(
                    //         fontFamily: 'Exo2',
                    //         fontSize: 20,
                    //       ),
                    //       delay: Duration(milliseconds: 900),
                    //       shouldAnimate: !_isLoading,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            Spacer(flex: 3), // Optional: Adjusts space below the content
          ],
        ),
      ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WeatherPage(),
  ));
}






