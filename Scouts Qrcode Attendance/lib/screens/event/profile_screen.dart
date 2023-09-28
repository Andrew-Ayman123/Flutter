import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/widgets/home/profile_page.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ProfileScreen({super.key});
  late final AppUser user;
  static const routeName = "/ProfileScreen";
  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)!.settings.arguments as AppUser;
    return CustomScaffold(
      appBar: AppBar(title: Text("User Profile"),),
      body: ProfilePage(receivedUser: user),
    );
  }
}
