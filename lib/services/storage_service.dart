import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<bool> saveBool({required String key, required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  Future<bool?> getBool({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}