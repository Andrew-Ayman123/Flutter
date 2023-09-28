part of 'tasks_cubit.dart';

@immutable
abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;
  final List<Task> habits;
  TasksLoaded({required this.tasks, required this.habits});
}

class TasksError extends TasksState {
  final Object error;
  TasksError(this.error);
}
