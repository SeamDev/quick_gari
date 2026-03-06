import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_vehicle_controller.dart';

class RegisterVehicleView extends GetView<RegisterVehicleController> {
  const RegisterVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F9),

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
          children: [
            // ================= OWNER INFO =================
            buildSectionCard(
              title: "Owner Information",
              children: [
                appInput(
                  "Full Name",
                  onChanged: (v) => controller.fullName.value = v,
                ),
                appInput(
                  "Phone Number",
                  keyboard: TextInputType.phone,
                  onChanged: (v) => controller.phone.value = v,
                ),
                appInput(
                  "Email",
                  keyboard: TextInputType.emailAddress,
                  onChanged: (v) => controller.email.value = v,
                ),
                appInput(
                  "Address",
                  maxLines: 3,
                  onChanged: (v) => controller.address.value = v,
                ),

                uploadButton("NID Card Photo (Optional)", "nid"),
              ],
            ),

            // ================= VEHICLE BASIC =================
            buildSectionCard(
              title: "Vehicle Basic Information",
              children: [
                dropdownField("Vehicle Type", [
                  "Sedan",
                  "SUV",
                  "Hatchback",
                  "Convertible",
                  "Coupe",
                  "Pickup",
                  "Minivan",
                  "Crossover",
                  "Van",
                  "Truck",
                  "Bus",
                ], (v) => controller.vehicleType.value = v!),

                dropdownField("Brand", [
                  "Toyota",
                  "Nissan",
                  "Honda",
                  "Suzuki",
                  "Hyundai",
                  "BMW",
                ], (v) => controller.brand.value = v!),

                appInput("Model", onChanged: (v) => controller.model.value = v),

                dropdownField(
                  "Seat Capacity",
                  List.generate(12, (i) => "${i + 1}"),
                  (v) => controller.seatCapacity.value = v!,
                ),

                // AC Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("AC Available?"),
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
                  'Petrol',
                  'Diesel',
                  'Hybrid',
                  'Electric',
                ], (v) => controller.fuelType.value = v!),

                dropdownField("Gear Type", [
                  "Automatic",
                  "Manual",
                ], (v) => controller.gearType.value = v!),

                dropdownField(
                  "Manufacture Year",
                  List.generate(26, (i) => (2000 + i).toString()),
                  (v) => controller.manufactureYear.value = v!,
                ),
              ],
            ),

            // ================= REGISTRATION =================
            buildSectionCard(
              title: "Vehicle Registration Details",
              children: [
                appInput(
                  "Registration Number",
                  onChanged: (v) => controller.registrationNumber.value = v,
                ),

                dropdownField(
                  "Registration Year",
                  List.generate(26, (i) => (2000 + i).toString()),
                  (v) => controller.registrationYear.value = v!,
                ),

                uploadButton("Tax Token Photo", "tax"),

                uploadButton("Registration Card Photo", "reg"),
              ],
            ),

            // ================= DRIVER INFO =================
            buildSectionCard(
              title: "Driver Information",
              children: [
                appInput(
                  "Driver Name",
                  onChanged: (v) => controller.driverName.value = v,
                ),

                appInput(
                  "Driver Phone",
                  keyboard: TextInputType.phone,
                  onChanged: (v) => controller.driverPhone.value = v,
                ),

                appInput(
                  "License Number",
                  onChanged: (v) => controller.licenseNumber.value = v,
                ),

                uploadButton("License Photo (Optional)", "lic"),

                uploadButton("Driver Photo (Optional)", "dri"),
              ],
            ),

            // ================= VEHICLE IMAGES =================
            buildSectionCard(
              title: "Upload Vehicle Images",
              children: [
                uploadButton("Front View", "front"),
                uploadButton("Side View", "side"),
                uploadButton("Back View", "back"),
                uploadButton("Interior", "interior"),
              ],
            ),

            const SizedBox(height: 20),

            // ================= SUBMIT =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.uploadVehicle(),
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
  // SECTION CARD
  // ===========================================================

  Widget buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
  // INPUT FIELD
  // ===========================================================

  Widget appInput(
    String hint, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: keyboard,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: hint,
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ===========================================================
  // DROPDOWN
  // ===========================================================

  Widget dropdownField(
    String title,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: title,
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // ===========================================================
  // FILE UPLOAD BUTTON
  // ===========================================================

  Widget uploadButton(String label, String key) {
    return GestureDetector(
      onTap: () async {
        controller.filePICK(key);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF00804B)),
          color: const Color(0xFFE8F7EF),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Icon(Icons.cloud_upload, color: Color(0xFF00804B)),
          ],
        ),
      ),
    );
  }
}
