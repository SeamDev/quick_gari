import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

class RegisterVehicleController extends GetxController {
  // =============================
  // TEXT CONTROLLERS
  // =============================

  final fullName = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final address = ''.obs;

  final model = ''.obs;
  final registrationNumber = ''.obs;
  final driverName = ''.obs;
  final driverPhone = ''.obs;
  final licenseNumber = ''.obs;

  // =============================
  // DROPDOWNS
  // =============================

  final vehicleType = ''.obs;
  final brand = ''.obs;
  final seatCapacity = ''.obs;
  final fuelType = ''.obs;
  final gearType = ''.obs;
  final manufactureYear = ''.obs;
  final registrationYear = ''.obs;

  final isAC = false.obs;

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

  // =============================
  // FILE PICKER FUNCTION
  // =============================

  Future<Map?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // important
    );

    if (result != null) {
      return {
            "bytes": result.files.first.bytes,
            "extension": result.files.first.extension ?? "jpg",
          }
          as Map<String, dynamic>;
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

  void uploadVehicle() async {
    Map body = {
      "taxTokenPhoto": taxTokenPhoto,
      "drivingLicensePhoto": licensePhoto,
      "images": [frontView, sideView, backView, interiorView],
      "registrationCardPhoto": registrationCardPhoto,
      "data": {
        "carName": fullName.value,
        "features": {
          "vehicleType": vehicleType.value,
          "model": model.value,
          "brand": brand.value,
          "fuelType": fuelType.value,
          "gearType": gearType.value,
          "seatCapacity": int.parse(seatCapacity.value),
          "manufactureYear": int.parse(manufactureYear.value),
        },
        "vehicleRegistration": {
          "registrationNumber": registrationNumber.value,
          "registration": int.parse(registrationYear.value),
        },
      },
    };
    bool hasNull(dynamic value) {
      if (value == null) return true;

      if (value is Map) {
        // Check all values in the Map
        return value.values.any((v) => hasNull(v));
      }

      if (value is List) {
        // Check all elements in the List
        return value.any((v) => hasNull(v));
      }

      // Primitive value (int, String, bool, etc.) is not null
      return false;
    }

    if (hasNull(body)) {
      Get.snackbar("Empty", "Fill all Required Field");
    }
    bool res = await ApiService.registerCar(body);
    if (res) {
      Get.back();
    } else {}
  }
}
