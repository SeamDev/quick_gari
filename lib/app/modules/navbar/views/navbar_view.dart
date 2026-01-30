import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:get/get.dart';
import 'package:quick_gari/app/modules/favourite/views/favourite_view.dart';
import 'package:quick_gari/app/modules/home/views/home_view.dart';
import 'package:quick_gari/app/modules/navbar/views/menu_view.dart';
import 'package:quick_gari/app/modules/offer/views/offer_view.dart';
import 'package:quick_gari/app/modules/profile/views/profile_view.dart';
import 'package:quick_gari/app/modules/wallet/views/wallet_view.dart';

import '../controllers/navbar_controller.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = controller.currentIndex;

      Widget content;
      switch (index) {
        case 0:
          content = const HomeView();
          break;
        case 1:
          content = const FavouriteView();
          break;
        case 2:
          content = const WalletView();
          break;
        case 3:
          content = const OfferView();
          break;
        case 4:
          content = const ProfileView();
          break;
        default:
          content = const HomeView();
      }
      // Menu
      return AdvancedDrawer(
        controller: controller.advancedDrawerController,
      //backdropColor: Colors.black.withValues(alpha: 0.2),
      animationDuration: const Duration(milliseconds: 270),
      openRatio: 0.6,
      animateChildDecoration: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),

      /// ---- SIDE MENU SCREEN ----
      drawer: const MenuView(),

      /// ---- MAIN SCREEN ----
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Scaffold(
            body: content,
            bottomNavigationBar: SizedBox(
              height: 100,
              child: Stack(
                children: [
                  // Background bar
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _navItem(Icons.home, "Home", 0),
                          _navItem(Icons.favorite_border, "Favourite", 1),
                          const SizedBox(width: 60), // Gap for floating button
                          _navItem(Icons.local_offer_outlined, "Offer", 3),
                          _navItem(Icons.person_outline, "Profile", 4),
                        ],
                      ),
                    ),
                  ),
          
                  // Center hexagon floating button
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.currentIndex = 2,
                      child: Column(
                        children: [
                          CustomPaint(
                            size: const Size(70, 70),
                            painter: HexagonPainter(color: Color(0xFF00A86B)),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
          
                  // Wallet icon inside hexagon
                  Positioned(
                    bottom: 38,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.currentIndex = 2,
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _navItem(IconData icon, String text, int index) {
    final isActive = index == controller.currentIndex;
    return GestureDetector(
      onTap: () => controller.currentIndex = index,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Color(0xFF00A86B) : Colors.grey),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Color(0xFF00A86B) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Draw hexagon shape
class HexagonPainter extends CustomPainter {
  final Color color;

  HexagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
