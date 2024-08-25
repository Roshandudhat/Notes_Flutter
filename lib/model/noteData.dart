import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';



class SQLHelper{
  static Future<void> createTables(sql.Database database ) async{
    await database.execute('''
          create table data(
            id integer primary key autoincrement not null,
            title text,
            detali text,
            dateAp timestamp not null default current_timestamp
          )
          ''');
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase('book.db',version: 1,
        onCreate: (sql.Database database ,int version ) async {
          await createTables(database);
        }
    );
  }



  static Future<int> createData(String title, String? detali )async{
    final db = await SQLHelper.db();
    final data = {'title' : title, 'detali': detali};
    final id = await db.insert('data', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String,dynamic>>> getAllData()async{
    final db= await SQLHelper.db();
    return db.query('data',orderBy: 'id');
  }

  static Future<List<Map<String,dynamic>>> getSingleData(int id) async{
    final db = await SQLHelper.db();
    return db.query('data',where: "id = ?",whereArgs: [id],limit: 1);
  }

  static Future<int> updateData(int id,String title, String? detali ) async{
    final db = await SQLHelper.db();
    final data = {
      'title':title,
      'detali':detali,
      'dateAp': DateTime.now().toString()
    };

    final result = await db.update('data',data,whereArgs: [id],where: "id =?");

    return result;
  }

  static Future<void> deleteData(int id) async{
    final db= await SQLHelper.db();
    try{
      await db.delete('data',where: "id= ?",whereArgs: [id]);
    }catch(e){}
  }


}


