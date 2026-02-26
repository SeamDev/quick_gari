import 'package:get/get.dart';
import 'package:quick_gari/app/service/hive_service.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  dynamic userInfo;
  @override
  void onInit() {
    userInfo = HiveService.get("user");
    print(userInfo);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    print(0);
    super.onClose();
  }
}
