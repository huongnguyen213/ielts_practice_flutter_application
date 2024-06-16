import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MockSharedPreferences implements SharedPreferences {
  Map<String, dynamic> _prefsMap = {};

  @override
  dynamic? get(String key) {
    return _prefsMap[key];
  }

  @override
  Future<bool> setString(String key, String value) {
    _prefsMap[key] = value;
    return Future.value(true);
  }

  @override
  bool containsKey(String key) {
    return _prefsMap.containsKey(key);
  }

  @override
  Future<bool> clear() {
    _prefsMap.clear();
    return Future.value(true);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    _prefsMap[key] = value;
    return Future.value(true);
  }

  @override
  bool? getBool(String key) {
    return _prefsMap[key] as bool?;
  }

  @override
  Future<bool> setDouble(String key, double value) {
    _prefsMap[key] = value;
    return Future.value(true);
  }

  @override
  double? getDouble(String key) {
    return _prefsMap[key] as double?;
  }

  @override
  Future<bool> setInt(String key, int value) {
    _prefsMap[key] = value;
    return Future.value(true);
  }

  @override
  int? getInt(String key) {
    return _prefsMap[key] as int?;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    _prefsMap[key] = value;
    return Future.value(true);
  }

  @override
  List<String>? getStringList(String key) {
    return _prefsMap[key] as List<String>?;
  }

  @override
  Future<bool> remove(String key) {
    _prefsMap.remove(key);
    return Future.value(true);
  }

  @override
  Set<String> getKeys() {
    return _prefsMap.keys.toSet();
  }

// Implement other methods as needed for your tests
}
