import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/provider/temperature_provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  final WeatherModel weather;

  const WeatherScreen({super.key, required this.weather});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);
      if (weatherProvider.weather == null && !weatherProvider.isLoading) {
        weatherProvider.fetchWeatherByLocation();
      }
    });
  }

  Map<String, String> getWeatherInfo(double temp) {
    if (temp > 30) {
      return {
        'icon': 'assets/images/sunny.png', // Hot Weather
        'message': 'Mostly Sunny',
      };
    } else if (temp < 10) {
      return {
        'icon': 'assets/images/cold.png', // Cold Weather
        'message': 'Mostly Cold',
      };
    } else {
      return {
        'icon': 'assets/images/clear.png', // Default Clear Sky
        'message': 'Mostly Clear',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final unitProvider = Provider.of<TemperatureUnitProvider>(context);
    Map<String, String> weatherInfo =
        getWeatherInfo(weatherProvider.weather!.temp);

    double convertTemperature(double temperature) {
      if (unitProvider.isFahrenheit) {
        // Convert Celsius to Fahrenheit
        return (temperature * 9 / 5) + 32;
      }
      return temperature; // Return Celsius as is
    }

    DateTime now = DateTime.now(); // Get the current date and time

// Format the DateTime object
    String formattedDate = DateFormat('EEE MMM dd | HH:mm').format(now);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // ✅ Toggle Temperature Unit
          Switch(
            activeColor: Colors.white,
            value: unitProvider.isFahrenheit,
            onChanged: (value) => unitProvider.toggleUnit(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              unitProvider.isFahrenheit ? "°F" : "°C",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: weatherProvider.isLoading
            ? const CircularProgressIndicator()
            : weatherProvider.weather == null
                ? ElevatedButton(
                    onPressed: () {
                      weatherProvider.fetchWeatherByLocation();
                    },
                    child: const Text("Fetch Weather"),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.cyanAccent, Colors.cyan.shade500],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          weatherInfo['message']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          weatherInfo['icon']!,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${convertTemperature(weatherProvider.weather!.temp).toStringAsFixed(1)}°",
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Column(
                                children: [
                                  WeatherInfo(
                                      icon: Icons.water_drop, label: "22%"),
                                  Text(
                                    "Rain",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  WeatherInfo(
                                      icon: Icons.air,
                                      label:
                                          "${weatherProvider.weather!.windSpeed} m/s"),
                                  const Text(
                                    "Wind",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  WeatherInfo(
                                      icon: Icons.thermostat,
                                      label:
                                          "${weatherProvider.weather!.humidity}%"),
                                  const Text(
                                    "Humidity",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const WeatherInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}
