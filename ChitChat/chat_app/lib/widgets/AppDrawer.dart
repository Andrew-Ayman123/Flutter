import 'package:chat_app/Utils/AuthHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/Utils/Theme.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end:Alignment.bottomCenter,
                colors: Provider.of<ThemeChooser>(context).gradientColors,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'Assets/Images/Logo.png',
                  fit: BoxFit.fitWidth,
                  width: 40,
                ),
                SizedBox(width: 10),
                Text(
                  'ChitChat',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile.adaptive(
            secondary: Icon(Icons.color_lens_outlined),
            title: Text('Dark/Light'),
            value: Provider.of<ThemeChooser>(context).isDark,
            onChanged: Provider.of<ThemeChooser>(context).toggleTheme,
          ),
          Divider(),
          ListTile(
            onTap: ()=>AuthHelper.resetAuth(context),
            leading: Icon(Icons.exit_to_app_rounded),
            title: Text('SignOut'),
          ),
          Divider()
        ],
      ),
    );
  }
}
