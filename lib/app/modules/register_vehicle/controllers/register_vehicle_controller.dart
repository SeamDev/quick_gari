import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/services/api_service.dart';

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

  Rxn<Map<String, dynamic>> taxTokenPhoto = Rxn<Map<String, dynamic>>();
  Rxn<Map<String, dynamic>> registrationCardPhoto = Rxn<Map<String, dynamic>>();
  Rxn<Map<String, dynamic>> licensePhoto = Rxn<Map<String, dynamic>>();

  Rxn<Map<String, dynamic>> frontView = Rxn<Map<String, dynamic>>();
  Rxn<Map<String, dynamic>> sideView = Rxn<Map<String, dynamic>>();
  Rxn<Map<String, dynamic>> backView = Rxn<Map<String, dynamic>>();
  Rxn<Map<String, dynamic>> interiorView = Rxn<Map<String, dynamic>>();

  final user = AppConfig().user;
  late final String carId;
  @override
  void onInit() {
    super.onInit();
    carId = Get.arguments ?? "0";
  }

  void checkValid() {}

  // =============================
  // FILE PICKER FUNCTION
  // =============================

  Future<Map<String, dynamic>?> pickFile() async {
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
        };
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
    final files = <Rxn<Map<String, dynamic>>, String>{
      taxTokenPhoto: "Tax Token Photo",
      registrationCardPhoto: "Registration Card Photo",
      licensePhoto: "License Photo",
      frontView: "Front View",
      sideView: "Side View",
      backView: "Back View",
      interiorView: "Interior View",
    };

    for (final entry in files.entries) {
      if (entry.key.value == null) {
        Get.snackbar(
          "Required",
          "${entry.value} is required",
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
      "taxTokenPhoto": taxTokenPhoto.value,
      "drivingLicensePhoto": licensePhoto.value,
      "images": [
        frontView.value,
        sideView.value,
        backView.value,
        interiorView.value,
      ],
      "registrationCardPhoto": registrationCardPhoto.value,
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

    bool res;
    if (user.isCarOwner) {
      res = await ApiService.updateCar(carId, body);
    } else {
      res = await ApiService.registerCar(body);
    }
    if (res) {
      Get.back();
      if (user.isCarOwner) Get.back();
      Get.snackbar(
        "Status",
        user.isCarOwner
            ? "Vehicle Update Successful"
            : "Vehicle Registration Successful",
      );
    } else {
      Get.snackbar(
        "Status",
        user.isCarOwner
            ? "Vehicle Update Unsuccessful"
            : "Vehicle Registration Unsuccessful",
      );
    }
  }
}
