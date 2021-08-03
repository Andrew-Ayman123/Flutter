import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ThemeChooser with ChangeNotifier {
  bool _theme = true;
  //true means dark

  void toggleDark(bool temp) {
    _theme = temp;
    notifyListeners();
  }

  bool get theme => _theme;
  Color get casesColor =>
      _theme ? Colors.yellowAccent.shade400 : Colors.yellow.shade700;
  Color get recoveredColor =>
      _theme ? Colors.lightGreenAccent.shade700 : Colors.lightGreen.shade600;
  Color get deathsColor => Colors.redAccent;
  Color get activeCasesColor =>
      _theme ? Colors.lightGreen : Colors.green.shade600;
  Color get townColor => _theme ? Colors.blue : Colors.blueAccent.shade100;
}
