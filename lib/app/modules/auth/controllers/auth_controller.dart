import 'package:get/get.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/service/api_service.dart';
import 'package:quick_gari/app/service/hive_service.dart';

class AuthController extends GetxController {
  bool isSplash = true;
  bool isInit = true;
  @override
  void onInit() {
    if (Get.arguments != null) {
      isInit = Get.arguments["isInit"] ?? true;
    }
    if (isInit) {
      checkAuth();
    } else {
      isSplash = false;
    }
    update();
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
        Get.offAllNamed(Routes.NAVBAR);
      } else {
        isSplash = false;
      }
    }
    await Future.delayed(Duration(seconds: 2));
    update();
  }
}
