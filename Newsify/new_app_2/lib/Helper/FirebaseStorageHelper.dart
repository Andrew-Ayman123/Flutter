import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase/firebase.dart' as fb;
// import 'package:image_picker_web/image_picker_web.dart';

class FireStorage {
  static Future<String> imageUrl(PickedFile picked) async {
    if (kIsWeb) {
      final task = await FirebaseStorage.instance
          .ref()
          .child('newsImages/${picked.path.replaceAll('/', '')}')
          .putData(await picked.readAsBytes(),
              SettableMetadata(contentType: 'image/jpeg'));

      return await task.ref.getDownloadURL();
    }
    final task = await FirebaseStorage.instance
        .ref()
        .child('newsImages/${picked.path.replaceAll('/', '')}')
        .putFile(File(picked.path));
    return await task.ref.getDownloadURL();
  }
}
