import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/return_controller.dart';

class ReturnView extends GetView<ReturnController> {
  const ReturnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        leadingWidth: 20,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 26),
        ),
        title: Text(
          'Return Trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Text('Trip Filter', style: TextStyle(color: Colors.black87)),
                SizedBox(width: 6),
                Icon(Icons.filter_list, color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Trip List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                TripCard(
                  carName: 'Axio',
                  rating: 2.0,
                  pickUp: 'মৌলভীবাজার, Bangladesh',
                  dropOff: 'মহাখালী, Dhaka, Bangladesh',
                  dateTime: '29-06-2025 03:30 AM',
                  fare: 4000,
                  charge: 396,
                  total: 4396,
                  imagePath: 'assets/car1.png',
                ),
                TripCard(
                  carName: 'X COROLLA',
                  rating: 5.0,
                  pickUp: 'Dhaka, Bangladesh',
                  dropOff: 'Moulvibazar, Bangladesh',
                  dateTime: '29-06-2025 05:00 PM',
                  fare: 4200,
                  charge: 399,
                  total: 4599,
                  imagePath: 'assets/car2.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Trip Card Widget
class TripCard extends StatelessWidget {
  final String carName;
  final double rating;
  final String pickUp;
  final String dropOff;
  final String dateTime;
  final int fare;
  final int charge;
  final int total;
  final String imagePath;

  const TripCard({
    super.key,
    required this.carName,
    required this.rating,
    required this.pickUp,
    required this.dropOff,
    required this.dateTime,
    required this.fare,
    required this.charge,
    required this.total,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔸 Header: Car info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          carName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '• 4 Seats  •  AC',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const Text(
                      'Sedan',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🔸 Pick up / Drop info
            // 🔸 Pick up / Drop info (with timeline)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Left side: timeline icons + line
                    Column(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.black54,
                        ),
                        Container(width: 2, height: 32, color: Colors.black26),
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),

                    // 🔹 Right side: pickup & drop text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pick Up Point',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            pickUp,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Drop Off Point',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            dropOff,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 20, thickness: 1),

            // 🔸 Fare Info
            Column(
              children: [
                _fareRow('Date & Time', dateTime),
                _fareRow('Driver Asking Fare', '৳ $fare', color: Colors.green),
                _fareRow('Platform Charge', '৳ $charge', color: Colors.green),
                const Divider(),
                _fareRow(
                  'Total fare',
                  '৳ $total',
                  color: Colors.blue,
                  isBold: true,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 🔸 Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Bid Your Fare',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fareRow(
    String title,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
