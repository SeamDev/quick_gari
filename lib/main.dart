//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/fcm_service.dart';
import 'package:quick_gari/app/services/hive_service.dart';
import 'package:quick_gari/app/services/notification_service.dart';
import 'package:quick_gari/app/utils/initial_binding.dart';
import 'package:quick_gari/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().localNotificationInitialize();
  FirebaseMessaging.onBackgroundMessage(FCMService.backgroundHandler);
  final fcmService = FCMService();

  await fcmService.initialize();

  runApp(const MyApp());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (fcmService.initialMessage != null) {
      fcmService.handleNotificationClick(fcmService.initialMessage!);
    }
  });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Gari',
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      //home: NavbarView(),
    );
  }
}
