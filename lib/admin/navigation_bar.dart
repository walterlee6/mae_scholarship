import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scholarship_application/admin/admin_page.dart';
import 'package:scholarship_application/admin/chatbot.dart';
import 'package:scholarship_application/admin/chatbox.dart';
import 'package:scholarship_application/admin/detailed_graph_page.dart';
import 'package:scholarship_application/admin/map_page.dart';
import 'package:scholarship_application/admin/testing_map_page.dart';
import 'package:scholarship_application/admin/user_management_page.dart';
import 'package:scholarship_application/admin/user_manual.dart';
import 'package:scholarship_application/admin/verification_page.dart';

class NaviBar extends StatelessWidget {
  const NaviBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          gap: 8,
          tabs: [
            GButton(
              icon: Icons.home,
              text: "Home",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
            ),
            GButton(
              icon: Icons.place,
              text: "Map",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chatbox()),
                );
              },
            ),
            GButton(
                icon: Icons.sms,
                text: "Messages",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chatbot()),
                  );
                }),
            GButton(
              icon: Icons.settings,
              text: "Settings",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProviderVerificationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
