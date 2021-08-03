import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Utils/AuthHelper.dart';
import 'package:chat_app/Utils/FireStoreHelper.dart';
import 'package:chat_app/screens/single_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searched = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 10, horizontal: MediaQuery.of(context).size.width * .05),
          child: TextField(
            
            decoration: InputDecoration(labelText: 'Search',suffixIcon: Icon(Icons.search),border: OutlineInputBorder()),
            onChanged: (src) => setState(() {searched=src;}),
          ),
        ),
        StreamBuilder(
          stream: FireStoreHelper.users(searched),
          // ignore: missing_return
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return Center(
                //child: CircularProgressIndicator(),
              );
            if (!snap.hasData)
              return Center(
                child: Text('No Users',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              );
            else {
              final docs = snap.data.docs;
              return Expanded(
                child: ListView.builder(
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
                          )),
                        ],
                      ),
                    );
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Center(
                            child: ListTile(
                              dense: true,
                              key: ValueKey(docs[index].id),
                              subtitle: Text(docs[index]['email']),
                              isThreeLine: true,
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: receiverImage),
                              title: Text(
                                docs[index]['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              onTap: () async {
                                AuthHelper.showLoding(context);
                                final chatId =
                                    await FireStoreHelper.createNewChat(
                                        docs[index].id,
                                        docs[index]['name'],
                                        docs[index]['imageLink']);
                                AuthHelper.closeDialog(context);
                                Navigator.of(context).pushNamed(
                                  SingleChatScreen.routeName,
                                  arguments: {
                                    'user': docs[index],
                                    'reciverImage': receiverImage,
                                    'chatId': chatId
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
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
