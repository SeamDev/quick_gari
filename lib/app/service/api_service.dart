import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quick_gari/app/modules/auth/views/verify.dart';
import 'package:quick_gari/app/service/config.dart';
import 'package:quick_gari/app/service/hive_service.dart';
import 'package:quick_gari/app/service/user.dart';

var client = http.Client();

class ApiService {
  static Future<bool> g() async {
    try {
      var url = Uri.parse(Config.baseUrl + Config.apiVersion + Config.loginAPI);

      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
            body: jsonEncode({}),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //                                Auth
  //Login
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
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        User.fromJson(data["data"]);
        HiveService.setToken(data["token"]["accessToken"]);
        HiveService.setRToken(data["token"]["refreshToken"]);
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

  //Rigister
  static Future<bool> register(
    String name,
    String email,
    String number,
    String gender,
    Uint8List? image,
    String password,
  ) async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.registerAPI,
      );

      var response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "name": name,
              "email": email,
              "password": password,
              "phoneNumber": number,
              "gender": gender,
              "avater": image,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);

        Get.to(
          () => VerifyOtpScreen(
            phoneNumber: email,
            token: data["data"]["verifyToken"],
          ),
        );
        return true;
      } else {
        print("Login failed ${response.body}");
        return false;
      }
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }

  //verify Code
  static Future<bool> verifyOTP(String token, String otp) async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.verifyOTPAPI,
      );

      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({"otp": otp}),
          )
          .timeout(const Duration(seconds: 15));

      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }

  //Resend Code
  static Future<bool> reSendOTP(String token) async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.reSendOTPAPI,
      );

      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }

  //getUser
  static Future<bool> getUser() async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.getUserAPI,
      );

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        User.fromJson(data["data"]);
        HiveService.put("user", data["data"]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //                              Car
  //Register Car
  static Future<bool> registerCar() async {
    try {
      var url = Uri.parse(Config.baseUrl + Config.apiVersion + Config.carAPI);

      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
            body: jsonEncode({
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
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //Update a Car
  static Future<bool> updateCar() async {
    try {
      var url = Uri.parse(
        "${Config.baseUrl}${Config.apiVersion}${Config.carAPI}/id--",
      );

      var response = await client
          .patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
            body: jsonEncode({
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
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get All Car List
  static Future<bool> getAllCar() async {
    try {
      var url = Uri.parse(Config.baseUrl + Config.apiVersion + Config.carAPI);

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //Approved a Car
  static Future<bool> approvedCar() async {
    try {
      var url = Uri.parse("${Config.baseUrl}${Config.apiVersion}${Config.carAPI}/698b0d428a0e47d876e665a7/approve");

      var response = await client
          .patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ',
            },
            body: jsonEncode({}),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // GEt Approved Car List
  static Future<bool> getApprovedCar() async {
    try {
      var url = Uri.parse("${Config.baseUrl}${Config.apiVersion}${Config.carAPI}/approved");

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get Car BY ID
  static Future<bool> getCarByID() async {
    try {
      var url = Uri.parse("${Config.baseUrl}${Config.apiVersion}${Config.loginAPI}/697edd2e776ffda4ab3d5b84");

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Get Car BY ID
  static Future<bool> getCarByIDForAdmin() async {
    try {
      var url = Uri.parse("${Config.baseUrl}${Config.apiVersion}${Config.loginAPI}/admin/698ad1e0f7e407ff0cacab2c");

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //                              Ride
  // Request For a Ride
  static Future<dynamic> rideSheet(dynamic body) async {
    try {
      var url = Uri.parse(Config.baseUrl + Config.apiVersion + Config.rideAPI);
      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${await HiveService.getToken()}',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //HiveService.put("user", data["data"]);
        print(data);
        return true;
      } else {
        print("Login failed ${response.body}");
        return false;
      }
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }

  // Send Proposal For a Ride
  static Future<bool> sendProposalForRide() async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.rideProposalAPI,
      );

      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
            body: jsonEncode({
              "rideId": "69a2cf2d0e9808e22b83289c",
              "fare": "200",
              "message": "Hello There i am available for this period",
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  // Send Proposal For a Ride
  static Future<bool> acceptProposal() async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.acceptProposalAPI,
      );

      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
            body: jsonEncode({
              "rideId": "69a31106061621a0432d5c99",
              "proposalId": "69a31131061621a0432d5ca2",
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //Get MY Ride Proposal
  static Future<bool> getMyRideProposal() async {
    try {
      var url = Uri.parse(
        "${Config.baseUrl}${Config.apiVersion}${Config.rideAPI}/69a31106061621a0432d5c99/proposals/",
      );

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //Get MY Ride Proposal
  static Future<bool> getRideByIDProposal() async {
    try {
      var url = Uri.parse(
        "${Config.baseUrl}${Config.apiVersion}${Config.rideAPI}/69a31106061621a0432d5c99/",
      );

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //                    Return
  //ReturnTrip
  static Future<bool> returnTrip() async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.returnTripAPI,
      );

      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
            body: jsonEncode({
              "startLocation": "Rajshahi University",
              "endLocation": "Shaheb Bazar",
              "date": "2026-02-10",
              "startTime": "2026-02-01T10:30:00.000Z",
              "fare": 500,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //GetAllAvailable Trip
  static Future<bool> returnAllTrip() async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.returnTripAPI,
      );

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //                  Share Vehicle
  //Create Share Vehicle
  static Future<bool> createShareVehicle() async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.shareVehicleAPI,
      );

      var response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
            body: jsonEncode({
              "journeyDate": "2026-02-25",
              "stops": [
                {"location": "Rajshahi", "arrivalTime": "08:00 AM", "order": 0},
                {"location": "Natore", "arrivalTime": "09:30 AM", "order": 1},
                {"location": "Bogura", "arrivalTime": "11:00 AM", "order": 2},
              ],
              "perSeatFare": 250,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //Get Available Share Vehicle
  static Future<bool> getAvShVehicle() async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.shareVAvailableAPI,
      );

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //get Driver Share Vehicle
  static Future<bool> getDrShVehicle() async {
    try {
      var url = Uri.parse(
        Config.baseUrl + Config.apiVersion + Config.shareVDriverAPI,
      );

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  //get Share Vehicle BY ID
  static Future<bool> getShVehicleByID() async {
    try {
      var url = Uri.parse(
        "${Config.baseUrl}${Config.apiVersion}${Config.shareVehicleAPI}/699bf590be2911b89c1b23da",
      );

      var response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${HiveService.getToken()}',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  ///
  ///
}
