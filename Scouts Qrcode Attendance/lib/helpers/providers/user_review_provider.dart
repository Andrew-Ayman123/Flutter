import 'package:asdt_app/classes/user_rev.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppUserReviewProvider with ChangeNotifier {
  late AppUserReview _userReview;
  final formKey = GlobalKey<FormState>();
  AppUserReviewProvider(AppUserReview appReview) {
    _userReview = appReview;
  }

  AppUserReviewProvider.withEmailAndId(String email, String eventId) {
    _userReview = AppUserReview(email: email, eventId: eventId);
  }

  void setIsCostume(bool variable) {
    _userReview.isCostume = variable;
    notifyListeners();
  }

  void setIsChurch(bool variable) {
    _userReview.isChurch = variable;
    notifyListeners();
  }

  void setIsSharing(bool variable) {
    _userReview.isSharing = variable;
    notifyListeners();
  }

  void setExcuse(String? txt) {
    _userReview.excuse = txt!.trim();
  }

  bool get getIsCostume {
    return _userReview.isCostume;
  }

  bool get getIsChurch {
    return _userReview.isChurch;
  }

  bool get getIsSharing {
    return _userReview.isSharing;
  }

  String get getExcuse {
    return _userReview.excuse;
  }

  Future<bool> get saveReview async {
    try {
      formKey.currentState!.save();
      await FirebaseFirestoreHelper.addNewReview(_userReview);
      return true;
    } catch (e) {
      return false;
    }
  }
}
