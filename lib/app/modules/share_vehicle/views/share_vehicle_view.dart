import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/share_vehicle/views/select_car.dart';

import '../controllers/share_vehicle_controller.dart';

class ShareVehicleView extends GetView<ShareVehicleController> {
  const ShareVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Shared Cars'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 28),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _dateFilters(),
          const SizedBox(height: 12),
          _carCard(
            startTime: 'Tue, Apr 30 - Start: 09:10',
            imageUrl:
                'https://loremflickr.com/0/150/car', // replace with your image
            seats: '3 / 8',
          ),
          const SizedBox(height: 16),
          _carCard(
            startTime: 'Tue, Apr 30 - Start: 10:30',
            imageUrl:
                'https://loremflickr.com/0/150/car', // replace with your image
            seats: '5 / 8',
          ),
        ],
      ),
    );
  }

  /// 🔹 Date filter chips
  Widget _dateFilters() {
    return Row(
      children: [
        _chip('All Dates', isActive: true),
        const SizedBox(width: 8),
        _chip('Tue, Apr 30'),
        const SizedBox(width: 8),
        _chip('Wed, May 1'),
      ],
    );
  }

  Widget _chip(String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromARGB(255, 0, 131, 29)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (isActive)
            const Icon(Icons.calendar_month, size: 16, color: Colors.white),
          if (isActive) const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Shared car card
  Widget _carCard({
    required String startTime,
    required String imageUrl,
    required String seats,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            startTime,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),

          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),

          /// Route
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _LocationTime(name: 'Rajshahi', time: '09:10'),
              _LocationTime(name: 'Godagari', time: '09:40'),
              _LocationTime(name: 'Copalpur', time: '09:00'),
            ],
          ),

          const SizedBox(height: 10),

          /// Seats
          Row(
            children: [
              const Icon(
                Icons.person,
                size: 18,
                color: Color.fromARGB(255, 0, 131, 29),
              ),
              const SizedBox(width: 6),
              Text(
                'Available Seats: $seats',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// Select button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Get.to(() => SelectCar()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 131, 29),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'SELECT CAR',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationTime extends StatelessWidget {
  final String name;
  final String time;

  const _LocationTime({required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}
