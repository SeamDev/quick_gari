import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:quick_gari/app/modules/home/views/home_view.dart';
import 'package:quick_gari/app/routes/app_pages.dart';

void main() {
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
      home: HomeView()
      );
  }
}
