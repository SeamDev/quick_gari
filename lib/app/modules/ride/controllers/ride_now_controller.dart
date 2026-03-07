import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

class RideNowController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFailed = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void proposalInfo() async {
    String rideID = "69a832478ff2811a1ee7e6c3";
    if (await ApiService.getMyRideProposal(rideID)) {
    } else {
      isFailed.value = true;
    }
    isLoading.value = false;
  }
}
