import 'package:flutter/material.dart';

// --- GLOBAL SETTINGS (ChangeNotifier) ---
class GlobalSettings extends ChangeNotifier {
  // --- LANGUAGE (i18n) ---
  String _selectedLanguage = 'English';
  Map<String, Locale> languageLocales = {
    'English': const Locale('en', 'US'),
    'Spanish': const Locale('es', 'ES'),
    'French': const Locale('fr', 'FR'),
    'German': const Locale('de', 'DE'),
    'Chinese': const Locale('zh', 'CN'),
    'Japanese': const Locale('ja', 'JP'),
    'Korean': const Locale('ko', 'KR'),
  };

  String get selectedLanguage => _selectedLanguage;
  Locale? get currentLocale => languageLocales[_selectedLanguage];

  set selectedLanguage(String newValue) {
    if (_selectedLanguage == newValue) return;
    _selectedLanguage = newValue;
    notifyListeners(); // <-- TRIGGERS REBUILD
  }

  // --- TEXT SIZE ---
  String _selectedTextSize = 'Medium (Default)';
  Map<String, double> textSizeFactors = {
    'Small': 0.85,
    'Medium (Default)': 1.0,
    'Large': 1.25,
    'Extra Large': 1.5,
  };

  String get selectedTextSize => _selectedTextSize;
  double? get currentTextScaleFactor => textSizeFactors[_selectedTextSize];

  set selectedTextSize(String newValue) {
    if (_selectedTextSize == newValue) return;
    _selectedTextSize = newValue;
    notifyListeners(); // <-- TRIGGERS REBUILD
  }

  // --- CONTRAST MODE ---
  bool _highContrastEnabled = false;
  bool get highContrastEnabled => _highContrastEnabled;

  set highContrastEnabled(bool newValue) {
    if (_highContrastEnabled == newValue) return;
    _highContrastEnabled = newValue;
    notifyListeners(); // <-- TRIGGERS REBUILD
  }
}
