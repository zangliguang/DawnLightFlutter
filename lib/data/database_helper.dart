import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
//    Directory documentDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentDirectory.path, "main.db");
//    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
//    return ourDb;

    var databasesPath = await getDatabasesPath();
    Directory(databasesPath).create(recursive: true);

    String path = join(databasesPath, "asset_movie.db");
    await deleteDatabase(path);
    ByteData data = await rootBundle.load(join("asset", "movie.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);

    // open the database
    Database db = await openDatabase(path);
    return db;
  }
}
