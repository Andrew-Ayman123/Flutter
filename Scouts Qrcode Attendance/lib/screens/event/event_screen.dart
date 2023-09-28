import 'package:asdt_app/classes/event.dart';
import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/classes/user_att.dart';
import 'package:asdt_app/constants/colors.dart';
import 'package:asdt_app/constants/fonts.dart';
import 'package:asdt_app/helpers/excel.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/format.dart';
import 'package:asdt_app/screens/event/review_screen.dart';
import 'package:asdt_app/screens/event/profile_screen.dart';
import 'package:asdt_app/screens/event/qr_scanner_screen.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/widgets/loading_error_handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});
  static const routeName = '/EventScreen';

  Widget generateAppUserTile({
    required AppUser user,
    required BuildContext context,
    AppUserAttendance? appUserAttendance,
    required Event event,
  }) {
    final bool attended = appUserAttendance != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(user.name),
          onTap: () {
            Navigator.of(context).pushNamed(ReviewScreen.routeName, arguments: {
              "user": user,
              "event": event,
            });
          },
          subtitle: Text(
              attended
                  ? FormatHelper.formatDate(appUserAttendance.date)
                  : "Didn't Attend.",
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: attended
                      ? (event.date.isBefore(appUserAttendance.date))
                          ? ConstColors.errorColor
                          : ConstColors.doneColor
                      : ConstColors.errorColor)),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProfileScreen.routeName, arguments: user);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.imageLink),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Event event = ModalRoute.of(context)!.settings.arguments as Event;
    return CustomScaffold(
      appBar: AppBar(
        title: Text(event.name),
        actions: [
          IconButton(
              onPressed: () => ExcelHelper.shareEventExcelSheet(event, context),
              icon: Icon(Icons.share))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestoreHelper.getUsersByEventIdStream(event.id!),
        builder: (streamContext,
            AsyncSnapshot<QuerySnapshot<AppUserAttendance>> streamSnapshot) {
          return FutureBuilder(
            future: FirebaseFirestoreHelper.getUsers,
            builder: (
              futureContext,
              AsyncSnapshot<Map<String, AppUser>> futureSnapshot,
            ) {
              return LoadingErrorHandling(
                  builder: () {
                    final Map<String, AppUserAttendance> usersAttendance =
                        FirebaseFirestoreHelper.convertListToMap(
                            streamSnapshot.data!.docs);
                    final Map<String, AppUser> allUsers = futureSnapshot.data!;
                    final List<String> usersAttendanceListEmails =
                        usersAttendance.keys.toList();
                    final List<String> allUsersNotArrived = allUsers.keys
                        .where(
                            (element) => !usersAttendance.containsKey(element))
                        .toList();

                    return CustomListView(
                      noScroll: false,
                      padding: EdgeInsets.only(top: 8.0),
                      children: [
                        CustomListView.builder(
                          padding: EdgeInsets.zero,
                          noScroll: true,
                          itemCount: usersAttendanceListEmails.length,
                          itemBuilder: (listCtx, listIndex) {
                            final AppUser user =
                                allUsers[usersAttendanceListEmails[listIndex]]!;
                            final userAttendance = usersAttendance[
                                usersAttendanceListEmails[listIndex]]!;
                            return generateAppUserTile(
                                user: user,
                                appUserAttendance: userAttendance,
                                context: listCtx,
                                event: event);
                          },
                        ),
                        CustomListView.builder(
                          padding: EdgeInsets.zero,
                          noScroll: true,
                          itemCount: allUsersNotArrived.length,
                          itemBuilder: (listCtx, listIndex) {
                            final AppUser user =
                                allUsers[allUsersNotArrived[listIndex]]!;

                            return generateAppUserTile(
                                user: user, context: listCtx, event: event);
                          },
                        ),
                      ],
                    );
                  },
                  isLoading: futureSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      streamSnapshot.connectionState == ConnectionState.waiting,
                  isError: futureSnapshot.hasError || streamSnapshot.hasError);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            QRScanner.routeName,
            arguments: event,
          );
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
