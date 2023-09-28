import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum CustomTextInputType {
  userEmail(
    label: "E-mail",
    icon: Icon(Icons.email),
    keyboardType: TextInputType.emailAddress,
  ),
  userName(
    label: "Name",
    icon: Icon(Icons.person),
    keyboardType: TextInputType.name,
  ),
  userNickname(
      label: "Nickname",
      icon: Icon(Icons.face),
      keyboardType: TextInputType.name,
      isOptional: true),
  userPhoneNumber(
    label: "Phone number",
    icon: Icon(Icons.phone),
    keyboardType: TextInputType.phone,
  ),
  userPassword(
    label: "Password",
    icon: Icon(Icons.password),
    keyboardType: TextInputType.visiblePassword,
    isObscured: true,
  ),
  userConfirmPassword(
    label: "Confirm Password",
    icon: Icon(Icons.lock_rounded),
    hint: "Please Confirm Password",
    keyboardType: TextInputType.visiblePassword,
    isObscured: true,
  ),
  eventName(
    label: "Event Name",
    icon: Icon(Icons.event),
    keyboardType: TextInputType.name,
  ),
  eventLocation(
    label: "Location",
    icon: Icon(Icons.location_on),
    keyboardType: TextInputType.name,
  ),
  groupName(
      label: "Group Name",
      icon: Icon(Icons.groups_rounded),
      keyboardType: TextInputType.name),
  excuse(
    label: "Excuse",
    isOptional: true,
    icon: FaIcon(FontAwesomeIcons.solidFaceFrown),
    keyboardType: TextInputType.multiline,
  );

  final String label;
  final String? hint;
  final Widget icon;

  final TextInputType keyboardType;
  final bool isOptional, isObscured;

  const CustomTextInputType({
    required this.label,
    required this.icon,
    required this.keyboardType,
    this.isOptional = false,
    this.hint,
    this.isObscured = false,
  });
}

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.onSaved,
    required this.type,
    this.initialValue,
  });
  final void Function(String?) onSaved;
  final CustomTextInputType type;
  final String? initialValue;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      validator: (str) {
        if (widget.type.isOptional) {
          return null;
        }
        if (str == null || (str = str.trim()).isEmpty) {
          return "${widget.type.label} is Empty.";
        }
        if (widget.type == CustomTextInputType.userEmail &&
            !str.contains('@')) {
          return "${widget.type.label} isn't valid.";
        }
        return null;
      },
      onSaved: widget.onSaved,
      keyboardType: widget.type.keyboardType,
      textInputAction: (widget.type == CustomTextInputType.excuse)
          ? TextInputAction.newline
          : TextInputAction.next,
      obscureText: widget.type.isObscured && isObscured,

      maxLines: (widget.type == CustomTextInputType.excuse) ? 2 : 1,
      decoration: InputDecoration(
        icon: widget.type.icon,
        hintText: widget.type.hint ?? "Write ${widget.type.label}",
        labelText:
            "${widget.type.label} ${widget.type.isOptional ? '(Optional)' : ''}",
        suffixIcon: (!widget.type
                .isObscured) // if not password then appear nothing else appear the button
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
                icon: FaIcon(
                  isObscured ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                ),
              ),
      ),
    );
  }
}
