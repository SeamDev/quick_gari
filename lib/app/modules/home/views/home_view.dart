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
              onPressed: () => showEditableAddressSheet(context, Routes.RIDE),
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
              onPressed: () => showEditableAddressSheet(context, Routes.RIDE),
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

showEditableAddressSheet(BuildContext context, String routes) {
  final startCtrl = TextEditingController(text: "Adabor Dhaka");
  final endCtrl = TextEditingController(text: "Malopara Rajshahi");
  final dateCtrl = TextEditingController(text: "12-05-2025");
  final timeCtrl = TextEditingController(text: "12 : 05 AM");

  Get.bottomSheet(
    DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      
      builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            children: [
              /// drag handle
              Center(
                child: Container(
                  height: 5,
                  width: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const Text(
                "Select address",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// Starting Point
              _editableField(
                icon: Icons.location_on,
                iconColor: Colors.green,
                label: "Starting Point",
                controller: startCtrl,
                borderColor: Colors.green,
              ),

              const SizedBox(height: 12),

              /// Arrival Point
              _editableField(
                icon: Icons.location_on_outlined,
                iconColor: Colors.red,
                label: "Arrival Point",
                controller: endCtrl,
              ),

              const SizedBox(height: 12),

              /// Date Picker
              _editableField(
                icon: Icons.calendar_month,
                iconColor: Colors.redAccent,
                label: "Date",
                controller: dateCtrl,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dateCtrl.text =
                        "${picked.day.toString().padLeft(2, '0')}-"
                        "${picked.month.toString().padLeft(2, '0')}-"
                        "${picked.year}";
                  }
                },
              ),

              const SizedBox(height: 12),

              /// Time Picker
              _editableField(
                icon: Icons.access_time,
                iconColor: Colors.green,
                label: "Time",
                controller: timeCtrl,
                readOnly: true,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    timeCtrl.text = picked.format(context);
                  }
                },
              ),

              const SizedBox(height: 24),

              /// Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007F4F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.toNamed(routes, arguments: {
                    "start": startCtrl.text,
                    "end": endCtrl.text,
                    "date": dateCtrl.text,
                    "time": timeCtrl.text,
                  });
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
  );
}

Widget _editableField({
  required IconData icon,
  required Color iconColor,
  required String label,
  required TextEditingController controller,
  bool readOnly = false,
  VoidCallback? onTap,
  Color borderColor = const Color(0xFFE0E0E0),
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              labelStyle:
                  const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (controller.text.isNotEmpty)
          GestureDetector(
            onTap: () => controller.clear(),
            child: const Icon(Icons.close, color: Colors.red, size: 18),
          ),
      ],
    ),
  );
}
