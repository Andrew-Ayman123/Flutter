import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/helpers/date_helper.dart';

import '../models/task.dart';

class DBHelper {
  Database? _db;
  static const String _tasksTableName = "Tasks";
  static const String _habitsTableName = "habits";
  static const String _habitsOriginalTableName = "habitsOriginal";
  static const String _idColumn = "id";
  static const String _insideTextColumn = "insideText";
  static const String _isCheckedColumn = "isChecked";
  // static const String _colorColumn = "color";
  static const String _dateColumn = "date";
  DBHelper() {
    Future.delayed(const Duration(seconds: 1), () {
      FlutterNativeSplash.remove();
    });
  }
  Future<void> _connectDatabase() async {
    if (_db != null) return;
    // Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo_db.db');
    // await deleteDatabase(path);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $_tasksTableName ($_idColumn INTEGER PRIMARY KEY, $_insideTextColumn TEXT, $_isCheckedColumn BOOLEAN, $_dateColumn DATE)');
        await db.execute(
            'CREATE TABLE $_habitsOriginalTableName ($_idColumn INTEGER PRIMARY KEY, $_insideTextColumn TEXT)');
        await db.execute(
            'CREATE TABLE $_habitsTableName ($_idColumn INTEGER, $_dateColumn DATE, $_isCheckedColumn BOOLEAN, PRIMARY KEY ($_idColumn, $_dateColumn))');
      },
    );
  }

  Future<List<Task>> getTasks(DateTime date) async {
    await _connectDatabase();
    final data = await _db!.query(_tasksTableName,
        orderBy: _idColumn,
        where: '$_dateColumn = ?',
        whereArgs: [DateFormatHelper.formatYMD(date)]);
    return data
        .map<Task>(
          (e) => Task(
            e[_isCheckedColumn] == 1,
            e[_insideTextColumn] as String,
            e[_idColumn] as int,
          ),
        )
        .toList();
  }

  Future<List<Task>> getHabits(DateTime date) async {
    await _connectDatabase();
    final data = await _db!.rawQuery("""
        SELECT $_habitsOriginalTableName.$_idColumn, $_habitsOriginalTableName.$_insideTextColumn, $_habitsTableName.$_isCheckedColumn 
        FROM $_habitsOriginalTableName 
        LEFT JOIN $_habitsTableName ON ($_habitsOriginalTableName.$_idColumn = $_habitsTableName.$_idColumn)
        AND $_habitsTableName.$_dateColumn = ?
        """, [DateFormatHelper.formatYMD(date)]);
    return data
        .map<Task>(
          (e) => Task(
            (e[_isCheckedColumn] ?? 0) == 1,
            e[_insideTextColumn] as String,
            e[_idColumn] as int,
          ),
        )
        .toList();
  }

  Future<void> insertHabit(Task task) async {
    await _connectDatabase();
    await _db!.insert(_habitsOriginalTableName, {
      _insideTextColumn: task.text,
      _idColumn: task.id,
    });
  }

  Future<void> insertTask(Task task, DateTime date) async {
    await _connectDatabase();
    await _db!.insert(_tasksTableName, {
      _dateColumn: DateFormatHelper.formatYMD(date),
      _isCheckedColumn: task.isChecked ? 1 : 0,
      _insideTextColumn: task.text,
      _idColumn: task.id,
    });
  }

  Future<void> deleteTask(Task task) async {
    await _connectDatabase();
    await _db!
        .delete(_tasksTableName, where: '$_idColumn = ?', whereArgs: [task.id]);
  }

  Future<void> deleteHabit(Task task) async {
    await _connectDatabase();
    await _db!.delete(_habitsOriginalTableName,
        where: '$_idColumn = ?', whereArgs: [task.id]);
    await _db!.delete(_habitsTableName,
        where: '$_idColumn = ?', whereArgs: [task.id]);
  }

  Future<void> setListChecked(int id, bool val) async {
    await _connectDatabase();
    await _db!.update(_tasksTableName, {_isCheckedColumn: val ? 1 : 0},
        where: '$_idColumn = ?', whereArgs: [id]);
  }

  Future<void> setHabitChecked(int id, bool val, DateTime date) async {
    await _connectDatabase();

    await _db!.insert(
      _habitsTableName,
      {
        _idColumn: id,
        _dateColumn: DateFormatHelper.formatYMD(date),
        _isCheckedColumn: val ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> swapTask(Task oldTask, Task newTask) async {
    await _connectDatabase();
    await _db!.update(
      _tasksTableName,
      {
        _insideTextColumn: newTask.text,
        _isCheckedColumn: newTask.isChecked,
      },
      where: "$_idColumn=?",
      whereArgs: [oldTask.id],
    );
    await _db!.update(
      _tasksTableName,
      {
        _insideTextColumn: oldTask.text,
        _isCheckedColumn: oldTask.isChecked,
      },
      where: "$_idColumn=?",
      whereArgs: [newTask.id],
    );
  }
  Future<void> swapHabit(Task oldTask, Task newTask) async {
    await _connectDatabase();
    await _db!.update(
      _habitsOriginalTableName,
      {
        _insideTextColumn: newTask.text,
      },
      where: "$_idColumn=?",
      whereArgs: [oldTask.id],
    );
     await _db!.update(
      _habitsOriginalTableName,
      {
        _insideTextColumn: oldTask.text,
      },
      where: "$_idColumn=?",
      whereArgs: [newTask.id],
    );
      await _db!.update(
      _habitsTableName,
      {
        _idColumn: 0,
      },
      where: "$_idColumn=?",
      whereArgs: [oldTask.id],
    );
    await _db!.update(
      _habitsTableName,
      {
        _idColumn: oldTask.id,
      },
      where: "$_idColumn=?",
      whereArgs: [newTask.id],
    );
       await _db!.update(
      _habitsTableName,
      {
        _idColumn: newTask.id,
      },
      where: "$_idColumn=?",
      whereArgs: [0],
    );
  }
}
