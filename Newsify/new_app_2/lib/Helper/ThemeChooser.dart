import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChooser extends ChangeNotifier {
  bool _isDark = true;
  SharedPreferences? _instance;
  Future<void> _intialize() async {
    _instance = await SharedPreferences.getInstance();
    _isDark = _instance!.getBool('theme') ?? true;
    notifyListeners();
  }

  ThemeChooser() {
    _intialize();
  }
  Future<void> toggle(bool val) async {
    _isDark = val;
    _instance!.setBool('theme', val);
    notifyListeners();
  }

  bool get isDark => _isDark;
  ThemeData get theme {
    if (_isDark)
      return ThemeData.dark().copyWith();
    else
      return ThemeData.light();
  }

  List<Color> get gradient => _isDark
      ? [
          Color.fromRGBO(0x04, 0x61, 0x9f, 1),
          Colors.black,
        ]
      : [
          Color.fromRGBO(0x50, 0x78, 0xf2, 1),
          Color.fromRGBO(0xef, 0xe9, 0xf4, 1),
        ];
  Color get textColorTitle => _isDark ? Colors.white : Colors.black;
  Color get textColorSub => _isDark ? Colors.grey.shade400 : Colors.black87;
}
