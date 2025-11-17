import 'package:get/get.dart';

import '../controllers/load_controller.dart';

class LoadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadController>(
      () => LoadController(),
    );
  }
}
