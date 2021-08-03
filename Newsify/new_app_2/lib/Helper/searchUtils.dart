import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_app_2/Helper/FireStoreHelper.dart';
import 'package:new_app_2/Helper/ThemeChooser.dart';
import 'package:new_app_2/widgets/article.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate<String> {
  final bool normalSearch;
  final Function? func;
  DataSearch(this.normalSearch, [this.func]);

  @override
  ThemeData appBarTheme(BuildContext context) {
    // ignore: todo
    // TODO: implement appBarTheme
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
          ),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // ignore: todo
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      decoration: MediaQuery.of(context).size.width > 800
          ? BoxDecoration(
              gradient: LinearGradient(
              colors: Provider.of<ThemeChooser>(context).gradient,
            ))
          : null,
      child: StreamBuilder(
          stream: FireStoreHepler.articles(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            var docs = snapshot.data!.docs;
            if (query.trim().isNotEmpty) {
              docs = docs
                  .where((element) => (element['head'] as String)
                      .toLowerCase()
                      .startsWith(query.toLowerCase()))
                  .toList();
            }
            if (docs.isEmpty)
              return Center(
                child: Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'There is No News Today\nCome again later',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      kIsWeb && MediaQuery.of(context).size.width > 700 ? 3 : 1,
                  mainAxisExtent: 375,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (ctx, index) => GestureDetector(
                      onTap: normalSearch
                          ? null
                          : () {
                              func!(
                                docs[index]['head'],
                                docs[index]['cap'],
                                docs[index]['imageUrl'],
                                docs[index].id,
                                docs[index]['categorie'],
                              );
                            },
                      child: Article(
                        imageUrl: docs[index]['imageUrl'],
                        title: docs[index]['head'],
                        cap: docs[index]['cap'],
                        date: (docs[index]['date'] as Timestamp).toDate(),
                        id: docs[index].id,
                        categorie: docs[index]['categorie'],
                        normalSearch: normalSearch,
                      ),
                    ),
                itemCount: docs.length);
          }),
    );
  }
}
