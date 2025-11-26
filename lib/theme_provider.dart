import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  ThemeProvider() {
    loadTheme();
  }

  get themeMode => null;

  void toggleTheme(bool value) {
    isDarkMode = !isDarkMode;
    saveTheme();
    notifyListeners();
  }

  void saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}
