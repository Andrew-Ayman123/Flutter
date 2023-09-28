import 'dart:io';

import 'package:asdt_app/classes/event.dart';
import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/classes/user_att.dart';
import 'package:asdt_app/classes/user_rev.dart';
import 'package:asdt_app/constants/colors.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/format.dart';
import 'package:asdt_app/helpers/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelHelper {
  static Future<void> shareEventExcelSheet(
      Event event, BuildContext context) async {
    try {
      final PermissionStatus status = await Permission.storage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        throw Error();
      }
      final Map<String, AppUser> allUsers =
          await FirebaseFirestoreHelper.getUsers;
      final List<QueryDocumentSnapshot<AppUserAttendance>> usersAttended =
          await FirebaseFirestoreHelper.getUsersByEventIdFuture(event.id!);
      final Map<String, AppUserAttendance> usersAttendedMap = {
        for (QueryDocumentSnapshot<AppUserAttendance> val in usersAttended)
          val.data().email: val.data()
      };
      final List<QueryDocumentSnapshot<AppUserReview>> usersReview =
          await FirebaseFirestoreHelper.getReviewsByEventId(event.id!);
      final Map<String, AppUserReview> usersReviewMap = {
        for (QueryDocumentSnapshot<AppUserReview> val in usersReview)
          val.data().email: val.data()
      };
      final Workbook workbook = Workbook();

      final eventSheet = workbook.worksheets[0];

      final usersSheet = workbook.worksheets.add();
      eventSheet.name = "Event Details";
      usersSheet.name = "Users Attendance";

      eventSheet.getRangeByIndex(1, 1).setText("Event Name");
      eventSheet.getRangeByIndex(2, 1).setText(event.name);
      eventSheet.getRangeByIndex(1, 2).setText("Event Location");
      eventSheet.getRangeByIndex(2, 2).setText(event.location);
      eventSheet.getRangeByIndex(1, 3).setText("Event Date");
      eventSheet
          .getRangeByIndex(2, 3)
          .setText(FormatHelper.formatDate(event.date));
      eventSheet.getRangeByIndex(1, 4).setText("Event Admin");
      eventSheet.getRangeByIndex(2, 4).setText(event.adminEmail);
      eventSheet.getRangeByIndex(1, 5).setText("Event Id");
      eventSheet.getRangeByIndex(2, 5).setText(event.id);
      eventSheet.getRangeByIndex(1, 1, 2, 5).autoFit();
      const firstRow = [
        "Email",
        "Arrived Date",
        "Costume",
        "Church",
        "Sharing",
        "Excuse",
      ];

      for (int i = 1; i <= firstRow.length; i++) {
        usersSheet.getRangeByIndex(1, i).setText(firstRow[i - 1]);
      }

      final allUsersKeys = allUsers.keys.toList();
      for (int i = 1; i <= allUsers.length; i++) {
        final email = allUsersKeys[i - 1];
        usersSheet.getRangeByIndex(i + 1, 1).setText(email);
        usersSheet.getRangeByIndex(i + 1, 2).setText(
              usersAttendedMap.containsKey(email)
                  ? FormatHelper.formatDate(usersAttendedMap[email]!.date)
                  : "Didn't Attend",
            );
        if (usersReviewMap.containsKey(email)) {
          usersSheet
              .getRangeByIndex(i + 1, 3)
              .setText(usersReviewMap[email]!.isCostume.toString());
          usersSheet
              .getRangeByIndex(i + 1, 4)
              .setText(usersReviewMap[email]!.isChurch.toString());
          usersSheet
              .getRangeByIndex(i + 1, 5)
              .setText(usersReviewMap[email]!.isSharing.toString());

          usersSheet
              .getRangeByIndex(i + 1, 6)
              .setText(usersReviewMap[email]!.excuse);
        } else {
          usersSheet.getRangeByIndex(i + 1, 3).setText("false");
          usersSheet.getRangeByIndex(i + 1, 4).setText("false");
          usersSheet.getRangeByIndex(i + 1, 5).setText("false");
          usersSheet.getRangeByIndex(i + 1, 6).setText("");
        }
      }
      usersSheet.getRangeByIndex(1, 1, 2, firstRow.length).autoFit();
      List<int> bytes = workbook.saveAsStream();
      final String folderPath = (await getExternalStorageDirectory())!.path;
      File('$folderPath/${event.name} ${FormatHelper.formatDateForFilePath(event.date)}.xlsx')
          .writeAsBytes(bytes);
      workbook.dispose();
      SnackBarShower.showSnack(
          context: context,
          message: "success",
          icon: Icons.done,
          backgroundColor: ConstColors.doneColor);
    } catch (e) {
      print(e);
      SnackBarShower.showSnack(
          context: context,
          message: "wrong",
          icon: Icons.warning_amber,
          backgroundColor: ConstColors.errorColor);
    }
  }
}
