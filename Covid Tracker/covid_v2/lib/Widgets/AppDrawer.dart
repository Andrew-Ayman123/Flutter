import 'package:covid_v2/Screens/Credits.dart';
import 'package:covid_v2/Screens/Main_Screen.dart';
import 'package:covid_v2/Screens/Theme_Selection.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  Column button(BuildContext context, String name, String route, Widget icon) =>
      Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(route);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  icon,
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ),
         const Divider(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'App Drawer',
            ),
            centerTitle: true,
          ),
          button(
            context,
            'Main',
            MainScreen.routeName,
            Icon(
              Icons.sick_outlined,
              color: Colors.grey,
            ),
          ),
          button(
            context,
            'Theme',
            ThemeSelection.routeName,
            Icon(
              Icons.settings,
              color: Colors.grey,
            ),
          ),
          button(
            context,
            'Credits',
            Credits.routeName,
            Icon(
              Icons.star_border,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
