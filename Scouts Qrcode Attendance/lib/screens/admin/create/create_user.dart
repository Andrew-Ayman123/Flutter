import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/constants/fonts.dart';
import 'package:asdt_app/helpers/dialog.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/format.dart';
import 'package:asdt_app/helpers/providers/new_user_provider.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/custom_loading_button.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CreateNewUserScreen extends StatelessWidget {
  static const String routeName = "/CreateNewUser";

  const CreateNewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateNewUserProvider>(context);
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('Create New User'),
      ),
      body: Form(
        key: provider.formKey,
        child: CustomListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 26),
          children: [
            CustomTextFormField(
              onSaved: provider.setUserEmail,
              type: CustomTextInputType.userEmail,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              onSaved: provider.setUserPassword,
              type: CustomTextInputType.userPassword,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              onSaved: provider.setUserConfirmPassword,
              type: CustomTextInputType.userConfirmPassword,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              onSaved: provider.setUserName,
              type: CustomTextInputType.userName,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              onSaved: provider.setUserNickname,
              type: CustomTextInputType.userNickname,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              onSaved: provider.setUserPhoneNumber,
              type: CustomTextInputType.userPhoneNumber,
            ),
            const SizedBox(
              height: 16,
            ),
            provider.generatePhotoSelector(),
            SizedBox(
              height: 8,
            ),
            provider.generateGroupsDropDown(),
            SizedBox(
              height: 8,
            ),
            provider.generateAdminTypeDropDown(),
            SizedBox(
              height: 8,
            ),
            CustomLoadingButton(
                text: 'Submit',
                onPressed: () async {
                  if (await provider.createUser(context)) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.add)),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
          ],
        ),
      ),
    );
  }
}
