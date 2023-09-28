import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/widgets/loading_error_handling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});
  static const routeName = '/ReportScreen';
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text("Reports")),
      body: FutureBuilder(
          future: FirebaseFirestoreHelper.userReports(),
          builder: (_, snapshot) {
            return LoadingErrorHandling(
                builder: () {
                  final users = snapshot.data!;
                  final userKeys = users.keys.toList();

                  return CustomListView.builder(
                      itemCount: userKeys.length,
                      itemBuilder: (_, index) {
                        final AppUser user =
                            users[userKeys[index]]!['user']! as AppUser;
                        final int eventsNum =
                            (users[userKeys[index]]!['events_num'])! as int;
                        final int totalEvents =
                            (users[userKeys[index]]!['total_events_num'])!
                                as int;
                        return ListTile(
                          title: Text(user.name),
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.imageLink)),
                          trailing: Text("$eventsNum/$totalEvents"),
                        );
                      });
                },
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                isError: snapshot.hasError);
          }),
    );
  }
}
