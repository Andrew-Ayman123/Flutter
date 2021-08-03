import 'package:chat_app/Utils/Theme.dart';
import 'package:chat_app/screens/Profile.dart';
import 'package:chat_app/screens/chats.dart';
import 'package:chat_app/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/TabsScreen';
  const TabsScreen({Key key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'Assets/Images/Logo.png',
                  fit: BoxFit.fitHeight,
                  height: 37,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'ChitChat',
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
            
              tabs: [
                Tab(
                  text: 'Search',
                ),
                Tab(text: 'Chats'),
                Tab(text: 'Profile'),
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: Provider.of<ThemeChooser>(context).gradientColors,
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Search(),
              Chats(),
              Profile(),
            ],
          ),
        ),
      ),
    );
  }
}
