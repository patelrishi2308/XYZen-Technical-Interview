import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferences? _prefs;

  /// Initialize shared preferences instance
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Set string
  static Future<bool> setString(String key, String value) async {
    return _prefs!.setString(key, value);
  }

  /// Get string
  static String? getString(String key) {
    return _prefs!.getString(key);
  }

  /// Set int
  static Future<bool> setInt(String key, int value) async {
    return _prefs!.setInt(key, value);
  }

  /// Get int
  static int? getInt(String key) {
    return _prefs!.getInt(key);
  }

  /// Set bool
  static Future<bool> setBool(String key, bool value) async {
    return _prefs!.setBool(key, value);
  }

  /// Get bool
  static bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  /// Remove specific key
  static Future<bool> remove(String key) async {
    return _prefs!.remove(key);
  }

  /// Clear all preferences
  static Future<bool> clear() async {
    return _prefs!.clear();
  }
}