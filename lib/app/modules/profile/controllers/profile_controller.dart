import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/modules/navbar/controllers/navbar_controller.dart';

class ProfileController extends GetxController {
  final user = AppConfig().user;

  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final presentVillage = TextEditingController();
  final presentUnion = TextEditingController();
  final presentUpazila = TextEditingController();
  final presentDistrict = TextEditingController();

  final permanentVillage = TextEditingController();
  final permanentUnion = TextEditingController();
  final permanentUpazila = TextEditingController();
  final permanentDistrict = TextEditingController();

  final nidController = TextEditingController();

  var selectedGender = "male".obs;

  var showAddress = false.obs;
  var sameAddress = false.obs;
  var showNid = false.obs;

  Rxn<Uint8List> nidFront = Rxn<Uint8List>();
  Rxn<Uint8List> nidBack = Rxn<Uint8List>();

  @override
  void onInit() {
    super.onInit();

    selectedGender.value = user.gender ?? "male";

    emailController.text = user.email;
    phoneController.text = "+88${user.phoneNumber}";
  }

  final navController = Get.put(NavbarController());

  void unInit() {
    navController.unInit();
  }

  void toggleAddress() {
    showAddress.toggle();
  }

  void toggleNid() {
    showNid.toggle();
  }

  void changeGender(String value) {
    selectedGender.value = value;
  }

  void changeSameAddress(bool value) {
    sameAddress.value = value;

    if (value) {
      permanentVillage.text = presentVillage.text;
      permanentUnion.text = presentUnion.text;
      permanentUpazila.text = presentUpazila.text;
      permanentDistrict.text = presentDistrict.text;
    }
  }

  Future<void> pickNidImage(bool front) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.first.bytes != null) {
      if (front) {
        nidFront.value = result.files.first.bytes;
      } else {
        nidBack.value = result.files.first.bytes;
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();

    presentVillage.dispose();
    presentUnion.dispose();
    presentUpazila.dispose();
    presentDistrict.dispose();

    permanentVillage.dispose();
    permanentUnion.dispose();
    permanentUpazila.dispose();
    permanentDistrict.dispose();

    nidController.dispose();

    super.onClose();
  }
}
