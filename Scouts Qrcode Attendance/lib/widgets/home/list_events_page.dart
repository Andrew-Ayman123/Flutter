import 'package:asdt_app/classes/event.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/format.dart';
import 'package:asdt_app/screens/admin/create/create_event.dart';
import 'package:asdt_app/screens/event/event_screen.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/loading_error_handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListEventsPage extends StatelessWidget {
  const ListEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Upcoming Events: "),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(CreateNewEventScreen.routeName);
            },
          ),
        ),
        Expanded(
            child: StreamBuilder(
          stream: FirebaseFirestoreHelper.eventsGet,
          builder: (ctx, AsyncSnapshot<QuerySnapshot<Event>> snapshot) {
            return LoadingErrorHandling(
              builder: () {
                final List<Event> events = snapshot.data!.docs
                    .map<Event>((e) => e.data()..setId(e.id))
                    .toList();
                return CustomListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: events.length,
                  itemBuilder: (listCtx, index) {
                    return Column(
                      children: [
                        ListTile(
                          dense: true,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                EventScreen.routeName,
                                arguments: events[index]);
                          },
                          isThreeLine: true,
                          title: Text(
                              "${(index % 2 == 0) ? '⚜️' : '⚓'} ${events[index].name}"),
                          subtitle: FittedBox(
                            child: Text(
                              '${events[index].location}\n${FormatHelper.formatDate(events[index].date)}',
                            ),
                          ),
                          trailing: SizedBox(
                            width: MediaQuery.of(context).size.width * .25,
                            child: FutureBuilder(
                              future: FirebaseFirestoreHelper.getUserByEmail(
                                  events[index].adminEmail),
                              builder: (futureCtx, futureSnapshot) {
                                if (!futureSnapshot.hasData) {
                                  return SizedBox();
                                } else {
                                  return FittedBox(
                                      child: Text(futureSnapshot.data!.name));
                                }
                              },
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              },
              isLoading: snapshot.connectionState == ConnectionState.waiting,
              isError: snapshot.hasError,
            );
          },
        ))
      ],
    );
  }
}
