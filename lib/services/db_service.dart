import 'dart:io';

import 'package:dictionary/models/definition_model.dart';
import 'package:dictionary/models/eng_model.dart';
import 'package:dictionary/models/uzb_model.dart';
import 'package:dictionary/services/cache_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DBService {
  static List<Map<String, dynamic>> sqlResponse = [];

  Future<bool> openAssetDatabase() async {
    try {
      String path = join(await getDatabasesPath(), "eng_dictionary.db");
      var exists = await databaseExists(path);
      if (!exists) {
        print("Creating new copy from asset");
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}
        ByteData data = await rootBundle.load(join("assets", "eng_dictionary.db"));
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } else {
        print("Opening existing database");
      }
      CachedModels.database = await openDatabase(path);
      return true;
    } catch(error, stacktrace) {
      debugPrint("Databasing opening error: $error, $stacktrace");
      return false;
    }
  }

  Future<bool?> getEngUzb(String word, int page) async {
    if(page == 1) {
      CachedModels.engUzbModel.clear();
    } else {
      page += 30;
    }
    try{
      if(CachedModels.database != null) {
        print((await CachedModels.database!.query('sqlite_master', columns: ['type', 'name'])));
        sqlResponse = await CachedModels.database!.rawQuery("SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY _id) AS RowNum, * FROM eng_uzb WHERE eng_uzb.eng like '%$word%') AS RowConstrainedResult WHERE RowNum >= $page AND RowNum < ${page+30} ORDER BY RowNum");
        CachedModels.engUzbModel.addAll(engUzbModelFromJson(sqlResponse));
        return sqlResponse.isNotEmpty;
      } else {
        debugPrint("Database is null!");
        return null;
      }
    } catch(error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return null;
    }
  }

  Future<bool?> getUzbEng(String word, int page) async {
    if(page == 1) {
      CachedModels.uzbEngModel.clear();
    } else {
      page += 30;
    }
    try{
      if(CachedModels.database != null) {
        sqlResponse = await CachedModels.database!.rawQuery("SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY _id) AS RowNum, * FROM uzb_eng WHERE uzb_eng.uzb like '%$word%') AS RowConstrainedResult WHERE RowNum >= $page AND RowNum < ${page+30} ORDER BY RowNum");
        CachedModels.uzbEngModel.addAll(uzbEngModelFromJson(sqlResponse));
        return sqlResponse.isNotEmpty;
      } else {
        debugPrint("Database is null!");
        return null;
      }
    } catch(error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return null;
    }
  }

  Future<bool?> getDefinition(String word, int page) async {
    if(page == 1) {
      CachedModels.definitionModel.clear();
    } else {
      page += 30;
    }
    try{
      if(CachedModels.database != null) {
        sqlResponse = await CachedModels.database!.rawQuery("SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY ID) AS RowNum, * FROM definition WHERE definition.Word like '%$word%') AS RowConstrainedResult WHERE RowNum >= $page AND RowNum < ${page+30} ORDER BY RowNum");
        CachedModels.definitionModel.addAll(definitionModelFromJson(sqlResponse));
        return sqlResponse.isNotEmpty;
      } else {
        debugPrint("Database is null!");
        return null;
      }
    } catch(error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return null;
    }
  }

  Future<bool?> addWordToDB(String table, Map<String, dynamic> body) async {
    try{
      if(CachedModels.database != null) {
        bool wordExist = true;
        switch(table) {
          case "eng_uzb":
            bool? haveWord = await getEngUzb(body["eng"], 1);
            if(haveWord != null) {
              wordExist = haveWord;
            }
            break;
          case "uzb_eng":
            bool? haveWord = await getUzbEng(body["uzb"], 1);
            if(haveWord != null) {
              wordExist = haveWord;
            }
            break;
          case "definition":
            bool? haveWord = await getDefinition(body["Word"], 1);
            if(haveWord != null) {
              wordExist = haveWord;
            }
            break;
        }
        int id = 0;
        if(!wordExist) {
          id = await CachedModels.database!.insert(table, body);
        }
        return id != 0;
      } else {
        debugPrint("Database is null!");
        return null;
      }
    } catch (error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return null;
    }
  }
}