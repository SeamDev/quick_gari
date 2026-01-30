import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_vehicle_controller.dart';

class RegisterVehicleView extends GetView<RegisterVehicleController> {
  const RegisterVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F6F9,
      ), // Light background like screenshot

      appBar: AppBar(
        title: const Text(
          "Register Vehicle",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionCard(
              title: "Owner Information",
              children: [
                appInput("Full Name"),
                appInput("Phone Number", keyboard: TextInputType.phone),
                appInput("Email", keyboard: TextInputType.emailAddress),
                appInput("Address", maxLines: 3),
                uploadButton("NID Card Photo (Optional)"),
              ],
            ),

            buildSectionCard(
              title: "Vehicle Basic Information",
              children: [
                dropdownField("Vehicle Type", [
                  "Car",
                  "Microbus",
                  "SUV",
                  "Truck",
                  "Pickup",
                ]),
                dropdownField("Brand", [
                  "Toyota",
                  "Nissan",
                  "Honda",
                  "Suzuki",
                  "Hyundai",
                  "BMW",
                ]),
                appInput("Model"),
                dropdownField("Seat Capacity", ["2", "4", "5", "7", "9", "12"]),

                // AC Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("AC Available?", style: TextStyle(fontSize: 16)),
                    Obx(
                      () => Switch(
                        activeColor: const Color(0xFF00804B),
                        value: controller.isAC.value,
                        onChanged: (v) => controller.isAC.value = v,
                      ),
                    ),
                  ],
                ),

                dropdownField("Fuel Type", [
                  "Petrol",
                  "Octane",
                  "Diesel",
                  "CNG",
                ]),
                dropdownField("Gear Type", ["Automatic", "Manual"]),
                dropdownField(
                  "Manufacture Year",
                  List.generate(26, (i) => (2000 + i).toString()),
                ),
              ],
            ),

            buildSectionCard(
              title: "Vehicle Registration Details",
              children: [
                appInput("Registration Number"),
                dropdownField(
                  "Registration Year",
                  List.generate(26, (i) => (2000 + i).toString()),
                ),
                uploadButton("Tax Token Photo"),
                uploadButton("Registration Card Photo"),
              ],
            ),

            buildSectionCard(
              title: "Driver Information",
              children: [
                appInput("Driver Name"),
                appInput("Driver Phone", keyboard: TextInputType.phone),
                appInput("License Number"),
                uploadButton("License Photo (Optional)"),
                uploadButton("Driver Photo (Optional)"),
              ],
            ),

            buildSectionCard(
              title: "Upload Vehicle Images",
              children: [
                uploadButton("Front View"),
                uploadButton("Side View"),
                uploadButton("Back View"),
                uploadButton("Interior"),
              ],
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed("/vehicle-register-success"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00804B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Register Vehicle",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // Reusable SECTION CARD widget
  // ===========================================================

  Widget buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00804B),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ===========================================================
  // TextField
  // ===========================================================

  Widget appInput(
    String hint, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00804B), width: 1.5),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // Dropdown
  // ===========================================================

  Widget dropdownField(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: title,
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) {},
      ),
    );
  }

  // ===========================================================
  // Upload Button UI
  // ===========================================================

  Widget uploadButton(String label) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00804B),
          style: BorderStyle.solid,
        ),
        color: const Color(0xFFE8F7EF),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Icon(Icons.cloud_upload, color: Color(0xFF00804B), size: 28),
        ],
      ),
    );
  }
}
