import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_gari/app/modules/ride/views/ride_view_proposal.dart';
import 'package:quick_gari/app/service/api_service.dart';
import '../controllers/ride_controller.dart';

class RideView extends GetView<RideController> {
  const RideView({super.key});

  @override
  Widget build(BuildContext context) {
    void refresh() {
      controller.dataRefresh();
    }

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
        actions: [
          IconButton(
            onPressed: () => showEditableAddressSheet(context, refresh),
            icon: Icon(Icons.add_circle, size: 30),
          ),
          SizedBox(width: 5),
        ],
      ),

      body: GetBuilder<RideController>(
        builder: (_) {
          return controller.isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.green))
              : controller.dataList.isEmpty
              ? Center(child: Text("No Proposal Created"))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      Text(
                        "${controller.dataList.length} cars found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),

                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.dataList.length,
                          itemBuilder: (context, index) {
                            final data = controller.dataList[index];
                            return vehicleCard(data);
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

Widget vehicleCard(Map<String, String> data) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: EdgeInsets.only(top: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFE9F8E9),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.green),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Starting Area
        _infoRow(
          icon: Icons.circle,
          iconColor: Colors.green,
          title: "Starting Area",
          value: data["startLocation"] ?? "--Error--",
        ),

        const SizedBox(height: 8),

        /// Ending Area
        _infoRow(
          icon: Icons.location_on,
          iconColor: Colors.green,
          title: "Ending Area",
          value: data["endLocation"] ?? "--Error--",
        ),

        const SizedBox(height: 8),

        /// Date & Time
        _infoRow(
          icon: Icons.calendar_month,
          iconColor: Colors.redAccent,
          title: "Date & Time",
          value: DateFormat("dd-MM-yyyy   hh:mm a").format(
            DateTime.parse(
              data["startTime"] ?? "2026-03-04T13:23:00.000Z",
            ).toLocal(),
          ),
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
            minimumSize: Size(300, 50),
          ),
          onPressed: () {
            Get.to(() => RideProposalView(id: data["_id"] ?? "00"));
          },
          child: const Text(
            "See Proposal",
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

showEditableAddressSheet(BuildContext context, void Function() refresh) {
  final startCtrl = TextEditingController();
  final endCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());

  Get.bottomSheet(
    DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.35,
      maxChildSize: 0.85,

      builder: (context, cont) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: cont,
            children: [
              /// drag handle
              Center(
                child: Container(
                  height: 5,
                  width: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const Text(
                "Select address",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// Starting Point
              _editableField(
                icon: Icons.location_on,
                iconColor: Colors.green,
                label: "Starting Point",
                controller: startCtrl,
                borderColor: Colors.green,
              ),

              const SizedBox(height: 12),

              /// Arrival Point
              _editableField(
                icon: Icons.location_on_outlined,
                iconColor: Colors.red,
                label: "Arrival Point",
                controller: endCtrl,
              ),

              const SizedBox(height: 12),

              /// Date Picker
              _editableField(
                icon: Icons.calendar_month,
                iconColor: Colors.redAccent,
                label: "Date",
                controller: dateCtrl,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dateCtrl.text =
                        "${picked.day.toString().padLeft(2, '0')}-"
                        "${picked.month.toString().padLeft(2, '0')}-"
                        "${picked.year}";
                    selectedDate = picked;
                  }
                },
              ),

              const SizedBox(height: 12),

              /// Time Picker
              _editableField(
                icon: Icons.access_time,
                iconColor: Colors.green,
                label: "Time",
                controller: timeCtrl,
                readOnly: true,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    final hour = picked.hourOfPeriod == 0
                        ? 12
                        : picked.hourOfPeriod;
                    final minute = picked.minute.toString().padLeft(2, '0');
                    final period = picked.period == DayPeriod.am ? "AM" : "PM";

                    timeCtrl.text = "$hour:$minute $period";
                    selectedTime = picked;
                  }
                },
              ),

              const SizedBox(height: 24),

              /// Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007F4F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  //Get.back();

                  final combinedDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  final requestBody = {
                    "startLocation": startCtrl.text,
                    "endLocation": endCtrl.text,
                    "date":
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                    "startTime": combinedDateTime.toUtc().toIso8601String(),
                  };

                  await ApiService.rideSheet(requestBody);
                  refresh();
                  Get.back();
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
  );
}

Widget _editableField({
  required IconData icon,
  required Color iconColor,
  required String label,
  required TextEditingController controller,
  bool readOnly = false,
  VoidCallback? onTap,
  Color borderColor = const Color(0xFFE0E0E0),
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              labelStyle: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        if (controller.text.isNotEmpty)
          GestureDetector(
            onTap: () => controller.clear(),
            child: const Icon(Icons.close, color: Colors.red, size: 18),
          ),
      ],
    ),
  );
}
