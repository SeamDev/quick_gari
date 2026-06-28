import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({super.key});

  final Color green = const Color(0xff08783F);

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
          "About QuickGari",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Logo
            Center(
              child: Column(
                children: [
                  Icon(Icons.directions_car, size: 90, color: green),
                  Text(
                    "QuickGari",
                    style: TextStyle(
                      color: green,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Smart Ride, Save More",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            title("About QuickGari"),

            const SizedBox(height: 10),

            const Text(
              "QuickGari is a smart digital platform designed to make "
              "transportation more affordable, efficient, and accessible. "
              "We focus on passenger transportation, effective utilization "
              "of empty return vehicles, and vehicle-sharing services to help "
              "users save both time and money.\n\n"
              "Our mission is to reduce transportation costs, improve travel "
              "convenience, and provide reliable mobility solutions for everyone.",
              style: TextStyle(fontSize: 17, height: 1.55),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                missionCard(
                  Icons.track_changes,
                  "Our Mission",
                  "To make transportation smarter, more affordable, and technology-driven for everyone.",
                ),

                const SizedBox(width: 15),

                missionCard(
                  Icons.visibility,
                  "Our Vision",
                  "To build a unified transportation platform where passengers, vehicle owners, and businesses can connect.",
                ),
              ],
            ),

            const SizedBox(height: 25),

            title("Our Services"),

            const SizedBox(height: 10),

            serviceList(),

            const SizedBox(height: 35),

            Center(
              child: Column(
                children: [
                  Text(
                    "“স্বস্তির যাত্রায় সাশ্রয় সমাধান”",
                    style: TextStyle(
                      color: green,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Version 1.0",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    );
  }

  Widget missionCard(IconData icon, String title, String desc) {
    return Expanded(
      child: Container(
        //height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffF5FBF5),
          border: Border.all(color: Colors.green.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: green, size: 35),

            const SizedBox(height: 12),

            Text(
              title,
              style: TextStyle(
                color: green,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(desc, style: const TextStyle(fontSize: 14, height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget serviceList() {
    final data = [
      [
        Icons.directions_car,
        "Ride Service",
        "Safe and convenient vehicle rental for your travel needs.",
        null,
      ],

      [
        Icons.sync,
        "Empty Return Vehicle",
        "Find vehicles returning empty and enjoy lower transportation costs.",
        null,
      ],

      [
        Icons.people,
        "Shared Vehicle Service",
        "Travel with others heading in the same direction and save money.",
        null,
      ],

      [Icons.inventory_2, "Load & Cargo Service", "Coming Soon...", "orange"],

      [Icons.emergency, "Emergency Transport", "Coming Soon...", "green"],
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Column(
        children: List.generate(data.length, (index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xffEFF8EE),
              child: Icon(data[index][0] as IconData, color: green),
            ),

            title: Text(
              data[index][1].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),

            subtitle: Text(data[index][2].toString()),

            trailing: data[index][3] != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: data[index][3] == "orange"
                          ? Colors.orange
                          : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Coming Soon",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                : null,

            //  const Icon(
            // Icons.arrow_forward_ios,
            // size: 18,
            //),
          );
        }),
      ),
    );
  }
}
