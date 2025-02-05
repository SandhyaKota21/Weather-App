import 'package:hive/hive.dart';
part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel {
  @HiveField(0)
  final double temp;

  @HiveField(1)
  final double feelsLike;

  @HiveField(2)
  final double humidity;

  @HiveField(3)
  final double minTemp;

  @HiveField(4)
  final double maxTemp;

  @HiveField(5)
  final double windSpeed;

  @HiveField(6)
  final double windDegrees;

  @HiveField(7)
  final int sunrise;

  @HiveField(8)
  final int sunset;

  WeatherModel({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.minTemp,
    required this.maxTemp,
    required this.windSpeed,
    required this.windDegrees,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      humidity: json['humidity'].toDouble(),
      minTemp: json['min_temp'].toDouble(),
      maxTemp: json['max_temp'].toDouble(),
      windSpeed: json['wind_speed'].toDouble(),
      windDegrees: json['wind_degrees'].toDouble(),
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'feels_like': feelsLike,
      'humidity': humidity,
      'min_temp': minTemp,
      'max_temp': maxTemp,
      'wind_speed': windSpeed,
      'wind_degrees': windDegrees,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }
}
