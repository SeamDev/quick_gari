import 'package:quick_gari/app/models/setting_model.dart';
import 'package:quick_gari/app/models/user_model.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  UserModel user = UserModel();
  UserSettings settings = UserSettings();

  void loadUser(Map<String, dynamic> map) => user = UserModel.fromJson(map);
  void loadSetting(Map<String, dynamic> map) =>
      settings = UserSettings.fromJson(map);
}
