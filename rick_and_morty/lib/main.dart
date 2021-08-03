import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/Providers/handling_data.dart';
import 'package:rick_and_morty/Screens/char_screen.dart';
import 'package:rick_and_morty/Screens/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DataHandler(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rick & Morty',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color.fromRGBO(10, 0x15, 0x1E, 1),
          accentColor: Colors.teal,
        ),
        home: MainPage(),
        routes: {
          CharacterScreen.routeName: (ctx) => CharacterScreen(),
        },
      ),
    );
  }
}
