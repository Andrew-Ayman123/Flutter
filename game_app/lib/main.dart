import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:game_app/Chess/main_page.dart';
import 'package:game_app/Snake/main_page.dart';
import 'package:game_app/Tick%20Tack%20Toe/main_page.dart';
import 'package:game_app/main_page.dart';
import 'Tick Tack Toe/game_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android:
                //ZoomPageTransitionsBuilder()
                SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.scaled,
            ),
          },
        ),
      ),
      home: MainPage(),
      routes: {
        TTTMainPage.routeName: (ctx) => TTTMainPage(),
        TTTGamePage.routeName: (ctx) => TTTGamePage(),
        SnakeMainPage.routeName: (ctx) => SnakeMainPage(),
        ChessMainPage.routeName: (ctx) => ChessMainPage()
      },
    );
  }
}
