import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

class RideController extends GetxController {
  bool isLoading = true;
  List<Map<String, String>> dataList = [];

  @override
  void onInit() {
    getUserRideList();
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

  void getUserRideList() async {
    dataList = await ApiService.getUserRideList();
    isLoading = false;
    update();
  }

  void dataRefresh() async {
    isLoading = true;
    update();
    dataList = await ApiService.getUserRideList();
    isLoading = false;
    update();
  }

  
}
