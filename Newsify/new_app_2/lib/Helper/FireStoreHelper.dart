import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:new_app_2/Screens/MainPage.dart';
import 'package:new_app_2/Screens/signin_page.dart';
import 'package:flutter/material.dart';

class FireStoreHepler {
  static Widget get initialPage {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, AsyncSnapshot<User?> snap) {
        try {
          if (snap.connectionState == ConnectionState.waiting)
            return Scaffold();
          if (snap.hasError || !snap.hasData || snap.data == null)
            return Signin();
          else
            return MainPage();
        } catch (e) {
          return Scaffold();
        }
      },
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> articles() {
    return FirebaseFirestore.instance.collection('articles').snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> user() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  static Future<void> addNewArticle(
      String imageUrl, String head, String cap, String categorie) async {
    await FirebaseFirestore.instance.collection('articles').add({
      'imageUrl': imageUrl,
      'head': head,
      'cap': cap,
      'date': Timestamp.now(),
      'categorie': categorie,
      'likeCount':0,
    });
  }

  static Future<void> editArticle(String imageUrl, String head, String cap,
      String id, String categorie) async {
    await FirebaseFirestore.instance.collection('articles').doc(id).update({
      'imageUrl': imageUrl,
      'head': head,
      'cap': cap,
      'date': Timestamp.now(),
      'categorie': categorie
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> categories() {
    return FirebaseFirestore.instance.collection('categories').snapshots();
  }

  static Future<void> addCategorie(String categorie) async {
    await FirebaseFirestore.instance.collection('categories').add(
      {'value': categorie},
    );
  }

  static Future<void> deleteArticle(String id) async {
    await FirebaseFirestore.instance.collection('articles').doc(id).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> likes(String id) {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .collection('likes')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> comments(String id) {
    return FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .collection('comments')
        .snapshots();
  }

  static Future<void> addLikes(String id, int likeCount) async {
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .update({'likeCount': likeCount + 1});
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'like': 'like'});
  }

  static Future<void> removeLike(String id, int likeCount) async {
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .update({'likeCount': likeCount - 1});
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }

  static Future<void> addComment(String id, String comment) async {
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(id)
        .collection('comments')
        .add({
      'id': FirebaseAuth.instance.currentUser!.uid,
      'value': comment,
      'name': (await FireStoreHepler.user().first)['name'],
      'date':Timestamp.now()
    });
  }
}
