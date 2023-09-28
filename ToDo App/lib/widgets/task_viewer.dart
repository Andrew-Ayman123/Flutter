import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:todo_app/consts/colors.dart';
import 'package:todo_app/helpers/cubit/tasks_cubit.dart';
import 'package:todo_app/helpers/dialog_helper.dart';
import 'package:todo_app/models/task.dart';

class TaskViewer extends StatefulWidget {
  const TaskViewer(
      {super.key,
      required this.tasks,
      required this.type,
      required this.isAdd,
      required this.removeKeyboard});
  final List<Task> tasks;
  final TaskType type;
  final bool isAdd;
  final Function removeKeyboard;
  @override
  State<TaskViewer> createState() => _TaskViewerState();
}

class _TaskViewerState extends State<TaskViewer> {
  bool get _isTasks => widget.type == TaskType.task;
  final ScrollController _textScrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _textScrollController.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.tasks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isTasks ? "Tasks" : "Habits",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ConstColors.darkGreyColor),
                ),
                Text(
                  "(${widget.tasks.where((element) => element.isChecked).length}/${widget.tasks.length})",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ConstColors.darkGreyColor,
                  ),
                ),
              ],
            ),
          )
        else
          Center(
            child: Text("Please Add ${_isTasks ? 'Tasks' : 'Habits'}",
                style: TextStyle(color: ConstColors.darkColor, fontSize: 32)),
          ),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.tasks.length,
          itemBuilder: (ctx, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              color: widget.tasks[index].isChecked
                  ? ConstColors
                      .disabledColors[index % ConstColors.disabledColors.length]
                  : ConstColors
                      .activeColors[index % ConstColors.activeColors.length],
              key: Key(index.toString()),
              child: CheckboxListTile(
                key: Key(index.toString()),
                checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_isTasks ? 4 : 16)),
                secondary: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    DialogHelper.bottomShower(
                        context: context,
                        task: widget.tasks[index],
                        type: widget.type);
                  },
                ),
                activeColor: Colors.transparent,
                checkColor: ConstColors.darkColor,
                value: widget.tasks[index].isChecked,
                onChanged: (value) => _isTasks
                    ? BlocProvider.of<TasksCubit>(context)
                        .setTaskChecked(widget.tasks[index].id, value ?? false)
                    : BlocProvider.of<TasksCubit>(context).setHabitChecked(
                        widget.tasks[index].id, value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  widget.tasks[index].text,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: widget.tasks[index].isChecked
                          ? ConstColors.darkGreyColor
                          : ConstColors.darkColor),
                ),
              ),
            );
          },
          onReorder: (oldIndex, newIndex) async {
            if (newIndex >= widget.tasks.length) {
              newIndex = widget.tasks.length - 1;
            }
            if (oldIndex == newIndex) return;
            if (_isTasks) {
              await BlocProvider.of<TasksCubit>(context)
                  .swapTask(widget.tasks[oldIndex], widget.tasks[newIndex]);
            } else {
              await BlocProvider.of<TasksCubit>(context)
                  .swapHabit(widget.tasks[oldIndex], widget.tasks[newIndex]);
            }
          },
        ),
        if (widget.isAdd)
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: null,
            value: false,
            tileColor: ConstColors.activeColors[
                widget.tasks.length % ConstColors.activeColors.length],
            checkColor: ConstColors.darkColor,
            secondary: IconButton(
              icon: const Icon(Icons.save_alt),
              onPressed: () async {
                widget.removeKeyboard();
                final String text = _textEditingController.value.text.trim();
                if (text != "") {
                  _textEditingController.clear();
                  if (_isTasks) {
                    await BlocProvider.of<TasksCubit>(context).insertTask(
                      Task(
                        false,
                        text,
                        DateTime.now().toUtc().millisecondsSinceEpoch,
                      ),
                    );
                  } else {
                    await BlocProvider.of<TasksCubit>(context).insertHabit(
                      Task(
                        false,
                        text,
                        DateTime.now().toUtc().millisecondsSinceEpoch,
                      ),
                    );
                  }
                }
              },
            ),
            title: Scrollbar(
              controller: _textScrollController,
              child: TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 2,
                scrollPadding: EdgeInsets.zero,
                autofocus: true,
                cursorColor: ConstColors.darkColor,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: ConstColors.darkColor),
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
