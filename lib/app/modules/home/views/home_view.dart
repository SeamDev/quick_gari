import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quick Gari',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
        ),
        leadingWidth: 70,
        leading: Padding(
          padding: EdgeInsetsGeometry.only(left: 10,top: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset('assets/icon.png', fit: BoxFit.fill),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
            icon: Icon(Icons.notifications_none_outlined, size: 30),
          ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: Icon(Icons.account_circle_outlined, size: 30),
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
                    onPressed: () => _launchDialer('+8801700000000'),
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
              onPressed: () => _sheet(context, Routes.RIDE),
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
              onPressed: () => _sheet(context, Routes.RIDE),
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
              onPressed: () => Get.toNamed(Routes.EMERGENCY),
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
              onPressed: () => Get.toNamed(Routes.SHARE_VEHICLE),
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

_sheet(context, routes) {
  return Get.bottomSheet(
    DraggableScrollableSheet(
      initialChildSize: 0.55, // start position (middle)
      minChildSize: 0.30,
      maxChildSize: 0.85,
      builder: (context, controller) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            children: [
              // top drag handle
              Center(
                child: Container(
                  height: 5,
                  width: 60,
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              Text(
                "Select address",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Your inputs (Pick Location)
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.my_location, color: Colors.green),
                    SizedBox(width: 10),
                    Text("Pick Location"),
                    Spacer(),
                    Icon(Icons.close, color: Colors.red),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // Drop Location
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 10),
                    Text("Drop Location"),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Recent Places Title
              Text(
                "Recent places",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 10),

              // Example recent place
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_pin),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Office",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "2972 Westheimer Rd, Santa Ana, Illinois 85486",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Text("2.7km"),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007F4F),
                  fixedSize: Size(250, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.toNamed(routes);
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    ),

    // settings
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
