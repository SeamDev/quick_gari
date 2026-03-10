import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/ride/controllers/ride_proposal_controller.dart';
import 'package:quick_gari/app/modules/ride/views/ride_now.dart';
class RideProposalView extends StatelessWidget {
  final String id;
  RideProposalView({super.key, required this.id});

  late final RideProposalController controller = Get.put(
    RideProposalController(id),
  );

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        title: const Text("Back", style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),

      body: GetBuilder<RideProposalController>(
        builder: (_) {
          return controller.isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.green))
              : controller.dataList.isEmpty
              ? Center(child: Text("No Proposal Created"))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      Text(
                        "${controller.dataList["proposals"].length} proposal found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),

                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.dataList["proposals"].length,
                          itemBuilder: (context, index) {
                            final data =
                                controller.dataList["proposals"][index];
                            return vehicleCard(data, controller.mainList , id);
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
}

Widget vehicleCard(Map<String, dynamic> data, List<String> mainList,String id) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: EdgeInsets.only(top: 16),
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
          data["car"]["features"]["images"]?[0] ??
              "assets/car1.png", // replace with your image
          height: 120,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 12),

        /// Car Name
        Text(
          data["car"]["carName"] ?? "--Error--",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 4),

        /// AC + Seat
        Text(
          "${data["car"]?["features"]?["seatCapacity"] ?? 0} Seat",
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
          value: mainList[0],
        ),

        const SizedBox(height: 8),

        /// Ending Area
        _infoRow(
          icon: Icons.location_on,
          iconColor: Colors.green,
          title: "Ending Area",
          value: mainList[1],
        ),

        const SizedBox(height: 8),

        /// Date & Time
        _infoRow(
          icon: Icons.calendar_month,
          iconColor: Colors.redAccent,
          title: "Date & Time",
          value: mainList[2],
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
              data["fare"].toString(),
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
            Get.to(() => CarDetailPage(data, mainList,id));
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