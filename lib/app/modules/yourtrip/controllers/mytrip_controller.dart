import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/services/api_service.dart';

class WalletController extends GetxController {
  RxList<Map<String, dynamic>> dataRide = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dataReturn = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dataSVehicle = <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    isLoading.value = true;
    fetchData();
    super.onInit();
  }

  /// FETCH ALL RIDES
  Future<void> fetchData() async {
    try {
      if (AppConfig().user.isCarOwner) {
        dataReturn.value = await ApiService.getDriverActiveReturn();
        dataRide.value = await ApiService.getDriverActiveRide();
        dataSVehicle.value = await ApiService.getDriverActiveSVehicle();
      } else {
        dataReturn.value = await ApiService.getPassengerActiveReturn();
        dataRide.value = await ApiService.getPassengerActiveRide();
        dataSVehicle.value = await ApiService.getPassengerActiveSVehicle();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
