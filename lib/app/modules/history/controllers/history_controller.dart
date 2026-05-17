import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/service/api_service.dart';
import 'package:quick_gari/app/widgets/driver_info_page.dart';

class WalletController extends GetxController {
  RxMap<String, dynamic> dataRide = <String, dynamic>{}.obs;
  RxMap<String, dynamic> dataReturn = <String, dynamic>{}.obs;

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
      } else {
        dataReturn.value = await ApiService.getPassengerActiveReturn();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// GO TO DRIVER PAGE
  Future<void> gotoDriver({
    required String rideId,
    required String driverId,
    bool isVerified = false,
  }) async {
    try {
      isLoading.value = true;

      /// NAVIGATE
      Get.to(() => DriverInfoContainer(isVerified: isVerified));
    } catch (e) {
      debugPrint("Goto Driver Error: $e");

      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
