import 'dart:io';

import 'package:chat_app/Utils/AuthHelper.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Registration {
  google,
  phoneNumber,
  email,
  facebook,
  signUp,
}

class RegistrationUtils with ChangeNotifier {
  Registration _registrationType = Registration.signUp;
  Map<String, dynamic> _userData = {
    'email': '',
    'password': '',
    'phoneNumber': '',
    'name': '',
    'image': null,
  };
  void changeType(Registration reg) {
    _registrationType = reg;
    notifyListeners();
  }

  bool _isLoading = false;
  void loading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  Map<String, String> get userData => _userData;
  Registration get registrationType => _registrationType;
  void insertEmailData(String email) => _userData['email'] = email.trim();
  void insertpasswordData(String password) =>
      _userData['password'] = password.trim();
  void insertphoneNumberData(String phoneNumber) =>
      _userData['phoneNumber'] = phoneNumber.trim();
  void insertNameData(String name) => _userData['name'] = name.trim();
  void insertImageData(File image) {
    print(image.toString());
    _userData['image'] = image;
  }

  String get registrationName {
    String tempName = 'Signin';
    if (_registrationType == Registration.email)
      tempName = 'Signin with E-mail';
    else if (_registrationType == Registration.signUp)
      tempName = 'Signup with E-mail';
    else if (_registrationType == Registration.google)
      tempName = 'Signin with Google';
    else if (_registrationType == Registration.facebook)
      tempName = 'Signin with Facebook';
    else if (_registrationType == Registration.phoneNumber)
      tempName = 'Signin with phone Number';
    return tempName;
  }

  void errorWidget(BuildContext context, String errorText) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (errorText.isNotEmpty)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 7),
          content: Text(
            errorText.contains('firebase')
                ? errorText.replaceAll('firebase_auth/', '')
                : errorText,
          ),
          action: SnackBarAction(
            label: 'hide',
            textColor: Colors.orange,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
  }

  Future<void> signUp(BuildContext context) async {
    try {
      await AuthHelper.signUpwithemail(
          _userData['email'],
          _userData['password'],
          _userData['name'],
          _userData['image'],
          context);
    } catch (e) {
      errorWidget(context, e.toString());
    }
  }

  Future<void> signIn(BuildContext context) async {
    try {
      await AuthHelper.signInwithemail(
          _userData['email'], _userData['password'], context);
    } catch (e) {
      errorWidget(context, e.toString());
    }
  }

  Future<void> signWithPhone(BuildContext context) async {
    try {
      await AuthHelper.signInwithePhoneNumber(
        context,
        _userData['phoneNumber'],
        _userData['name'],
        _userData['image'],
      );
    } catch (e) {
      errorWidget(context, e.toString());
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await AuthHelper.signInWithGoogle();
    } catch (e) {
      errorWidget(context, e.toString());
    }

  }
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      await AuthHelper.signInWithFacebook(context);
    } catch (e) {
      errorWidget(context, e.toString());
    }

  }
}
