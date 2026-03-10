import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

class ReturnController extends GetxController {
  bool isLoading = true;
  List<Map> data = [];

  @override
  void onInit() {
    getReturnList();
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

  void getReturnList() async {
    data = await ApiService.getAllReturnTrip();
    isLoading = false;
    update();
  }

  void dataRefresh() async {
    isLoading = true;
    update();
    data = await ApiService.getAllReturnTrip();
    isLoading = false;
    update();
  }
}
