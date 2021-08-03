import 'dart:io';

import 'package:chat_app/Utils/AuthScreenUtils.dart';
import 'package:chat_app/Utils/FireStoreHelper.dart';
import 'package:chat_app/screens/LoadingScreen.dart';
import 'package:chat_app/screens/MainScreen.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthHelper {
  static void showLoding(BuildContext context) {
    showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: EdgeInsets.all(16),
          child: Container(
            height: 100,
            child: Row(
              children: [
                SizedBox(width: 40),
                CircularProgressIndicator(),
                SizedBox(width: 15),
                Text('Loading'),
              ],
            ),
          ),
        );
      },
    );
    _isLoadingOpen = true;
  }

  static bool _isLoadingOpen = false;
  static void closeDialog(BuildContext context) {
    if (_isLoadingOpen) {
      Navigator.of(context).pop();
      _isLoadingOpen = false;
    }
  }

  static final _fireBase = FirebaseAuth.instance;
  static User get user => _fireBase.currentUser;
  static bool firstTime = true;
  static Widget get initialScreen {
    return StreamBuilder(
      stream: _fireBase.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapShot) {
        if (snapShot.hasData && !RegistrationUtils().isLoading) {
          closeDialog(context);
          return TabsScreen();
        }
        if (snapShot.connectionState == ConnectionState.waiting && firstTime) {
          firstTime = false;
          return LoadingScreen();
        }
        return ChangeNotifierProvider.value(
          value: RegistrationUtils(),
          child: AuthScreen(),
        );
      },
    );
  }

  static Future<void> signUpwithemail(String email, String pass, String name,
      File image, BuildContext context) async {
    showLoding(context);
    try {
      await _fireBase.createUserWithEmailAndPassword(
          email: email, password: pass);
      String url;
      if (image != null) {
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref()
            .child('Users_Images')
            .child(user.uid + '.jpg')
            .putFile(image);
        if (snapshot.state == TaskState.success)
          url = await snapshot.ref.getDownloadURL();
      }
      await FireStoreHelper.addNewUser(
        name,
        image != null ? url : null,
      );
      closeDialog(context);
    } catch (e) {
      closeDialog(context);
      throw e;
    }
  }

  static Future<void> signInwithemail(
      String email, String pass, BuildContext context) async {
    showLoding(context);
    try {
      await _fireBase.signInWithEmailAndPassword(email: email, password: pass);
      closeDialog(context);
    } catch (e) {
      closeDialog(context);
      throw e;
    }
  }

  static Future<void> resetAuth(BuildContext context) async {
    await FacebookLogin().logOut();
    await _fireBase.signOut();
  }

  static Future<void> signInwithePhoneNumber(
      BuildContext context, String phoneNumber, String name, File image) async {
    showLoding(context);
    try {
      await _fireBase.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: (cred) async {
          await _fireBase.signInWithCredential(cred);
          closeDialog(context);
        },
        verificationFailed: (error) {
          closeDialog(context);
          RegistrationUtils().errorWidget(context, error.toString());

          throw error;
        },
        codeSent: (verifcationId, forceRT) {
          closeDialog(context);

          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) {
              final formKey = GlobalKey<FormState>();
              return AlertDialog(
                title: Text('Enter Verification Code From Text Message'),
                content: Form(
                  key: formKey,
                  child: TextFormField(
                    validator: (value) {
                      String tempValue;
                      if (value.isEmpty)
                        tempValue = 'The Code must not be empty';
                      else if (value.length != 6)
                        tempValue = 'The number must contain exactly 11 long';
                      return tempValue;
                    },
                    onSaved: (str) async {
                      try {
                        await _fireBase.signInWithCredential(
                          PhoneAuthProvider.credential(
                            verificationId: verifcationId,
                            smsCode: str,
                          ),
                        );
                        Navigator.of(ctx).pop();
                        String url;
                        if (image != null) {
                          TaskSnapshot snapshot = await FirebaseStorage.instance
                              .ref()
                              .child('Users_Images')
                              .child(user.uid + '.jpg')
                              .putFile(image);
                          if (snapshot.state == TaskState.success)
                            url = await snapshot.ref.getDownloadURL();
                        }
                        await FireStoreHelper.addNewUser(
                          name,
                          url,
                        );

                        RegistrationUtils().loading(false);
                      } catch (e) {
                        Navigator.of(ctx).pop();

                        RegistrationUtils().errorWidget(context, e.toString());
                        throw e;
                      }
                    },
                    key: Key('phoneAuth'),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Enter the SMS Code',
                      labelText: 'SMS Code',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Press here to verify',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () async {
                      if (!formKey.currentState.validate()) return;
                      formKey.currentState.save();
                    },
                  ),
                ],
              );
            },
          );
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      closeDialog(context);
      throw e;
    }
  }

  static Future<void> signInWithGoogle() async {
    final googleSignInAccount = await GoogleSignIn().signIn();
    if (googleSignInAccount == null) throw ErrorDescription('');
    final googleAuth = await googleSignInAccount.authentication;
    await _fireBase.signInWithCredential(
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
    );
    await FireStoreHelper.addNewUser(null, null);
  }

  static Future<void> signInWithFacebook(BuildContext context) async {
    final fb = FacebookLogin();
    var result = await fb.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        throw result.errorMessage;
        break;
      case FacebookLoginStatus.loggedIn:
        await _fireBase.signInWithCredential(
          FacebookAuthProvider.credential(result.accessToken.token),
        );
        await FireStoreHelper.addNewUser(null, null);
        break;
      default:
    }
  }
}
