
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController extends GetxController {
  late final SharedPreferences _sharedPreferences;

  SharedPreferencesController({required SharedPreferences sharedPreferences}) {
    _sharedPreferences = sharedPreferences;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return await _sharedPreferences.setString(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await _sharedPreferences.setInt(key, value);
  }

  int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return await _sharedPreferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _sharedPreferences.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _sharedPreferences.getDouble(key);
  }

  // List<String> operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await _sharedPreferences.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _sharedPreferences.getStringList(key);
  }

  // Check if key exists
  bool containsKey(String key) {
    return _sharedPreferences.containsKey(key);
  }

  // Remove a specific key
  Future<bool> remove(String key) async {
    return await _sharedPreferences.remove(key);
  }

  // Clear all data
  Future<bool> clear() async {
    return await _sharedPreferences.clear();
  }

  // Get all keys
  Set<String> getKeys() {
    return _sharedPreferences.getKeys();
  }

  // Reload shared preferences from disk
  Future<void> reload() async {
    await _sharedPreferences.reload();
  }
}
