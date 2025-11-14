import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initMobileDatabase(String filePath) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);

  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT NOT NULL';
      const intType = 'INTEGER NOT NULL';

      await db.execute('''
        CREATE TABLE tasks (
          id $idType,
          title $textType,
          priority $textType,
          description $textType,
          isCompleted $intType
        )
      ''');
    },
  );
}

