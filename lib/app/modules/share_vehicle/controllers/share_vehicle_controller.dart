import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';

class ShareVehicleController extends GetxController {
  /// Image
  var selectedImage = Rx<Uint8List?>(null);

  final user = AppConfig().user;

  /// Stops (JSON-like)
  var stops = List.generate(3, (_) => {"place": "", "time": ""}).obs;

  /// Loading state
  var isLoading = false.obs;

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
      stops[index]["time"] = picked.format(context);
      stops.refresh();
    }
  }

  void addStop() {
    if (stops.length < 8) {
      stops.add({"place": "", "time": ""});
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

  // ================== IMAGE ==================

  void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // only images
        allowMultiple: false,
      );

      if (result != null) {
        selectedImage.value = result.files.single.bytes;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick file",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  // ================== ACTIONS ==================

  void onCancel() {
    /// Reset everything
    stops.value = List.generate(3, (_) => {"place": "", "time": ""});

    selectedImage.value = null;

    Get.back();
  }

  void onSubmit() async {
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

    /// Validate image
    if (selectedImage.value == null) {
      Get.snackbar(
        "Error",
        "Please upload vehicle image",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      /// Prepare clean JSON
      final data = {
        "stops": stops
            .map((e) => {"place": e["place"], "time": e["time"]})
            .toList(),
        "image": selectedImage.value,
      };

      /// DEBUG
      debugPrint("SUBMIT DATA: $data");

      /// TODO: API CALL HERE

      await Future.delayed(const Duration(seconds: 1)); // fake API

      Get.snackbar(
        "Success",
        "Vehicle added successfully",
        snackPosition: SnackPosition.BOTTOM,
      );

      /// Reset after success
      onCancel();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
