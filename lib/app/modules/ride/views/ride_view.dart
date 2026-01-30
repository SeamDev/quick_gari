import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/ride/views/ride_now.dart';
//import 'package:quick_gari/app/modules/ride/views/ride_view_list.dart';
import '../controllers/ride_controller.dart';

class RideView extends GetView<RideController> {
  const RideView({super.key});

  @override
  Widget build(BuildContext context) {
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "18 cars found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  vehicleCard(),
                  const SizedBox(height: 16),
                  vehicleCard(),
                  const SizedBox(height: 16),
                  vehicleCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carCard({
    required String name,
    required String specs,
    required String distance,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FFF2), // Light mint like screenshot
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7FD7B5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      specs,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 6),
                        Text(distance, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  height: 70,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF7FD7B5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Get.to(() => CarDetailPage());
              },
              child: const Text(
                "View car details",
                style: TextStyle(fontSize: 16, color: Color(0xFF0DBA78)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget vehicleCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFE9F8E9),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.green),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Car Image
        Image.asset(
          "assets/car1.png", // replace with your image
          height: 120,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 12),

        /// Car Name
        const Text(
          "BMW 1 Cabrio",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 4),

        /// AC + Seat
        const Text(
          "AC | 3 Seat",
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
          value: "Rajshahi University",
        ),

        const SizedBox(height: 8),

        /// Ending Area
        _infoRow(
          icon: Icons.location_on,
          iconColor: Colors.green,
          title: "Ending Area",
          value: "Mirpur 11, Dhaka",
        ),

        const SizedBox(height: 8),

        /// Date & Time
        _infoRow(
          icon: Icons.calendar_month,
          iconColor: Colors.redAccent,
          title: "Date & Time",
          value: "29-06-2025   08:35 AM",
        ),

        const SizedBox(height: 14),

        /// Fare
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.currency_exchange, color: Colors.green),
            SizedBox(width: 8),
            Text(
              "Estimated Fare : ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "8500",
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
            minimumSize: Size(300, 50)
          ),
          onPressed: () {
            Get.to(() => CarDetailPage());
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
