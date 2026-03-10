import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_gari/app/modules/return/views/filter_bottom.dart';
import 'package:quick_gari/app/modules/return/views/vehicle_detail.dart';

import '../controllers/return_controller.dart';

class ReturnView extends GetView<ReturnController> {
  const ReturnView({super.key});

  @override
  Widget build(BuildContext context) {
    void refresh() {
      controller.dataRefresh();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        leadingWidth: 30,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 26),
          ),
        ),
        title: Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () => showEditableAddressSheet(context,refresh),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Text('Create', style: TextStyle(color: Colors.black87)),
                  SizedBox(width: 6),
                  Icon(Icons.add, color: Colors.black54),
                  SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<ReturnController>(
        builder: (_) {
          return controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : controller.data.isEmpty
              ? Center(child: Text("NO Return Car Found"),)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      Text(
                        "${controller.data.length} cars found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),

                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.data.length,
                          itemBuilder: (context, index) {
                            final data = controller.data[index];
                            return vehicleCard(data);
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget vehicleCard(Map<dynamic, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F8E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Car Image
          Image.network(
            data["car"]?["features"]?["images"]?[0] ?? "assets/car1.png",
            height: 120,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 12),

          /// Car Name
          Text(
            "${data["car"]["carName"]}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          /// AC + Seat
          Text(
            "${data["car"]?["features"]?["seatCapacity"]} Seat",
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),

          const SizedBox(height: 6),

          /// Distance
          const Text(
            "5 KM | Distance from your starting location",
            style: TextStyle(color: Colors.black87, fontSize: 12),
          ),

          const SizedBox(height: 14),

          /// Starting Area
          _infoRow(
            icon: Icons.circle,
            iconColor: Colors.green,
            title: "Starting Area",
            value: "${data["startLocation"]}",
          ),

          const SizedBox(height: 8),

          /// Ending Area
          _infoRow(
            icon: Icons.location_on,
            iconColor: Colors.green,
            title: "Ending Area",
            value: "${data["endLocation"]}",
          ),

          const SizedBox(height: 8),

          /// Date & Time
          _infoRow(
            icon: Icons.calendar_month,
            iconColor: Colors.redAccent,
            title: "Date & Time",
            value: DateFormat("dd-MM-yyyy   hh:mm a").format(
              DateTime.parse(
                data["startTime"] ?? "2026-03-04T13:23:00.000Z",
              ).toLocal(),
            ),
          ),

          const SizedBox(height: 14),

          /// Fare
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.currency_exchange, color: Colors.green),
              SizedBox(width: 8),
              Text(
                "Estimated Fare : ",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "${data["fare"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: Size(300, 50),
            ),
            onPressed: () {
              Get.to(() => CarDetailsView(data));
            },
            child: const Text(
              "Vehicle Details & Booking",
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
        Column(
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
      ],
    );
  }
}
