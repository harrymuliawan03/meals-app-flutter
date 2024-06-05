// ignore_for_file: unnecessary_null_comparison

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future<void> saveData<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
    print('saveData $key value $value');
  }

  static String? getStringData(String key) {
    return _prefs.getString(key);
  }

  static bool? getBoolData(String key) {
    return _prefs.getBool(key);
  }

  static int? getIntData(String key) {
    return _prefs.getInt(key);
  }

  static double? getDoubleData(String key) {
    return _prefs.getDouble(key);
  }

  static List<String>? getStringListData(String key) {
    return _prefs.getStringList(key);
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  static void removeAll() {
    var keys = _prefs.getKeys();
    if (keys.isNotEmpty) {
      for (var element in keys) {
        _prefs.remove(element);
      }
    }
  }
}
