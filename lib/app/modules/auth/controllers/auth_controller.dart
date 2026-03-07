import 'package:get/get.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/service/api_service.dart';
import 'package:quick_gari/app/service/hive_service.dart';

class AuthController extends GetxController {
  bool isSplash = true;
  @override
  void onInit() {
    checkAuth();
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

  void checkAuth() async {
    final token = await HiveService.getToken();
    if (token == null) {
      isSplash = false;
    } else {
      if (await ApiService.getUser()) {
        Get.offAllNamed(Routes.NAVBAR,);
      } else {
        isSplash = false;
      }
    }
    await Future.delayed(Duration(seconds: 2));
    update();
  }
}
