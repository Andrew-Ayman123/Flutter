import 'package:chat_app/Utils/AuthHelper.dart';
import 'package:chat_app/Utils/FireStoreHelper.dart';
import 'package:chat_app/Utils/Theme.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DialogAdd extends StatefulWidget {
  @override
  _DialogAddState createState() => _DialogAddState();
}

class _DialogAddState extends State<DialogAdd> {
  bool email = true;
  final textFieldKey = GlobalKey<FormFieldState>();
  var _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.height * .5,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adding a new user',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    onSelected: (_) {
                      FocusScope.of(context).unfocus();
                      if (!email) _textEditingController.clear();
                      setState(() {
                        email = true;
                      });
                    },
                    selected: email,
                    elevation: 5,
                    label: Text('Email'),
                    avatar: Icon(Icons.email),
                    labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  ChoiceChip(
                    onSelected: (_) async {
                      // FocusScope.of(context).unfocus();
                      // email = false;
                      // final _contactPicker = ContactPicker();
                      // final contact = await _contactPicker.selectContact();
                      // String val =
                      //     contact.phoneNumber.number.replaceAll(' ', '') ?? '';
                      // _textEditingController.value = TextEditingValue(
                      //   text: val,
                      //   selection: TextSelection.fromPosition(
                      //     TextPosition(
                      //       offset: val.length,
                      //     ),
                      //   ),
                      // );

                      setState(() {});
                    },
                    selected: !email,
                    elevation: 5,
                    label: Text('Phone'),
                    avatar: Icon(Icons.phone),
                    labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                key: textFieldKey,
                controller: _textEditingController,
                validator: (val) {
                  val = val.trim();
                  String tempValue;
                  if (val.isEmpty)
                    tempValue = 'It must not be empty';
                  else if (!val.contains('@') && email)
                    tempValue = 'The email must contain @';
                  else if (!val.startsWith('+') && !email)
                    tempValue =
                        'The number must start with the +(country code)';
                  return tempValue;
                },
                keyboardType:
                    email ? TextInputType.emailAddress : TextInputType.phone,
                decoration: InputDecoration(
                  labelText: email ? 'Email' : 'Phone',
                  hintText: email ? 'Enter Email' : 'Enter Phone Number',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color:
                            Provider.of<ThemeChooser>(context).bubbleChatColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      // FocusScope.of(context).unfocus();
                      // if (!textFieldKey.currentState.validate()) return;
                      // AuthHelper.showLoding(context);
                      // bool temp = await FireStoreHelper.checkIsUser(
                      //     _textEditingController.text.trim());
                      // AuthHelper.closeDialog(context);
                      // Navigator.of(context).pop();

                      // if (temp) {
                      //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content:
                      //           Text('This User has been added to your chats'),
                      //     ),
                      //   );
                      // } else {
                      //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text('This User does not Exist'),
                      //     ),
                      //   );
                      // }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
