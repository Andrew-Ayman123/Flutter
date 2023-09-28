import 'dart:io';

import 'package:asdt_app/classes/user.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseStorageHelper {
  static final _firebaseStorage = FirebaseStorage.instance;
  static Future<String> uploadUserImage(
      AppUser user, File image) async {
    final ref = _firebaseStorage
        .ref()
        .child('users/${user.email.split('@')[0]}+${user.phoneNumber}.jpeg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}