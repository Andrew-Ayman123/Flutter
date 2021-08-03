import 'package:covid_v2/Widgets/AppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Credits extends StatelessWidget {
  static const routeName = '/Credits';
  @override
  Widget build(BuildContext context) {
    Widget link(String pic, String link, String name) {
      return TextButton(
        onPressed: () => launch('$link'),
        child: ListTile(
          leading: Image.asset(
            pic,
            fit: BoxFit.contain,
          ),
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * .15),
            alignment: Alignment.center,
            child: const Text(
              'Developed By\nAndrew Ayman',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const Divider(),
          link(
              'Assets/Images/Credits logo.png',
              'https://www.facebook.com/AndroidIlove.IphoneIhate',
              'Andrew Ayman'),
          const Divider(),
          link('Assets/Images/insta.png',
              'https://www.instagram.com/andrew_ayman2002', 'andrew_ayman2002'),
          const Divider(),
        ],
      ),
    );
  }
}
