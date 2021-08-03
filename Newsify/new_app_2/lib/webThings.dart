import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_app_2/Helper/filtersUtils.dart';
import 'package:new_app_2/widgets/articles.dart';
import 'package:provider/provider.dart';

import 'Helper/AdminHelper.dart';
import 'Helper/FireStoreHelper.dart';
import 'Helper/ThemeChooser.dart';
import 'Screens/UserPage.dart';

class WebMainPage extends StatefulWidget {
  @override
  _WebMainPageState createState() => _WebMainPageState();
}

class _WebMainPageState extends State<WebMainPage> {
  Widget iconCard(IconData icon, String text, Function func) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: 125,
        child: Card(
          child: InkWell(
            onTap: () => func(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 45,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(text),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Provider.of<ThemeChooser>(context).gradient,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(children: [
              iconCard(Icons.all_inbox, 'All News', () {
                if (Filters.index == 1)
                  setState(() {
                    Filters.index = 0;
                  });
              }),
              iconCard(Icons.person, 'My Profile', () {
                if (Filters.index == 0)
                  setState(() {
                    Filters.index = 1;
                  });
              }),
              StreamBuilder(
                  stream: FireStoreHepler.user(),
                  builder: (ctx,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snap) {
                    if (snap.connectionState == ConnectionState.waiting)
                      return Container();
                    if (snap.data!['isAdmin'])
                      return Column(
                        children: [
                          iconCard(Icons.add, 'Add News',
                              () => AdminHelper.addNews(context)),
                          iconCard(Icons.edit, 'Edit News', () {
                            AdminHelper.editArticles(context);
                          }),
                          iconCard(Icons.delete, 'Delete News', () {
                            AdminHelper.deleteArticles(context);
                          }),
                          iconCard(Icons.category, 'Add Category', () {
                            AdminHelper.addCategorie(context);
                          }),
                        ],
                      );
                    else
                      return Container();
                  }),
            ]),
          ),
          if (Filters.index == 0)
            Expanded(
              child: Articles(),
              flex: 17,
            ),
          if (Filters.index == 1)
            Expanded(
              child: UserPage(),
              flex: 17,
            ),
        ],
      ),
    );
  }
}
