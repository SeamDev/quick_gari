import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/emergency_controller.dart';

class EmergencyView extends GetView<EmergencyController> {
  const EmergencyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmergencyView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EmergencyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
