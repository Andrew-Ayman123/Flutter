import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/helpers/cubit/tasks_cubit.dart';

import '../models/task.dart';

class DialogHelper {
  static Future<DateTime?> datePickerDialogShower(
      BuildContext context, DateTime initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(
        const Duration(days: 7),
      ),
    );
  }

  static Future<void> bottomShower(
      {required BuildContext context,
      required Task task,
      required TaskType type}) async {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        context: context,
        builder: (ctx) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete"),
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (type == TaskType.task) {
                    BlocProvider.of<TasksCubit>(context).deleteTask(task);
                  } else {
                    BlocProvider.of<TasksCubit>(context).deleteHabit(task);
                  }
                },
              )
            ],
          );
        });
  }
}
