import 'package:flutter/material.dart';

class CustomLoadingButton extends StatefulWidget {
  const CustomLoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
  });
  final Future<void> Function() onPressed;
  final String text;
  final Icon icon;
  @override
  State<CustomLoadingButton> createState() => _CustomLoadingButtonState();
}

class _CustomLoadingButtonState extends State<CustomLoadingButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 8.0)),
      icon: isLoading ? CircularProgressIndicator() : widget.icon,
      onPressed: isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await widget.onPressed();
              // ignore: unnecessary_this
              if (this.mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
      label: Text(widget.text),
    );
  }
}
