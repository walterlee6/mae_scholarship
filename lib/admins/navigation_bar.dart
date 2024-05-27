import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scholarship_application/admins/admin_page.dart';
import 'package:scholarship_application/admins/chatbot.dart';
import 'package:scholarship_application/admins/chatbox.dart';
import 'package:scholarship_application/admins/contact_page.dart';
import 'package:scholarship_application/admins/detailed_graph_page.dart';
import 'package:scholarship_application/admins/map_page.dart';
import 'package:scholarship_application/admins/testing_map_page.dart';
import 'package:scholarship_application/admins/user_management_page.dart';
import 'package:scholarship_application/admins/user_manual.dart';
import 'package:scholarship_application/admins/verification_page.dart';

class NaviBar extends StatefulWidget {
  const NaviBar({super.key});

  @override
  State<NaviBar> createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          gap: 2,
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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
              icon: Icons.auto_graph,
              text: "Graph",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailedGraphPage()),
                );
              },
            ),
            GButton(
              icon: Icons.sms,
              text: "SMS",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
              },
            ),
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
