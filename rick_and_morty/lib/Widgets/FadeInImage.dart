import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgPro;
import 'package:flutter_svg/svg.dart' as svg;

class FadeImageRM extends StatelessWidget {
  final int id;
  final String link;
  FadeImageRM({this.id = 0, @required this.link});

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      fit: BoxFit.cover,
      image: NetworkImage(
        link,
      ),
      placeholder: svgPro.Svg(
          (id & 2 == 0) ? 'lib/assets/morty.svg' : 'lib/assets/ricky.svg'),
      placeholderErrorBuilder: (a1, b2, c3) => svg.SvgPicture.asset(
          (id & 2 == 0) ? 'lib/assets/morty.svg' : 'lib/assets/ricky.svg'),
    );
  }
}
