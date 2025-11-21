import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:quick_gari/app/modules/navbar/views/navbar_view.dart';
import 'package:quick_gari/app/routes/app_pages.dart';

void main() {
  Get.put(NavbarController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Gari',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      home: NavbarView(),
      );
  }
}
