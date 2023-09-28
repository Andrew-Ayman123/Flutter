import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo_app/consts/colors.dart';

import 'date_picker/my_date_picker.dart';

class BlurryBackgroundWidget extends StatelessWidget {
  const BlurryBackgroundWidget({
    super.key,
    required this.child,
    required this.dir,
  });
  final Widget child;
  final AxisDirection dir;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: dir == AxisDirection.up
          ? const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            )
          : const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
      child: Container(
        color: ConstColors.backgroundColor.withOpacity(.85),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}
