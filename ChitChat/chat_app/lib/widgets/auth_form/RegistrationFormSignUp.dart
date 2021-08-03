import 'package:chat_app/Utils/AuthScreenUtils.dart';
import 'package:chat_app/widgets/FadeWidget.dart';
import 'package:chat_app/widgets/auth_form/SelectingPicture.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignUpMainForm extends StatefulWidget {
  const SignUpMainForm();

  @override
  _SignUpMainFormState createState() => _SignUpMainFormState();
}

class _SignUpMainFormState extends State<SignUpMainForm> {
  bool passwordHidden = true, confirmPassHidden = true;
  final confirmPassController = TextEditingController();
  @override
  void dispose() {
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var regUtils = Provider.of<RegistrationUtils>(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        height: regUtils.registrationType == Registration.signUp
            ? 475
            : regUtils.registrationType == Registration.email
                ? 225
                : 300,
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInWidget(
              duration: Duration(milliseconds: 1000),
              child: Text(
                regUtils.registrationName,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // const SizedBox(height: 10),
            if (regUtils.registrationType == Registration.email ||
                regUtils.registrationType == Registration.signUp) ...[
              // email
              TextFormField(
                key: const Key('E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  value = value.trim();
                  String tempValue;
                  if (value.isEmpty)
                    tempValue = 'The E-Mail must Not be Empty';
                  else if (!value.contains('@'))
                    tempValue = 'THis is not a valid E-Mail';
                  return tempValue;
                },
                onSaved: regUtils.insertEmailData,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelText: 'E-Mail',
                  hintText: 'Enter Your E-Mail here',
                  prefixIcon: const Icon(
                    Icons.email,
                  ),
                ),
              ),
              //password
              TextFormField(
                controller: confirmPassController,
                key: const Key('Password'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: passwordHidden,
                validator: (value) {
                  value = value.trim();
                  String tempValue;
                  if (value.isEmpty || value.length < 7)
                    tempValue = 'The Password must be at least 7 characters';
                  return tempValue;
                },
                onSaved: regUtils.insertpasswordData,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordHidden ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() {
                      passwordHidden = !passwordHidden;
                    }),
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelText: 'Password',
                  hintText: 'Enter Your Password here',
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                ),
              ),
              if (regUtils.registrationType == Registration.signUp) ...[
                //confirm passowrd on signing up
                TextFormField(
                  key: const Key('Confirm Password'),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: confirmPassHidden,
                  validator: (value) {
                    value = value.trim();
                    String tempValue;
                    if (value.isEmpty || value.length < 7)
                      tempValue = 'The Password must be at least 7 characters';
                    else if (value != confirmPassController.text)
                      tempValue = 'The Passwords don\'t match';
                    return tempValue;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        confirmPassHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() {
                        confirmPassHidden = !confirmPassHidden;
                      }),
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    labelText: 'Confirm Password',
                    hintText: 'Confirm The Password here',
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                    ),
                  ),
                ),
              ],
            ],
            if (regUtils.registrationType == Registration.phoneNumber)
              TextFormField(
                validator: (value) {
                  value = value.trim();
                  String tempValue;
                  if (value.isEmpty)
                    tempValue = 'The phone number must not be empty';
                  else if (!value.startsWith('01') && !value.startsWith('+'))
                    tempValue =
                        'The number must start with the +(country code)';
                  else if (value.startsWith('01') && value.length != 11)
                    tempValue = 'It must include 11 numbers';
                  return tempValue;
                },
                onSaved: (val) {
                  val = val.trim();
                  regUtils.insertphoneNumberData(
                      val.startsWith('01') ? '+20' + val : val);
                },
                key: const Key('phone'),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: 'Begin with +(Country code) if not egypt',
                  labelText: 'Phone Number',
                  hintStyle: TextStyle(fontSize: 13),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            if (regUtils.registrationType == Registration.phoneNumber ||
                regUtils.registrationType == Registration.signUp) ...[
              TextFormField(
                key: const Key('name'),
                validator: (value) {
                  value = value.trim();
                  String tempValue;
                  if (value.isEmpty || value.length < 2)
                    tempValue = 'The name must be atleast 2 characters';
                  if(value.length>15)
                    tempValue='The name must be max 15 characters';
                  return tempValue;
                },
                onSaved: (val) {
                  val = val.trim();
                  regUtils.insertNameData(val);
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Enter Name ...',
                  labelText: 'Name',
                  hintStyle: TextStyle(fontSize: 13),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              SelectingPicture(),
            ],
          ],
        ),
      ),
    );
  }
}
