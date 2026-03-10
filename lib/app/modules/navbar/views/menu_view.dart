import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/service/hive_service.dart';

class MenuView extends GetView<NavbarController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Container(
      width: MediaQuery.of(context).size.width * .75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(radius: 40, backgroundImage: NetworkImage(controller.profile)),
                      SizedBox(height: 10),
                      Text(
                        controller.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        controller.email,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () => controller.closeDrawer(),
                    icon: Icon(Icons.close),
                    iconSize: 30,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            _menuItem(
              Icons.app_registration,
              "Register Your Vehicle",
              route: Routes.REGISTER_VEHICLE,
            ),
            _menuItem(Icons.car_rental, "My Vehicle", route: Routes.MY_VEHICLE),
            _menuItem(Icons.report_problem_outlined, "Complain"),
            _menuItem(Icons.group_add_outlined, "Referral"),
            _menuItem(Icons.info_outline, "About Us"),
            _menuItem(Icons.settings_outlined, "Settings"),
            _menuItem(Icons.help_outline, "Help & Support"),

            const Spacer(),
            ListTile(
              leading: Icon(Icons.logout, size: 22),
              title: Text("Log Out", style: const TextStyle(fontSize: 16)),
              onTap: () {
                HiveService.clear();
                Get.offAllNamed(Routes.AUTH , arguments: {"isInit": false});
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {route = Routes.NAVBAR}) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Get.toNamed(route);
        controller.closeDrawer();
      },
    );
  }
}
