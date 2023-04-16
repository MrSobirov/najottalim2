import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dictionary/models/definition_model.dart';
import 'package:dictionary/models/eng_model.dart';
import 'package:dictionary/models/uzb_model.dart';
import 'package:sqflite/sqflite.dart';

class CacheKeys {
  static bool engUzb = false;
  static int engUzbPage = 1;
  static int uzbEngPage = 1;
  static int definitionPage = 0;
  static List<ConnectivityResult> internet = [
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
    ConnectivityResult.vpn
  ];

  static Future<bool> hasInternet() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    return CacheKeys.internet.contains(result);
  }
}

class CachedModels {
  static Database? database;
  static List<EngUzbModel> engUzbModel = [];
  static List<UzbEngModel> uzbEngModel = [];
  static List<DefinitionModel> definitionModel = [];
}