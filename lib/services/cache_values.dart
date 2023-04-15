import 'package:dictionary/models/definition_model.dart';
import 'package:dictionary/models/eng_model.dart';
import 'package:dictionary/models/uzb_model.dart';
import 'package:sqflite/sqflite.dart';

class CacheKeys {
  static bool english = false;
}

class CachedModels {
  static Database? database;
  static List<EngUzbModel> engUzbModel = [];
  static List<UzbEngModel> uzbEngModel = [];
  static List<DefinitionModel> definitionModel = [];
}