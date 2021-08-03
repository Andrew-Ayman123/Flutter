import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialIcon extends StatelessWidget {
  final List<Color> colors;
  final Function func;
  final IconData icon;
  final bool isCloased;
  const SocialIcon(
      {@required this.colors,
      @required this.func,
      @required this.icon,
      this.isCloased = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
    
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(left: 10),
      height: isCloased ? 0 : 55,
      width: isCloased ? 0 : 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
        ),
        shape: BoxShape.circle,
      ),
      child: InkWell(borderRadius: BorderRadius.circular(25),
        onTap: func,
        child: Center(
          child: FaIcon(
            icon,
            color: Colors.white,
            textDirection: TextDirection.rtl,
            size: isCloased ? 0 : 30,
          ),
        ),
      ),
    );
  }
}
