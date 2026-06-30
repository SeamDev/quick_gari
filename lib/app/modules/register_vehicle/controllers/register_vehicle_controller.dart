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

  // =============================
  // FILE VARIABLES
  // =============================

  Rxn<Map> taxTokenPhoto = Rxn<Map>();
  Rxn<Map> registrationCardPhoto = Rxn<Map>();
  Rxn<Map> licensePhoto = Rxn<Map>();

  Rxn<Map> frontView = Rxn<Map>();
  Rxn<Map> sideView = Rxn<Map>();
  Rxn<Map> backView = Rxn<Map>();
  Rxn<Map> interiorView = Rxn<Map>();

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
  final file = await pickFile();

  if (file == null) return;

  switch (key) {
    case "tax":
      taxTokenPhoto.value = file;
      break;

    case "reg":
      registrationCardPhoto.value = file;
      break;

    case "lic":
      licensePhoto.value = file;
      break;

    case "front":
      frontView.value = file;
      break;

    case "side":
      sideView.value = file;
      break;

    case "back":
      backView.value = file;
      break;

    case "interior":
      interiorView.value = file;
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
      ApiService.getUser();
      Get.back();
    } else {}
  }
}
