import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/load_controller.dart';

class LoadView extends GetView<LoadController> {
  const LoadView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoadView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LoadView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
