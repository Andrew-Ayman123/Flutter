import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ThemeChooser with ChangeNotifier {
  bool _isDark = true;
  bool get isDark => _isDark;
  void toggleTheme(bool val) {
    _isDark = val;
    notifyListeners();
    setStatusBarAndNavigColor();
  }

  Color get textColor => _isDark ? Colors.white : Colors.black;
  List<Color> get gradientColors => _isDark
      ? [
          Color.fromRGBO(0, 0x04, 0x28, 1),
          Color.fromRGBO(0, 0x4e, 0x92, 1),
        ]
      : [
          Color.fromRGBO(2, 84, 183, 1),
          Color.fromRGBO(124, 177, 255, 1),
        ];
  ThemeData get mainTheme => _isDark
      ? ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          accentColor: Colors.white,
          backgroundColor: Colors.grey[850])
      : ThemeData.light().copyWith(
          backgroundColor: Color.fromRGBO(0xf5, 0xf5, 0xf5, 1),
          iconTheme: IconThemeData(color: Colors.blue));
  void setStatusBarAndNavigColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarIconBrightness:
            _isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: _isDark
            ? Colors.grey[850]
            : Color.fromRGBO(0xf5, 0xf5, 0xf5, 1), // navigation bar color
        statusBarColor: _isDark
            ? Color.fromRGBO(0, 0x04, 0x28, 1)
            : Color.fromRGBO(2, 84, 183, 1), // status bar color
      ),
    );
  }

  Color get bubbleChatColor =>
      _isDark ? Colors.blue.shade800 : Colors.blue.shade600;
}
