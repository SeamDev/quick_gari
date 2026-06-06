import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_gari/app/modules/share_vehicle/views/select_car.dart';

import '../controllers/share_vehicle_controller.dart';

class ShareUser extends GetView<ShareVehicleController> {
  const ShareUser({super.key});

  @override
  Widget build(BuildContext context) {
    String formatJourneyDate(String date) {
      final DateTime dt = DateTime.parse(date).toLocal();

      return DateFormat('EEE, MMM dd - hh:mm a').format(dt);
    }

    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchData();
      },
      child: Obx(
        () => controller.data.isEmpty
            ? CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: controller.isLoading.value
                          ? CircularProgressIndicator()
                          : Text("No Ride"),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: controller.data.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = controller.data[index];
                  return _carCard(
                    startTime: formatJourneyDate(data["journeyDate"]),
                    imageUrl: data["vehicle"]["images"][0],
                    stops: data["stops"],
                    seats: data["availableSeats"].toString(),
                    goto: () =>
                        Get.to(() => SelectCar(data: controller.data[index])),
                  );
                },
              ),
      ),
    );
  }

  /// 🔹 Shared car card
  Widget _carCard({
    required String startTime,
    required String imageUrl,
    required List stops,
    required String seats,
    required VoidCallback goto,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
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
          Column(
            children: [
              for (int i = 0; i < stops.length; i += 4)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: stops
                        .skip(i)
                        .take(4)
                        .map<Widget>(
                          (stop) => _LocationTime(
                            name: stop['location'] ?? '',
                            time: stop['arrivalTime'] ?? '',
                          ),
                        )
                        .toList(),
                  ),
                ),
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
              onPressed: goto,
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
                  color: Colors.white,
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
