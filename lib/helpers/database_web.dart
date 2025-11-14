import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class WebDatabase {
  static const String _tasksKey = 'tasks_list';
  List<Map<String, dynamic>> _tasks = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await _loadTasks();
    _initialized = true;
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_tasksKey);
    if (tasksJson != null) {
      final List<dynamic> decoded = json.decode(tasksJson);
      _tasks = decoded.cast<Map<String, dynamic>>();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(_tasks);
    await prefs.setString(_tasksKey, tasksJson);
  }

  Future<int> insert(String table, Map<String, dynamic> data, {ConflictAlgorithm? conflictAlgorithm}) async {
    await init();
    if (data['id'] == null) {
      int maxId = _tasks.isEmpty ? 0 : _tasks.map((t) => t['id'] as int? ?? 0).reduce((a, b) => a > b ? a : b);
      data['id'] = maxId + 1;
    }
    _tasks.add(Map<String, dynamic>.from(data));
    await _saveTasks();
    return data['id'] as int;
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    await init();
    return List.from(_tasks);
  }

  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async {
    await init();
    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      final id = whereArgs[0] as int;
      _tasks.removeWhere((task) => task['id'] == id);
      await _saveTasks();
      return 1;
    }
    return 0;
  }

  Future<int> update(String table, Map<String, dynamic> data, {String? where, List<dynamic>? whereArgs}) async {
    await init();
    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      final id = whereArgs[0] as int;
      final index = _tasks.indexWhere((task) => task['id'] == id);
      if (index != -1) {
        _tasks[index] = Map<String, dynamic>.from(data);
        await _saveTasks();
        return 1;
      }
    }
    return 0;
  }

  Future<void> close() async {
    // No-op for web
  }
}

Future<dynamic> initWebDatabase() async {
  final db = WebDatabase();
  await db.init();
  return db;
}
