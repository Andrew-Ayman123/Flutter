import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/widgets/home/admin_page.dart';
import 'package:asdt_app/widgets/home/list_events_page.dart';
import 'package:asdt_app/widgets/home/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = "/HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 1;
  Widget generateScreen() {
    if (_index == 0) {
      return const AdminPage();
    } else if (_index == 1) {
      return const ListEventsPage();
    } else {
      // index == 2 (profile)
      return const ProfilePage();
    }
  }

  Color generateBottomNavIconColor(int index) {
    if (_index == index) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
          title: Text(
            'A.S.T',
            style: Theme.of(context).textTheme.headline2,
          ),
          elevation: 0,
          centerTitle: true),
      body: generateScreen(),
      bottomNavigationBar: CurvedNavigationBar(
        index: _index,
        height: 58,
        backgroundColor: Theme.of(context).primaryColor,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        color: ConstColors.backgroundColor,
        items: <Widget>[
          Icon(Icons.admin_panel_settings_rounded,
              size: 30, color: generateBottomNavIconColor(0)),
          Icon(
            Icons.event,
            size: 30,
            color: generateBottomNavIconColor(1),
          ),
          Icon(Icons.person, size: 30, color: generateBottomNavIconColor(2)),
        ],
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
