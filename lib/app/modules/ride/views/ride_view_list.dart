import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ride_controller.dart';

class RideViewList extends GetView<RideController> {
  const RideViewList({super.key});

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
              "Avaiable cars for ride",
              style: TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(90, 90, 90, 1),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "18 cars found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  _carCard(
                    name: "BMW Cabrio",
                    specs: "Automatic · 3 seats · Octane",
                    distance: "800m (5mins away)",
                    image: "assets/car1.png",
                  ),

                  const SizedBox(height: 16),

                  _carCard(
                    name: "Mustang Shelby GT",
                    specs: "Automatic · 3 seats · Octane",
                    distance: "800m (5mins away)",
                    image: "assets/car2.png",
                  ),
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

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF7FD7B5)),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.to("");
                  },
                  child: const Text(
                    "Book later",
                    style: TextStyle(fontSize: 16, color: Color(0xFF0DBA78)),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007F4F),

                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: (){},
                  child: const Text(
                    'Ride Now',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
