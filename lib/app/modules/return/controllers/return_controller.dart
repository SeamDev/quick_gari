import 'package:get/get.dart';
import 'package:quick_gari/app/services/api_service.dart';

class ReturnController extends GetxController {
  bool isLoading = true;
  List<Map> data = [];

  @override
  void onInit() {
    getReturnList();
    super.onInit();
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
