import 'package:chat_app/Utils/AuthHelper.dart';

import 'package:chat_app/Utils/Theme.dart';
import 'package:chat_app/screens/MainScreen.dart';

import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chats.dart';

import 'package:chat_app/screens/single_chat.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Utils/AuthScreenUtils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ThemeChooser(),
      child: WidgetTree(),
    );
  }
}

class WidgetTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeChooser>(context, listen: false)
        .setStatusBarAndNavigColor();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeChooser>(context).mainTheme,
      home: AuthHelper.initialScreen,
      routes: {
        AuthScreen.routeName: (ctx) => ChangeNotifierProvider.value(
              value: RegistrationUtils(),
              child: AuthScreen(),
            ),
        TabsScreen.routeName: (ctx) => TabsScreen(),
        SingleChatScreen.routeName: (ctx) => SingleChatScreen(),
      },
    );
  }
}
