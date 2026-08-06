import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/hive_service.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black87)),

        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,

        actions: [
          GestureDetector(
            onTap: () {
              HiveService.clear();
              controller.unInit();
              Get.offAllNamed(Routes.AUTH, arguments: {"isInit": false});
            },

            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        child: Column(
          children: [
            const SizedBox(height: 16),

            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(controller.user.avatar),
            ),

            const SizedBox(height: 12),

            Text(
              controller.user.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 25),

            inputField(
              controller: controller.emailController,
              hint: controller.user.email,
            ),

            const SizedBox(height: 12),

            inputField(
              controller: controller.phoneController,
              hint: "+88${controller.user.phoneNumber}",
              keyboard: TextInputType.phone,
            ),

            const SizedBox(height: 12),

            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: controller.selectedGender.value,

                items: const [
                  DropdownMenuItem(value: "male", child: Text("Male")),

                  DropdownMenuItem(value: "female", child: Text("Female")),

                  DropdownMenuItem(value: "other", child: Text("Other")),
                ],

                onChanged: (v) {
                  controller.changeGender(v!);
                },

                decoration: fieldDecoration("Gender"),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: controller.toggleAddress,

              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),

                backgroundColor: Colors.grey[100],

                side: BorderSide(color: Colors.grey.shade300, width: 1),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Address",
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),

                  Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Obx(
              () => controller.showAddress.value
                  ? Column(
                      children: [
                        title("Present Address"),

                        addressInput(controller.presentVillage, "Village"),

                        addressInput(controller.presentUnion, "Union"),

                        addressInput(controller.presentUpazila, "Upazila"),

                        addressInput(controller.presentDistrict, "District"),

                        Row(
                          children: [
                            Checkbox(
                              value: controller.sameAddress.value,

                              onChanged: (v) {
                                controller.changeSameAddress(v ?? false);
                              },
                            ),

                            const Text("Same as Present Address"),
                          ],
                        ),

                        title("Permanent Address"),

                        addressInput(controller.permanentVillage, "Village"),

                        addressInput(controller.permanentUnion, "Union"),

                        addressInput(controller.permanentUpazila, "Upazila"),

                        addressInput(controller.permanentDistrict, "District"),
                      ],
                    )
                  : const SizedBox(),
            ),

            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: controller.toggleNid,

              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),

                backgroundColor: Colors.grey[100],

                side: BorderSide(color: Colors.grey.shade300, width: 1),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Add Other file",
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),

                  Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Obx(
              () => controller.showNid.value
                  ? Column(
                      children: [
                        inputField(
                          controller: controller.nidController,
                          hint: "NID Number",
                          keyboard: TextInputType.number,
                        ),

                        const SizedBox(height: 12),

                        nidUploadBox(
                          "NID Front Photo",
                          controller.nidFront.value,
                          () {
                            controller.pickNidImage(true);
                          },
                        ),

                        nidUploadBox(
                          "NID Back Photo",
                          controller.nidBack.value,
                          () {
                            controller.pickNidImage(false);
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),

        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: controller,

      keyboardType: keyboard,

      decoration: fieldDecoration(hint),
    );
  }

  Widget addressInput(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: inputField(controller: controller, hint: hint),
    );
  }

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      filled: true,

      fillColor: Colors.grey[100],

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: BorderSide.none,
      ),
    );
  }

  Widget nidUploadBox(String title, Uint8List? image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(top: 10),

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.grey[100],

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: Colors.green),
        ),

        child: Column(
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child: Image.memory(
                  image,

                  height: 150,

                  width: double.infinity,

                  fit: BoxFit.scaleDown,
                ),
              ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(image == null ? title : "Change $title"),

                const Icon(Icons.cloud_upload, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
