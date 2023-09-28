import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:todo_app/consts/paths.dart';
import 'package:todo_app/helpers/cubit/tasks_cubit.dart';
import 'package:todo_app/helpers/db_helper.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'consts/colors.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: ConstColors.backgroundColor,
    statusBarColor: ConstColors.backgroundColor,
  ));

  WidgetsFlutterBinding.ensureInitialized();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit(DBHelper(), DateTime.now()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scrollbarTheme: const ScrollbarThemeData(
              thickness: MaterialStatePropertyAll<double>(1),
              radius: Radius.circular(8),
              thumbColor:
                  MaterialStatePropertyAll<Color>(ConstColors.darkGreyColor)),
          primarySwatch: ConstColors.primarySwatch,
          scaffoldBackgroundColor: ConstColors.backgroundColor,
          fontFamily: 'NotoSansArabic',
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900, // set the font weight globally
            ),
            displayMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent, elevation: 0),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
