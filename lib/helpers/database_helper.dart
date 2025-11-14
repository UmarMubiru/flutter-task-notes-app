import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import '../models/task_item.dart';

// Import platform-specific implementations
import 'database_mobile.dart' as mobile;
import 'database_desktop.dart' as desktop;
import 'database_web.dart' as web;
import 'platform_detector.dart' as platform;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  dynamic _database;

  DatabaseHelper._init();

  Future<dynamic> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<dynamic> _initDB(String filePath) async {
    if (kIsWeb) {
      // Web platform - use SharedPreferences-based storage
      return await web.initWebDatabase();
    } else if (platform.isDesktop()) {
      // Desktop platform - use sqflite_common_ffi
      return await desktop.initDesktopDatabase(filePath);
    } else {
      // Mobile platform (Android/iOS) - use regular sqflite
      return await mobile.initMobileDatabase(filePath);
    }
  }

  // Insert a new TaskItem
  Future<int> insertTask(TaskItem task) async {
    final db = await database;
    if (kIsWeb) {
      return await db.insert('tasks', task.toJson());
    } else {
      return await db.insert(
        'tasks',
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Retrieve all TaskItems
  Future<List<TaskItem>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TaskItem.fromJson(maps[i]);
    });
  }

  // Delete a TaskItem by id
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a TaskItem
  Future<int> updateTask(TaskItem task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
