import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/share_vehicle/views/share_admin.dart';
import 'package:quick_gari/app/modules/share_vehicle/views/share_user.dart';

import '../controllers/share_vehicle_controller.dart';

class ShareVehicleView extends GetView<ShareVehicleController> {
  const ShareVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.user.isCarOwner ? ShareAdmin() : ShareUser();
  }
}
