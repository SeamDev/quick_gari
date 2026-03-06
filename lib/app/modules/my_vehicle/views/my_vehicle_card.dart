import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key});

  @override
  Widget build(BuildContext context) {
    int bookedSeat = 2;
    int totalSeat = 4;

    return Container(
      //constraints: const BoxConstraints(maxWidth: 500),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// VEHICLE IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.network(
                  "https://loremflickr.com/600/400/car",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "DH-10-1234",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                const Text(
                  "Toyota Prius",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  "Model: 2022",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),

                const SizedBox(height: 20),

                /// ROUTE BOX
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      /// START
                      Row(
                        children: const [
                          Icon(
                            Icons.location_on_outlined,
                            color: Color(0xff0F9D8A),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Starting Area",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Mirpur",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const SizedBox(width: 30),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.send,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// END
                      Row(
                        children: const [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.purple,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ending Area",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Motijheel",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// SHARE VEHICLE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffE7F0FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Share Vehicle",
                    style: TextStyle(
                      color: Color(0xff3B82F6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// TRIP DETAILS
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// DEPARTURE
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Color(0xff3B82F6),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Departure",
                                style: TextStyle(color: Color(0xff3B82F6)),
                              ),
                              Text(
                                "Feb 10, 2026 at 08:00",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// SEAT BOOKING
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline,
                            color: Color(0xff3B82F6),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Seat Booking",
                            style: TextStyle(color: Color(0xff3B82F6)),
                          ),
                          const Spacer(),
                          Text(
                            "$bookedSeat/$totalSeat",
                            style: const TextStyle(color: Color(0xff3B82F6)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: bookedSeat / totalSeat,
                          minHeight: 6,
                          backgroundColor: Colors.white,
                          color: const Color(0xff3B82F6),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "৳150/seat",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Route Stops",
                        style: TextStyle(
                          color: Color(0xff3B82F6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      route("Mirpur 10", "08:00"),
                      route("Shewrapara", "08:15"),
                      route("Farmgate", "08:30"),
                      route("Shahbag", "08:45"),
                      route("Motijheel", "09:00"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Divider(color: Colors.grey.shade300),

                const SizedBox(height: 10),

                /// TOTAL EARNINGS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Total Earnings"),
                    Text(
                      "৳4,800",
                      style: TextStyle(
                        color: Color(0xff0F9D8A),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0F9D8A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  static Widget route(String name, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xff3B82F6)),
          const SizedBox(width: 10),
          Text(name),
          const Spacer(),
          const Icon(Icons.access_time, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(time),
        ],
      ),
    );
  }
}
