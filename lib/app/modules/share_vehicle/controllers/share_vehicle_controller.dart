import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/service/api_service.dart';

class ShareVehicleController extends GetxController {
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    dateController.text = "";
    stops.value = List.generate(3, (_) => {"place": "", "time": "--:--"});
    super.onClose();
  }

  final dateController = TextEditingController();

  final user = AppConfig().user;

  /// Stops (JSON-like)
  var stops = List.generate(3, (_) => {"place": "", "time": "--:--"}).obs;

  /// Loading state
  var isLoading = false.obs;

  //  Data
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;


  // ================== STOPS ==================

  void updatePlace(int index, String value) {
    stops[index]["place"] = value;
    stops.refresh();
  }

  void pickTime(int index, BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      stops[index]["time"] =
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';

      stops.refresh();
    }
  }

  void addStop() {
    if (stops.length < 8) {
      stops.add({"place": "", "time": "--:--"});
    } else {
      Get.snackbar(
        "Limit Reached",
        "Maximum 8 stops allowed",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeStop(int index) {
    if (stops.length > 3) {
      stops.removeAt(index);
    } else {
      Get.snackbar(
        "Minimum Required",
        "At least 3 stops are required",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================== ACTIONS ==================

  void onSubmit() async {
    /// Validate Date
    if (dateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill date",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    /// Validate stops
    for (var stop in stops) {
      if (stop["place"]!.isEmpty || stop["time"]!.isEmpty) {
        Get.snackbar(
          "Error",
          "Please fill all route stops",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    try {
      isLoading.value = true;

      /// Prepare clean JSON
      final data = {
        "journeyDate": dateController.text,
        "stops": stops.asMap().entries.map((entry) {
          final index = entry.key;
          final stop = entry.value;

          return {
            "location": stop["place"],
            "arrivalTime": stop["time"],
            "order": index,
          };
        }).toList(),
      };

      /// API CALL HERE

      final res = await ApiService.createShareVehicle(data);
      if (res == 201) {
        Get.back();
        Get.snackbar(
          "Success",
          "Vehicle added successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Failed",
          res["message"],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      dateController.text = "";
      stops.value = List.generate(3, (_) => {"place": "", "time": "--:--"});
    }
  }

  // Avai;able

  void fetchData() async {
    isLoading.value = true;

    if (AppConfig().user.isCarOwner) {
      data.value = await ApiService.getDrShVehicle();
    } else {
      data.value = await ApiService.getAvShVehicle();
    }

    isLoading.value = false;
  }
}
