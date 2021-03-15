import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseProvider {
  Database _instance;

  String get databaseName;

  String get tableName;

  Future<Database> get database async {
    if (_instance == null) {
      _instance = await openDatabase(
        join(
          await getDatabasesPath(),
          databaseName,
        ),
        onCreate: createDatabase,
        version: 1,
      );
    }
    return _instance;
  }

  createDatabase(Database db, int version);
}
