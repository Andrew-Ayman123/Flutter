import 'package:covid_v2/Providers/Countries.dart';
import 'package:covid_v2/Screens/Credits.dart';
import 'package:covid_v2/Widgets/Search.dart';
import 'package:covid_v2/Screens/Theme_Selection.dart';
import 'package:flutter/material.dart';
import 'Providers/ThemePrv.dart';
import 'package:provider/provider.dart';
import 'Screens/Main_Screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeChooser()),
        ChangeNotifierProvider.value(value: Countries()),
      ],
      child: MaterialAppProv(),
    );
  }
}

class MaterialAppProv extends StatelessWidget {
  const MaterialAppProv({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.black,
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      themeMode: Provider.of<ThemeChooser>(context).theme
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: MainScreen.routeName,
      routes: {
        MainScreen.routeName: (ctx) => MainScreen(),
        Credits.routeName: (ctx) => Credits(),
        ThemeSelection.routeName: (ctx) => ThemeSelection(),
      },
    );
  }
}
