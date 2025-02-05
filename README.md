# Weather App

This is a Flutter-based Weather App that retrieves real-time weather data using the API-Ninja API. The app supports local data caching, unit conversion between Celsius and Fahrenheit, and handles errors gracefully.

## Features

- Fetch current weather data based on city name
- Local database caching using Hive for offline access
- Unit conversion (Celsius ↔ Fahrenheit)
- Error handling for network failures
- User-friendly UI with weather descriptions and icons

## Setup Instructions

### Prerequisites

- Flutter 3.0+
- Dart 2.17+
- API-Ninja API key (Sign up at [API-Ninja](https://api-ninjas.com/api/weather))

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/SandhyaKota21/Weather-App.git
   cd weather_app
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Set up API key:

   - Open `weather_service.dart`
   - Replace `YOUR_API_KEY` with your actual API key

4. Run the app:
   ```sh
   flutter run
   ```

## Dependencies

- `provider` (State management)
- `http` (API requests)
- `hive` & `hive_flutter` (Local storage)

## Project Structure

```
lib/
│-- main.dart
│-- models/
│   ├── weather_model.dart
│-- providers/
│   ├── weather_provider.dart
│-- services/
│   ├── weather_service.dart
│-- screens/
│   ├── weather_screen.dart
```

## License

This project is licensed under the MIT License.
