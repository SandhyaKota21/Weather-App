import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  WeatherModel? _weather;
  bool _isLoading = false;
  final WeatherService _weatherService = WeatherService();

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    Future.delayed(Duration.zero, () {
      notifyListeners(); // Ensures Flutter finishes its current build cycle
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Location services are disabled.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Request location permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint("Location permission denied.");
      _isLoading = false;
      notifyListeners();
      return;
    } else if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permission permanently denied.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lon = position.longitude;

      debugPrint("Current Location - Latitude: $lat, Longitude: $lon");

      // Fetch weather data from API
      try {
        final WeatherModel? fetchedWeather =
            await _weatherService.fetchWeather(lat, lon);
        if (fetchedWeather != null) {
          _weather = fetchedWeather;
          await _weatherService.saveWeatherToLocalStorage(fetchedWeather);
          debugPrint(
              "Weather Data: ${_weather!.temp}°C, ${_weather!.humidity}% humidity");
        }
      } catch (e) {
        // If API call fails, use local storage as fallback
        debugPrint("Error fetching weather, using local storage: $e");
        _weather = await _weatherService.fetchWeatherFromLocalStorage();
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
      // Use local storage if location fails
      _weather = await _weatherService.fetchWeatherFromLocalStorage();
    }

    _isLoading = false;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
}
