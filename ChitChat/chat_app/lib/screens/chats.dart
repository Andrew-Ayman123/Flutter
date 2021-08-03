import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Utils/FireStoreHelper.dart';
import 'package:chat_app/Utils/Theme.dart';
import 'package:chat_app/screens/single_chat.dart';

import 'package:chat_app/widgets/AppDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireStoreHelper.chats,
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        final docs = snapShot.data.docs;
        return docs == null || docs.isEmpty
            ? Center(
                child: Text(
                  'There are no Chats',
                  style: TextStyle(fontSize: 30),
                ),
              )
            : ListView.builder(
                itemCount: docs.length,
                itemExtent: 100,
                itemBuilder: (contex, index) {
                  Widget receiverImage = CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 500),
                    errorWidget: (ctx, url, _) =>
                        Image.asset('Assets/Images/No Profile.jpg'),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    imageUrl: docs[index]['imageLink'],
                    placeholder: (ctx, url) => Stack(
                      children: [
                        Image.asset('Assets/Images/No Profile.jpg'),
                        Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Center(
                          child: ListTile(dense: true,
                            key: ValueKey(docs[index].id),
                            subtitle: Text(
                                intl.DateFormat.yMMMMEEEEd().format((docs[index]['time'] as Timestamp).toDate())),
                            isThreeLine: true,
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: receiverImage),
                            title: Text(
                              docs[index]['name'],
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                SingleChatScreen.routeName,
                                arguments: {
                                  'user': docs[index],
                                  'reciverImage': receiverImage,
                                  'chatId': docs[index]['chatId']
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                        indent: MediaQuery.of(context).size.width * .1,
                        endIndent: MediaQuery.of(context).size.width * .05,
                      )
                    ],
                  );
                },
              );
      },
    );
  }
}
