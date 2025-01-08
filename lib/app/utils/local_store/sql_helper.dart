// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import '../../core/app_string.dart';

class DbHelper {
  static const dbVersion = 1;
  static Database? _database;

  /*----------> For avoid the multiple class instance and this lines of
              code gives you a single private instance for global use <---------*/

  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  /*-----------------------> For check the database availability <--------------*/

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDataBase();
    return _database;
  }

  /*----> For database is not available then get db path and create table <-----*/

  initDataBase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, SqlTableString.dbname);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  /*----------------------> SQL Create Table Function <-------------------------*/

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${SqlTableString.userdataTable} (
      ${SqlTableString.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${SqlTableString.dbCreatedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  ''');

    await db.execute('''
    CREATE TABLE ${SqlTableString.loanProfileTable} (
      ${SqlTableString.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${SqlTableString.dbCreatedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      ${SqlTableString.loanProfile} TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE ${SqlTableString.advanceEmiTable} (
      ${SqlTableString.dbId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${SqlTableString.dbCreatedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      ${SqlTableString.advanceEmi} TEXT
    )
  ''');
  }

  Future<int?> insert(String tableName, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(
      tableName,
      row,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>?> queryAll(String tableName) async {
    Database? db = await instance.database;
    return await db?.query(
      tableName,
    );
  }

  Future<int?> deleteQuery(
    String tableName,
    int id,
    String columnName,
  ) async {
    Database? db = await instance.database;
    try {
      var res = await db?.delete(
        tableName,
        where: "$columnName = ?",
        whereArgs: [id],
      );
      return res;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<void> deleteAllData(String tableName) async {
    final db = await database;
    await db?.delete(tableName);
  }

  Future<List<Map<String, Object?>>?> queryAllWithOrderBy(
    String tableName,
    String columnName,
  ) async {
    Database? db = await instance.database;
    return await db?.query(tableName, orderBy: " $columnName DESC");
  }

  Future<List<Map<String, dynamic>>?> querySpecific(
    String tableName,
    dynamic id, {
    String? columnName,
  }) async {
    try {
      Database? db = await instance.database;
      var res =
          await db?.query(tableName, where: "$columnName = ?", whereArgs: [id]);
      return res;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<int?> update(
    String tableName,
    Map<String, dynamic> row,
    int id,
  ) async {
    Database? db = await instance.database;
    try {
      return await db?.update(
        tableName,
        row,
        where: '${SqlTableString.dbId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}
