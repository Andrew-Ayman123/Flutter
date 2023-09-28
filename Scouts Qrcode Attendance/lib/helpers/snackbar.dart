import 'package:flutter/material.dart';

class SnackBarShower {
  static void showSnack(
      {required BuildContext context,
      required String message,
      Color backgroundColor = Colors.black,
      Color fontColor = Colors.white,
      required IconData icon}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: fontColor,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              message,
              style: TextStyle(color: fontColor),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
