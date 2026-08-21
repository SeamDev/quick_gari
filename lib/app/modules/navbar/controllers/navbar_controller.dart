import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/models/notification_model.dart';
import 'package:quick_gari/app/services/api_service.dart';
import 'package:quick_gari/app/services/chat_socket_service.dart';
import 'package:quick_gari/app/services/hive_service.dart';
import 'package:quick_gari/app/services/notification_service.dart';

class NavbarController extends GetxController {
  final _currentIndex = 0.obs;

  RxInt get notificationCount => _notificationService.notificationCount;

  int get currentIndex => _currentIndex.value;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final ChatSocketService _chatSocket = Get.find<ChatSocketService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  @override
  void onInit() async {
    super.onInit();
    _chatSocket.onNewNotification = () {
      _notificationService.notificationCount.value++;
    };
    _chatSocket.init();
    await _notificationService.initialize();
    await ApiService.patchFCM(await _fcm.getToken());
  }

  @override
  void onReady() async {
    super.onReady();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final message = await _fcm.getInitialMessage();
      if (message == null) {
        return;
      }

      _notificationService.notificationRedirect(
        NotificationModel.fromRemoteMessage(message),
      );
    });
  }

  Future<void> unInit() async {
    _chatSocket.unInit();
    await _notificationService.unInit();

    await ApiService.deleteFCM(await _fcm.getToken());

    await HiveService.clear();
  }

  set currentIndex(int index) => _currentIndex.value = index;
  final advancedDrawerController = AdvancedDrawerController();

  void openDrawer() {
    advancedDrawerController.showDrawer();
  }

  void closeDrawer() {
    advancedDrawerController.hideDrawer();
  }
}
