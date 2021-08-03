import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' as svg;

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  AnimationController _aniController;
  Animation<double> ani;
  @override
  void initState() {
    _aniController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    ani = Tween<double>(begin: 0, end: 1).animate(_aniController);
    _aniController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return RotationTransition(
      turns: ani,
      child: svg.SvgPicture.asset(
        'lib/assets/Main Logo.svg',
        color: Colors.white,
        height: 75,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
