import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:todo_app/consts/colors.dart';
import 'package:todo_app/helpers/date_helper.dart';

class DatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final double size;
  final void Function(DateTime selectedDate) onTap;
  final Future<DateTime?> Function() onTapActive;

  const DatePicker({
    super.key,
    required this.selectedDate,
    this.size = 75,
    required this.onTap,
    required this.onTapActive,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late int _index;

  List<DateTime> _days = [];
  GlobalKey _key = GlobalKey();
  Offset _position = Offset(-50, 0);
  @override
  void initState() {
    generateDays(widget.selectedDate);
    super.initState();
  }

  void resetDays() {
    _days.clear();
  }

  void generateDays(DateTime date) {
    resetDays();
    DateTime firstDay = date.subtract(Duration(days: date.weekday - 1));

    _days = List.generate(
      7,
      (index) => firstDay.add(
        Duration(days: index),
      ),
    );

    _index = date.weekday - 1;
  }

  void _onTap(int index) async {
    if (_index == index) {
      final DateTime? date = await widget.onTapActive();
      if (date != null) {
        setState(() {
          generateDays(date);
        });
      }
    } else {
      widget.onTap(_days[index]);
      setState(() {
        _index = index;
      });
    }
  }

  Widget _buildDateWidget(int index) {
    return GestureDetector(
      key: _index == index ? _key : null,
      onTap: () => _onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(DateFormatHelper.formatDayShort(_days[index]),
              style: const TextStyle(
                  color: ConstColors.darkGreyColor, fontSize: 14)),
          Text(
            DateFormatHelper.formatDayNum(_days[index]),
            style: TextStyle(
              color: _index == index
                  ? ConstColors.backgroundColor
                  : ConstColors.darkColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  late List<Widget> _daysWidgetsList;
  void _buildListWidget() {
    _daysWidgetsList = List.generate(
      _days.length,
      (index) => _buildDateWidget(index),
    );
    Future.delayed(Duration.zero, () {
      RenderBox targetBox =
          _key.currentContext!.findRenderObject() as RenderBox;
      Offset position = targetBox.localToGlobal(Offset.zero);

      setState(() {
        _position = position.translate(targetBox.size.width / 2, 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildListWidget();
    return SizedBox(
      height: widget.size,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            bottom: 8,
            left: _position.dx - 16,
            child: CircleAvatar(
              radius: 16,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _daysWidgetsList,
          ),
        ],
      ),
    );
  }
}
