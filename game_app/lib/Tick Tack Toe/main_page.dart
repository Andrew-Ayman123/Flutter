import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:game_app/Tick%20Tack%20Toe/game_page.dart';
import 'package:google_fonts/google_fonts.dart';

class TTTMainPage extends StatelessWidget {
  static final routeName = '/TTTMainPage';
  final arcadeFont =
      GoogleFonts.pressStart2p(wordSpacing: 3, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FittedBox(
              child: Text(
                'Tick Tack Toe',
                style: arcadeFont.copyWith(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: AvatarGlow(
                duration: const Duration(seconds: 3),
                repeat: true,
                endRadius: 160,
                glowColor: Colors.grey.shade500,

                repeatPauseDuration: const Duration(seconds: 1),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('lib/assets/tictactoelogo.png'),
                  maxRadius: 120,
                ),
              ),
            ),
            Container(
              height: 75,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(TTTGamePage.routeName);
                },
                child: Text(
                  'Play Now',
                  style: arcadeFont.copyWith(color: Colors.black, fontSize: 30),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
