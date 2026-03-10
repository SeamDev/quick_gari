import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/service/hive_service.dart';

class NavbarController extends GetxController {
  final _currentIndex = 0.obs;

  String profile =
      "https://www.shutterstock.com/image-vector/bus-driver-wand-icon-isolated-600nw-2600303135.jpg";
  String name = "Name";
  String email = "Email";

  int get currentIndex => _currentIndex.value;

  set currentIndex(int index) => _currentIndex.value = index;
  final advancedDrawerController = AdvancedDrawerController();

  void openDrawer() {
    advancedDrawerController.showDrawer();
  }

  void closeDrawer() {
    advancedDrawerController.hideDrawer();
  }

  @override
  void onInit() {
    Map ss = HiveService.get("user");
    profile = ss["avatar"] ?? profile ;
    name = ss["name"] ?? name ;
    email = ss["email"] ?? email ;
    super.onInit();
  }
}
