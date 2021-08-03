import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Gender extends StatelessWidget {
  final IconData icon;
  final String type;
  final bool isIt;

  const Gender({
    @required this.icon,
    @required this.type,
    @required this.isIt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: isIt ? Colors.tealAccent : Colors.white70,
          width: 3,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            color: isIt ? Colors.tealAccent : Colors.white70,
            size: 50,
          ),
          FittedBox(
            child: Text(
              type,
              style: TextStyle(
                color: isIt ? Colors.tealAccent : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
