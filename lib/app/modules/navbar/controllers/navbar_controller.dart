import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/services/chat_socket_service.dart';

class NavbarController extends GetxController {
  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  final ChatSocketService chatSocket = Get.find<ChatSocketService>();

  @override
  void onInit() {
    super.onInit();
    chatSocket.init();
  }

  @override
  void onClose() {
    chatSocket.unInit();
    super.onClose();
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
