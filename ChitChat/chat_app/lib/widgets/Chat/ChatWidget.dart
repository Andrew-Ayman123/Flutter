import 'package:bubble/bubble.dart';
import 'package:chat_app/Utils/AuthHelper.dart';
import 'package:chat_app/Utils/FireStoreHelper.dart';
import 'package:chat_app/Utils/Theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class Messages extends StatelessWidget {
  final String chatId;
  final Widget image;
  Messages(this.chatId, this.image);
  @override
  Widget build(BuildContext context) {
    final userId = AuthHelper.user.uid;
    return StreamBuilder(
      stream: FireStoreHelper.chat(chatId),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );

        final docs = snapShot.data.docs;
        return snapShot.hasError || docs == null || docs.isEmpty
            ? Center(
                child: Text(
                  'There are no Messages',
                  style: TextStyle(fontSize: 30),
                ),
              )
            : Scrollbar(
                child: Stack(children: [
                 
                  //  Container(
                  //   height: double.infinity,
                  //   decoration: BoxDecoration(
                  //    color:Theme.of(context).backgroundColor
                  //   ),
                  // ),

                  ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .015,
                      vertical: 0,
                    ),
                    itemBuilder: (ctx, index) {
                      bool isMe = docs[index]['senderId'] == userId;
                      bool isFirst = index != 0
                          ? isMe != (docs[index - 1]['senderId'] == userId)
                          : true;
                      return Column(
                        children: [
                          if (isFirst)
                            SizedBox(
                              height: 10,
                            ),
                          Row(
                            key: ValueKey(index),
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * .45,
                                ),
                                //color: Colors.transparent,
                                child: Bubble(
                                    color:
                                        isMe ? Colors.grey.shade800 : Provider.of<ThemeChooser>(context).bubbleChatColor,
                                    elevation: 2,
                                    showNip: isFirst,
                                    margin: BubbleEdges.symmetric(vertical: 1),padding: BubbleEdges.symmetric(vertical: 10),
                                    nip: isMe
                                        ? BubbleNip.rightTop
                                        : BubbleNip.leftTop,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Wrap(
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            runAlignment: WrapAlignment.start,
                                            textDirection: isMe
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            // mainAxisSize: MainAxisSize.min,
                                            // mainAxisAlignment: MainAxisAlignment.end,
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              if (!isMe && isFirst) ...[
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  height: 30,
                                                  width: 25,
                                                  color: Colors.transparent,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: image,
                                                  ),
                                                ),
                                              ],
                                              Text(
                                                docs[index]['text'],
                                                textAlign: TextAlign.start,
                                                textDirection: docs[index]
                                                            ['text']
                                                        .trim()
                                                        .startsWith(
                                                          RegExp(
                                                            '[a-z]',
                                                            caseSensitive:
                                                                false,
                                                          ),
                                                        )
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              // SizedBox(
                                              //   width: 10,
                                              // ),
                                            ],
                                          ),
                                          Align(
                                            widthFactor: 1,
                                            heightFactor: 1,
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              intl.DateFormat('H:m').format(
                                                (docs[index]['time']
                                                        as Timestamp)
                                                    .toDate(),
                                              ),
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          )
                        ],
                      );
                    },
                    itemCount: docs.length,
                  ),
                ]),
              );
      },
    );
  }
}
