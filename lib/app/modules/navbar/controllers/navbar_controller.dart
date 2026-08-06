import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/services/api_service.dart';
import 'package:quick_gari/app/services/chat_socket_service.dart';
import 'package:quick_gari/app/services/hive_service.dart';
import 'package:quick_gari/app/services/notification_service.dart';

class NavbarController extends GetxController {
  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  final ChatSocketService _chatSocket = Get.find<ChatSocketService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  @override
  void onInit() async {
    super.onInit();
    _chatSocket.init();
    _notificationService.initialize();

    final token = HiveService.get("fcm") as String? ?? "";
    await ApiService.patchFCM(token);
  }

  Future<void> unInit() async {
    _chatSocket.unInit();
    await _notificationService.unInit();
    final token = HiveService.get("fcm") as String? ?? "";

    await ApiService.deleteFCM(token);
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
