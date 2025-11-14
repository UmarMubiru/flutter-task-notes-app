import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initDesktopDatabase(String filePath) async {
  // Initialize FFI for desktop
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final documentsDirectory = await getApplicationDocumentsDirectory();
  final dbPath = path.join(documentsDirectory.path, filePath);

  return await openDatabase(
    dbPath,
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

