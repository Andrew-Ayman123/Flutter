import 'package:asdt_app/classes/event.dart';
import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/classes/user_att.dart';
import 'package:asdt_app/classes/user_rev.dart';
import 'package:asdt_app/constants/colors.dart';
import 'package:asdt_app/helpers/firebase_auth.dart';
import 'package:asdt_app/helpers/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreHelper {
  static final _firebase = FirebaseFirestore.instance;
  static AppUser? _user;
  static Future<AppUser> get profileGet async {
    String email = FirebaseAuthHelper.getEmail;
    if (_user == null) {
      final data =
          (await _firebase.collection('users').doc(email).get()).data();
      _user = AppUser.fromJson(data!);
    }
    return _user!;
  }

  static logout() {
    _user = null;
  }

  static Stream<QuerySnapshot<Event>> get eventsGet {
    return _firebase
        .collection('events')
        .orderBy('date', descending: true)
        .withConverter<Event>(
          fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
          toFirestore: (event, _) => event.toJson(),
        )
        .snapshots();
  }

  static Stream<QuerySnapshot<AppUserAttendance>> getUsersByEventIdStream(
      String eventId) {
    return _firebase
        .collection('events_att.')
        .where('event_id', isEqualTo: eventId)
        .orderBy('date', descending: false)
        .withConverter<AppUserAttendance>(
          fromFirestore: (snapshot, _) =>
              AppUserAttendance.fromJson(snapshot.data()!),
          toFirestore: (appUser, _) => appUser.toJson(),
        )
        .snapshots();
  }

  static Future<List<QueryDocumentSnapshot<AppUserAttendance>>>
      getUsersByEventIdFuture(String eventId) async {
    return (await _firebase
            .collection('events_att.')
            .where('event_id', isEqualTo: eventId)
            .orderBy('date', descending: false)
            .withConverter<AppUserAttendance>(
              fromFirestore: (snapshot, _) =>
                  AppUserAttendance.fromJson(snapshot.data()!),
              toFirestore: (appUser, _) => appUser.toJson(),
            )
            .get())
        .docs;
  }

  static Future<Map<String, AppUser>> get getUsers async {
    final data =
        (await _firebase.collection('users').orderBy('name').get()).docs;
    return {
      for (QueryDocumentSnapshot<Map<String, dynamic>> e in data)
        (e.data()["email"]): AppUser.fromJson(e.data())
    };
  }

  static Map<String, AppUserAttendance> convertListToMap(
      List<QueryDocumentSnapshot<AppUserAttendance>> emails) {
    return {
      for (QueryDocumentSnapshot<AppUserAttendance> val in emails)
        val.data().email: val.data()
    };
  }

  static Future<void> addUserToEventAtt(
      AppUserAttendance user, BuildContext context) async {
    try {
      if ((await _firebase.collection('users').doc(user.email).get()).exists) {
        if ((await _firebase
                    .collection('events_att.')
                    .where('email', isEqualTo: user.email)
                    .where('event_id', isEqualTo: user.eventId)
                    .get())
                .size >
            0) {
          SnackBarShower.showSnack(
            context: context,
            message: "${user.email} \nhas already been added before.",
            icon: Icons.warning_amber,
            fontColor: Colors.white,
            backgroundColor: ConstColors.errorColor,
          );
        } else {
          await _firebase
              .collection("events_att.")
              .doc("${user.eventId} ${user.email}")
              .set(user.toJson());
          SnackBarShower.showSnack(
            context: context,
            message: "${user.email} \nhas been added.",
            icon: Icons.done,
            fontColor: Colors.white,
            backgroundColor: ConstColors.doneColor,
          );
        }
      } else {
        SnackBarShower.showSnack(
          context: context,
          message: "This User Does not Exist.",
          icon: Icons.warning_amber,
          fontColor: Colors.white,
          backgroundColor: ConstColors.errorColor,
        );
      }
    } catch (e) {
      SnackBarShower.showSnack(
        context: context,
        message: "Something has gone wrong.\nPlease try again.",
        icon: Icons.warning_amber,
        fontColor: Colors.white,
        backgroundColor: ConstColors.errorColor,
      );
    }
  }

  static Future<bool> addNewEvent({
    required String eventName,
    required String eventLocation,
    required DateTime eventDate,
    required BuildContext context,
  }) async {
    try {
      await _firebase.collection('events').add(
            Event(
              name: eventName,
              adminEmail: FirebaseAuthHelper.getEmail,
              location: eventLocation,
              date: eventDate,
            ).toJson(),
          );
      SnackBarShower.showSnack(
        context: context,
        message: "$eventName \nhas been added.",
        icon: Icons.done,
        fontColor: Colors.white,
        backgroundColor: ConstColors.doneColor,
      );
      return true;
    } catch (e) {
      SnackBarShower.showSnack(
        context: context,
        message: "Something has gone wrong.\nPlease try again.",
        icon: Icons.warning_amber,
        fontColor: Colors.white,
        backgroundColor: ConstColors.errorColor,
      );
    }

    return false;
  }

  static Future<AppUser> getUserByEmail(String email) async {
    return AppUser.fromJson(
        (await _firebase.collection('users').doc(email).get()).data()!);
  }

  static Future<List<String>> get getGroupNames async {
    return <String>[
      for (QueryDocumentSnapshot<String> x in ((await _firebase
              .collection('groups')
              .orderBy('name')
              .withConverter<String>(
                fromFirestore: (snapshot, _) => snapshot.data()!['name'],
                toFirestore: (str, _) => {'name': str},
              )
              .get())
          .docs))
        x.data()
    ];
  }

  static Future<void> addNewUser(
      {required AppUser user, required BuildContext context}) async {
    await _firebase.collection('users').doc(user.email).set(user.toJson());
  }

  static Future<void> addNewGroup(String name, BuildContext context) async {
    try {
      await _firebase.collection('groups').doc(name).set({'name': name});
    } catch (e) {
      SnackBarShower.showSnack(
        context: context,
        message: "Something has gone wrong.\nPlease try again.",
        icon: Icons.warning_amber,
        fontColor: Colors.white,
        backgroundColor: ConstColors.errorColor,
      );
    }
  }

  static Future<Map<String, Map<String, dynamic>>> userReports() async {
    final allUsers = await getUsers;
    final eventsNumber =
        (await _firebase.collection('events').count().get()).count;
    final users = (await _firebase
            .collection('events_att.')
            .withConverter<AppUserAttendance>(
              fromFirestore: (snapshot, _) =>
                  AppUserAttendance.fromJson(snapshot.data()!),
              toFirestore: (appUser, _) => appUser.toJson(),
            )
            .get())
        .docs;

    final Map<String, int> usersCount = {};
    for (int i = 0; i < users.length; i++) {
      usersCount.update(users[i].data().email, (value) => value += 1,
          ifAbsent: () => 1);
    }
    return {
      for (String email in allUsers.keys)
        email: {
          'events_num': usersCount.putIfAbsent(email, () => 0),
          'total_events_num': eventsNumber,
          'user': allUsers[email]!
        }
    };
  }

  static Future<List<QueryDocumentSnapshot<AppUserReview>>>
      getReviewByUserEmail(String email, String eventId) async {
    return (await _firebase
            .collection('events_rev.')
            .where('email', isEqualTo: email)
            .where('event_id', isEqualTo: eventId)
            .withConverter<AppUserReview>(
              fromFirestore: (snapshot, _) =>
                  AppUserReview.fromJson(snapshot.data()!),
              toFirestore: (userReview, _) => userReview.toJson(),
            )
            .get())
        .docs;
  }

  static Future<void> addNewReview(AppUserReview userReview) async {
    await _firebase
        .collection('events_rev.')
        .doc("${userReview.eventId} ${userReview.email}")
        .set(userReview.toJson());
  }

  static Future<List<QueryDocumentSnapshot<AppUserReview>>> getReviewsByEventId(
      String eventId) async {
    return (await _firebase
            .collection('events_rev.')
            .where('event_id', isEqualTo: eventId)
            .withConverter<AppUserReview>(
              fromFirestore: (snapshot, _) =>
                  AppUserReview.fromJson(snapshot.data()!),
              toFirestore: (userReview, _) => userReview.toJson(),
            )
            .get())
        .docs;
  }
}
