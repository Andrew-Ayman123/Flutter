import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:todo_app/consts/colors.dart';
import 'package:todo_app/helpers/cubit/tasks_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets/popup_button.dart';
import 'package:todo_app/widgets/task_viewer.dart';

class DailyWidget extends StatefulWidget {
  const DailyWidget({super.key});

  @override
  State<DailyWidget> createState() => _DailyWidgetState();
}

class _DailyWidgetState extends State<DailyWidget> {
  final ScrollController _screenScrollController = ScrollController();

  bool isTaskAdd = false;
  bool isHabitAdd = false;
  @override
  void initState() {
    KeyboardVisibilityController().onChange.listen((bool keyboardVisible) {
      if (!keyboardVisible) {
        setState(() {
          isTaskAdd = false;
          isHabitAdd = false;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _screenScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(builder: (context, state) {
      if (state is TasksInitial) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is TasksError) {
        return Text(state.error.toString());
      }
      final List<Task> tasks = (state as TasksLoaded).tasks;
      final List<Task> habits = (state).habits;

      return Stack(
        children: [
          SingleChildScrollView(
            controller: _screenScrollController,
            child: Column(
              children: [
                TaskViewer(
                  tasks: habits,
                  type: TaskType.habit,
                  isAdd: isHabitAdd,
                  removeKeyboard: (){
                    setState(() {
                      isHabitAdd=false;
                    });
                  },
                ),
                TaskViewer(
                  tasks: tasks,
                  type: TaskType.task,
                  isAdd: isTaskAdd,
                   removeKeyboard: (){
                    setState(() {
                      isTaskAdd=false;
                    });
                  },
                ),
              ],
            ),
          ),
          if (!isTaskAdd && !isHabitAdd)
            Positioned(
                bottom: 8,
                right: 8,
                child: PopupButton(
                  radius: 56,
                  firstIcon: Icons.task,
                  secondIcon: Icons.task_alt,
                  firstFunction: () async {
                    await _screenScrollController.animateTo(
                        _screenScrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                    setState(() {
                      isTaskAdd = true;
                    });
                  },
                  secondFunction: () async {
                    setState(() {
                      isHabitAdd = true;
                    });
                  },
                  primaryColor: const [
                    ConstColors.primaryColor,
                    ConstColors.primaryColor,
                  ],
                  firstColor: const [
                    ConstColors.secondaryColor,
                    ConstColors.secondaryColor
                  ],
                  thirdColor: const [
                    ConstColors.thirdColor,
                    ConstColors.thirdColor,
                  ],
                ))
        ],
      );
    });
  }
}
