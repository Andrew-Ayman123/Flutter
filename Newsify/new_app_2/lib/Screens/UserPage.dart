import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_app_2/Helper/AdminHelper.dart';
import 'package:new_app_2/Helper/FireStoreHelper.dart';
import 'package:new_app_2/Helper/SignInHelper.dart';
import 'package:new_app_2/Helper/ThemeChooser.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  Widget adminDash(IconData icon, String text, Function func) {
    return Card(
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
            Text(text)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireStoreHepler.user(),
      builder:
          (ctx, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: [
              Text(
                'Name : ${snap.data!['name']}',
                style: TextStyle(fontSize: 25),
              ),
              Text(
                'E-mail : ${snap.data!['email']}',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              SwitchListTile(
                  title: Text('Theme : [Dark/Light]'),
                  value: Provider.of<ThemeChooser>(context).isDark,
                  onChanged: Provider.of<ThemeChooser>(context).toggle),
              if (snap.data!['isAdmin']&&MediaQuery.of(context).size.width < 800) ...[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150),
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      adminDash(Icons.add, 'Add News',
                          () => AdminHelper.addNews(context)),
                      adminDash(Icons.edit, 'Edit News', () {
                        AdminHelper.editArticles(context);
                      }),
                      adminDash(Icons.delete, 'Delete News', () {
                        AdminHelper.deleteArticles(context);
                      }),
                      adminDash(Icons.category, 'Add Category', () {
                        AdminHelper.addCategorie(context);
                      }),
                    ],
                  ),
                )
              ],
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      SignInHelper.signOut(context);
                    },
                    child: Text('Sign Out')),
              ),
            ],
          ),
        );
      },
    );
  }
}
