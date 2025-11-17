import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/share_vehicle_controller.dart';

class ShareVehicleView extends GetView<ShareVehicleController> {
  const ShareVehicleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShareVehicleView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ShareVehicleView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
