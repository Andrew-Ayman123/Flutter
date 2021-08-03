import 'package:covid_v2/Widgets/AppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid_v2/Providers/ThemePrv.dart';

class ThemeSelection extends StatelessWidget {
  static const routeName = '/ThemeSelection';
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ThemeChooser>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Theme',
        ),
      ),
      drawer: AppDrawer(),
      body: SwitchListTile(
        value: data.theme,
        onChanged: data.toggleDark,
        title: Text(
          'Toggle Dark/Light',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
