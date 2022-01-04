import 'package:flutter_alarm_app/models/alarm.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createObject();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createObject();
    }

    return _databaseHelper!;
  }

  static const String _tblAlarm = 'alarm';

  Future<Database> _initializeDb() async {
    final path = await getDatabasesPath();
    final db = openDatabase('$path/alarms.db', onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $_tblAlarm (
            alarm_id INTEGER PRIMARY KEY,
            schedule_time TEXT,
            schedule_type TEXT,
            is_ringed INTEGER
          )
        ''');
    }, version: 1);

    return db;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database!;
  }

  Future<bool> insertAlarm(Alarm alarm) async {
    try {
      final db = await database;
      await db.insert(_tblAlarm, alarm.toJson());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final db = await database;
    await db.update(_tblAlarm, alarm.toJson(),
        where: 'alarm_id = ?', whereArgs: [alarm.alarmId]);
  }

  Future<List<Alarm>> getAlarms() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tblAlarm);
    return results.map((e) => Alarm.fromJson(e)).toList();
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;

    await db.delete(_tblAlarm, where: 'alarm_id = ?', whereArgs: [id]);
  }
}
