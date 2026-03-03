import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/auth/views/login_view.dart';
import 'package:quick_gari/app/service/api_service.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String token;

  const VerifyOtpScreen({
    super.key,
    required this.phoneNumber,
    required this.token,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int secondsRemaining = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void verifyOTP(String otp) async {
    try {
      bool res = await ApiService.verifyOTP(widget.token, otp);
      if (res) {
        Get.snackbar("Verify OTP", "Successful");
        Get.to(() => const SignInScreen());
      } else {
        Get.snackbar("Verify OTP", "Failed");
      }
    } catch (e) {
      print(e);
    }
  }

  void reSendCode() async {
    try {
      bool res = await ApiService.reSendOTP(widget.token);
      if (res) {
        Get.snackbar("Resend OTP", "OTP Send Successful");
      } else {
        Get.snackbar("Resend OTP", "OTP Send Failed");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String get otpCode => controllers.map((controller) => controller.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Code"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Icon(Icons.sms_outlined, size: 80, color: Color(0xFF00A86B)),

            const SizedBox(height: 20),

            const Text(
              "Enter Verification Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Text(
              "We have sent a 6-digit code to\n${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            // OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return _otpBox(index);
              }),
            ),

            const SizedBox(height: 25),

            // Resend Section
            secondsRemaining > 0
                ? Text(
                    "Resend code in 00:$secondsRemaining",
                    style: TextStyle(color: Colors.grey.shade600),
                  )
                : TextButton(
                    onPressed: () {
                      reSendCode();
                      setState(() {
                        secondsRemaining = 30;
                      });
                      startTimer();
                    },
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(color: Color(0xFF00A86B)),
                    ),
                  ),

            const SizedBox(height: 30),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  verifyOTP(otpCode);
                  // call verify api here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 48,
      height: 55,
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
