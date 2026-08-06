import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/hive_service.dart';

class MenuView extends GetView<NavbarController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppConfig().user.obs;
    final setting = AppConfig().settings.obs;

    return Material(
      //width: MediaQuery.of(context).size.width * .75,
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(80),
        bottomRight: Radius.circular(80),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Stack(
              children: [
                Center(
                  child: Obx(
                    () => Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.value.avatar),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.value.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.value.email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.value.isCarOwner ? "Car Owner" : "User",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () => controller.closeDrawer(),
                    icon: const Icon(Icons.close),
                    iconSize: 30,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            if (setting.value.carRegistrationRequest == null)
              _menuItem(
                Icons.app_registration,
                "Register Your Vehicle",
                route: Routes.REGISTER_VEHICLE,
              ),
            if (setting.value.carRegistrationRequest == false)
              ListTile(
                leading: Icon(Icons.pending_outlined),
                title: Text("Request Pending"),
              ),
            if (setting.value.carRegistrationRequest == true)
              _menuItem(
                Icons.car_rental,
                "My Vehicle",
                route: Routes.MY_VEHICLE,
              ),

            _menuItem(Icons.report_problem_outlined, "Complain"),

            _menuItem(Icons.history, "History", route: Routes.HISTORY),

            _menuItem(Icons.info_outline, "About Us", route: Routes.ABOUT_US),

            // _menuItem(
            //   Icons.settings_outlined,
            //   "Settings",
            // ),
            _menuItem(
              Icons.help_outline,
              "Help & Support",
              route: Routes.HELP_SUPPORT,
            ),

            const Spacer(),

            ListTile(
              leading: const Icon(Icons.logout, size: 22),
              title: const Text("Log Out", style: TextStyle(fontSize: 16)),
              onTap: () async{
                await HiveService.clear();
                await controller.unInit();
                Get.offAllNamed(Routes.AUTH, arguments: {"isInit": false});
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {String? route}) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        if (route != null) {
          Get.toNamed(route);
        }

        controller.closeDrawer();
      },
    );
  }
}
