import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

class HistoryController extends GetxController {
  RxList data = [].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    print(await ApiService.getDriverCompleteRide());
    print(await ApiService.getPassengerCompleteRide());
  }
}
