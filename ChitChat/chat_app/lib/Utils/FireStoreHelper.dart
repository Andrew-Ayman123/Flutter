import 'package:chat_app/Utils/AuthHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  static var _fireStore = FirebaseFirestore.instance;
  static Future<void> addNewUser(String name, String url) async {
    await _fireStore.collection('users').doc(AuthHelper.user.uid).set(
      {
        'name': AuthHelper.user.displayName ?? name ?? 'Unknown',
        'email': AuthHelper.user.email ?? AuthHelper.user.phoneNumber,
        'imageLink': AuthHelper.user.photoURL ?? url ?? 'null',
        'lastSeen': Timestamp.now(),
      },
      SetOptions(merge: true),
    );
  }

  static Future<void> sendMessage(String chatId, String message) async {
    await _fireStore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': message,
      'senderId': AuthHelper.user.uid,
      'time': Timestamp.now(),
    });
  }

  static Future<String> createNewChat(
      String reciverId, String name, String imageUrl) async {
    final snap = await _fireStore
        .collection('users')
        .doc(AuthHelper.user.uid)
        .collection('chats')
        .doc(reciverId)
        .get();
    if (snap.exists) return snap['chatId'];
    final res = await _fireStore.collection('chats').add(
      {
        'members': [AuthHelper.user.uid, reciverId],
        'ownerId': AuthHelper.user.uid,
      },
    );
    await _fireStore
        .collection('users')
        .doc(AuthHelper.user.uid)
        .collection('chats')
        .doc(reciverId)
        .set({
      'chatId': res.id,
      'name': name,
      'imageLink': imageUrl,
      'time': Timestamp.now(),
    }, SetOptions(merge: true));
    final temp =
        await _fireStore.collection('users').doc(AuthHelper.user.uid).get();
    await _fireStore
        .collection('users')
        .doc(reciverId)
        .collection('chats')
        .doc(AuthHelper.user.uid)
        .set({
      'chatId': res.id,
      'name': temp['name'],
      'imageLink': temp['imageLink'],
      'time': Timestamp.now(),
    }, SetOptions(merge: true));
    return res.id;
  }

  static Stream<QuerySnapshot> chat(String chatId) {
    return _fireStore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  static Stream<DocumentSnapshot> get user {
    return _fireStore.collection('users').doc(AuthHelper.user.uid).snapshots();
  }

  static Stream<QuerySnapshot> users(String searched) async* {
    // String email = (await _fireStore
    //     .collection('users')
    //     .doc(AuthHelper.user.uid)
    //     .get(GetOptions(source: Source.cache)))['email'];

    yield* _fireStore
        .collection('users')
        .where(
          'name',
          isGreaterThanOrEqualTo: searched.isEmpty ? null : searched,
          isLessThanOrEqualTo: searched.isEmpty
              ? null
              : searched.substring(0, searched.length - 1) +
                  String.fromCharCode(
                      searched.codeUnitAt(searched.length - 1) + 1),
        )
        .snapshots();
  }

  static Stream<QuerySnapshot> get chats {
    return _fireStore
        .collection('users')
        .doc(AuthHelper.user.uid)
        .collection('chats')
        .snapshots();
  }
}
