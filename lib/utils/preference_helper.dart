import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static Future<SharedPreferences> get sharedPrefs =>
      SharedPreferences.getInstance();

  static Future<bool> getBool(String key) async {
    final prefs = await sharedPrefs;
    return prefs.getBool(key) ?? false;
  }

  static Future setBool(String key, bool value) async {
    final prefs = await sharedPrefs;
    return prefs.setBool(key, value);
  }

  static Future<int> getInt(String key) async {
    final prefs = await sharedPrefs;
    return prefs.getInt(key) ?? 0;
  }

  static Future setInt(String key, int value) async {
    final prefs = await sharedPrefs;
    return prefs.setInt(key, value);
  }

  static Future<String> getString(String key) async {
    final prefs = await sharedPrefs;
    return prefs.getString(key) ?? '';
  }

  static Future setString(String key, String value) async {
    final prefs = await sharedPrefs;
    return prefs.setString(key, value);
  }

  static Future<double> getDouble(String key) async {
    final prefs = await sharedPrefs;
    return prefs.getDouble(key) ?? 0.0;
  }

  static Future setDouble(String key, double value) async {
    final prefs = await sharedPrefs;
    return prefs.setDouble(key, value);
  }
}
