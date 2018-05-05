import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

final String tableOrder = "grocery";
final String columnId = "_id";
final String columnTitle = "title";
final String columnQuantity = "quantity";
final String columnType ="type";
final String columnPic ="picture" ;

class TodoProvider {
  Database db;
  static List <Map> list;
  static String text;

  Future open() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    db = await openDatabase(dbPath, version: 1,
        onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute("""
          CREATE TABLE IF NOT EXISTS  $tableOrder (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT ,
        $columnTitle TEXT NOT NULL,
        $columnQuantity DOUBLE NOT NULL,
        $columnType TEXT NOT NULL,
        $columnPic TEXT)
         """);
  }

  Future insert(String _name, double _q, String _type, String _picture) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    await db.rawInsert(
        "INSERT INTO $tableOrder (title, quantity, type, picture) VALUES ('$_name' , '$_q' , '$_type', '$_picture' )");
    var count = await db.rawQuery("SELECT COUNT(*) FROM $tableOrder");
    list = await db.rawQuery('SELECT title, quantity, type, picture FROM $tableOrder');
    await db.close();
    return [count,list];
  }

  Future delete(String id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    await db.delete(tableOrder, where: "$columnTitle = ?", whereArgs: [id]);
    var count = await db.rawQuery("SELECT COUNT(*) FROM $tableOrder");
    list = await db.rawQuery('SELECT title, quantity, type, picture FROM $tableOrder');
    await db.close();
    return count;
  }

  Future countCategory() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    var count = await db.rawQuery("SELECT COUNT(*) FROM $tableOrder");
    list = await db.rawQuery('SELECT title, quantity, type, picture FROM $tableOrder');
    await db.close();
    return [count, list];
  }

  Future<String> getJson(int count) async {
    Directory path;
    if(Platform.isAndroid)
      path = await getExternalStorageDirectory();
    File listText = new File(join(path.path,"Download", "shareList.txt"));
    String json = "[";
    for (int i= 0; i < count; i++) {
      String Title = TodoProvider.list[i]['title'];
      double Quantity = TodoProvider.list[i]['quantity'];
      String Type =TodoProvider.list[i]['type'];
      String Pic =TodoProvider.list[i]['picture'];
      json += '{ "title":"$Title", "quantity":"$Quantity", "type":"$Type", "picture":"$Pic"}';
      if (i < count-1 ) {
        json += ",";
      }
    }
    json += "]";
    text=json;
    listText.writeAsString(json);
    return json;
  }

}