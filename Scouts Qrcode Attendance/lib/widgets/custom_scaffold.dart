import 'package:asdt_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final AppBar appBar;
  final Widget? floatingActionButton, bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  const CustomScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.primaryColor,
      appBar: AppBar(
        backgroundColor: ConstColors.primaryColor,
        // toolbarHeight: 65,
        elevation: 0,
        actions: appBar.actions,
        centerTitle: appBar.centerTitle,
        title: appBar.title,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft:  Radius.circular(20), topRight: Radius.circular(20)),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                scale: .5,
                image: AssetImage('assets/images/logo_center.png'),
                opacity: .1),
            color: ConstColors.backgroundColor,
          ),
          height: double.infinity,
          child: body,
        ),
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
