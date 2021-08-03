import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChessMainPage extends StatefulWidget {
  static const routeName = '/ChessMainPage';

  @override
  _ChessMainPageState createState() => _ChessMainPageState();
}

class _ChessMainPageState extends State<ChessMainPage> {
  final squaresPerRow = 8, totalSquares = 64;
  Color getGridColor(int index) {
    if (index ~/ squaresPerRow % 2 == 0)
      return index % 2 == 1 ? Colors.grey.shade800 : Colors.brown;
    else
      return index % 2 == 0 ? Colors.grey.shade800 : Colors.brown;
  }

  List<Piece> piecies = [
    //White Pieces
    Piece(index: 0, type: PieceType.Rook, isBlack: false, isSelected: false),
    Piece(index: 1, type: PieceType.Knight, isBlack: false, isSelected: false),
    Piece(index: 2, type: PieceType.Bishop, isBlack: false, isSelected: false),
    Piece(index: 3, type: PieceType.King, isBlack: false, isSelected: false),
    Piece(index: 4, type: PieceType.Queen, isBlack: false, isSelected: false),
    Piece(index: 5, type: PieceType.Bishop, isBlack: false, isSelected: false),
    Piece(index: 6, type: PieceType.Knight, isBlack: false, isSelected: false),
    Piece(index: 7, type: PieceType.Rook, isBlack: false, isSelected: false),
    Piece(index: 8, type: PieceType.Pawn, isBlack: false, isSelected: false),
    Piece(index: 9, type: PieceType.Pawn, isBlack: false, isSelected: false),
    Piece(index: 10, type: PieceType.Pawn, isBlack: false, isSelected: false),
    Piece(index: 11, type: PieceType.Pawn, isBlack: false, isSelected: false),
    Piece(index: 12, type: PieceType.Pawn, isBlack: false, isSelected: false),
    Piece(index: 13, type: PieceType.Pawn, isBlack: false, isSelected: false),
    Piece(index: 14, type: PieceType.Pawn, isBlack: false, isSelected: false),
    Piece(index: 15, type: PieceType.Pawn, isBlack: false, isSelected: false),
    //emptyPieceis
    for (int i = 16; i < 48; i++) Piece.empty(i),
    //Black Piece
    Piece(index: 48, type: PieceType.Pawn, isBlack: true, isSelected: false),
    Piece(index: 49, type: PieceType.Pawn, isBlack: true, isSelected: false),
    Piece(index: 50, type: PieceType.Pawn, isBlack: true, isSelected: false),
    Piece(index: 51, type: PieceType.Pawn, isBlack: true, isSelected: false),
    Piece(index: 52, type: PieceType.Pawn, isBlack: true, isSelected: false),
    Piece(index: 53, type: PieceType.Pawn, isBlack: true, isSelected: false),
    Piece(index: 54, type: PieceType.Pawn, isBlack: true, isSelected: false),
    Piece(index: 55, type: PieceType.Pawn, isBlack: true, isSelected: false),
    Piece(index: 56, type: PieceType.Rook, isBlack: true, isSelected: false),
    Piece(index: 57, type: PieceType.Knight, isBlack: true, isSelected: false),
    Piece(index: 58, type: PieceType.Bishop, isBlack: true, isSelected: false),
    Piece(index: 59, type: PieceType.King, isBlack: true, isSelected: false),
    Piece(index: 60, type: PieceType.Queen, isBlack: true, isSelected: false),
    Piece(index: 61, type: PieceType.Bishop, isBlack: true, isSelected: false),
    Piece(index: 62, type: PieceType.Knight, isBlack: true, isSelected: false),
    Piece(index: 63, type: PieceType.Rook, isBlack: true, isSelected: false),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.brown,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                thickness: 1,
                height: 0,
                color: Colors.black,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: squaresPerRow),
                itemCount: totalSquares,
                itemBuilder: (ctx, index) => Container(
                  alignment: Alignment.center,
                  color: getGridColor(index),
                  child: piecies[index].icon != null
                      ? Draggable<Piece>(
                          onDragStarted: () {
                            print('started');
                          },
                          onDragEnd: (_) {
                            print('enmd');
                          },
                          data: piecies[index],
                          feedback: Container(
                            color: Colors.red,
                          ),
                          child: FaIcon(
                            piecies[index].icon,
                            size: 35,
                            color: piecies[index].getColor,
                          ),
                        )
                      : null,
                ),
              ),
              Divider(
                thickness: 1,
                height: 0,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Piece {
  int index;
  PieceType type;
  bool isBlack;
  bool isSelected;
  IconData icon;
  Piece({
    @required this.index,
    @required this.type,
    @required this.isBlack,
    @required this.isSelected,
  }) {
    switch (type) {
      case PieceType.Rook:
        icon = FontAwesomeIcons.chessRook;
        break;

      case PieceType.Knight:
        icon = FontAwesomeIcons.chessKnight;
        break;

      case PieceType.Bishop:
        icon = FontAwesomeIcons.chessBishop;
        break;

      case PieceType.King:
        icon = FontAwesomeIcons.chessKing;
        break;

      case PieceType.Queen:
        icon = FontAwesomeIcons.chessQueen;
        break;

      case PieceType.Pawn:
        icon = FontAwesomeIcons.chessPawn;
        break;
      default:
        icon = null;
    }
  }
  Piece.empty(
    this.index, {
    this.isBlack = false,
    this.isSelected = false,
    this.type = PieceType.Empty,
  });
  void toggleSelection() => isSelected = !isSelected;
  Color get getColor => isBlack ? Colors.black : Colors.white;
}

enum PieceType {
  Bishop,
  King,
  Rook,
  Queen,
  Knight,
  Pawn,
  Empty,
}
