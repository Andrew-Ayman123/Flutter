import 'package:asdt_app/constants/colors.dart';
import 'package:asdt_app/constants/fonts.dart';
import 'package:asdt_app/helpers/firebase_auth.dart';
import 'package:asdt_app/helpers/providers/new_user_provider.dart';
import 'package:asdt_app/screens/admin/create/create_event.dart';
import 'package:asdt_app/screens/admin/create/create_group.dart';
import 'package:asdt_app/screens/admin/create/create_user.dart';
import 'package:asdt_app/screens/admin/reports.dart';
import 'package:asdt_app/screens/event/event_screen.dart';

import 'package:asdt_app/screens/event/qr_scanner_screen.dart';
import 'package:asdt_app/screens/event/review_screen.dart';
import 'package:asdt_app/screens/home/home_screen.dart';
import 'package:asdt_app/screens/login/login_screen.dart';
import 'package:asdt_app/screens/event/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASDT Scouts',
      theme: ThemeData(
          scaffoldBackgroundColor: ConstColors.backgroundColor,
          textTheme: ConstFonts.appTextTheme,
          primaryColor: ConstColors.primaryColor,
          errorColor: ConstColors.errorColor,
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: ConstColors.primaryColor,
              secondary: ConstColors.secondaryColor,
              error: ConstColors.errorColor,
              onPrimary: ConstColors.backgroundColor,
              onSecondary: ConstColors.backgroundColor,
              onError: ConstColors.backgroundColor,
              background: ConstColors.backgroundColor,
              onBackground: Colors.black,
              surface: ConstColors.backgroundColor,
              onSurface: Colors.black)),
      home: FirebaseAuthHelper.initialPage,
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        CreateNewEventScreen.routeName: (ctx) => const CreateNewEventScreen(),
        EventScreen.routeName: (ctx) => const EventScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
        QRScanner.routeName: (ctx) => QRScanner(),
        CreateNewUserScreen.routeName: (ctx) => ChangeNotifierProvider(
              create: (_) => CreateNewUserProvider(),
              child: const CreateNewUserScreen(),
            ),
        CreateNewGroupScreen.routeName: (ctx) => const CreateNewGroupScreen(),
        ReviewScreen.routeName: (ctx) => const ReviewScreen(),
        ReportScreen.routeName: (ctx) => const ReportScreen(),
      },
    );
  }
}
