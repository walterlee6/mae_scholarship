import 'package:flutter/material.dart';
import 'package:scholarship_application/admins/navigation_bar.dart';
import 'package:scholarship_application/admins/welcoming_board.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomingBoard(),
      bottomNavigationBar: NaviBar(),
    );
  }
}
