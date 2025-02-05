import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String apiKey =
      'KgaGN+1Ly8H77YeXxps20Q==NL9uREuKJ6SDGq5j'; // Replace with your actual API key
  final String apiUrl = 'https://api.api-ninjas.com/v1/weather';

  Future<WeatherModel?> fetchWeather(double lat, double lon) async {
    try {
      // Check Internet Connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print("No Internet. Fetching from local storage.");
        return fetchWeatherFromLocalStorage();
      }

      // API Call
      final response = await http.get(
        Uri.parse('$apiUrl?lat=$lat&lon=$lon'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        var weather = WeatherModel.fromJson(jsonDecode(response.body));
        await saveWeatherToLocalStorage(weather); // Cache data locally
        print(response.body); // Debugging the response

        return weather;
      } else {
        throw Exception('Failed to load weather data');
      }
    } on SocketException {
      print("No Internet Connection. Using local storage.");
      return fetchWeatherFromLocalStorage();
    } catch (e) {
      print("Error fetching weather: $e");
      return fetchWeatherFromLocalStorage();
    }
  }

  Future<WeatherModel?> fetchWeatherFromLocalStorage() async {
    var box = await Hive.openBox<WeatherModel>('weatherData');
    var localData = box.get('weather');
    print('Local data: $localData');
    return localData;
  }

  Future<void> saveWeatherToLocalStorage(WeatherModel weather) async {
    var box = await Hive.openBox<WeatherModel>('weatherData');
    box.put('weather', weather);
  }
}
