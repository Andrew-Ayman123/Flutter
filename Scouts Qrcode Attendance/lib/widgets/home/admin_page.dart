import 'package:asdt_app/constants/colors.dart';
import 'package:asdt_app/screens/admin/create/create_group.dart';
import 'package:asdt_app/screens/admin/create/create_user.dart';
import 'package:asdt_app/screens/admin/edit_users_screen.dart';
import 'package:asdt_app/screens/admin/reports.dart';
import 'package:asdt_app/widgets/custom_gridview.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  Widget gridTile(
      {required IconData icon,
      required String text,
      required void Function() func,
      required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(),
          borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MaterialButton(
          onPressed: func,
          child: GridTile(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 45,
              ),
            ),
            footer: Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomGridView(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25),
        children: [
          gridTile(
            context: context,
            icon: Icons.person_add_alt_rounded,
            text: 'Create New Member',
            func: () {
              Navigator.of(context).pushNamed(CreateNewUserScreen.routeName);
            },
          ),
          gridTile(
            context: context,
            icon: Icons.group_add,
            text: 'Create New Group',
            func: () {
              Navigator.of(context).pushNamed(CreateNewGroupScreen.routeName);
            },
          ),
          gridTile(
              context: context,
              icon: FontAwesomeIcons.chartPie,
              text: "Reports",
              func: () {
                Navigator.of(context).pushNamed(ReportScreen.routeName);
              }),
          // gridTile(
          //     context: context,
          //     icon: Icons.person_search_rounded,
          //     text: "Edit Users Data",
          //     func: () {
          //       showSearch(
          //         context: context,
          //         delegate: SearchUsersData(),
          //       );
          //     }),
        ]);
  }
}
