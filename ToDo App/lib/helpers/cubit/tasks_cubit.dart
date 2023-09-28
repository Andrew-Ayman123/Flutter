import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/helpers/db_helper.dart';
import 'package:todo_app/models/task.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final DBHelper _dbHelper;
  DateTime _day;
  TasksCubit(this._dbHelper, this._day) : super(TasksInitial()) {
    getTasks();
  }

  Future<void> getTasks() async {
    try {
      final tasks = await _dbHelper.getTasks(_day);
      final habits = await _dbHelper.getHabits(_day);
      emit(TasksLoaded(tasks: tasks, habits: habits));
    } catch (e) {
      emit(TasksError(e));
    }
  }

  Future<void> insertTask(Task task) async {
    try {
      await _dbHelper.insertTask(task, _day);
      await getTasks();
    } catch (e) {
      emit(TasksError(e));
    }
  }

  Future<void> insertHabit(Task task) async {
    try {
      await _dbHelper.insertHabit(task);
      await getTasks();
    } catch (e) {
      emit(TasksError(e));
    }
  }

  Future<void> setTaskChecked(int id, bool val) async {
    try {
      await _dbHelper.setListChecked(id, val);
      await getTasks();
    } catch (e) {
      emit(TasksError(e));
    }
  }

  Future<void> setHabitChecked(int id, bool val) async {
    try {
      await _dbHelper.setHabitChecked(id, val, _day);
      await getTasks();
    } catch (e) {
      emit(TasksError(e));
    }
  }

  Future<void> setDayTaskBar(DateTime day) async {
    _day = day;
    await getTasks();
  }

  Future<void> deleteTask(Task task) async {
    try {
      await _dbHelper.deleteTask(task);
      await getTasks();
    } catch (e) {
      emit(TasksError(e));
    }
  }

  Future<void> deleteHabit(Task task) async {
    try {
      await _dbHelper.deleteHabit(task);
      await getTasks();
    } catch (e) {
      emit(TasksError(e));
    }
  }

  Future<void> swapTask(Task oldTask, Task newTask) async {
    try {
      await _dbHelper.swapTask(oldTask, newTask);
      await getTasks();
    } catch (e) {
      emit(TasksError(e));
    }
  }
Future<void> swapHabit(Task oldTask, Task newTask) async {
    try {
      await _dbHelper.swapHabit(oldTask, newTask);
      await getTasks();
    } catch (e) {
      emit(TasksError(e));
    }
  }
  DateTime get getDay => _day;
}
