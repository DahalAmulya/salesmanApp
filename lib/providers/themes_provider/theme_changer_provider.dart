import 'package:flutter/material.dart';

class ThemeChangerProvider extends ChangeNotifier {
  var _themeMode = ThemeMode.light;
  bool _isChooseThemePopup = false;
  bool _isDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  bool get isChooseThemePopup => _isChooseThemePopup;
  bool get isDarkMode => _isDarkMode;

  void setThemeMode(themeMode) {
    _themeMode = themeMode;
    print('Theme = $_themeMode');
    if (_themeMode == ThemeMode.light) {
      _isDarkMode = false;
    } else {
      _isDarkMode = true;
    }
    if (_themeMode == ThemeMode.system) {
      if (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark) {
        _isDarkMode = true;
        print('Dark mode = $_isDarkMode');
      }
      if (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.light) {
        _isDarkMode = false;
        print('Dark mode = $_isDarkMode');
      }
    }
    notifyListeners();
  }

  void toogleIsChooseThemePopUp() {
    _isChooseThemePopup = !isChooseThemePopup;
    notifyListeners();
  }
}
