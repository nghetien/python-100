import 'package:flutter/material.dart';
import '../helpers.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isLightMode => themeMode == ThemeMode.light;

  get currentTheme {
    return themeMode;
  }

  void setDefaultTheme(String theme) {
    switch (theme) {
      case "Light":
        themeMode = ThemeMode.light;
        break;
      case "Dark":
        themeMode = ThemeMode.dark;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void setCurrentTheme(String theme) async {
    switch (theme) {
      case "Light":
        themeMode = ThemeMode.light;
        break;
      case "Dark":
        themeMode = ThemeMode.dark;
        break;
      default:
        break;
    }
    SharedPreferenceHelper().saveThemeDefault(theme);
    notifyListeners();
  }

  String getCurrentTheme() {
    switch (themeMode) {
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
      case ThemeMode.system:
        return "";
    }
  }
}