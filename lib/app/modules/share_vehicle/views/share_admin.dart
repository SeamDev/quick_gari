import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/share_vehicle_controller.dart';

class ShareAdmin extends GetView<ShareVehicleController> {
  const ShareAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),

          /// Form Fields
          _buildLocationFields(),
          _buildDateTimeRow(),
          _buildSeatsField(),

          /// Image Upload
          _buildImageUpload(),

          /// Price
          _buildPriceField(),

          /// Route Section
          _buildRouteHeader(),
          _buildStopsList(),
          _buildAddStopButton(),
          const SizedBox(height: 10,),

          //
          Row(
            children: [
              /// Cancel Button
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.onCancel,
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

  // ================= HEADER =================
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Vehicle",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          "Fill in the details to list your ride",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // ================= LOCATION =================
  Widget _buildLocationFields() {
    return Column(
      children: [
        _label("Starting Area"),
        _input("e.g., Mirpur", Icons.location_on_outlined),

        _label("Ending Area *"),
        _input("e.g., Motijheel", Icons.location_on_outlined),
      ],
    );
  }

  // ================= DATE & TIME =================
  Widget _buildDateTimeRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("Departure Date *"),
              _input("mm/dd/yyyy", Icons.calendar_today),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("Departure Time *"),
              _input("--:--", Icons.access_time),
            ],
          ),
        ),
      ],
    );
  }

  // ================= SEATS =================
  Widget _buildSeatsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_label("Total Seats *"), _input("4 Seats", Icons.people)],
    );
  }

  // ================= IMAGE =================
  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Image Upload *"),
        const SizedBox(height: 6),

        Obx(() {
          final image = controller.selectedImage.value;

          return InkWell(
            onTap: controller.pickFile,
            borderRadius: BorderRadius.circular(12),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [6, 4],
              color: Colors.grey.shade400,
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(image, fit: BoxFit.fitHeight),
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Tap to upload vehicle image",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    /// Remove button
                    if (image != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: controller.removeImage,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ================= PRICE =================
  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Price per Seat (৳) *"),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: "৳ ",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
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
    //final stop = controller.stops[index];

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
          TextField(
            decoration: _inputDecoration("Place name"),
            onChanged: (val) => controller.updatePlace(index, val),
          ),

          const SizedBox(height: 10),

          /// Time
          TextField(
            readOnly: true,
            decoration: _inputDecoration("--:--", icon: Icons.access_time),
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
          const SizedBox(height: 10),

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

  Widget _input(String hint, IconData icon) {
    return TextField(decoration: _inputDecoration(hint, icon: icon));
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
