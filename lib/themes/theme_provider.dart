import 'package:flutter/material.dart';
import 'package:food_app/themes/dark_mode.dart';
import 'package:food_app/themes/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeProvider({bool isDarkMode = false}) {
    if (isDarkMode) {
      _themeData = darkMode;
    }
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData =  themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();

    // Persist preference to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}