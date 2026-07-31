import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:quick_gari/app/services/api_service.dart';
import 'package:quick_gari/app/widgets/otp_input.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isOtpSend = false;
  bool isOtpLoading = false;


  InputDecoration inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.green),
      filled: true,
      fillColor: Colors.green.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      labelStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.green.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),

                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    color: Colors.green,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Email Verification",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(
                  "Enter your email and the OTP sent to your inbox.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 35),

                /// Email
                TextFormField(
                  controller: _emailController,
                  readOnly: isOtpSend,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration(
                    label: "Email",
                    hint: "example@email.com",
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (_emailController.text.isEmpty) {
                      return "Please enter your email";
                    }

                    final emailRegex = RegExp(
                      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegex.hasMatch(_emailController.text)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 35),

                /// Email
                TextFormField(
                  controller: _passwordController,
                  readOnly: isOtpSend,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: inputDecoration(
                    label: "Password",
                    hint: "Password",
                    icon: Icons.password_outlined,
                  ),
                  validator: (value) {
                    if (_passwordController.text.isEmpty) {
                      return "Please enter your password";
                    }

                    if (_passwordController.text.length < 8) {
                      return "Please length must be 8  ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      if (!isOtpSend) {
                        setState(() {
                          isOtpLoading = true;
                        });
                        if (await ApiService.sendResetOTP(
                          _emailController.text,
                        )) {
                          setState(() {
                            
                            isOtpSend = true;
                          });
                        } else {
                          Get.snackbar(
                            "Forget Password",
                            "Forget Password Failed !",
                          );
                        }
                        setState(() {
                          isOtpLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: !isOtpLoading
                        ? Text(isOtpSend ? "OTP Sent , Now Verify" : "Send OTP")
                        : SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),

                /// OTP Widget
                OtpInputWidget(
                  length: 6,

                  bgColor: Colors.green,

                  text: "Verify OTP",

                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter OTP";
                    }

                    if (value.length != 6) {
                      return "OTP must be 6 digits";
                    }

                    return null;
                  },

                  onSubmit: (value) async{
                    Map<String,dynamic> res = await ApiService.changePassword(_emailController.text,value, _passwordController.text);

                    if(isOtpSend && (res["success"] ?? false)){
                      Get.back();
                      Get.snackbar("Success", "Password Changed Successfully");
                    }else{
                      Get.snackbar("Info", res["message"]);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
