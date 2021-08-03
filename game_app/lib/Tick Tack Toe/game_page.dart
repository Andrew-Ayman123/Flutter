import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTTGamePage extends StatefulWidget {
  static final routeName = '/TTTGamePage';
  @override
  _TTTGamePageState createState() => _TTTGamePageState();
}

class _TTTGamePageState extends State<TTTGamePage> {
  List<String> displayed = List<String>.filled(9, '');
  bool isXTurn = true;
  int xScore = 0, oScore = 0;
  final arcadeFont = GoogleFonts.pressStart2p(wordSpacing: 3);
  void _tapped(int index) {
    if (displayed[index] != '') return;
    setState(() {
      displayed[index] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // checks 1st row
    if (displayed[0] == displayed[1] &&
        displayed[0] == displayed[2] &&
        displayed[0] != '') {
      _showWinOrDrawDialog(displayed[0]);
      return;
    }

    // checks 2nd row
    if (displayed[3] == displayed[4] &&
        displayed[3] == displayed[5] &&
        displayed[3] != '') {
      _showWinOrDrawDialog(displayed[3]);
      return;
    }

    // checks 3rd row
    if (displayed[6] == displayed[7] &&
        displayed[6] == displayed[8] &&
        displayed[6] != '') {
      _showWinOrDrawDialog(displayed[6]);
      return;
    }

    // checks 1st column
    if (displayed[0] == displayed[3] &&
        displayed[0] == displayed[6] &&
        displayed[0] != '') {
      _showWinOrDrawDialog(displayed[0]);
      return;
    }

    // checks 2nd column
    if (displayed[1] == displayed[4] &&
        displayed[1] == displayed[7] &&
        displayed[1] != '') {
      _showWinOrDrawDialog(displayed[1]);
      return;
    }

    // checks 3rd column
    if (displayed[2] == displayed[5] &&
        displayed[2] == displayed[8] &&
        displayed[2] != '') {
      _showWinOrDrawDialog(displayed[2]);
      return;
    }

    // checks diagonal
    if (displayed[6] == displayed[4] &&
        displayed[6] == displayed[2] &&
        displayed[6] != '') {
      _showWinOrDrawDialog(displayed[6]);
      return;
    }

    // checks diagonal
    if (displayed[0] == displayed[4] &&
        displayed[0] == displayed[8] &&
        displayed[0] != '') {
      _showWinOrDrawDialog(displayed[0]);
      return;
    }
    if (displayed.where((element) => element == '').toList().length == 0) {
      _showWinOrDrawDialog('-');
      return;
    }
  }

  void _showWinOrDrawDialog(String winner) async {
    await AudioCache(prefix: 'lib/assets/')
        .play('tick_win.mp3', mode: PlayerMode.LOW_LATENCY);
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => Dialog(
        elevation: 5, backgroundColor: Colors.transparent,
        //   titlePadding: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: EdgeInsets.zero,
          child: Stack(children: [
            Container(
              height: 150,
              color: Colors.grey.shade700,
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.only(top: 13.0, right: 8.0),
              alignment: Alignment.center,
              child: Text(
                winner != '-'
                    ? '$winner WINS\n\nCongrats'
                    : 'Draw\n\nNobody Wins',
                style: arcadeFont.copyWith(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Colors.redAccent,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
    setState(() {
      if (winner == 'X')
        xScore++;
      else if (winner == 'O') oScore++;
      displayed = List.filled(9, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Player X\n\n$xScore',
                  style: arcadeFont.copyWith(
                      fontSize: 20, color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Player O\n\n$oScore',
                  style: arcadeFont.copyWith(
                      fontSize: 20, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (ctx, index) => InkWell(
                  onTap: () => _tapped(index),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    child: Text(
                      displayed[index],
                      style: arcadeFont.copyWith(
                          fontSize: 40,
                          color: displayed[index] == 'X'
                              ? Colors.redAccent
                              : Colors.blueAccent),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Tick Tack Toe',
                style: arcadeFont.copyWith(fontSize: 25),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
