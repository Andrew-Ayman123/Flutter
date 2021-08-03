import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Country {
  final String city;
  final int totalCases;
  final int activeCases;
  final int totalRecovered;
  final int totalDeaths;
  final int newCases;
  final int newRecovered;
  final int newDeaths;
  final String id;
  final DateTime date;
  Country(
      {@required this.city,
      @required this.totalCases,
      @required this.activeCases,
      @required this.totalRecovered,
      @required this.totalDeaths,
      @required this.newCases,
      @required this.newRecovered,
      @required this.newDeaths,
      @required this.id,
      @required this.date});
}

class Countries with ChangeNotifier {
  List<Country> _countries = [];
  Country _currentCountry;
  Future<void> fetchData() async {
    final respnse = await http.get(
      Uri.parse('https://api.covid19api.com/summary'),
    );

    final loadedData = json.decode(respnse.body) as Map<String, dynamic>;

    final List<Country> lo = [];
    lo.add(
      Country(
        city: 'Global',
        totalCases: loadedData['Global']['TotalConfirmed'],
        activeCases: loadedData['Global']['TotalConfirmed'] -
            loadedData['Global']['TotalRecovered'] -
            loadedData['Global']['TotalDeaths'],
        totalRecovered: loadedData['Global']['TotalRecovered'],
        totalDeaths: loadedData['Global']['TotalDeaths'],
        newCases: loadedData['Global']['NewConfirmed'],
        newRecovered: loadedData['Global']['NewRecovered'],
        newDeaths: loadedData['Global']['NewDeaths'],
        id: loadedData['Global']['ID'],
        date: DateTime.parse(loadedData['Global']['Date']),
      ),
    );

    loadedData['Countries'].forEach(
      (val) => lo.add(
        Country(
          city: val['Country'],
          totalCases: val['TotalConfirmed'],
          activeCases: val['TotalConfirmed'] -
              val['TotalRecovered'] -
              val['TotalDeaths'],
          totalRecovered: val['TotalRecovered'],
          totalDeaths: val['TotalDeaths'],
          newCases: val['NewConfirmed'],
          newRecovered: val['NewRecovered'],
          newDeaths: val['NewDeaths'],
          id: val['ID'],
          date: DateTime.parse(val['Date']),
        ),
      ),
    ) /*as List<Map<String, dynamic>>*/;
    if (_currentCountry == null) {
      _currentCountry = lo[0];
    } else {
      _currentCountry =
          lo[lo.indexWhere((element) => element.id == _currentCountry.id)];
    }
    lo.sort((a, b) => b.totalCases.compareTo(a.totalCases));
    _countries = lo;
    //print(_countries);
    //print(loadedData);
    notifyListeners();
  }

  List<Country> get countries {
    return [..._countries];
  }

  void changeCurrentCountry(String id) {
    _currentCountry =
        _countries[_countries.indexWhere((element) => element.id == id)];
    notifyListeners();
  }

  Country get country {
    return _currentCountry;
  }
}
