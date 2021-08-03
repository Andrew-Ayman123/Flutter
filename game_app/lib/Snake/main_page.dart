import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnakeMainPage extends StatefulWidget {
  static const routeName = '/SnakeMainPage';
  @override
  _SnakeMainPageState createState() => _SnakeMainPageState();
}

class _SnakeMainPageState extends State<SnakeMainPage> {
  final columnsNum = 20;
  var rowsNum = 30;
  Direction direction = Direction.bottom;
  //indexList
  List<int> snakeIndex = [45, 65, 85, 105];
  int foodIndex = 36;
  Timer timer;

  void startGame() {
    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
        updateLocation();
        if (checkLost()) {
          timer.cancel();
          endGame();
        }
      });
    }
  }

  void updateLocation() async {
    setState(() {
      switch (direction) {
        case Direction.up:
          var addedIndex = snakeIndex.last - columnsNum;
          if (addedIndex < 0) addedIndex += columnsNum * rowsNum;
          snakeIndex.add(addedIndex);
          break;
        case Direction.bottom:
          var addedIndex = snakeIndex.last + columnsNum;
          if (addedIndex > columnsNum * rowsNum)
            addedIndex -= columnsNum * rowsNum;
          snakeIndex.add(addedIndex);
          break;
        case Direction.left:
          var addedIndex = snakeIndex.last - 1;
          if (addedIndex % columnsNum == columnsNum - 1)
            addedIndex += columnsNum;
          snakeIndex.add(addedIndex);
          break;
        case Direction.right:
          var addedIndex = snakeIndex.last + 1;
          if (addedIndex % columnsNum == 0) addedIndex -= columnsNum;
          snakeIndex.add(addedIndex);
          break;
        default:
      }
      if (snakeIndex.last != foodIndex)
        snakeIndex.removeAt(0);
      else {
        do {
          foodIndex = Random().nextInt(columnsNum * rowsNum);
        } while (snakeIndex.contains(foodIndex));
        
     AudioCache(prefix:'lib/assets/').play('snake_eat.mp3',mode: PlayerMode.LOW_LATENCY);
      }
    });
  }

  bool checkLost() {
    bool result = false;
    snakeIndex.forEach((element) {
      result =
          snakeIndex.where((element2) => element == element2).toList().length >
              1;
    });
    return result;
  }

  void endGame() async {
    AudioCache(prefix:'lib/assets/').play('snake_loss.mp3',mode: PlayerMode.LOW_LATENCY);
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Your score is : ${snakeIndex.length - 4}'),
            actions: [
              TextButton(
                onPressed: Navigator.of(ctx).pop,
                child: Text('Close'),
              )
            ],
          );
        });
    setState(() {
      snakeIndex = [45, 65, 85, 105];
    });
  }

  @override
  void dispose() {
    if (timer != null) timer.cancel();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final mobileHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        50;
    if (rowsNum != mobileHeight ~/ 19)
      setState(() {
        rowsNum = mobileHeight ~/ 19;
      });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 && direction != Direction.left)
                    direction = Direction.right;
                  else if (details.delta.dx < 0 && direction != Direction.right)
                    direction = Direction.left;
                },
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 && direction != Direction.up)
                    direction = Direction.bottom;
                  else if (details.delta.dy < 0 &&
                      direction != Direction.bottom) direction = Direction.up;
                },
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnsNum,
                    mainAxisExtent: 19,
                  ),
                  itemCount: columnsNum * rowsNum,
                  itemBuilder: (ctx, index) => Container(
                    color: snakeIndex.contains(index)
                        ? snakeIndex.last == index
                            ? Colors.green
                            : Colors.greenAccent
                        : foodIndex != index
                            ? Colors.transparent
                            : Colors.red,
                  ),
                ),
              ),
            ),
            Divider(thickness: .5, height: 0, color: Colors.white),
            Container(
              height: 50,
              child: Stack(
                children: [
                  Center(
                    child: TextButton.icon(
                      onPressed: startGame,
                      icon: Icon(
                        Icons.gamepad,
                        size: 30,
                      ),
                      style: TextButton.styleFrom(primary: Colors.white),
                      label: Text(
                        'Play',
                        style: GoogleFonts.pressStart2p(
                            fontSize: 20, wordSpacing: 5),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Score : ${snakeIndex.length - 4}',
                      style: GoogleFonts.pressStart2p(
                          fontSize: 12, wordSpacing: 3),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Direction {
  up,
  bottom,
  left,
  right,
}
