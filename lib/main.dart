// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:weather_app/provider/weather_provider.dart';
// import 'package:weather_app/screens/home_screen.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => WeatherProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WeatherScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/provider/temperature_provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and open the required boxes
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherModelAdapter());
  await Hive.openBox<WeatherModel>(
      'weatherBox'); // Open the box for weather data
  await Hive.openBox<String>(
      'temperatureUnit'); // Open box for temperature unit

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
        ),
        ChangeNotifierProvider(create: (_) => TemperatureUnitProvider()),
      ],
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: WeatherScreenLoader(),
      ),
    );
  }
}

class WeatherScreenLoader extends StatefulWidget {
  @override
  _WeatherScreenLoaderState createState() => _WeatherScreenLoaderState();
}

class _WeatherScreenLoaderState extends State<WeatherScreenLoader> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      await Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherByLocation();
    } catch (e) {
      print("Error loading weather data: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                if (weatherProvider.weather == null) {
                  return Center(child: Text("Weather data unavailable"));
                }
                return WeatherScreen(weather: weatherProvider.weather!);
              },
            ),
    );
  }
}
