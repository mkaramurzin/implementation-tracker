import 'package:flutter/material.dart';
import 'package:tracker/services/extension.dart';

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() {
    return _instance;
  }

  ThemeManager._internal();

  String _currentTheme = "classic";

  Color? get scaffoldColor {
    if(_currentTheme == "kenneth") {
      return "#1A0136".toColor();
    } else {
      return Colors.grey[50];
    }
  }

  Color get primaryColor {
    if(_currentTheme == "kenneth") {
      return Color(0xFF00FFFF);
    } else {
      return "#FFA611".toColor();
    }
  }

  Color get secondaryColor {
    if(_currentTheme == "kenneth") {
      return "#3C0949".toColor();
    } else {
      return "#F5820D".toColor();
    }
  }

  Color get appBarColor {
    if(_currentTheme == "kenneth") {
      return Colors.black;
    } else {
      return "#172D3B".toColor();
    }
  }

  // Button theme
  Color get buttonSecondary {
    if(_currentTheme == "kenneth") {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  Color? get buttonPrimary {
    if(_currentTheme == "kenneth") {
      return Colors.deepPurple[400];
    } else {
      return Colors.blue;
    }
  }

  Color? get deleteButton {
    if(_currentTheme == "kenneth") {
      return Colors.deepPurple[400];
    } else {
      return Colors.red;
    }
  }

  Color? get buttonAccent {
    if(_currentTheme == "kenneth") {
      return "#F432FF".toColor();
    } else {
      return Colors.blue;
    }
  }

  // Step icon theme
  Color? get stepPrimary {
    if(_currentTheme == "kenneth") {
      return Colors.deepPurple[400];
    } else {
      return Colors.blueGrey[800];
    }
  }

  Color get stepSecondary {
    if(_currentTheme == "kenneth") {
      return "#F432FF".toColor();
    } else {
      return "#F5820D".toColor();
    }
  }

  Color? get stepSegment {
    if(_currentTheme == "kenneth") {
      return Colors.deepPurple[400];
    } else {
      return Colors.black;
    }
  }

  // Popup theme
  Color? get popupPrimary {
    if(_currentTheme == "kenneth") {
      return Colors.deepPurple[400];
    } else {
      return Colors.white;
    }
  }

  Color get text {
    if(_currentTheme == "kenneth") {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  String get currentTheme => _currentTheme;

  set theme(String value) {
    _currentTheme = value;
  }
}
