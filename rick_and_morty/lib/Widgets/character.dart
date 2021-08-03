import 'package:flutter/material.dart';
import 'package:rick_and_morty/Providers/models.dart';
import 'package:rick_and_morty/Screens/char_screen.dart';
import 'package:rick_and_morty/Widgets/FadeInImage.dart';

class SingleCharacter extends StatelessWidget {
  final Character char;
  SingleCharacter(this.char);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(CharacterScreen.routeName, arguments: char);
        },
        child: GridTile(
          key: ValueKey(char.id),
          child: Hero(
            tag: 'img${char.id}',
            child: FadeImageRM(
              id: int.parse(char.id),
              link: char.imageUrl,
            ),
          ),
          footer: Container(
            padding: EdgeInsets.only(top: 5, left: 5, bottom: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    char.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: char.statusColor,
                      maxRadius: 5,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      '${char.statusName} - ${char.species}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    text: 'Location : ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: '${char.locationName}',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
