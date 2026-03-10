import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/auth/views/login_view.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'package:quick_gari/app/service/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;

  String selectedGender = "male";
  Uint8List? selectedImageBytes;

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Pick profile image
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        Uint8List? imageBytes = result.files.first.bytes;

        if (imageBytes != null) {
          if (!kIsWeb) {
            imageBytes = await FlutterImageCompress.compressWithList(
              imageBytes,
              quality: 60,
              minWidth: 512,
              minHeight: 512,
            );
          }

          setState(() {
            selectedImageBytes = imageBytes;
          });
        }
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  // Example register function
  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if(password.length <8 ){
      
      Get.snackbar(
        "Error",
        "Password length must b greater than 7",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedGender == "Gender") {
      Get.snackbar(
        "Error",
        "Please select gender",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedImageBytes == null) {
      Get.snackbar(
        "Error",
        "Please upload a profile image",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Map response = await ApiService.register(
      name,
      email,
      "0$phone",
      selectedGender,
      selectedImageBytes,
      password,
    );

    if (response['success']) {
      //Get.offAllNamed(Routes.NAVBAR);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response['message'].toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Sign up with your email or phone number",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 25),

              _textField(hint: "Name", controller: nameController),
              const SizedBox(height: 15),
              _textField(hint: "Email", controller: emailController),
              const SizedBox(height: 15),

              // Phone Number
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                height: 55,
                child: Row(
                  children: [
                    Image.asset("assets/bd_flag.png", width: 28, height: 18),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down_rounded),
                    const SizedBox(width: 10),
                    const Text(
                      "+880",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: "Your mobile number",
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Gender + Profile Image Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedGender,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: "male",
                              child: Text("Male"),
                            ),
                            DropdownMenuItem(
                              value: "female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "other",
                              child: Text("Other"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Profile Image
                  Expanded(
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: selectedImageBytes != null
                                ? MemoryImage(selectedImageBytes!)
                                : null,
                            child: selectedImageBytes == null
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A86B),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        obscureText: hidePassword,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Password",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      child: Icon(
                        hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "By signing up, you agree to the ",
                        children: [
                          TextSpan(
                            text: "Terms of service",
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy policy.",
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A86B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  "or",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialCircle("assets/apple.png"),
                  _socialCircle("assets/facebook.png"),
                  _socialCircle("assets/gmail.png"),
                ],
              ),
              const SizedBox(height: 25),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Get.to(() => SignInScreen()),
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // TextField with controller
  Widget _textField({
    required String hint,
    TextEditingController? controller,
    bool isPassword = false,
    IconData? icon,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: icon != null ? Icon(icon) : null,
        ),
      ),
    );
  }

  Widget _socialCircle(String asset) {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Image.asset(asset, width: 48, height: 48),
    );
  }
}
