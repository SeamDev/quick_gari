import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioLogger extends Interceptor {
  // ANSI color codes
  static const String reset = "\x1B[0m";
  static const String red = "\x1B[31m";
  static const String green = "\x1B[32m";
  static const String blue = "\x1B[34m";
  static const String yellow = "\x1B[33m";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print("$blue➡️ REQUEST: ${options.method} ${options.uri}$reset");
      print("$yellow Headers: ${options.headers}$reset");
      print("$yellow Body: ${options.data}$reset");
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        "$green✅ SUCCESS [${response.statusCode}] ${response.requestOptions.uri}$reset",
      );
      print("$green Response: ${response.data}$reset");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        "$red❌ ERROR [${err.response?.statusCode ?? "NO STATUS"}] ${err.requestOptions.uri}$reset",
      );
      print("$red Message: ${err.message}$reset");
      print("$red Response: ${err.response?.data}$reset");
    }
    super.onError(err, handler);
  }
}