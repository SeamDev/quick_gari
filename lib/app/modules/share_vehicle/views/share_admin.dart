import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/share_vehicle_controller.dart';

class ShareAdmin extends GetView<ShareVehicleController> {
  const ShareAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.resetData();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDateTimeRow(),

            /// Route Section
            _buildRouteHeader(),
            _buildStopsList(),
            _buildAddStopButton(),
            const SizedBox(height: 16),

            //
            Row(
              children: [
                /// Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// Add Vehicle Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.onSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Color.fromRGBO(21, 93, 252, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Add Vehicle",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= APP BAR =================
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Available Shared Cars'),
      centerTitle: true,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search, size: 28)),
      ],
    );
  }

  // ================= DATE & TIME =================
  Widget _buildDateTimeRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Departure Date *"),
        dateInput(
          hint: "Select Date",
          icon: Icons.calendar_today,
          controller: controller.dateController,
        ),
      ],
    );
  }

  // ================= ROUTE =================
  Widget _buildRouteHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Route (3 Stops) *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Min 3, Max 8"),
          ],
        ),
        SizedBox(height: 6),
        Text(
          "Add places on your route with arrival time at each stop",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStopsList() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.stops.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => _stopCard(index),
      ),
    );
  }

  Widget _stopCard(int index) {
    final stop = controller.stops[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Color.fromRGBO(21, 93, 252, 1),
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Stop ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              /// ❌ Remove Button
              if (controller.stops.length > 3)
                GestureDetector(
                  onTap: () => controller.removeStop(index),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),

          const SizedBox(height: 12),

          /// Place
          // TextFormField(
          //   initialValue: stop["place"] ?? "",
          //   decoration: _inputDecoration("Place name"),
          //   onChanged: (val) => controller.updatePlace(index, val),
          // ),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration("Place name"),
            items: controller.allStopLocation
                .where((location) {
                  // Allow current value
                  if (location == stop["place"]) return true;

                  // Hide values selected in other dropdowns
                  return !controller.stops.any(
                    (s) => s != stop && s["place"] == location,
                  );
                })
                .map(
                  (location) => DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.updatePlace(index, value);
              }
            },
          ),
          const SizedBox(height: 10),

          /// Time
          TextField(
            readOnly: true,
            decoration: _inputDecoration(
              stop["time"] ?? "--:--",
              icon: Icons.access_time,
            ),
            onTap: () => controller.pickTime(index, Get.context!),
          ),
        ],
      ),
    );
  }

  Widget _buildAddStopButton() {
    return Obx(
      () => Column(
        children: [
          /// Add Stop Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.stops.length >= 8
                  ? null
                  : controller.addStop,
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                "Add Stop",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          /// Optional hint
          if (controller.stops.length >= 8)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Maximum 8 stops allowed",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // ================= COMMON =================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget dateInput({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: _inputDecoration(hint, icon: icon),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: Get.context!, // or context if inside StatefulWidget
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
