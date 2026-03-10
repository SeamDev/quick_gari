import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quick_gari/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  Future<void> _launchDialer(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerX = Get.find<NavbarController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quick Gari',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
        ),
        leadingWidth: 70,
        leading: Padding(
          padding: EdgeInsetsGeometry.only(left: 10, top: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset('assets/icon.jpg', fit: BoxFit.fill),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
            icon: Icon(Icons.notifications_none_outlined, size: 30),
          ),
          IconButton(
            onPressed: () => drawerX.openDrawer(),
            icon: Icon(Icons.menu, size: 30),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 20,
          children: [
            const SizedBox(height: 10),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Color.fromRGBO(225, 190, 175, 0.35),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Call  For Booking ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _launchDialer('+8801780613284'),
                    icon: Image.asset("assets/call.png"),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007F4F),
                fixedSize: Size(250, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Get.toNamed(Routes.RIDE),
              child: const Text(
                'Ride',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007F4F),
                fixedSize: Size(250, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: ()=> Get.toNamed(Routes.EMERGENCY),
              child: const Text(
                'Load',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007F4F),
                fixedSize: Size(250, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: ()=> Get.toNamed(Routes.EMERGENCY),
              child: const Text(
                'Emergency',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007F4F),
                fixedSize: Size(250, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Get.toNamed(Routes.RETURN),
              child: const Text(
                'Return',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007F4F),
                fixedSize: const Size(250, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: ()=> Get.toNamed(Routes.SHARE_VEHICLE),
              child: const Text(
                'Share Vehicle',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

