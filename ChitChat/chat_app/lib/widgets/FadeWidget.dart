import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  const FadeInWidget({
    @required this.duration,
    @required this.child,
  });
  final Duration duration;
  final Widget child;
  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with TickerProviderStateMixin {
  AnimationController aniController;
  Animation<double> opacity;

  @override
  void initState() {
    aniController = AnimationController(vsync: this, duration: widget.duration);
    opacity = Tween(begin: 0.0, end: 1.0).animate(aniController);
    aniController.forward();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant FadeInWidget oldWidget) {
    aniController = AnimationController(vsync: this, duration: widget.duration);
    opacity = Tween(begin: 0.0, end: 1.0).animate(aniController);
    aniController.forward();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    aniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: widget.child,
    );
  }
}
