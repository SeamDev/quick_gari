import 'package:get/get.dart';
import 'package:quick_gari/app/routes/app_pages.dart';

class RentController extends GetxController {
  RxBool charge = true.obs;




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
