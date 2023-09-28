import 'package:asdt_app/helpers/firebase_auth.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/custom_loading_button.dart';
import 'package:asdt_app/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const routeName = "/LoginScreen";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> loginWithEmailPass(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    await FirebaseAuthHelper.login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Form(
              key: formKey,
              child: CustomListView(
                children: [
                  Text(
                    "Hello, Scout",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 250,
                    child: Image.asset("assets/images/logo_center.png"),
                  ),
                  const CustomTextFormField(
                    onSaved: FirebaseAuthHelper.setEmail,
                    type: CustomTextInputType.userEmail,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const CustomTextFormField(
                    onSaved: FirebaseAuthHelper.setPassword,
                    type: CustomTextInputType.userPassword,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomLoadingButton(
                      text: 'Login',
                      onPressed: () async => await loginWithEmailPass(context),
                      icon: Icon(Icons.login)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
