import 'package:flutter/material.dart';
import 'package:new_app_2/Helper/ThemeChooser.dart';

import 'package:new_app_2/Screens/Article_Screen.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as time;

class Article extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  final String? cap;
  final DateTime? date;
  final String? id;
  final String? categorie;
  final bool? normalSearch;
  const Article(
      {@required this.imageUrl,
      @required this.title,
      @required this.cap,
      @required this.date,
      @required this.id,
      @required this.categorie,
      this.normalSearch = true});

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: widget.normalSearch!
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ArticleScreen(
                      title: widget.title,
                      imageUrl: widget.imageUrl,
                      cap: widget.cap,
                      id: widget.id,
                      date: widget.date,
                      categorie: widget.categorie,
                    ),
                  ),
                );
              }
            : null,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: Hero(
                  tag: widget.id!,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    imageErrorBuilder: (_, _b, _c) =>
                        Image.network('https://firebasestorage.googleapis.com/v0/b/newsify-4a7e7.appspot.com/o/newsImages%2Ferror.png?alt=media&token=99c6b6c8-67ab-4876-8996-9647eb2fa6a1'),
                    placeholder: AssetImage('Assets/placeHolder.png'),
                    image: NetworkImage(widget.imageUrl!),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.title!,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Provider.of<ThemeChooser>(context).textColorTitle),
              ),
              Text(
                '#${widget.categorie}',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.cap!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Provider.of<ThemeChooser>(context).textColorSub,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  time.format(widget.date!),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 10,
                    color: Provider.of<ThemeChooser>(context).textColorSub,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
