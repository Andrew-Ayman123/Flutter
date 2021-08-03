import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_app_2/Helper/FireStoreHelper.dart';
import 'package:new_app_2/Helper/filtersUtils.dart';

import 'article.dart';

class Articles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireStoreHepler.articles(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );

        return StatefulBuilder(builder: (contextSt, setSta) {
          var docs = snap.data!.docs;

          if (Filters.filters.contains('Time'))
            docs.sort((a, b) =>
                (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));
          if (Filters.filters.contains('Most Rated'))
            docs.sort((a, b) =>
                (b['likeCount'] as int).compareTo(a['likeCount'] as int));
          if (Filters.categoryList.length >= 1)
            docs = docs
                .where((element) =>
                    Filters.categoryList.contains(element['categorie']))
                .toList();

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 10,
                  children: Filters.filters
                      .map(
                        (e) => Chip(
                          label: Text(e),
                          onDeleted: () {
                            setSta(() {
                              Filters.categoryList.remove(e);
                              Filters.filters.remove(e);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              if (Filters.filters.isNotEmpty)
                Divider(
                  thickness: 2,
                ),
              (docs.isEmpty)
                  ? Center(
                      child: Container(padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'There is No News Today\nCome again later',
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            kIsWeb && MediaQuery.of(context).size.width > 700
                                ? 3
                                : 1,
                        mainAxisExtent: 375,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (ctxl, index) {
                        return Article(
                          imageUrl: docs[index]['imageUrl'],
                          title: docs[index]['head'],
                          cap: docs[index]['cap'],
                          date: (docs[index]['date'] as Timestamp).toDate(),
                          id: docs[index].id,
                          categorie: docs[index]['categorie'],
                        );
                      },
                    )
            ],
          );
        });
      },
    );
  }
}
