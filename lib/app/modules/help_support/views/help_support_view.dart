import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/service/call_service.dart';

import '../controllers/help_support_controller.dart';

class HelpSupportView extends GetView<HelpSupportController> {
  const HelpSupportView({super.key});

  final green = const Color(0xff08783F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        //leading: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Header Card
            Container(
              padding: const EdgeInsets.all(25),
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: const Color(0xffF5FBF6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "We’re Here to Help!",
                          style: TextStyle(
                            color: green,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          "Facing any issue while using\nQuickGari? Contact us anytime.\nWe’re always ready to assist\nyou with the best support.",
                          style: TextStyle(fontSize: 18, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.support_agent, size: 95, color: green),
                ],
              ),
            ),

            const SizedBox(height: 30),

            sectionTitle("Common Support"),

            supportBox([
              ["Account Related Issues", Icons.person],
              ["Booking Issues", Icons.calendar_month],
              ["Payment Related Support", Icons.wallet],
              ["Vehicle Registration Support", Icons.directions_car],
              ["Complaints & Feedback", Icons.chat],
            ]),

            const SizedBox(height: 25),

            sectionTitle("Contact Us"),

            Row(
              children: [
                contactCard(
                  Icons.email,
                  "Email",
                  "quickgari@gmail.com",
                  () => SupportService.email(email: "quickgari@gmail.com"),
                ),
                const SizedBox(width: 15),
                contactCard(
                  Icons.phone,
                  "Hotline",
                  "+880178061328",
                  () => SupportService.call("0178061328"),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xffF7FBF7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield, size: 65, color: green),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "If you have any complaint about a driver, vehicle,\nor any service, please use the “Complain” option\nin the app or contact our support team directly.\n\nWe are committed to your safety and satisfaction.",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: green.withOpacity(.25))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            text,
            style: TextStyle(
              color: green,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: green.withOpacity(.25))),
      ],
    );
  }

  Widget supportBox(List items) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xffEFF8EE),
                  child: Icon(items[i][1], color: green),
                ),
                title: Text(
                  items[i][0],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // trailing: const Icon(
                //   Icons.arrow_forward_ios,
                //   size: 22,
                // ),
              ),
              if (i != items.length - 1)
                Divider(height: 1, color: Colors.grey.shade200),
            ],
          );
        }),
      ),
    );
  }

  Widget contactCard(
    IconData icon,
    String title,
    String value,
    VoidCallback onClick,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: green, size: 35),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(value, style: TextStyle(color: green, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
