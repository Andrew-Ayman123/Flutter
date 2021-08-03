import 'package:chat_app/Utils/Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreenTopLogo extends StatefulWidget {
  const AuthScreenTopLogo();

  @override
  _AuthScreenTopLogoState createState() => _AuthScreenTopLogoState();
}

class _AuthScreenTopLogoState extends State<AuthScreenTopLogo> {
  bool isOpen = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      isOpen = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: isOpen ? 200 : 0,
      decoration:  BoxDecoration(
        borderRadius:const BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
        gradient:  LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Provider.of<ThemeChooser>(context).gradientColors,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              'Assets/Images/Logo.png',
              height: 46,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ChitChat',
              style: TextStyle(
                fontSize: 36,
                fontFamily: 'Lato',
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.asset(
              'Assets/Images/Auth Screen logo2.png',
              height: 165,
              width: 122,
            ),
          ),
        ],
      ),
    );
  }
}
