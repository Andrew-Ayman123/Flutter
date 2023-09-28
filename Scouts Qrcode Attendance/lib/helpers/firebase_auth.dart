import 'package:asdt_app/constants/colors.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/snackbar.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/screens/home/home_screen.dart';
import 'package:asdt_app/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class FirebaseAuthHelper {
  static final _firebase = FirebaseAuth.instance;
  static String _email = '';
  static String _password = '';
  static Widget get initialPage {
    return StreamBuilder(
      stream: _firebase.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          FlutterNativeSplash.remove();
 
          return const HomeScreen();
        } else {
          if (snapshot.connectionState != ConnectionState.waiting) {
            FlutterNativeSplash.remove();
          }
          return LoginScreen();
        }
      },
    );
  }

  static setEmail(String? email) => _email = email!.trim();
  static setPassword(String? password) => _password = password!.trim();
  static Future<void> login(BuildContext context) async {
    try {
      await _firebase.signInWithEmailAndPassword(
          email: _email, password: _password);
    } catch (e) {
      SnackBarShower.showSnack(
        context: context,
        message:
            e.toString().startsWith("[firebase_auth/network-request-failed]")
                ? "Network is not currently available.\nPlease Try again later."
                : "E-mail Or Password isn't correct.\nPlease Try again.",
        icon: Icons.warning_amber,
        backgroundColor: ConstColors.errorColor,
        fontColor: Colors.white,
      );
    }
  }

  static void logout() async {
    FirebaseFirestoreHelper.logout();
    await _firebase.signOut();
  }

  static String get getEmail {
    return _firebase.currentUser!.email!;
  }

  static Future<void> signingInNewUser(String email, String password) async {
    // await _firebase.createUserWithEmailAndPassword(
    //   email: person.email,
    //   password: person.password!,
    // );
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    late UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await app.delete();
      rethrow;
    } 
    await app.delete();
    return Future.sync(() => userCredential);
  }
}
