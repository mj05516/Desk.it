import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskit/models/task_model.dart';

class DatabaseHelper {

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _db;

  String tasksTable = 'task_table1';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colCategory = 'category';
  String colStatus = 'status';

  Future<Database> get db async {
    _db = await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'deskit.db';
    print(path);
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tasksTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colCategory TEXT, $colStatus INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getMapTaskList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
  }

  Future<List<Task>> getTaskList(String filter) async {
    final List<Map<String, dynamic>> taskMapList = await getMapTaskList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      if (filter == "All"){
      taskList.add(Task.fromMap(taskMap));
      } else if (filter == "Completed"){
        if (taskMap[colStatus] == 1){
          taskList.add(Task.fromMap(taskMap));
        }
      } else if (filter == "Active"){
        if (taskMap[colStatus] == 0){
          taskList.add(Task.fromMap(taskMap));
        }
      }
      if (filter == "Personal"){
        if (taskMap[colCategory] == "Personal"){
          taskList.add(Task.fromMap(taskMap));
        }
      } else if (filter == "Work"){
        if (taskMap[colCategory] == "Work"){
          taskList.add(Task.fromMap(taskMap));
        }
      } else if (filter == "Miscellaneous"){
        if (taskMap[colCategory] == "Miscellaneous"){
          taskList.add(Task.fromMap(taskMap));
        }
      }

    });
    taskList.sort((taskA, taskB) => taskA.date!.compareTo(taskB.date!));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(tasksTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(tasksTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int? id) async {
    Database db = await this.db;
    final int result =
        await db.delete(tasksTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
