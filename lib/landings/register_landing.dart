import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scholarship_application/components/RoleOptionCard.dart';
import 'package:scholarship_application/pages/login_page.dart';
import 'package:scholarship_application/pages/register_page.dart';
import 'package:scholarship_application/utils/colors.dart';

class RegisterLandingPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterLandingPage({super.key, required this.onTap});

  @override
  State<RegisterLandingPage> createState() => _RegisterLandingPageState();
}

class _RegisterLandingPageState extends State<RegisterLandingPage> {
  final _formKey = GlobalKey<FormState>();

  void _navigateToRegisterPage(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(
          onTap: widget.onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: LottieBuilder.asset(
                      "assets/Lottie/chicken.json",
                      width: 700,
                      height: 250,
                    ),
                  ),
                  SizedBox(height: 20),
                  RoleOptionCard(
                    role: 'Student',
                    icon: Icons.school,
                    onPressed: () {
                      _navigateToRegisterPage(context, 'Student');
                    },
                  ),
                  SizedBox(height: 20),
                  RoleOptionCard(
                    role: 'Admin',
                    icon: Icons.admin_panel_settings,
                    onPressed: () {
                      _navigateToRegisterPage(context, 'Admin');
                    },
                  ),
                  SizedBox(height: 20),
                  RoleOptionCard(
                    role: 'Provider',
                    icon: Icons.verified_rounded,
                    onPressed: () {
                      _navigateToRegisterPage(context, 'Provider');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
