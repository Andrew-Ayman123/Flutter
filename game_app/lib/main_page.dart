import 'package:flutter/material.dart';
import 'package:game_app/Chess/main_page.dart';
import 'package:game_app/Snake/main_page.dart';
import 'package:game_app/Tick%20Tack%20Toe/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  Widget listItem({
    @required BuildContext context,
    @required String routeName,
    Color color,
    @required Text title,
    @required String imagePath,
    List<Color> colors,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            gradient: colors != null
                ? LinearGradient(
                    colors: colors,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(routeName);
              },
              child: Container(
                height: 75,
                width: MediaQuery.of(context).size.width * .5,
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(width: 10),
                    title,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Opacity(
              opacity: .35,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'lib/assets/Main_page_background.jpg',
                    ),
                  ),
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.all(20),
              children: [
                Text(
                  'Welcome !',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rockSalt(fontSize: 40),
                ),
                SizedBox(height: 10),
                Image.asset(
                  'lib/assets/main_page_2.png',
                  height: 250,
                ),
                SizedBox(height: 30),
                listItem(
                  context: context,

                  routeName: TTTMainPage.routeName,
                  color: Colors.black,
                  //colors: [Colors.black, Colors.white],
                  title: Text('Tick Tack Toe'),
                  imagePath: 'lib/assets/tictactoelogo.png',
                ),
                listItem(
                  context: context,
                  routeName: SnakeMainPage.routeName,
                  color: Colors.white,
                  title: Text(
                    'Snake',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  imagePath: 'lib/assets/snake_logo.png',
                ),
                listItem(
                  context: context,
                  routeName: ChessMainPage.routeName,
                  color: Colors.grey,
                  title: Text(
                    'Chess',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  imagePath: 'lib/assets/chess_logo.png',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
