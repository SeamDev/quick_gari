import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/history_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());
    return Scaffold(
      appBar: AppBar(title: const Text("Current Ride"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchData();
          },
          child: Obx(
            () => controller.rides.isEmpty
                ? Center(child: Text("No Ride"))
                : ListView.builder(
                    //physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.rides.length,
                    itemBuilder: (context, index) {
                      return vehicleCard(
                        controller.rides[index],
                        () => controller.gotoDriver(
                          rideId: controller.rides[index]["_id"],
                          driverId: controller.rides[index]["driver"],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

Widget vehicleCard(
  Map<dynamic, dynamic> data,
  void Function() driver, {
  String type = "ride",
}) {
  String startPT = data["startLocation"] ?? "--Error--";
  String endPT = data["endLocation"] ?? "--Error--";

  String date = DateFormat("dd-MM-yyyy   hh:mm a").format(
    DateTime.parse(data["startTime"] ?? "2026-03-04T13:23:00.000Z").toLocal(),
  );

  Color color = type == "return" ? Colors.red : Colors.green;

  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _infoRow(
          icon: Icons.circle,
          iconColor: Colors.green,
          title: "Starting Area",
          value: startPT,
        ),
        const SizedBox(height: 8),

        _infoRow(
          icon: Icons.location_on,
          iconColor: Colors.deepOrange,
          title: "Ending Area",
          value: endPT,
        ),
        const SizedBox(height: 8),

        _infoRow(
          icon: Icons.calendar_month,
          iconColor: Colors.redAccent,
          title: "Date & Time",
          value: date,
        ),
        const SizedBox(height: 16),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            driver();
          },
          child: const Text(
            "Driver Details",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

Widget _infoRow({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: iconColor, size: 18),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    ],
  );
}
