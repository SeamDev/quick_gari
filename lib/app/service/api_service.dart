import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_gari/app/service/config.dart';
import 'package:quick_gari/app/service/hive_service.dart';

class ApiService {
  static var client = http.Client();

  static Future<bool> login(String email, String password) async {
    try {
      var url = Uri.parse(Config.baseUrl + Config.apiVersion + Config.loginAPI);

      var response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        HiveService.put("user", data["data"]);
        return true;
      } else {
        print("Login failed");
        return false;
      }
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }
}
