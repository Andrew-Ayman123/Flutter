import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/screens/event/profile_screen.dart';
import 'package:asdt_app/screens/event/review_screen.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/loading_error_handling.dart';
import 'package:flutter/material.dart';

class SearchUsersData extends SearchDelegate {
  Map<String, AppUser>? allUsers;

  Widget generateSearchSuggestAndResult(BuildContext context) {
    return FutureBuilder<Map<String, AppUser>>(
        initialData: allUsers,
        future: allUsers == null ? FirebaseFirestoreHelper.getUsers : null,
        builder:
            (BuildContext ctx, AsyncSnapshot<Map<String, AppUser>> snapshot) {
          return LoadingErrorHandling(
              builder: () {
                allUsers = snapshot.data;
                final userEmails = allUsers!.keys
                    .where((element) => element.startsWith(query.toLowerCase()))
                    .toList();

                return CustomListView.builder(
                  itemCount: userEmails.length,
                  itemBuilder: (listCtx, index) {
                    final user = allUsers![userEmails[index]]!;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(user.name),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                ProfileScreen.routeName,
                                arguments: user);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.imageLink),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              },
              isLoading: snapshot.connectionState == ConnectionState.waiting,
              isError: snapshot.hasError);
        });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme

    return Theme.of(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return generateSearchSuggestAndResult(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return generateSearchSuggestAndResult(context);
  }
}
