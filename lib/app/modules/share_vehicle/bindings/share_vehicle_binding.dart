import 'package:get/get.dart';

import '../controllers/share_vehicle_controller.dart';

class ShareVehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareVehicleController>(
      () => ShareVehicleController(),
    );
  }
}
