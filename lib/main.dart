import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/service/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Get.put(NavbarController());
  await HiveService.init();
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
      //home: NavbarView(),
    );
  }
}
