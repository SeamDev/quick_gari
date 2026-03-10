import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_vehicle_controller.dart';

class RegisterVehicleView extends GetView<RegisterVehicleController> {
  const RegisterVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // ================= OWNER INFO =================
              buildSectionCard(
                title: "Owner Information",
                children: [
                  appInput(
                    id: "fullName",
                    label: "Car Name",
                    onChanged: (v) => controller.fullName = v,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Car Name required";
                      return null;
                    },
                  ),
                  appInput(
                    id: "phone",
                    label: "Phone Number",
                    keyboard: TextInputType.phone,
                    onChanged: (v) => controller.phone = v,
                  ),
                  appInput(
                    id: "email",
                    label: "Email",
                    keyboard: TextInputType.emailAddress,
                    onChanged: (p0) => controller.email = p0,
                  ),
                  appInput(id: "address", label: "Address", maxLines: 3),
                  uploadButton("NID Card Photo (Optional)", "nid"),
                ],
              ),

              // ================= VEHICLE BASIC =================
              buildSectionCard(
                title: "Vehicle Basic Information",
                children: [
                  dropdownField(
                    title: "Vehicle Type",
                    items: [
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
                    ],
                    currentValue: controller.vehicleType,
                    onChanged: (p0) => controller.vehicleType = p0,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  dropdownField(
                    title: "Brand",
                    items: [
                      "Toyota",
                      "Nissan",
                      "Honda",
                      "Suzuki",
                      "Hyundai",
                      "BMW",
                    ],
                    currentValue: controller.brand,
                    onChanged: (v) => controller.brand = v!,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  appInput(
                    id: "model",
                    label: "Model",
                    onChanged: (p0) => controller.model = p0,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  dropdownField(
                    title: "Seat Capacity",
                    items: List.generate(12, (i) => "${i + 1}"),
                    currentValue: controller.seatCapacity,
                    onChanged: (v) => controller.seatCapacity = v!,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  // AC Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("AC Available?"),
                      GetBuilder<RegisterVehicleController>(
                        builder: (c) => Switch(
                          activeThumbColor: const Color(0xFF00804B),
                          value: controller.isAC,
                          onChanged: (v) => controller.isAC = v,
                        ),
                      ),
                    ],
                  ),
                  dropdownField(
                    title: "Fuel Type",
                    items: ['Petrol', 'Diesel', 'Hybrid', 'Electric'],
                    currentValue: controller.fuelType,
                    onChanged: (v) => controller.fuelType = v!,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  dropdownField(
                    title: "Gear Type",
                    items: ["Automatic", "Manual"],
                    currentValue: controller.gearType,
                    onChanged: (v) => controller.gearType = v!,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  dropdownField(
                    title: "Manufacture Year",
                    items: List.generate(26, (i) => (2000 + i).toString()),
                    currentValue: controller.manufactureYear,
                    onChanged: (v) => controller.manufactureYear = v!,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
                  ),
                ],
              ),

              // ================= REGISTRATION =================
              buildSectionCard(
                title: "Vehicle Registration Details",
                children: [
                  appInput(
                    id: "registrationNumber",
                    label: "Registration Number",
                    onChanged: (p0) => controller.registrationNumber = p0,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  dropdownField(
                    title: "Registration Year",
                    items: List.generate(26, (i) => (2000 + i).toString()),
                    currentValue: controller.registrationYear,
                    onChanged: (v) => controller.registrationYear = v!,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      return null;
                    },
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
                    id: "dName",
                    label: "Driver Name",
                    onChanged: (v) => controller.driverName = v,
                  ),
                  appInput(
                    id: "dPhone",
                    label: "Driver Phone",
                    onChanged: (p0) => controller.driverPhone = p0,
                  ),
                  appInput(
                    id: "lNumber",
                    label: "Licence Number",
                    onChanged: (p0) => controller.licenseNumber = p0,
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.uploadVehicle();
                    }
                  },
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
      ),
    );
  }

  // ================= HELPERS =================

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

  Widget appInput({
    required String id,
    required String label,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    Function(String?)? onChanged,
    String? Function(String?)? validator,
    Color borderColor = Colors.black,
    String? errorText,
  }) {
    return GetBuilder<RegisterVehicleController>(
      id: id,
      builder: (con) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            keyboardType: keyboard,
            maxLines: maxLines,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: borderColor),
              errorText: errorText,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget dropdownField({
    required String title,
    required List<String> items,
    String? currentValue,
    Function(String?)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: currentValue,
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
        validator: validator,
      ),
    );
  }

  Widget uploadButton(String label, String key) {
    return GestureDetector(
      onTap: () async => controller.filePICK(key),
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
