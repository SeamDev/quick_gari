import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/modules/auth/views/verify.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/utils/api_config.dart';
import 'package:quick_gari/app/utils/dio_logger.dart';
import 'package:quick_gari/app/services/hive_service.dart';

bool firstTry = false, secondTry = false;

class ApiService {
  // ==========================================
  // 1. DIO INITIALIZATION & INTERCEPTOR SETUP
  // ==========================================
  static Dio dio =
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            contentType: Headers.jsonContentType,
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              // Check if this request opted out of needing auth (defaults to true)
              bool requiresAuth = options.extra['requiresAuth'] ?? true;

              // Only attach token if requiresAuth is true AND it doesn't already have one
              if (requiresAuth &&
                  !options.headers.containsKey('Authorization')) {
                String? token = await HiveService.getToken();
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
                /* else {
                  // Step 3: Try to refresh token
                  bool refreshed = await ApiService.refreshToken();
                  bool userFetched = false;

                  if (refreshed) {
                    userFetched = await ApiService.getUser();
                  }

                  if (refreshed && userFetched) {
                    // Step 4: Attach new token if available
                    token = await HiveService.getToken();
                    if (token != null && token.isNotEmpty) {
                      options.headers['Authorization'] = 'Bearer $token';
                    } else {
                      // If token still missing → navigate to login
                      Get.offAllNamed(Routes.AUTH);
                    }
                  } else {
                    // Refresh failed → navigate to login
                    Get.offAllNamed(Routes.AUTH);
                  }
                } */
              }
              return handler.next(options);
            },
            onError: (DioException error, handler) async {
              final is401 = error.response?.statusCode == 401;

              if (is401 && !secondTry) {
                if (firstTry) {
                  secondTry = true;
                } else {
                  firstTry = true;
                }
                final refreshed = await ApiService.refreshToken();
                if (refreshed) {
                  final token = await HiveService.getToken();

                  if (token != null && token.isNotEmpty) {
                    try {
                      final retryDio = Dio();

                      final RequestOptions options = error.requestOptions
                          .copyWith(
                            headers: Map<String, dynamic>.from(
                              error.requestOptions.headers,
                            )..['Authorization'] = 'Bearer $token',
                          );

                      final response = await retryDio.fetch(options);

                      return handler.resolve(response);
                    } catch (e) {
                      HiveService.clear();
                      Get.offAllNamed(Routes.AUTH);
                      debugPrint("Retry Error");
                      return handler.next(error);
                    }
                  }
                  HiveService.clear();
                  Get.offAllNamed(Routes.AUTH);
                }
              }

              return handler.next(error);
            },
          ),
        )
        ..interceptors.add(DioLogger());
  // ==========================================
  // 2. API SERVICE CLASS
  // ==========================================
  static Future<bool> g() async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}";
      var response = await dio.post(url, data: {});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // ==========================================
  // Auth
  // ==========================================

  // Login (NO TOKEN NEEDED)
  static Future<Map> login(String email, String password) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.loginAPI;
      var response = await dio.post(
        url,
        data: {"email": email, "password": password},
        options: Options(extra: {'requiresAuth': false}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        HiveService.setToken(data["data"]["accessToken"]);
        HiveService.setRToken(data["data"]["refreshToken"]);
        await ApiService.getUser();
        await ApiService.getUserSettings();
        return response.data;
      } else {
        debugPrint("Login failed");
        return response.data;
      }
    } on DioException catch (e) {
      debugPrint("ERROR: $e");
      return {
        'success': false,
        'message': e.response?.data["message"].toString(),
      };
    } catch (e) {
      debugPrint("ERROR: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // Register (NO TOKEN NEEDED)

  static Future<Map> register(
    String name,
    String email,
    String number,
    String gender,
    Uint8List? image,
    String password,
  ) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.registerAPI;

      FormData formData = FormData.fromMap({
        "name": name,
        "email": email,
        "password": password,
        "phoneNumber": number,
        "gender": gender,
        if (image != null)
          "avatar": MultipartFile.fromBytes(image, filename: "avatar.png"),
      });

      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
          extra: {'requiresAuth': false},
        ),
      );

      Map data =
          response.data ?? {'success': false, 'message': 'Error Null Return'};

      if (response.statusCode == 201) {
        Get.to(
          () => VerifyOtpScreen(
            phoneNumber: email,
            token: data["data"]["verifyToken"],
          ),
        );

        return data;
      }

      return data;
    } on DioException catch (e) {
      return e.response?.data;
    } catch (e) {
      debugPrint("❌ Register ERROR: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // Verify Code (USES SPECIFIC TOKEN)
  static Future<bool> verifyOTP(String token, String otp) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.verifyOTPAPI;

      var response = await dio.post(
        url,
        options: Options(
          // Since we manually add Authorization here, the interceptor will NOT overwrite it
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {"otp": otp},
      );

      debugPrint("${response.data}");
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Refresh Token (USES SPECIFIC TOKEN)
  static Future<bool> refreshToken() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.refreashAPI;

      String? refreshToken = await HiveService.getRToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      var response = await dio.post(
        url,
        options: Options(extra: {'requiresAuth': false}),
        data: {"refreshToken": refreshToken},
      );
      if (response.statusCode == 200) {
        HiveService.setToken(response.data?["data"]?["accessToken"]);
        HiveService.setRToken(response.data?["data"]?["refreshToken"]);
        return true;
      } else {
        HiveService.clear();
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Resend Code (USES SPECIFIC TOKEN)
  static Future<bool> reSendOTP(String token) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.reSendOTPAPI;

      var response = await dio.post(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get User (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getUser() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.getUserAPI;
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        AppConfig().loadUser(Map<String, dynamic>.from(data["data"]));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get User Settings
  static Future<bool> getUserSettings() async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}/user/settings";
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        AppConfig().loadSetting(Map<String, dynamic>.from(data["data"]));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // payment
  static Future<Map> postPayment(Map<String, dynamic> body) async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}/payment/submit";
      var response = await dio.post(url, data: body);
      return response.data;
    } on DioException catch (e) {
      return e.response?.data ?? {};
    } catch (e) {
      debugPrint("ERROR: $e");
      return {'success': false};
    }
  }

  // sent reset password otp
  static Future<bool> sendResetOTP(String email) async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}/auth/forgot-password";
      var response = await dio.post(
        url,
        options: Options(extra: {'requiresAuth': false}),
        data: {"email": email},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // change password otp
  static Future<Map<String, dynamic>> changePassword(
    String email,
    String otp,
    String password,
  ) async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}/auth/reset-password";
      var response = await dio.post(
        url,
        options: Options(extra: {'requiresAuth': false}),
        data: {"email": email, "otp": otp, "newPassword": password},
      );
      return response.data;
    } on DioException catch (e) {
      debugPrint(e.toString());
      return e.response?.data ?? {};
    } catch (e) {
      debugPrint("ERROR: $e");
      return {};
    }
  }

  //                         Car

  // Register Car (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> registerCar(Map body) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.carAPI;

      Map<String, dynamic> formDataMap = {};

      // Text Data
      formDataMap['data'] = jsonEncode(body["data"]);

      // File helper
      void addFileToMap(Map<String, dynamic>? file, String fieldName) {
        if (file != null && file['bytes'] != null) {
          final Uint8List bytes = file['bytes'];
          final String ext = file['extension'] ?? 'jpg';
          formDataMap[fieldName] = MultipartFile.fromBytes(
            bytes,
            filename: "$fieldName.$ext",
          );
        }
      }

      addFileToMap(body["taxTokenPhoto"], "taxTokenPhoto");
      addFileToMap(body["registrationCardPhoto"], "registrationCardPhoto");
      addFileToMap(body["drivingLicensePhoto"], "drivingLicensePhoto");

      // Multiple Images
      List images = body["images"] ?? [];
      List<MultipartFile> imageFiles = [];

      for (var img in images) {
        if (img != null && img['bytes'] != null) {
          final Uint8List bytes = img['bytes'];
          final String ext = img['extension'] ?? 'jpg';
          imageFiles.add(
            MultipartFile.fromBytes(bytes, filename: "car_image.$ext"),
          );
        }
      }

      if (imageFiles.isNotEmpty) {
        formDataMap["images"] = imageFiles;
      }

      FormData formData = FormData.fromMap(formDataMap);

      var response = await dio.post(url, data: formData);

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Response: ${response.data}");

      return response.statusCode == 201;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Update a Car (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> updateCar(String id, Map body) async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}${Config.carAPI}/$id";
      Map<String, dynamic> formDataMap = {};

      // Text Data
      formDataMap['data'] = jsonEncode(body["data"]);

      // File helper
      void addFileToMap(Map<String, dynamic>? file, String fieldName) {
        if (file != null && file['bytes'] != null) {
          final Uint8List bytes = file['bytes'];
          final String ext = file['extension'] ?? 'jpg';
          formDataMap[fieldName] = MultipartFile.fromBytes(
            bytes,
            filename: "$fieldName.$ext",
          );
        }
      }

      addFileToMap(body["taxTokenPhoto"], "taxTokenPhoto");
      addFileToMap(body["registrationCardPhoto"], "registrationCardPhoto");
      addFileToMap(body["drivingLicensePhoto"], "drivingLicensePhoto");

      // Multiple Images
      List images = body["images"] ?? [];
      List<MultipartFile> imageFiles = [];

      for (var img in images) {
        if (img != null && img['bytes'] != null) {
          final Uint8List bytes = img['bytes'];
          final String ext = img['extension'] ?? 'jpg';
          imageFiles.add(
            MultipartFile.fromBytes(bytes, filename: "car_image.$ext"),
          );
        }
      }

      if (imageFiles.isNotEmpty) {
        formDataMap["images"] = imageFiles;
      }

      FormData formData = FormData.fromMap(formDataMap);

      var response = await dio.patch(url, data: formData);

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Response: ${response.data}");

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get All Car List (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getAllCar() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.carAPI;
      var response = await dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Approved a Car (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> approvedCar() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.carAPI}/698b0d428a0e47d876e665a7/approve";
      var response = await dio.patch(url, data: {});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // GEt Approved Car List (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getApprovedCar() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.carAPI}/approved";
      var response = await dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get Car BY ID (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getCarByID() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.loginAPI}/697edd2e776ffda4ab3d5b84";
      var response = await dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get Car BY ID (TOKEN AUTOMATICALLY INJECTED)
  static Future<Map<String, dynamic>> getCarByUserId() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/car/user/${AppConfig().user.id}";
      var response = await dio.get(url);
      return response.data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return {};
    }
  }

  // Get Car BY ID For Admin (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getCarByIDForAdmin() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.loginAPI}/admin/698ad1e0f7e407ff0cacab2c";
      var response = await dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //                          Ride

  // Request For a Ride (TOKEN AUTOMATICALLY INJECTED)
  static Future<Map> rideSheet(dynamic body) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.rideAPI;
      var response = await dio.post(url, data: body);

      return {
        'success': response.statusCode == 200,
        'message': response.data["message"],
      };
    } catch (e) {
      debugPrint("ERROR: $e");
      return {'success': false, 'message': 'Error'};
    }
  }

  // Ride - Get User All Created PRoposal List
  static Future<List<Map<String, dynamic>>> getUserRideList() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.getUserRideListAPI;

      var response = await dio.get(url);

      //debugPrint("${response.data["data"]}");

      List data = response.data["data"];

      return data
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  // Owner Ride - Get User All Created PRoposal List
  static Future<List<Map<String, dynamic>>> getAllRideList() async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}/ride/requested";

      var response = await dio.get(url);

      //debugPrint("${response.data["data"]}");

      List data = response.data["data"];

      return data
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  // Get Ride BY ID Proposal (TOKEN AUTOMATICALLY INJECTED)
  static Future<Map<String, dynamic>> getUserRideProposalList(
    String rideID,
  ) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.rideAPI}/$rideID/";
      var response = await dio.get(url);
      return response.data["data"];
    } catch (e) {
      debugPrint("ERROR: $e");
      return {};
    }
  }

  // Send Proposal For a Ride (TOKEN AUTOMATICALLY INJECTED)
  static Future<Map> sendProposalForRide(body) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.rideProposalAPI;

      var response = await dio.post(url, data: body);

      return {
        'success': response.statusCode == 200,
        "message": response.data["message"],
      };
    } on DioException catch (e) {
      debugPrint("ERROR: $e");
      return {
        'success': false,
        "message": e.response?.data["message"].toString(),
      };
    } catch (e) {
      debugPrint("ERROR: $e");
      return {'success': false, "message": "Error"};
    }
  }

  // Accept Proposal (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> acceptProposal(String rideID, String proposalID) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.acceptProposalAPI;

      var response = await dio.post(
        url,
        data: {"rideId": rideID, "proposalId": proposalID},
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get MY Ride Proposal (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getMyRideProposal(String rideID) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.rideAPI}/$rideID/proposals/";
      var response = await dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<Map> tripVerifyOtp({
    required String tripType,
    required String tripId,
    required String otp,
    String? passengerID,
  }) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/$tripType/$tripId/verify-otp";

      var response = await dio.post(
        url,
        data: {"otp": otp, "passengerId": passengerID},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {"success": false, "message": "OTP verification failed"};
      }
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data["message"] ?? e.message,
      };
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<List<Map<String, dynamic>>> getPassengerActiveRide() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.rideAPI}/passenger/active";
      var response = await dio.get(url);

      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDriverActiveRide() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.rideAPI}/driver/active";
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getPassengerCompleteRide() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.rideAPI}/list/user/completed";
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDriverCompleteRide() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.rideAPI}/list/driver/completed";
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  // ==========================================
  // Return
  // ==========================================

  // ReturnTrip (TOKEN AUTOMATICALLY INJECTED)
  static Future<Map> createReturnTrip(Map<String, dynamic> body) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.returnTripAPI;

      var response = await dio.post(url, data: body);

      return response.data;
    } on DioException catch (e) {
      // Get response message if available
      String errorMessage = "Something went wrong";

      if (e.response != null && e.response?.data != null) {
        if (e.response!.data is Map<String, dynamic> &&
            e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = e.response!.data.toString();
        }
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      debugPrint("Dio ERROR: $errorMessage");

      return {
        'success': false,
        'message': errorMessage,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      debugPrint("ERROR: $e");
      return {'success': false};
    }
  }

  static Future<List<Map>> getAllReturnTrip() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.returnTripAPI;
      var response = await dio.get(url);
      List data = response.data["data"];

      return data.map<Map>((e) => Map.from(e)).toList();
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<bool> acceptReturnTrip(String id) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.returnTripAPI}/$id/book";

      var response = await dio.post(url);

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<bool> verifyReturnOTP(String id, String otp) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.acceptProposalAPI}/$id/verify-otp";

      var response = await dio.post(url, data: {"otp": otp});

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getPassengerActiveReturn() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.returnTripAPI}/passenger/active";
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDriverActiveReturn() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.returnTripAPI}/driver/active";
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getPassengerCompleteReturn() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.returnTripAPI}/passenger/completed";
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDriverCompleteReturn() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.returnTripAPI}/driver/completed";
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  // ==========================================
  // Share Vehicle
  // ==========================================

  // Share Vehicle (TOKEN AUTOMATICALLY INJECTED)

  static Future<dynamic> createShareVehicle(Map<String, dynamic> data) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.shareVehicleAPI;

      var response = await dio.post(url, data: data);

      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return {"success": false, 'message': 'No Dio Error'};
    }
  }

  static Future<List<Map<String, dynamic>>> getAvShVehicle() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.shareVAvailableAPI;
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();
      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDrShVehicle() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.shareVDriverAPI;
      var response = await dio.get(url);
      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();
      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> getSVCostPer(
    String from,
    String to,
  ) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/share-vehicle-fare/$from/$to";
      var response = await dio.get(url);
      Map<String, dynamic> data = response.data["data"];
      return data;
    } on DioException catch (e) {
      return e.response?.data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return {};
    }
  }

  static Future<List<String>> getSVStopLocation() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/share-vehicle-fare/locations-list";
      var response = await dio.get(url);
      List<String> data = response.data["data"].cast<String>();
      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<Map> acceptSV(Map<String, dynamic> body) async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}/share-vehicle-booking";
      var response = await dio.post(url, data: body);
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return {'success': false};
    }
  }

  static Future<Map> tripverifyOtpSV(
    String shareVehicleID,
    String passengerID,
    String otp,
  ) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}//$shareVehicleID/verify-otp";
      var response = await dio.post(
        url,
        data: {"passengerId": passengerID, "otp": otp},
      );
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return {'success': false};
    }
  }

  static Future<List<Map<String, dynamic>>> getPassengerActiveSVehicle() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/share-vehicle-booking/user/active-bookings";
      var response = await dio.get(url);

      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDriverActiveSVehicle() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/share-vehicle-booking/driver/active-bookings";
      var response = await dio.get(url);

      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>>
  getPassengerCompleteSVehicle() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/share-vehicle-booking/user/complete-bookings";
      var response = await dio.get(url);

      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDriverCompleteSVehicle() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/share-vehicle-booking/driver/complete-bookings";
      var response = await dio.get(url);

      List<Map<String, dynamic>> data = response.data["data"]
          .cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  /// Chat
  // Create Chat
  static Future<bool> createChat(String type, String id) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/chat/conversation/$type/$id";
      var response = await dio.post(url);
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> getChat(
    String type,
    String id, {
    int limit = 50,
  }) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/chat/conversation/$type/$id?limit=$limit";
      var response = await dio.get(url);
      return response.data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return {"isActive": false, "messages": []};
    }
  }

  static Future<bool> sendMessage(
    String type,
    String id,
    String receiver,
    String message,
  ) async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}/chat/send";
      var response = await dio.post(
        url,
        data: {
          "contextType": type,
          "contextId": id,
          "receiverId": receiver,
          "message": message,
        },
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  ///                          Notification
  /// getNotification
  static Future<Map<String, dynamic>> getNotifications() async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}/notifications";
      var response = await dio.get(url);
      return response.data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return {};
    }
  }

  /// getUnreadCount
  static Future<int> getUnreadNotifications() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/notifications/unread-count";
      var response = await dio.get(url);
      return response.data["data"];
    } catch (e) {
      debugPrint("ERROR: $e");
      return 0;
    }
  }

  // set FCM
  static Future<bool> patchFCM(String? token) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/notifications/settings/update/fcm-token";
      var response = await dio.patch(url, data: {"fcmToken": token});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // set FCM
  static Future<bool> deleteFCM(String? token) async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}/notifications/settings/delete/fcm-token";
      var response = await dio.delete(url, data: {"fcmToken": token});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // MArk as read by id
  static Future<bool> markNotificationAsRead(String id) async {
    try {
      final url =
          "${Config.baseUrl}${Config.apiVersion}/notifications/mark-as-read/$id";

      final response = await dio.patch(url);

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // mark as read all
  static Future<bool> markAllNotificationsAsRead() async {
    try {
      final url =
          "${Config.baseUrl}${Config.apiVersion}/notifications/mark-all-as-read";

      final response = await dio.patch(url);

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }
  // Hello
}
