import 'dart:io';

import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/constants/colors.dart';
import 'package:asdt_app/helpers/firebase_auth.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/firebase_storage.dart';
import 'package:asdt_app/helpers/snackbar.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateNewUserProvider with ChangeNotifier {
  AppUser _user = AppUser.empty();
  String _password = '', _confirmPassword = '.';
  final formKey = GlobalKey<FormState>();
  List<String>? _groupNames;
  File? _selectedImage;
  Future<bool> createUser(BuildContext context) async {
    try {
      if (_selectedImage == null) {
        SnackBarShower.showSnack(
          context: context,
          message: "Please Choose Image.",
          icon: Icons.warning_amber,
          fontColor: Colors.white,
          backgroundColor: ConstColors.errorColor,
        );
      }
      if (!formKey.currentState!.validate()) {
        return false;
      }
      if (_selectedImage == null) {
        return false;
      }
      formKey.currentState!.save();
      if (_password != _confirmPassword) {
        SnackBarShower.showSnack(
          context: context,
          message: "Passwords aren't the same.",
          icon: Icons.warning_amber,
          fontColor: Colors.white,
          backgroundColor: ConstColors.errorColor,
        );
        return false;
      }

      await FirebaseAuthHelper.signingInNewUser(_user.email, _password);
      _user.imageLink =
          await FirebaseStorageHelper.uploadUserImage(_user, _selectedImage!);

      await FirebaseFirestoreHelper.addNewUser(user: _user, context: context);
      SnackBarShower.showSnack(
        context: context,
        message: "${_user.email} \n has been Successfully added>",
        icon: Icons.done,
        fontColor: Colors.white,
        backgroundColor: ConstColors.doneColor,
      );
      return true;
    } catch (e) {
      SnackBarShower.showSnack(
        context: context,
        message: "Please Try Again Later.",
        icon: Icons.warning_amber,
        fontColor: Colors.white,
        backgroundColor: ConstColors.errorColor,
      );
    }
    return false;
  }

  void setUserEmail(String? txt) {
    _user.email = txt!.trim();
  }

  void setUserPassword(String? txt) {
    _password = txt!.trim();
  }

  void setUserName(String? txt) {
    _user.name = txt!.trim();
  }

  void setUserNickname(String? txt) {
    _user.nickName = txt!.trim();
  }

  void setUserPhoneNumber(String? txt) {
    _user.phoneNumber = txt!.trim();
  }

  void setUserGroupName(String? txt) {
    _user.groupName = txt!.trim();
  }

  void setUserType(int? type) {
    if (type != null) {
      _user.typeSet(type);
    }
  }

  void setUserConfirmPassword(String? txt) {
    _confirmPassword = txt!.trim();
  }

  Widget generateAdminTypeDropDown() {
    return Row(
      children: [
        const Text("Type: "),
        Flexible(
          child: DropdownButtonFormField<int>(onTap: FocusManager.instance.primaryFocus?.unfocus,
            icon: const FaIcon(FontAwesomeIcons.handPointer),
            onChanged: (_) {},
            value: AppUserType.normal.id,
            items: const [
              DropdownMenuItem<int>(
                value: 2,
                child: Text("Normal"),
              ),
              DropdownMenuItem<int>(
                value: 1,
                child: Text("Admin"),
              ),
              DropdownMenuItem<int>(
                value: 0,
                child: Text("Super Admin"),
              ),
            ],
            onSaved: setUserType,
          ),
        ),
      ],
    );
  }

  Widget generateGroupsDropDown() {
    return Row(
      children: [
        const Text("Group: "),
        FutureBuilder(
          future: _groupNames != null
              ? null
              : FirebaseFirestoreHelper.getGroupNames,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return Text("Please Try Later");
            }
            final groupNames = _groupNames ?? snapshot.data!;
            _groupNames=groupNames;
            return Flexible(
              child: DropdownButtonFormField<String>(
                icon: const FaIcon(FontAwesomeIcons.handPointer),onTap: FocusManager.instance.primaryFocus?.unfocus,
                onChanged: (_) {},
                value: groupNames[0],
                items: groupNames
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onSaved: setUserGroupName,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget generatePhotoSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 30,
          backgroundImage: _selectedImage != null
              ? FileImage(_selectedImage!)
              : const AssetImage('assets/images/no_profile.jpg')
                  as ImageProvider,
        ),
        TextButton.icon(
          onPressed: () async {FocusManager.instance.primaryFocus?.unfocus();
            final image = await ImagePicker()
                .pickImage(source: ImageSource.camera, imageQuality: 50);
            if (image == null) return;

            _selectedImage = File(image.path);
            notifyListeners();
          },
          icon: const Icon(Icons.camera),
          label: const Text('Camera'),
        ),
        TextButton.icon(
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            final image = await ImagePicker()
                .pickImage(source: ImageSource.gallery, imageQuality: 50);
            if (image == null) return;

            _selectedImage = File(image.path);
            notifyListeners();
          },
          icon: const Icon(Icons.photo_size_select_actual_rounded),
          label: const Text('Gallery'),
        ),
        // TextButton.icon(
        //   onPressed: () async {
        //     _selectedImage = null;
        //     notifyListeners();
        //   },
        //   icon: const Icon(Icons.restore),
        //   label: const Text('reset'),
        // ),
      ],
    );
  }
}
