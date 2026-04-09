
import 'package:quick_gari/app/config/user.dart';

class AppConfig {

  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  UserModel user = UserModel();


  void load(Map<String, dynamic> map) => user = UserModel.fromJson(map);

}