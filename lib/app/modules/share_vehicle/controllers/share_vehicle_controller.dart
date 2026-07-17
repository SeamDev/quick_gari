import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/api_service.dart';

class ShareVehicleController extends GetxController {
  @override
  void onInit() {
    getAllStopLocation();
    fetchData();
    super.onInit();
  }

  final dateController = TextEditingController();

  final user = AppConfig().user;

  /// Stops (JSON-like)
  RxList<Map<String, String>> stops = List.generate(
    3,
    (_) => {"place": "", "time": "--:--"},
  ).obs;
  RxList<String> allStopLocation = <String>[].obs;

  /// Loading state
  var isLoading = false.obs;

  //  Data
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  // ================== STOPS ==================

  void getAllStopLocation() async {
    allStopLocation.value = await ApiService.getSVStopLocation();
  }

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

  void resetData() {
    dateController.clear();
    stops.value = List.generate(3, (_) => {"place": "", "time": "--:--"});
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

      Map<String,dynamic> res = await ApiService.createShareVehicle(data);
      if (res["success"]) {
        Get.snackbar(
          "Success",
          "Vehicle added successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.NAVBAR);
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
      //resetData();
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
