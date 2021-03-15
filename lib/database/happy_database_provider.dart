import 'package:sqflite/sqflite.dart';
import "package:intl/intl.dart";
import 'package:iikoto/database/database_provider.dart';
import 'package:iikoto/model/happy.dart';

class HappyDatabaseProvider extends DatabaseProvider {
  @override
  String get databaseName => "happy_database.db";

  @override
  String get tableName => "happy";

  @override
  createDatabase(Database db, int version) => db.execute(
        """
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            text TEXT,
            createdAt Text
          )
        """,
      );
}

Future<int> insertHappy(Happy happy) async {
  final HappyDatabaseProvider provider = HappyDatabaseProvider();
  final Database database = await provider.database;
  return await database.insert(provider.tableName, happy.toMap());
}

Future<List<Happy>> getHappies() async {
  final HappyDatabaseProvider provider = HappyDatabaseProvider();
  final Database database = await provider.database;
  final List<Map<String, dynamic>> maps = await database.query('happy');
  return List.generate(maps.length, (i) {
    return Happy(
      id: maps[i]['id'],
      text: maps[i]['text'],
      createdAt: DateTime.parse(maps[i]['createdAt']),
    );
  });
}

Future<CountHappyByDate> countHappiesByCreatedAt(DateTime createdAt) async {
  final HappyDatabaseProvider provider = HappyDatabaseProvider();
  final Database database = await provider.database;
  final List<Map<String, dynamic>> maps = await database.rawQuery('''
    SELECT
      COUNT(*) as count,
      strftime("%Y-%m-%d", date(createdAt)) as createdAt 
    FROM
      happy
    WHERE
      createdAt like "${DateFormat('yyyy-MM-dd').format(createdAt)}%"
  ''');
  final countHappyByDate = maps.first;
  return CountHappyByDate(
      count: countHappyByDate["count"],
      createdAt: countHappyByDate["createdAt"] == null ? DateTime.now(): DateTime.parse(countHappyByDate["createdAt"]));
}

Future<List<CountHappyByDate>> countHappiesByMonth(String yearMonth) async {
  final HappyDatabaseProvider provider = HappyDatabaseProvider();
  final Database database = await provider.database;
  final List<Map<String, dynamic>> maps = await database.rawQuery('''
    SELECT
      COUNT(*) as count,
      strftime("%Y-%m-%d", date(createdAt)) as groupByDate 
    FROM
      happy
    WHERE
      createdAt like "${yearMonth}%"
    group by
      groupByDate
  ''');
  return List.generate(maps.length, (i) {
    return CountHappyByDate(
      count: maps[i]['count'],
      createdAt: DateTime.parse(maps[i]['groupByDate']),
    );
  });
}

Future<List<Happy>> happiesByIds(List<int> ids) async {
  final HappyDatabaseProvider provider = HappyDatabaseProvider();
  final Database database = await provider.database;
  final List<Map<String, dynamic>> maps = await database.rawQuery('''
    SELECT
      *
    FROM
      happy
    WHERE
      id IN (${ids.join(",")})
  ''');
  return List.generate(maps.length, (i) {
    return Happy(
      id: maps[i]['id'],
      text: maps[i]['text'],
      createdAt: DateTime.parse(maps[i]['createdAt']),
    );
  });
}
