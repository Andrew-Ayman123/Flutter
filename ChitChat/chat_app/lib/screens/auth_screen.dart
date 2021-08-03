import 'package:chat_app/Utils/Theme.dart';
import 'package:chat_app/widgets/auth_form/TheOrWidget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/auth_form/TopLogo.dart';
import 'package:chat_app/widgets/auth_form/RegistrationFormSignUp.dart';
import 'package:chat_app/Utils/AuthScreenUtils.dart';
import 'package:chat_app/widgets/SocialIcon.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/AuthScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  void sign(RegistrationUtils reg) async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    FocusScope.of(context).unfocus();
    reg.loading(true);
    if (reg.registrationType == Registration.signUp) {
      await reg.signUp(context);
      reg.loading(false);
    } else if (reg.registrationType == Registration.email) {
      await reg.signIn(context);
      reg.loading(false);
    } else if (reg.registrationType == Registration.phoneNumber) {
      await reg.signWithPhone(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Consumer<RegistrationUtils>(
          builder: (ctx, reg, ch) {
            return ListView(
              children: [
                ch,
                Form(
                  key: formKey,
                  child: const SignUpMainForm(),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      tileMode: TileMode.mirror,
                      colors: Provider.of<ThemeChooser>(context).gradientColors,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .25,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () => sign(reg),
                    child: Center(
                      child: Text(
                        reg.registrationType == Registration.signUp
                            ? 'SignUp'
                            : 'Login',
                        softWrap: true,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 500),
                  height: reg.registrationType == Registration.signUp ? 0 : 40,
                  child: TextButton(
                    onPressed: () => reg.changeType(Registration.signUp),
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account ? ',
                        style: TextStyle(
                            color:
                                Provider.of<ThemeChooser>(context).textColor),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const TheORWidget(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //facebook
                    SocialIcon(
                      colors: const [
                        Color(0xFF102397),
                        Color(0xFF187adf),
                        Color(0xFF00eaf8),
                      ],
                      func: () async {
                        reg.loading(true);
                        await reg.signInWithFacebook(context);
                        reg.loading(false);
                      },
                      icon: FontAwesomeIcons.facebookF,
                    ),
                    //gmail
                    SocialIcon(
                      colors: const [
                        Color(0xFFff4f38),
                        Color(0xFFff355d),
                      ],
                      func: () async {
                        reg.loading(true);
                        await reg.signInWithGoogle(context);
                        reg.loading(false);
                      },
                      icon: FontAwesomeIcons.google,
                    ),

                    //phoneNumber
                    SocialIcon(
                      colors: const [
                        Color.fromRGBO(0x28, 0xC7, 0x6F, 1),
                        Color.fromRGBO(0x81, 0xFB, 0xB8, 1),
                      ],
                      isCloased:
                          reg.registrationType == Registration.phoneNumber,
                      func: () => reg.changeType(Registration.phoneNumber),
                      icon: FontAwesomeIcons.phone,
                    ),
                    //email address
                    SocialIcon(
                      colors: const [
                        Color.fromRGBO(0x59, 0x61, 0xF9, 1),
                        Color.fromRGBO(0xEE, 0x9A, 0xE5, 1),
                      ],
                      isCloased: reg.registrationType == Registration.email,
                      icon: Icons.alternate_email_rounded,
                      func: () => reg.changeType(Registration.email),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          },
          child: const AuthScreenTopLogo(),
        ),
      ),
    );
  }
}
