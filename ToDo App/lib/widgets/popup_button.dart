import 'package:flutter/material.dart';

class PopupButton extends StatefulWidget {
  const PopupButton({
    Key? key,
    required this.firstFunction,
    required this.secondFunction,
    required this.primaryColor,
    required this.firstColor,
    required this.thirdColor,
    required this.radius,
    required this.firstIcon,
    required this.secondIcon,
  }) : super(key: key);
  final void Function() firstFunction;
  final void Function() secondFunction;
  final IconData firstIcon;
  final IconData secondIcon;
  final List<Color> primaryColor;
  final List<Color> firstColor;
  final List<Color> thirdColor;
  final double radius;

  @override
  State<PopupButton> createState() => _PopupButtonState();
}

class _PopupButtonState extends State<PopupButton>
    with SingleTickerProviderStateMixin {
  late AnimationController aniCont;
  late Animation distance;

  @override
  void initState() {
    aniCont = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    distance = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: aniCont, curve: Curves.fastOutSlowIn));

    super.initState();
    aniCont.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    aniCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: 170,
      child: Stack(
        children: [
          Positioned(
            bottom: 72.0 * distance.value,
            right: 8.0 * distance.value,
            child: CircularButton(
              rotation: 360.0 * distance.value,
              colors: widget.firstColor,
              radius: widget.radius - 8,
              icon: widget.firstIcon,
              onPressed: widget.firstFunction,
            ),
          ),
          Positioned(
            bottom: 8.0 * distance.value,
            right: 72.0 * distance.value,
            child: CircularButton(
              rotation: 360.0 * distance.value,
              colors: widget.thirdColor,
              radius: widget.radius - 8,
              icon: widget.secondIcon,
              onPressed: widget.secondFunction,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircularButton(
              rotation: 360.0 * distance.value,
              colors: widget.primaryColor,
              radius: widget.radius,
              icon: Icons.add,
              onPressed: () {
                if (aniCont.isCompleted) {
                  aniCont.reverse();
                } else {
                  aniCont.forward();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  const CircularButton({
    Key? key,
    required this.colors,
    required this.radius,
    required this.icon,
    required this.onPressed,
    required this.rotation,
  }) : super(key: key);
  final List<Color> colors;
  final double radius;
  final IconData icon;
  final double rotation;
  double deg2rad(double num) => num * 0.01745329252;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: radius,
      child: Transform.rotate(
        angle: deg2rad(rotation),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: radius,
            width: radius,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: radius / 1.75,
            ),
          ),
        ),
      ),
    );
  }
}
