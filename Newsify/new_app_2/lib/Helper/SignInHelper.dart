import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app_2/Helper/GeneralUtils.dart';

class SignInHelper {
  static String? email = '';
  static String? pass = '';
  static String? name = '';
  static void setemail(String? emailVal) => email = emailVal;
  static void setPass(String? passVal) => pass = passVal;
  static void setName(String? nameVal) => name = nameVal;

  
  static Future<void> login(BuildContext context) async {
    try{

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: pass!);
        
    }catch(e){
     
      Utils.showSnackBar(context, e);
    }
  }

  static Future<void> signUp(BuildContext context) async {
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: pass!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.uid)
          .set({
        'email': email,
        'name': name,
        'isAdmin': false,
      });
    } catch (e) {
     Utils.showSnackBar(context, e);
    }
  }

  static Future<void> signOut(BuildContext context) async {
    try{
 await FirebaseAuth.instance.signOut();
    }catch(e){
    
Utils.showSnackBar(context, e);
    }
   
  }
}
