import 'package:asdt_app/widgets/no_glow_behavior.dart';
import 'package:flutter/material.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 25, horizontal: 26),
    this.noScroll = false,
    required this.gridDelegate,
  })  : itemBuilder = null,
        itemCount = null,
        itemExtent = null;
  const CustomGridView.builder(
      {super.key,
      this.padding = const EdgeInsets.symmetric(vertical: 25, horizontal: 26),
      required this.itemCount,
      required this.itemBuilder,
      this.noScroll = false,
      required this.gridDelegate,
      this.itemExtent})
      : children = null;
  final List<Widget>? children;
  final SliverGridDelegate gridDelegate;
  final int? itemCount;
  final Widget Function(BuildContext, int)? itemBuilder;
  final EdgeInsets padding;
  final bool noScroll;
  final double? itemExtent;
  @override
  Widget build(BuildContext context) {
    return itemCount != null && itemBuilder != null
        ? ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: GridView.builder(
              gridDelegate: gridDelegate,
              shrinkWrap: true,
              physics: noScroll
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              padding: padding,
              itemCount: itemCount,
              itemBuilder: itemBuilder!,
            ),
          )
        : ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: GridView(
              gridDelegate: gridDelegate,
              shrinkWrap: true,
              physics: noScroll
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              padding: padding,
              children: children!,
            ),
          );
  }
}
