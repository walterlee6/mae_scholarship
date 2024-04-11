import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scholarship_application/components/RoleOptionCard.dart';
import 'package:scholarship_application/components/my_button.dart';
import 'package:scholarship_application/components/my_textfield.dart';
import 'package:scholarship_application/landings/register_landing.dart';
import 'package:scholarship_application/utils/colors.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool showLoginPage = true;

  void userRegister() async {
    RegisterLandingPage(
      onTap: () {},
    );

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        showErrorMessage("Passwords do not match");
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
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
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 35,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(72, 72, 72, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  MyTextField(
                    hintText: "Your Email",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(72, 72, 72, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  MyTextField(
                    hintText: "Your Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(72, 72, 72, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  MyTextField(
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color.fromRGBO(95, 95, 95, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    onTap: userRegister,
                    text: "Register",
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Center(
                      child: Text(
                        "Already have Account? Login",
                        style: TextStyle(
                          color: Color.fromRGBO(95, 95, 95, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
