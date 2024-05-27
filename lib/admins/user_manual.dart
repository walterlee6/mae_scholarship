import 'package:flutter/material.dart';

class UserManual extends StatelessWidget {
  const UserManual({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Manual"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Manual: Scholarship Application",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              title: "Delete a user",
              content:
                  "To delete a user, click on the user's profile and click on the delete button.",
            ),
            _buildSection(
              title: "View a user",
              content: "To view a user, click on the user's profile.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required title, required content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
