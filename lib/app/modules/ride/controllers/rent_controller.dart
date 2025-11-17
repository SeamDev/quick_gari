import 'package:get/get.dart';
import 'package:quick_gari/app/routes/app_pages.dart';

class RentController extends GetxController {
  RxBool charge = true.obs;

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

  bool clicked() {
    if (charge.value) {
      charge.value = false;
      return false;
    } else {
      Get.offAllNamed(Routes.HOME);
      return true;
    }
  }
}
