
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'Assets/Images/Logo.png',
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'ChitChat',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.blue),)
          ],
        ),
      ),
    );
  }
}
