import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

showEditableAddressSheet(BuildContext context, void Function() refresh) {
  final startCtrl = TextEditingController();
  final endCtrl = TextEditingController();
  final fareCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          /// drag handle (visual only)
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

          EditableField(
            icon: Icons.location_on,
            iconColor: Colors.green,
            label: "Starting Point",
            controller: startCtrl,
            borderColor: Colors.green,
          ),

          const SizedBox(height: 12),

          EditableField(
            icon: Icons.location_on_outlined,
            iconColor: Colors.red,
            label: "Arrival Point",
            controller: endCtrl,
          ),

          const SizedBox(height: 12),

          EditableField(
            icon: Icons.money,
            iconColor: Colors.green,
            label: "Fare",
            controller: fareCtrl,
          ),

          const SizedBox(height: 12),

          EditableField(
            icon: Icons.calendar_month,
            iconColor: Colors.redAccent,
            label: "Date",
            controller: dateCtrl,
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now(),
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

          EditableField(
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

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007F4F),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              final combinedDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              if (startCtrl.text.isEmpty ||
                  endCtrl.text.isEmpty ||
                  startCtrl.text.isEmpty) {
                Get.snackbar("Info", "Fill all input field");
              } else {
                Get.back();
                final requestBody = {
                  "startLocation": startCtrl.text,
                  "endLocation": endCtrl.text,
                  "fare": int.parse(fareCtrl.text),
                  "date":
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                  "startTime": combinedDateTime.toUtc().toIso8601String(),
                };
                Map res = await ApiService.createReturnTrip(requestBody);
                if (res["success"]) {
                  Get.snackbar(
                    "Create Return",
                    res["message"] ?? "Return Created Successfully !",
                  );
                  refresh();
                } else {
                  Get.snackbar(
                    "Create Return",
                    res["message"] ??
                        "Return Creating Failed !\nYor are not driver",
                  );
                }
              }
            },
            child: const Text(
              "Continue",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true, // optional
  );
}

class EditableField extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color borderColor;

  const EditableField({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.onTap,
    this.borderColor = const Color(0xFFE0E0E0),
  });

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    showClear = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_textListener);
  }

  void _textListener() {
    if (mounted) {
      setState(() {
        showClear = widget.controller.text.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(widget.icon, color: widget.iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: widget.label,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          if (showClear && !widget.readOnly)
            GestureDetector(
              onTap: () {
                widget.controller.clear();
              },
              child: const Icon(Icons.close, color: Colors.red, size: 18),
            ),
        ],
      ),
    );
  }
}
