import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/consts/colors.dart';
import 'package:todo_app/consts/paths.dart';
import 'package:todo_app/screens/daily.dart';
import 'package:todo_app/widgets/blur_widget.dart';
import 'package:todo_app/widgets/date_picker/my_date_picker.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            BlurryBackgroundWidget(
              dir: AxisDirection.down,
              child: AppBar(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SvgPicture.asset(
                    ConstPath.logoSvg,
                    height: 36,
                  ),
                ),
                actions: [
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: ConstColors.lightGreyColor,
                          foregroundColor: ConstColors.darkGreyColor,
                          fixedSize: const Size(48, 48),
                          elevation: 5,
                        ),
                        child: const Icon(
                          UniconsLine.setting,
                          size: 24,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Expanded(
              child: DailyWidget(),
            ),
          ],
        ),
        bottomNavigationBar: const SizedBox(
          height: 64,
          child: BlurryBackgroundWidget(
            dir: AxisDirection.up,
            child: MyDatePicker(),
          ),
        ),
      ),
    );
  }
}
