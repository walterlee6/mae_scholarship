import 'package:flutter/material.dart';

class RoleOptionCard extends StatelessWidget {
  final String role;
  final IconData icon;
  final VoidCallback onPressed;

  const RoleOptionCard({
    super.key,
    required this.role,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange,
      elevation: 3,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
              ),
              SizedBox(width: 20),
              Text(
                role,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
