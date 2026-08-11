import 'package:get/get.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/api_service.dart';

class MyVehicleController extends GetxController {
  final RxMap<String, dynamic> vehicle = <String, dynamic>{}.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadVehicle();
  }

  Future<void> loadVehicle() async {
    try {
      isLoading.value = true;

      final data = await ApiService.getCarByUserId();

      vehicle.assignAll(data["data"] ?? {});
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void gotoUpdatePage() {
    final features = vehicle['features'] ?? {};
    Get.toNamed(
      Routes.REGISTER_VEHICLE,
      arguments: {
        "carId": vehicle["_id"],
        "images": (features['images'] as List?) ?? [],
        "carName": vehicle['carName'] ?? '',
        "vehicleType": features['vehicleType'] ?? '',
        "brand": features['brand'] ?? '',
        "model": features['model'] ?? '',
        "seatCapacity": features['seatCapacity'],
        "fuelType": features['fuelType'],
        "gearType": features['gearType'],
        "manufactureYear": features['manufactureYear'] ?? '',
        "registrationNumber":
            vehicle['vehicleRegistration']['registrationNumber'],
        "RegistrationYear": vehicle['vehicleRegistration']['registration'],
        "Taxphoto": vehicle['vehicleRegistration']['taxTokenPhoto'],
        "Registrationphoto":
            vehicle['vehicleRegistration']['registrationCardPhoto'],
        "Drivingphoto": vehicle['drivingLicensePhoto'],
      },
    );
  }
}
