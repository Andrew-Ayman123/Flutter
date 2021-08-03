import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_app_2/Helper/FireStoreHelper.dart';
import 'package:new_app_2/Helper/ThemeChooser.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ThemeChooser(),
      child: Builder(builder: (ctx)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: Provider.of<ThemeChooser>(ctx).theme,
          home: FireStoreHepler.initialPage,
        ),
      ),
    );
  }
}
