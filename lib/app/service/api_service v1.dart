import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/modules/auth/views/verify.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/service/api_config.dart';
import 'package:quick_gari/app/service/dio_logger.dart';
import 'package:quick_gari/app/service/hive_service.dart';

// ==========================================
// 1. DIO INITIALIZATION & INTERCEPTOR SETUP
// ==========================================
final dio =
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
            if (requiresAuth && !options.headers.containsKey('Authorization')) {
              String? token = await HiveService.getToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              } else {
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
              }
            }
            return handler.next(options);
          },
          onError: (DioException error, handler) async {
            if (error.response?.statusCode == 401) {
              if (!await ApiService.refreshToken()) {}
            }
            return handler.next(error);
          },
        ),
      )
      ..interceptors.add(DioLogger());

// ==========================================
// 2. API SERVICE CLASS
// ==========================================
class ApiService {
  static Future<bool> g() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.loginAPI;
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
        HiveService.setToken(data["token"]["accessToken"]);
        HiveService.setRToken(data["token"]["refreshToken"]);
        await ApiService.getUser();
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
      String? refreashToken = await HiveService.getRToken();
      var response = await dio.post(
        url,
        options: Options(extra: {'requiresAuth': false}),
        data: {"refreshToken": refreashToken},
      );
      HiveService.setToken(response.data["data"]["accessToken"]);
      HiveService.setRToken(response.data["data"]["refreshToken"]);
      return response.statusCode == 200;
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
        AppConfig().load(Map<String, dynamic>.from(data["data"]));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // ==========================================
  // Car
  // ==========================================

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
  static Future<bool> updateCar() async {
    try {
      var url = "${Config.baseUrl}${Config.apiVersion}${Config.carAPI}/id--";

      var response = await dio.patch(
        url,
        data: {
          "taxTokenPhoto": "",
          "drivingLicensePhoto": "",
          "images": "",
          "registrationCardPhoto": "",
          "data": {
            "carName": "Toyota Corolla 2020",
            "features": {
              "vehicleType": "Sedan",
              "model": "Corolla",
              "brand": "Toyota",
              "fuelType": "Petrol",
              "gearType": "Automatic",
              "seatCapacity": 5,
              "manufactureYear": 2020,
            },
            "vehicleRegistration": {
              "registrationNumber": "DHAKA-MA-11-2234",
              "registration": 2020,
            },
          },
        },
      );

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

  // ==========================================
  // Ride
  // ==========================================

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

  // GetAllAvailable Trip (TOKEN AUTOMATICALLY INJECTED)
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

  // ==========================================
  // Share Vehicle
  // ==========================================

  // Create Share Vehicle (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> createShareVehicle() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.shareVehicleAPI;

      var response = await dio.post(
        url,
        data: {
          "journeyDate": "2026-02-25",
          "stops": [
            {"location": "Rajshahi", "arrivalTime": "08:00 AM", "order": 0},
            {"location": "Natore", "arrivalTime": "09:30 AM", "order": 1},
            {"location": "Bogura", "arrivalTime": "11:00 AM", "order": 2},
          ],
          "perSeatFare": 250,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get Available Share Vehicle (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getAvShVehicle() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.shareVAvailableAPI;
      var response = await dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get Driver Share Vehicle (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getDrShVehicle() async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.shareVDriverAPI;
      var response = await dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get Share Vehicle BY ID (TOKEN AUTOMATICALLY INJECTED)
  static Future<bool> getShVehicleByID() async {
    try {
      var url =
          "${Config.baseUrl}${Config.apiVersion}${Config.shareVehicleAPI}/699bf590be2911b89c1b23da";
      var response = await dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  ///Paymnt -----------------------------------------
  /// Post - Payment
  static Future<Map> postPayment(String trx, Map<String, String> body) async {
    try {
      var url = Config.baseUrl + Config.apiVersion + Config.paymentAPI;
      var response = await dio.post(url, data: body);
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    } catch (e) {
      debugPrint("ERROR: $e");
      return {'success': false};
    }
  }
}
