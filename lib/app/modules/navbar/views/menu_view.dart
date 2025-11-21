import 'package:flutter/material.dart';


class MenuView extends StatelessWidget {

  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(height: 20),

            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/profile.png"),
                  ),
                  SizedBox(height: 10),
                  Text("Nate Samson",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("nate@email.com",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _menuItem(Icons.history, "History"),
            _menuItem(Icons.report_problem_outlined, "Complain"),
            _menuItem(Icons.group_add_outlined, "Referral"),
            _menuItem(Icons.info_outline, "About Us"),
            _menuItem(Icons.settings_outlined, "Settings"),
            _menuItem(Icons.help_outline, "Help & Support"),

            const Spacer(),
            _menuItem(Icons.logout, "Logout"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {},
    );
  }
}