import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Utils/AuthHelper.dart';
import 'package:chat_app/Utils/FireStoreHelper.dart';
import 'package:chat_app/Utils/Theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireStoreHelper.user,
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        final data = snap.data;
        try {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 500),
                    errorWidget: (ctx, url, _) =>
                        Image.asset('Assets/Images/No Profile.jpg'),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    imageUrl: data['imageLink'],
                    placeholder: (ctx, url) => Stack(
                      children: [
                        Image.asset('Assets/Images/No Profile.jpg'),
                        Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  data['name'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  data['email'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    AuthHelper.resetAuth(context);
                  },
                  color: Colors.redAccent,
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SwitchListTile.adaptive(
                  activeColor: Colors.blueAccent,
                  title: Text('Theme [Dark/Light]'),
                  value: Provider.of<ThemeChooser>(context).isDark,
                  onChanged: Provider.of<ThemeChooser>(context).toggleTheme,
                )
              ],
            ),
          );
        } catch (e) {
          return Center(
            child: Text(
              'Error. Please Try Again',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }
}
