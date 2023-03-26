import 'package:flutter/material.dart';
import 'package:tracker/services/extension.dart';

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() {
    return _instance;
  }

  ThemeManager._internal();

  final Map<String, ThemeData> _themes = {
    'classic': ThemeData(
      primarySwatch: Colors.orange,
      backgroundColor: Colors.orange,
    ),
    'kenneth': ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
    ),
  };

  ThemeData _currentTheme = ThemeData(
    // primarySwatch: MaterialColor(
    //   0xFF172D3B,
    //   <int, Color>{
    //     50: Color(0xFFE4E9EC),
    //     100: Color(0xFFBDC7CE),
    //     200: Color(0xFF91A2B2),
    //     300: Color(0xFF647B96),
    //     400: Color(0xFF425C7E),
    //     500: Color(0xFF172D3B),
    //     600: Color(0xFF152936),
    //     700: Color(0xFF12252F),
    //     800: Color(0xFF0F1E28),
    //     900: Color(0xFF09141A),
    //   },
    // ),
    appBarTheme: AppBarTheme(
      color: '#172D3B'.toColor(),
    ),
    scaffoldBackgroundColor: Colors.grey[50],
    primaryColor: "#FFA611".toColor(),

  );

  ThemeData get currentTheme => _currentTheme;

  Map<String, ThemeData> get themes => _themes;

  set theme(String value) {
    if (_themes.containsKey(value)) {
      _currentTheme = _themes[value]!;
    }
  }
}
