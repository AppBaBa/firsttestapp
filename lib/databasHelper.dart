import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:testapp/rpovider/databaseModel.dart';

class DatabaseHelper {
  static Database? database;
  Future<Database?> get db async {
    if (database != null) {
      return database;
    }
    database = await initDatabse();
    return database;
  }

  initDatabse() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT NOT NULL)');
  }

  Future<DatabaseModel> dbHelper(DatabaseModel model) async {
    var dbs = await db;
    await dbs?.insert('notes', model.toMap());
    return model;
  }

  Future<List<DatabaseModel>> getList() async {
    var querydb = await db;
    final List<Map<String, Object?>> objects = await querydb!.query('notes');
    return objects.map((e) => DatabaseModel.fromMap(e)).toList();
  }

  Future<int> removeItem(int id) async {
    var dbs = await db;
    return dbs!.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> upDateData(DatabaseModel model) async {
    var updateDatabase = await db;
    return updateDatabase!
        .update('notes', model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }
}
