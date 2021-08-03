import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app_2/Helper/GeneralUtils.dart';
import 'package:new_app_2/Helper/SignInHelper.dart';
import 'package:new_app_2/Helper/ThemeChooser.dart';
import 'package:provider/provider.dart';

enum Kind { Reg, Log }

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final formKey = GlobalKey<FormState>();
  var type = Kind.Reg;
  var passCheckerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Provider.of<ThemeChooser>(context).gradient,
            ),
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 150,
                      child: Image.asset(
                        'Assets/main_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Newsify',
                      style: GoogleFonts.quicksand(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (kIsWeb && width > 1000)
                      Container(
                        width: width * .4,
                        child: Text(
                          'Newsify is a news app that presents the latest news in crisp format from trusted national and international publishers. \nRead the latest India News, Breaking News from across the world, viral videos & more in English and Indic languages ',
                          style: GoogleFonts.roboto(
                            fontSize: 25,
                            wordSpacing: 3,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Form(
                      key: formKey,
                      child: AnimatedContainer(
                        width: min(
                            MediaQuery.of(context).size.width * .75, 900 * .65),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        duration: Duration(milliseconds: 500),
                        height: kIsWeb? type == Kind.Reg ? 440 : 290:type == Kind.Reg ? 500 : 350,margin: EdgeInsets.only(bottom: 30),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: MediaQuery.of(context).size.width * .03,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                type == Kind.Reg ? 'Registeration' : 'Login',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  focusColor: Theme.of(context).accentColor,
                                  hintText: 'Enter E-mail',
                                  labelText: 'E-mail',
                                ),
                                validator: (str) {
                                  if (str!.trim().isEmpty)
                                    return 'The email cannot be empty';
                                  return null;
                                },
                                onSaved: (str) =>
                                    SignInHelper.setemail(str!.trim()),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                controller: passCheckerController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  focusColor: Theme.of(context).accentColor,
                                  hintText: 'Enter Password',
                                  labelText: 'Password',
                                ),
                                validator: (str) {
                                  if (str!.trim().isEmpty || str.length < 7)
                                    return 'The password must be 7 characters long';
                                  return null;
                                },
                                onSaved: (str) =>
                                    SignInHelper.setPass(str!.trim()),
                              ),
                              if (type == Kind.Reg) ...[
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    focusColor: Theme.of(context).accentColor,
                                    hintText: 'Re Enter Password',
                                    labelText: 'Password Check',
                                  ),
                                  validator: (str) {
                                    if (str!.trim().isEmpty || str.length < 7)
                                      return 'The password must be 7 characters long';
                                    if (str != passCheckerController.text)
                                      return 'The passwords doesnot match';
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    focusColor: Theme.of(context).accentColor,
                                    hintText: 'Enter Name',
                                    labelText: 'Name',
                                  ),
                                  validator: (str) {
                                    if (str!.trim().isEmpty)
                                      return 'The Name cannot be empty';
                                    return null;
                                  },
                                  onSaved: (str) =>
                                      SignInHelper.setName(str!.trim()),
                                ),
                              ],
                              SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    type =
                                        type == Kind.Reg ? Kind.Log : Kind.Reg;
                                  });
                                },
                                child: Text(type == Kind.Reg
                                    ? 'Do you have an account ? Login Now'
                                    : 'Create an account'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) return;
                                  Utils.showLoading(context);
                                  formKey.currentState!.save();
                                  type == Kind.Reg
                                      ? await SignInHelper.signUp(context)
                                      : await SignInHelper.login(context);
                                  Utils.closeLoading();
                                },
                                child: Text(
                                    type == Kind.Reg ? 'Register' : 'Login'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
