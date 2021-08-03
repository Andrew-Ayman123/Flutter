import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_app_2/Helper/FireStoreHelper.dart';
import 'package:timeago/timeago.dart' as time;

class ArticleScreen extends StatefulWidget {
  final String? title;
  final String? imageUrl;
  final String? cap;
  final String? id;
  final DateTime? date;
  final String? categorie;

  ArticleScreen({
    @required this.title,
    @required this.imageUrl,
    @required this.cap,
    @required this.id,
    @required this.date,
    @required this.categorie,
  });

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  var commentController = TextEditingController();
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FireStoreHepler.comments(widget.id!),
          builder: (ctx,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            final comments = snapshot.data!.docs;
            return ListView(children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 19 / 6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: MediaQuery.of(context).size.width * .2),
                      child: Hero(
                        tag: widget.id!,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: AssetImage('Assets/placeHolder.png'),
                          image: NetworkImage(widget.imageUrl!),
                        ),
                      ),
                    ),
                  ),
                  Positioned(left: 5,top: 5,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      widget.title!,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.cap!,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        time.format(widget.date!, locale: ''),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder(
                            stream: FireStoreHepler.likes(widget.id!),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return TextButton.icon(
                                  label: Text('Like'),
                                  onPressed: null,
                                  style: TextButton.styleFrom(
                                    primary: Colors.red.shade900,
                                  ),
                                  icon: FaIcon(
                                    FontAwesomeIcons.heart,
                                  ),
                                );
                              final likesList = snapshot.data!.docs;
                              final isLiked = likesList
                                      .where((element) =>
                                          element.id ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .toList()
                                      .length ==
                                  1;
                              return TextButton.icon(
                                label: Text(likesList.length == 0
                                    ? 'Like'
                                    : likesList.length.toString()),
                                onPressed: () {
                                  !isLiked
                                      ? FireStoreHepler.addLikes(
                                          widget.id!, likesList.length)
                                      : FireStoreHepler.removeLike(
                                          widget.id!, likesList.length);
                                },
                                style: TextButton.styleFrom(
                                  primary: isLiked
                                      ? Colors.redAccent
                                      : Colors.red.shade900,
                                ),
                                icon: FaIcon(
                                  isLiked
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                ),
                              );
                            }),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              primary: Colors.purple.shade900),
                          label: Text('Share'),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text:
                                    'Headline : ${widget.title}\n Descreption : ${widget.cap}'));
                            Fluttertoast.showToast(
                                msg: 'The Article has been copied');
                          },
                          icon: FaIcon(FontAwesomeIcons.share),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Comment',
                                labelText: 'Comment',
                                prefixIcon: Icon(Icons.comment),
                                suffixIcon: TextButton(
                                  onPressed: () async {
                                    try {
                                      if (commentController.text.trim().isEmpty)
                                        return;
                                      if (!kIsWeb)
                                        FocusScope.of(context).unfocus();
                                      await FireStoreHepler.addComment(
                                          widget.id!,
                                          commentController.text.trim());
                                      setState(() {
                                        commentController.clear();
                                      });
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'There has been an error with your comment');
                                    }
                                  },
                                  child: Text('Send'),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Comments : ',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (ctx, index) => Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(comments[index]['name']),
                                subtitle: Text(
                                  comments[index]['value'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 15),
                                ),
                                trailing: Text(
                                  time.format(
                                    (comments[index]['date'] as Timestamp)
                                        .toDate(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
