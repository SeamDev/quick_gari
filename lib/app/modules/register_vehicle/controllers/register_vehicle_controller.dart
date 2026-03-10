import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

class RegisterVehicleController extends GetxController {
  // =============================
  // TEXT CONTROLLERS
  // =============================

  String? fullName;
  String? phone;
  String? email;
  String? address;

  String? model;
  String? registrationNumber;
  String? driverName;
  String? driverPhone;
  String? licenseNumber;

  // =============================
  // DROPDOWNS
  // =============================

  String? vehicleType;
  String? brand;
  String? seatCapacity;
  String? fuelType;
  String? gearType;
  String? manufactureYear;
  String? registrationYear;

  bool isAC = false;

  // =============================
  // FILE VARIABLES
  // =============================

  Map? nidPhoto;
  Map? taxTokenPhoto;
  Map? registrationCardPhoto;
  Map? licensePhoto;
  Map? driverPhoto;

  Map? frontView;
  Map? sideView;
  Map? backView;
  Map? interiorView;

  void checkValid() {}

  // =============================
  // FILE PICKER FUNCTION
  // =============================

  Future<Map?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // important
    );

    if (result != null && result.files.isNotEmpty) {
      Uint8List? imageBytes = result.files.first.bytes;

      if (imageBytes != null) {
        if (!kIsWeb) {
          imageBytes = await FlutterImageCompress.compressWithList(
            imageBytes,
            quality: 60,
            minWidth: 512,
            minHeight: 512,
          );
        }

        return {
              "bytes": imageBytes,
              "extension": result.files.first.extension ?? "jpg",
            }
            as Map<String, dynamic>;
      }
    }
    return null;
  }

  void filePICK(String key) async {
    switch (key) {
      case "nid":
        nidPhoto = await pickFile();
        break;
      case "tax":
        taxTokenPhoto = await pickFile();
        break;
      case "reg":
        registrationCardPhoto = await pickFile();
        break;
      case "lic":
        licensePhoto = await pickFile();
        break;
      case "dri":
        driverPhoto = await pickFile();
        break;
      case "front":
        frontView = await pickFile();
        break;
      case "side":
        sideView = await pickFile();
        break;
      case "back":
        backView = await pickFile();
        break;
      case "interior":
        interiorView = await pickFile();
        break;
    }
  }

  bool checkRequiredFiles() {
    // Map of file variable to its friendly name
    final Map<dynamic, String> files = {
      taxTokenPhoto: "Tax Token Photo",
      registrationCardPhoto: "Registration Card Photo",
      licensePhoto: "License Photo",
      frontView: "Front View",
      sideView: "Side View",
      backView: "Back View",
      interiorView: "Interior View",
    };

    for (var entry in files.entries) {
      final file = entry.key;
      final name = entry.value;

      // Check null or empty (if it's a String path)
      if (file == null || (file is String && file.trim().isEmpty)) {
        Get.snackbar(
          "Required",
          "$name is required",
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }
    return true;
  }

  void uploadVehicle() async {
    if (!checkRequiredFiles()) return;
    Map body = {
      "taxTokenPhoto": taxTokenPhoto,
      "drivingLicensePhoto": licensePhoto,
      "images": [frontView, sideView, backView, interiorView],
      "registrationCardPhoto": registrationCardPhoto,
      "data": {
        "carName": fullName,
        "features": {
          "vehicleType": vehicleType,
          "model": model,
          "brand": brand,
          "fuelType": fuelType,
          "gearType": gearType,
          "seatCapacity": int.parse(seatCapacity ?? '0'),
          "manufactureYear": int.parse(manufactureYear ?? '0'),
        },
        "vehicleRegistration": {
          "registrationNumber": registrationNumber,
          "registration": int.parse(registrationYear ?? '0'),
        },
      },
    };

    bool res = await ApiService.registerCar(body);
    if (res) {
      Get.back();
    } else {}
  }
}
