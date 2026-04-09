import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/service/api_service.dart';

class RideController extends GetxController {
  bool isLoading = true;
  List<Map<String, dynamic>> dataList = [];

  @override
  void onInit() {
    //AppConfig().user.isCarOwner ? getAlluserList() : getUserRideList();
    dataRefresh();
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
    dataList = AppConfig().user.isCarOwner
        ? await ApiService.getAllRideList()
        : await ApiService.getUserRideList();
    isLoading = false;
    update();
  }

  void getAlluserList() async {
    dataList = await ApiService.getAllRideList();
    isLoading = false;
    update();
  }
}
