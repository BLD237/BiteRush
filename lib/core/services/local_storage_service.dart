import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._(this._store);

  final _KeyValueStore _store;

  static Future<LocalStorageService> create() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return LocalStorageService._(_SharedPreferencesStore(preferences));
    } on MissingPluginException {
      return LocalStorageService._(_InMemoryStore());
    }
  }

  bool containsKey(String key) {
    return _store.containsKey(key);
  }

  String? getString(String key) {
    return _store.getString(key);
  }

  bool? getBool(String key) {
    return _store.getBool(key);
  }

  int? getInt(String key) {
    return _store.getInt(key);
  }

  double? getDouble(String key) {
    return _store.getDouble(key);
  }

  List<String>? getStringList(String key) {
    return _store.getStringList(key);
  }

  Future<bool> setString(String key, String value) {
    return _store.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) {
    return _store.setBool(key, value);
  }

  Future<bool> setInt(String key, int value) {
    return _store.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) {
    return _store.setDouble(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _store.setStringList(key, value);
  }

  Future<bool> remove(String key) {
    return _store.remove(key);
  }

  Future<bool> clear() {
    return _store.clear();
  }
}

abstract class _KeyValueStore {
  bool containsKey(String key);
  String? getString(String key);
  bool? getBool(String key);
  int? getInt(String key);
  double? getDouble(String key);
  List<String>? getStringList(String key);
  Future<bool> setString(String key, String value);
  Future<bool> setBool(String key, bool value);
  Future<bool> setInt(String key, int value);
  Future<bool> setDouble(String key, double value);
  Future<bool> setStringList(String key, List<String> value);
  Future<bool> remove(String key);
  Future<bool> clear();
}

class _SharedPreferencesStore implements _KeyValueStore {
  _SharedPreferencesStore(this._preferences);

  final SharedPreferences _preferences;

  @override
  bool containsKey(String key) => _preferences.containsKey(key);

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  bool? getBool(String key) => _preferences.getBool(key);

  @override
  int? getInt(String key) => _preferences.getInt(key);

  @override
  double? getDouble(String key) => _preferences.getDouble(key);

  @override
  List<String>? getStringList(String key) => _preferences.getStringList(key);

  @override
  Future<bool> setString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<bool> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  @override
  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  @override
  Future<bool> setDouble(String key, double value) =>
      _preferences.setDouble(key, value);

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _preferences.setStringList(key, value);

  @override
  Future<bool> remove(String key) => _preferences.remove(key);

  @override
  Future<bool> clear() => _preferences.clear();
}

class _InMemoryStore implements _KeyValueStore {
  final Map<String, Object> _values = {};

  @override
  bool containsKey(String key) => _values.containsKey(key);

  @override
  String? getString(String key) => _values[key] as String?;

  @override
  bool? getBool(String key) => _values[key] as bool?;

  @override
  int? getInt(String key) => _values[key] as int?;

  @override
  double? getDouble(String key) => _values[key] as double?;

  @override
  List<String>? getStringList(String key) => _values[key] as List<String>?;

  @override
  Future<bool> setString(String key, String value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _values[key] = List<String>.from(value);
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _values.clear();
    return true;
  }
}
