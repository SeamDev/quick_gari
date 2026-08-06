import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/services/api_service.dart';

class HistoryController extends GetxController {
  RxList<Map<String, dynamic>> dataRide = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dataReturn = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dataSVehicle = <Map<String, dynamic>>[].obs;

  bool isOwner = AppConfig().user.isCarOwner;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  /// FETCH ALL RIDES
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      if (AppConfig().user.isCarOwner) {
        dataReturn.value = await ApiService.getDriverCompleteReturn();
        dataRide.value = await ApiService.getDriverCompleteRide();
        dataSVehicle.value = await ApiService.getDriverCompleteSVehicle();
      } else {
        dataReturn.value = await ApiService.getPassengerCompleteReturn();
        dataRide.value = await ApiService.getPassengerCompleteRide();
        dataSVehicle.value = await ApiService.getPassengerCompleteSVehicle();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
