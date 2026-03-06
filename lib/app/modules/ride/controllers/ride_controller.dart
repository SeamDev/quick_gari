import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

class RideController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Map<String, String>> dataList = <Map<String, String>>[
    {
      "_id": "69a839eebd1641f1f936dd68",
      "startLocation": "Rajshahi University",
      "endLocation": "Shaheb Bazar",
      "date": "2026-03-03T18:00:00.000Z",
      "startTime": "2026-03-04T13:55:00.000Z",
    },
    {
      "_id": "69a8354bbd1641f1f936dd4a",
      "startLocation": "Rajshahi University",
      "endLocation": "Shaheb Bazar",
      "date": "2026-03-03T18:00:00.000Z",
      "startTime": "2026-03-04T13:36:00.000Z",
    },
    {
      "_id": "69a833548ff2811a1ee7e6cd",
      "startLocation": "Rajshahi University",
      "endLocation": "Shaheb Bazar",
      "date": "2026-03-03T18:00:00.000Z",
      "startTime": "2026-03-04T13:27:00.000Z",
    }
  ].obs;

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

  void rideInfo() async {
    String rideID = "69a832478ff2811a1ee7e6c3";
    await ApiService.getRideByID(rideID);
  }
}
