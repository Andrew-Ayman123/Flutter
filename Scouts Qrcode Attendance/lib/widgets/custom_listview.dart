import 'package:asdt_app/widgets/no_glow_behavior.dart';
import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  const CustomListView(
      {super.key,
      required this.children,
      this.padding = const EdgeInsets.symmetric(vertical: 25, horizontal: 26),
      this.noScroll = false,
      this.scrollDirection = Axis.vertical})
      : itemBuilder = null,
        itemCount = null,
        itemExtent = null;
  const CustomListView.builder(
      {super.key,
      this.padding = const EdgeInsets.symmetric(vertical: 25, horizontal: 26),
      required this.itemCount,
      required this.itemBuilder,
      this.noScroll = false,
      this.scrollDirection = Axis.vertical,
      this.itemExtent})
      : children = null;
  final List<Widget>? children;
  final int? itemCount;
  final Widget Function(BuildContext, int)? itemBuilder;
  final EdgeInsets padding;
  final bool noScroll;
  final double? itemExtent;
  final Axis scrollDirection;
  @override
  Widget build(BuildContext context) {
    return itemCount != null && itemBuilder != null
        ? ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: ListView.builder(
              scrollDirection: scrollDirection,
              itemExtent: itemExtent,
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
            child: ListView(
              scrollDirection: scrollDirection,
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
