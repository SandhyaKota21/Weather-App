import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TemperatureUnitProvider with ChangeNotifier {
  late Box<String> _settingsBox;
  bool _isFahrenheit = false;

  bool get isFahrenheit => _isFahrenheit;

  TemperatureUnitProvider() {
    _init();
  }

  Future<void> _init() async {
    // ✅ Prevent re-opening the box
    if (!Hive.isBoxOpen('temperatureunit')) {
      _settingsBox = await Hive.openBox<String>('temperatureunit');
    } else {
      _settingsBox = Hive.box<String>('temperatureunit');
    }

    _loadPreference();
  }

  void _loadPreference() {
    final storedValue = _settingsBox.get('unit', defaultValue: 'C');
    _isFahrenheit = storedValue == 'F';
    notifyListeners();
  }

  void toggleUnit() {
    _isFahrenheit = !_isFahrenheit;
    _settingsBox.put('unit', _isFahrenheit ? 'F' : 'C');
    notifyListeners();
  }
}
