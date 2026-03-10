import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/auth/views/register_view.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/service/api_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  bool isLoading = false;

  void login() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Email is Empty")));
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password is Empty")));
      return;
    } else if (password.length <= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password length must be greater than 7")),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map response = await ApiService.login(phone, password);

    if (!mounted) return;
    if (response["success"]) {
      Get.offAllNamed(Routes.NAVBAR);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response["message"])));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),

              const Text(
                "Sign in with your email",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 30),

              // Email or Phone
              _textField(hint: "Enter Your Email", controller: phoneController),

              const SizedBox(height: 15),

              // Password Field
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

              const SizedBox(height: 8),

              // Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to forgot password screen if needed
                    Get.snackbar("Forgot?", "Forgot password clicked!");
                  },
                  child: const Text(
                    "Forget password?",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Sign In Button
              isLoading
                  ? Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A86B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A86B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

              const SizedBox(height: 25),

              // Line Separator
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade400, thickness: 1),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("or"),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade400, thickness: 1),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Gmail
              _socialButton(
                icon: "assets/gmail.png",
                text: "Sign up with Gmail",
                onTap: () {},
              ),

              const SizedBox(height: 12),

              // Facebook
              _socialButton(
                icon: "assets/facebook.png",
                text: "Sign up with Facebook",
                onTap: () {},
              ),

              const SizedBox(height: 12),

              // Apple
              _socialButton(
                icon: "assets/apple.png",
                text: "Sign up with Apple",
                onTap: () {},
              ),

              const SizedBox(height: 30),

              // Sign Up Row
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () => Get.to(() => SignupScreen()),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
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

  // Social Button
  Widget _socialButton({
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 22),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
