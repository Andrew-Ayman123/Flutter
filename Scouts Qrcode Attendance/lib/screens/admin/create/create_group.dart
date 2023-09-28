import 'package:asdt_app/constants/colors.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/snackbar.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/custom_loading_button.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/widgets/custom_textformfield.dart';
import 'package:asdt_app/widgets/loading_error_handling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateNewGroupScreen extends StatefulWidget {
  const CreateNewGroupScreen({super.key});
  static const String routeName = "/CreateNewGroupScreen";

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  final _formKey = GlobalKey<FormState>();

  String _newGroupName = "";

  Future<void> createNewGroup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    await FirebaseFirestoreHelper.addNewGroup(_newGroupName, context);
    setState(() {
      _formKey.currentState!.reset();
    });
  }

  void setGroupName(String? txt) {
    _newGroupName = txt!.trim();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text("Edit Groups"),
      ),
      body: Form(
        key: _formKey,
        child: CustomListView(
          children: [
            CustomTextFormField(
              onSaved: setGroupName,
              type: CustomTextInputType.groupName,
            ),
            SizedBox(
              height: 8,
            ),
            CustomLoadingButton(
                text: 'Submit',
                onPressed: createNewGroup,
                icon: Icon(Icons.add)),
            SizedBox(
              height: 8,
            ),
            Divider(),
            Text("Groups: "),
            SizedBox(
              height: 8,
            ),
            FutureBuilder(
              future: FirebaseFirestoreHelper.getGroupNames,
              builder: (_, AsyncSnapshot<List<String>> snapshot) {
                return LoadingErrorHandling(
                    builder: () => CustomListView(
                          padding: EdgeInsets.zero,
                          noScroll: true,
                          children: snapshot.data!
                              .map<Widget>(
                                (e) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text("Group: $e"),
                                      subtitle: Divider(),
                                    )
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                    isLoading:
                        snapshot.connectionState == ConnectionState.waiting,
                    isError: snapshot.hasError);
              },
            ),
          ],
        ),
      ),
    );
  }
}
