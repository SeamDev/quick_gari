import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/modules/share_vehicle/views/share_admin.dart';
import 'package:quick_gari/app/modules/share_vehicle/views/share_user.dart';

import '../controllers/share_vehicle_controller.dart';

class ShareVehicleView extends GetView<ShareVehicleController> {
  const ShareVehicleView({super.key});
  @override
  Widget build(BuildContext context) {
    //return controller.user.isCarOwner ? ShareAdmin() : ShareUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Share Vehicle"),
        centerTitle: true,
        actions: [
          if(AppConfig().user.isCarOwner) ElevatedButton(
            onPressed: () => Get.to(() => ShareAdmin()),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 0, 131, 29),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text("Create"), SizedBox(width: 8), Icon(Icons.add)],
            ),
          ),
        ],
      ),
      body: ShareUser(),
    );
  }
}
