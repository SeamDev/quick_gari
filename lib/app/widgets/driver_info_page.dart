import 'package:flutter/material.dart';
import 'package:quick_gari/app/service/call_service.dart';

class DriverInfoContainer extends StatelessWidget {
  final Map<String, dynamic> data;

  const DriverInfoContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 1. Safe Data Extraction
    final String name = data["name"] ?? "Unknown Driver";
    final String phone = data["phone"] ?? "No Number";
    final String? imageUrl = data["image"];

    // 2. Initials Logic
    String initials = "";
    if (name.trim().isNotEmpty) {
      var parts = name.trim().split(' ');
      initials = parts.length > 1 
          ? (parts[0][0] + parts[1][0]).toUpperCase() 
          : parts[0][0].toUpperCase();
    } else {
      initials = "?";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents infinite height errors
        children: [
          // Avatar Section
          CircleAvatar(
            radius: 45,
            backgroundColor: Theme.of(context).primaryColor.withValues(alpha:  0.1),
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null
                ? Text(
                    initials,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : null,
          ),
          
          const SizedBox(height: 16),

          // Driver Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),

          // Phone Number
          Text(
            phone,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 20),

          // Call Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => PhoneCallService.call(phone),
              icon: const Icon(Icons.phone, size: 20),
              label: const Text("Call Driver"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}