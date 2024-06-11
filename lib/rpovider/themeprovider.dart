import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  var mode = ThemeMode.light;
  ThemeMode get modes => mode;

  void setTheme(thememode) {
    mode = thememode;
    notifyListeners();
  }
}
