import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/helpers/cubit/tasks_cubit.dart';
import 'package:todo_app/helpers/dialog_helper.dart';
import 'package:todo_app/widgets/date_picker/main_date_render.dart';

class MyDatePicker extends StatelessWidget {
  const MyDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final blocHelper = BlocProvider.of<TasksCubit>(context);
    return DatePicker(
      selectedDate: blocHelper.getDay,
      onTap: blocHelper.setDayTaskBar,
      onTapActive: () async {
        final DateTime? date = await DialogHelper.datePickerDialogShower(
            context, blocHelper.getDay);
        if (date != null) {
          blocHelper.setDayTaskBar(date);
          return date;
        }
        return null;
      },
    );
  }
}
