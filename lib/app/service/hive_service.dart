import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _defaultBox = 'appBox';
  static const String _tokenBox = 'appBox';

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_defaultBox);
    await Hive.openBox(_tokenBox);
  }

  /// Open custom box
  static Future<Box> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  /// Get value
  static T? get<T>(String key, {String boxName = _defaultBox}) {
    final box = Hive.box(boxName);
    return box.get(key);
  }

  /// Save value
  static Future<void> put<T>(
    String key,
    T value, {
    String boxName = _defaultBox,
  }) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  /// Delete value
  static Future<void> delete(
    String key, {
    String boxName = _defaultBox,
  }) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  /// Clear box
  static Future<void> clear({String boxName = _defaultBox}) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  /// Check if key exists
  static bool containsKey(
    String key, {
    String boxName = _defaultBox,
  }) {
    final box = Hive.box(boxName);
    return box.containsKey(key);
  }

  /// Close box
  static Future<void> closeBox({String boxName = _defaultBox}) async {
    await Hive.box(boxName).close();
  }
  ////
  ///
  ///
  static Future<void> setToken(String value) async {
    await Hive.box(_tokenBox).put("token", value);
  }
  static Future<void> setRToken(String value) async {
    await Hive.box(_tokenBox).put("Rtoken", value);
  }
  static Future<String?> getToken() async {
    return await Hive.box(_tokenBox).get("token");
  }
  static Future<String?> getRToken() async {
    return await Hive.box(_tokenBox).get("Rtoken");
  }
}