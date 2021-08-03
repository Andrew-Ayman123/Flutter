import 'package:flutter/material.dart';

class TheORWidget extends StatelessWidget {
  const TheORWidget();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            indent: 50,
            endIndent: 10,
            color: Colors.grey,
            thickness: 2,
            height: 5,
          ),
        ),
        Text(
          'OR',
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        Expanded(
          child: Divider(
            endIndent: 50,
            thickness: 2,
            indent: 10,
            color: Colors.grey,
            height: 5,
          ),
        )
      ],
    );
  }
}
