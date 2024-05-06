import 'package:flutter/material.dart';
import 'package:scholarship_application/landings/register_landing.dart';
import 'package:scholarship_application/pages/login_page.dart';
import 'package:scholarship_application/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  final String role;
  const LoginOrRegisterPage({super.key, required this.role});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
        role: widget.role,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
        role: widget.role,
      );
    }
  }
}
