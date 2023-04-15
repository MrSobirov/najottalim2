import 'package:flutter/foundation.dart';

import 'package:sqflite/sqflite.dart';

class DBService {
  static List<Map> sqlResponse = [];
  Future<bool> getEngUz() async {
    try{
      Database database = await openDatabase("assets/eng_dictionary.db");
      sqlResponse = await database.rawQuery("SELECT * FROM eng_uzb;");
      return sqlResponse.isNotEmpty;
    } catch(error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return false;
    }
  }

  Future<bool> getUzEng() async {
    try{
      Database database = await openDatabase("assets/eng_dictionary.db");
      sqlResponse = await database.rawQuery("SELECT * FROM uzb_eng;");
      return sqlResponse.isNotEmpty;
    } catch(error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return false;
    }
  }

  Future<bool> getDefinition() async {
    try{
      Database database = await openDatabase("assets/eng_dictionary.db");
      sqlResponse = await database.rawQuery("SELECT * FROM definition;");
      return sqlResponse.isNotEmpty;
    } catch(error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return false;
    }
  }

  Future<bool> addWordToDB(String word) async {
    try{
      Database database = await openDatabase("assets/eng_dictionary.db");
      database.insert('countries', {"a" : word});
      return true;
    } catch (error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return false;
    }
  }
}