import 'package:flutter/material.dart';
import 'package:scholarship_application/admin/top_screen.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Talent Treasure"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopScreen(),
        ],
      ),
    );
  }
}
