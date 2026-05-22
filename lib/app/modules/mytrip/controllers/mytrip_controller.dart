import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/service/api_service.dart';

class WalletController extends GetxController {
  RxList<Map<String, dynamic>> dataRide = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dataReturn = <Map<String, dynamic>>[].obs;

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
        dataReturn.value = await ApiService.getDriverActiveReturn();
        dataRide.value = await ApiService.getDriverActiveRide();
      } else {
        dataReturn.value = await ApiService.getPassengerActiveReturn();
        dataRide.value = await ApiService.getPassengerActiveRide();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
