import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_gari/app/modules/auth/views/login_view.dart';
import 'package:quick_gari/app/modules/auth/views/register_view.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<AuthController>(
          builder: (_) {
            return controller.isSplash
                ? Center(
                    child: Lottie.asset(
                      'assets/splash.json',
                      fit: BoxFit.contain,
                    ),
                  )
                : AuthWidget();
          },
        ),
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        /// Top Illustration
        SizedBox(
          height: 250,
          child: Image.asset(
            "assets/welcome.png", // put your illustration here
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 20),

        /// Title
        const Text(
          "Welcome",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 6),

        /// Subtitle
        const Text(
          "Have a better sharing experience",
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),

        const Spacer(),

        /// Create Account Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => Get.to(() => SignupScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B), // green
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Create an account",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// Login Button (Outline)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton(
              onPressed: () => Get.to(() => SignInScreen()),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A86B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Log In",
                style: TextStyle(fontSize: 16, color: Color(0xFF00A86B)),
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
